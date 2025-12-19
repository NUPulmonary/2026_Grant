library(Seurat)
library(dplyr)
library(ggplot2)
library(ggsci)
library(ggpubr)
library(broom)
library(spatstat.geom)
library(spatstat.explore)
library(GET)
library(tibble)
library(readr)
library(parallel)

complete = readRDS([REDACTED_FILE_PATH]
complete$typestate = factor(as.character(complete$typestate))

window = owin(xrange = range(complete@images$combined$centroids@coords[,"x"]),
              yrange = range(complete@images$combined$centroids@coords[,"y"]))

spatcor_data = data.frame(cell = complete@images$combined$centroids@cells,
                          x = complete@images$combined$centroids@coords[,"x"],
                          y = complete@images$combined$centroids@coords[,"y"]) %>% 
  left_join(., rownames_to_column(complete@meta.data, "cell"))

#downsample to ≤1,000 cells/typestate (otherwise takes weeks)
set.seed(12345)
spatcor_data = spatcor_data %>% 
  group_by(typestate) %>% 
  slice_sample(n = 1e3) %>% 
  ungroup()

#collect only remaining cells for analysis (no longer does anything)
coi = as.character(unique(spatcor_data$typestate))

#free up memory
rm(complete)
gc()

message("Generating point pattern")
point_pat = ppp(x = spatcor_data$x, 
                y = spatcor_data$y, 
                window = window, 
                marks = spatcor_data$typestate)

#create smoothed representations of spatial distributions
# Take a random 10% sample for sigma estimation
message("Estimating sigma")
set.seed(12345)
bandwidth_est = bw.ppl(point_pat[sample(1:npoints(point_pat), size = 0.1 * npoints(point_pat))])

message("Beginning pairwise comparisons")

spat_cor_results = mclapply(coi, function(cell_i){
  cur_row = 1
  
  #this will be one typestate against all (run in parallel)
  spat_cor_results_tmp = data.frame(cell_i = rep(NA_character_, length(coi)),
                                cell_j = rep(NA_character_, length(coi)),
                                pval = rep(NA_real_, length(coi)),
                                effect_size = rep(NA_real_, length(coi)))
  for(cell_j in coi){
    comp = paste0(cell_i, "_vs_", cell_j)
    message(comp) 
    
    #update comparison in df
    spat_cor_results_tmp[cur_row, "cell_i"] = as.character(cell_i)
    spat_cor_results_tmp[cur_row, "cell_j"] = as.character(cell_j)
    
    #determine association
    lambda_i = density.ppp(subset(point_pat, marks == cell_i), 
                         at = "points",
                         sigma = bandwidth_est)
    lambda_j = density.ppp(subset(point_pat, marks == cell_j), 
    at = "points",
    sigma = bandwidth_est)

    k_inhom = Kcross.inhom(point_pat,
                           i = cell_i,
                           j = cell_j,
                           lambdaI = lambda_i,
                           lambdaJ = lambda_j,
                           correction = "translation")
    
    #compare against null (shuffled labels)
    shuffle = envelope(point_pat,
                       fun = Kcross.inhom,
                       i = cell_i,
                       j = cell_j,
                       # lambdaI = lambda_i,
                       # lambdaJ = lambda_j,
                       nsim = 99,
                       correction = "translation",
                       savefuns = TRUE,
                       verbose = TRUE,
                       rejectNA = TRUE,
                       simulate = expression(rlabel(point_pat)))
    
    #get pval
    test = global_envelope_test(shuffle,
                                typeone = "fwer",
                                alpha = 0.05,
                                alternative = "two.sided",
                                type = "erl") 
    spat_cor_results_tmp[cur_row, "pval"] = attr(test, "p")
    
    
    #get effect size of correlation (over biologically relevant distance -- 100µm)
    pcf = pcfcross.inhom(point_pat, 
                         i = cell_i, 
                         j = cell_j,
                         rmax = 100)
    effect_size = mean(pcf$iso[pcf$r > 0 & pcf$r <= 100], na.rm=TRUE)
    spat_cor_results_tmp[cur_row, "effect_size"] = effect_size
    
    cur_row = cur_row + 1
  }
  gc()
  return(spat_cor_results_tmp)
}, mc.cores = 24) %>% 
  bind_rows()

spat_cor_results$padj = p.adjust(spat_cor_results$pval, method = "fdr")

write_csv(spat_cor_results, [REDACTED_FILE_PATH]
