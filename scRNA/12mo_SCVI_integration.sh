#!/bin/bash
#SBATCH -A [REDACTED_PROJECT_ALLOCATION]
#SBATCH -p genomics-gpu
#SBATCH -t 18:00:00
#SBATCH -N 1
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=170G
#SBATCH --ntasks-per-node=12
#SBATCH --mail-user=[REDACTED_EMAIL_URL]
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name='[REDACTED_DATE_YYMMDD]SCVI_integration'

module load R/4.1.1

Rscript [REDACTED_FILE_PATH]
