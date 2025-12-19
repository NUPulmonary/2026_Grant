#!/bin/bash
#SBATCH --output=%j.out.txt
#SBATCH --error=%j.err.txt
#SBATCH --array=0-19
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=12:00:00
#SBATCH --mem=80G
#SBATCH --job-name="Baysor_map_transcripts_\${SLURM_ARRAY_TASK_ID}"
#SBATCH --account=[REDACTED_PROJECT_ALLOCATION]
#SBATCH --partition=genomics
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[REDACTED_EMAIL_URL]

module load mamba/24.3.0
mamba activate spatial_env

tmp1=($(ls -d [REDACTED_FILE_PATH]
tmp2=($(ls -d [REDACTED_FILE_PATH]
dirs=( "${tmp1[@]}" "${tmp2[@]}" )
current_dir=${dirs[$SLURM_ARRAY_TASK_ID]}

cd ${current_dir}/Baysor_legacy_0pt8
rm -rf baysor_mtx #for rerun potential
[REDACTED_FILE_PATH] -baysor segmentation.csv -out baysor_mtx

cd ${current_dir}/Baysor_legacy_0pt5
rm -rf baysor_mtx
[REDACTED_FILE_PATH] -baysor segmentation.csv -out baysor_mtx