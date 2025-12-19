#!/bin/bash
#SBATCH --output=%j.out
#SBATCH --array=0-3
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=24:00:00
#SBATCH --mem=190G
#SBATCH --job-name="xenium_array_mouse_\${SLURM_ARRAY_TASK_ID}"
#SBATCH --account=[REDACTED_PROJECT_ALLOCATION]
#SBATCH --partition=genomics
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[REDACTED_EMAIL_URL]

dirs=($(ls -d [REDACTED_FILE_PATH]
current_dir=${dirs[$SLURM_ARRAY_TASK_ID]}
cd $current_dir

[REDACTED_FILE_PATH] import-segmentation --id=Resegmentation_v2 \
                                 --xenium-bundle=${current_dir}/outs \
                                 --cells="${current_dir}/outs/Baysor/segmentation_polygons_2d.json" \
                                 --units=microns \
                                 --localcores=12 \
                                 --localmem=190
