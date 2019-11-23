#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/train-job-%j.log
#SBATCH --time=30:00
#SBATCH --mem=500MB
#SBATCH --partition=regular

DATALOC='/data/'"${USER}"'/cm-vs-wo'

if [[ "$3" == "noat" ]]; then
	MODEL="none"
elif [[ "$3" == "attn" ]]; then
	MODEL="general"
fi

python "${DATALOC}"/OpenNMT-py/train.py -data "${DATALOC}"/data/"${1}"/prepared_data \
									    -save_model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${MODEL}"_"${4}" \
									    -train_steps 1000 \
									    -valid_steps 100 \
									    -save_checkpoint_steps 50 \
									    -global_attention "${MODEL}" \
									    -seed "${4}" \
									    -encoder_type "${2}" \
									    -decoder_type "${2}"
