#!/bin/bash

#SBATCH -A [REDACTED_PROJECT_ALLOCATION]
#SBATCH -p genomics
#SBATCH -t 06:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80G
#SBATCH --mail-user=[REDACTED_EMAIL_URL]
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=Baysor_map_transcripts_%a
#SBATCH --output=[REDACTED_FILE_PATH]
#SBATCH --error=[REDACTED_FILE_PATH]
#SBATCH --array=0-3

DIRS=([REDACTED_FILE_PATH]

source [REDACTED_FILE_PATH]

cd ${DIRS[$SLURM_ARRAY_TASK_ID]}outs/Baysor
[REDACTED_FILE_PATH] -baysor segmentation.csv -out baysor_mtx
