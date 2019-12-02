#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/thesis-job-%j.log
#SBATCH --time=5:00
#SBATCH --mem=50MB
#SBATCH --partition=short

# Print arguments
echo "${@}"

for WO in vso vos mix; do

  # Preprocess corpora
  sbatch preprocess.sh "${WO}"

  # Train LSTM with and without attention
  for GA in general none; do
    sbatch train.sh "${WO}" rnn "${GA}"
  done

  # Train large and small Transformer
  # for SIZE in large small; do
  for OPTIM in adam sgd; do
    # sbatch train-transformer.sh "${WO}" "${OPTIM}" "${SIZE}"
    sbatch train.sh "${WO}" transformer "${OPTIM}" small
  done
  # done

done

# Wait until all job scripts are done running, then start translation job scripts
sbatch delay.sh