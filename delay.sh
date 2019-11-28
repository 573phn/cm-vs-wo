#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/delay-job-%j.log
#SBATCH --time=1:00
#SBATCH --mem=1MB
#SBATCH --partition=short
#SBATCH --dependency=singleton

for WO in vso vos mix; do
  for ENCDEC in rnn transformer; do
    for MODEL in attn noat; do
      sbatch translate.sh "${WO}" "${ENCDEC}" "${MODEL}" -1 each
    done
  done
done
