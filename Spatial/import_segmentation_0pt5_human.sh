#!/bin/bash
#SBATCH --output=%j.out.txt
#SBATCH --error=%j.err.txt
#SBATCH --array=0-19
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=12:00:00
#SBATCH --mem=80G
#SBATCH --job-name="Baysor_import_transcripts_0pt5_\${SLURM_ARRAY_TASK_ID}"
#SBATCH --account=[REDACTED_PROJECT_ALLOCATION]
#SBATCH --partition=genomics
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[REDACTED_EMAIL_URL]


tmp1=($(ls -d [REDACTED_FILE_PATH]
tmp2=($(ls -d [REDACTED_FILE_PATH]
dirs=( "${tmp1[@]}" "${tmp2[@]}" )
current_dir=${dirs[$SLURM_ARRAY_TASK_ID]}
cd ${current_dir}/Baysor_legacy_0pt5

#clean up segmentation.csv
module load R/4.4.0
Rscript [REDACTED_FILE_PATH] ${current_dir}/Baysor_legacy_0pt5 [REDACTED_FILE_PATH]

rm -r Resegmentation_0pt5 #allow rerun
[REDACTED_FILE_PATH] import-segmentation --id=Resegmentation_0pt5 \
                                 --xenium-bundle=${current_dir} \
                                 --transcript-assignment=segmentation.csv \
                                 --viz-polygons=segmentation_polygons_2d.json \
                                 --units=microns \
                                 --localcores=12 \
                                 --localmem=80