#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/delay-job-%j.log
#SBATCH --time=1:00
#SBATCH --mem=1MB
#SBATCH --partition=short
#SBATCH --dependency=singleton

# Print arguments
echo "${@}"

# Set variables
ERROR=$(cat <<-END
  delay.sh: Incorrect usage.
  Correct usage options are:
  - delay.sh [train|translate]
END
)

if [[ "$1" == "train" ]]; then
  for WO in vso vos mix; do
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

elif [[ "$1" == "translate" ]]; then
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

else
  echo "${ERROR}"
  exit
fi
