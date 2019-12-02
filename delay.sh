#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/delay-job-%j.log
#SBATCH --time=1:00
#SBATCH --mem=1MB
#SBATCH --partition=short
#SBATCH --dependency=singleton

# Print arguments
echo "${@}"

for WO in vso vos mix; do

  # Translate LSTM with and without attention
  for GA in general none; do
    sbatch translate.sh "${WO}" rnn "${GA}"
  done

  # Translate large and small Transformer
  # for SIZE in large small; do
  for OPTIM in adam sgd; do
    # sbatch translate.sh "${WO}" "${OPTIM}" "${SIZE}"
    sbatch translate.sh "${WO}" transformer "${OPTIM}" small
  done

done
