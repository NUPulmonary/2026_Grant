#!/bin/bash
#SBATCH --output=%j.out.txt
#SBATCH --error=%j.err.txt
#SBATCH --array=0-19
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=2-00:00:00
#SBATCH --mem=240G
#SBATCH --job-name="Baysor_rerun_superagers\${SLURM_ARRAY_TASK_ID}"
#SBATCH --account=[REDACTED_PROJECT_ALLOCATION]
#SBATCH --partition=genomics-himem
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[REDACTED_EMAIL_URL]

module load julia/1.10.2
module load gcc/12.3.0-gcc-10.4.0

tmp1=($(ls -d [REDACTED_FILE_PATH]
tmp2=($(ls -d [REDACTED_FILE_PATH]
dirs=( "${tmp1[@]}" "${tmp2[@]}" )
current_dir=${dirs[$SLURM_ARRAY_TASK_ID]}
mkdir -p ${current_dir}/Baysor_legacy_0pt5
cd $current_dir

export JULIA_NUM_THREADS=12
[REDACTED_FILE_PATH] run \
-x x_location \
-y y_location \
-z z_location \
-g feature_name \
--n-clusters=12 \
--min-molecules-per-cell=15 \
--prior-segmentation-confidence 0.5 \
--polygon-format=GeometryCollectionLegacy \
filtered_transcripts.csv :cell_id \
-o ${current_dir}/Baysor_legacy_0pt5