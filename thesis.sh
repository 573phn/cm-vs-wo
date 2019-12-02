#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/thesis-job-%j.log
#SBATCH --time=1:00
#SBATCH --mem=1MB
#SBATCH --partition=short

# Print arguments
echo "${@}"

for WO in vso vos mix; do
  # Preprocess corpora
  sbatch preprocess.sh "${WO}"
done

# Wait until all preprocess jobs are done, then start train jobs
sbatch delay.sh train
