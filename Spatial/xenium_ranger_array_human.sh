#!/bin/bash
#SBATCH --output=%j.out
#SBATCH --array=0-19
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=16:00:00
#SBATCH --mem=80G
#SBATCH --job-name="xenium_array_\${SLURM_ARRAY_TASK_ID}"
#SBATCH --account=[REDACTED_PROJECT_ALLOCATION]
#SBATCH --partition=genomics
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[REDACTED_EMAIL_URL]

tmp1=($(ls -d [REDACTED_FILE_PATH]
tmp2=($(ls -d [REDACTED_FILE_PATH]
dirs=( "${tmp1[@]}" "${tmp2[@]}" )
current_dir=${dirs[$SLURM_ARRAY_TASK_ID]}
cd $current_dir

[REDACTED_FILE_PATH] import-segmentation --id=Resegmentation \
                                 --xenium-bundle=$current_dir \
                                 --cells="segmentation_polygons_2d.json" \
                                 --units=microns \
                                 --localcores=12 \
                                 --localmem=80
