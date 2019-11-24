#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/train-job-%j.log
#SBATCH --time=1:30:00
#SBATCH --mem=10GB
#SBATCH --partition=regular

DATALOC='/data/'"${USER}"'/cm-vs-wo'

if [[ "$3" == "noat" ]]; then
	MODEL="none"
elif [[ "$3" == "attn" ]]; then
	MODEL="general"
fi

if [[ "$2" == "rnn" ]]; then
	python "${DATALOC}"/OpenNMT-py/train.py -data "${DATALOC}"/data/"${1}"/prepared_data \
                                          -save_model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${MODEL}"_"${4}" \
                                          -train_steps 1000 \
                                          -valid_steps 100 \
                                          -save_checkpoint_steps 50 \
                                          -global_attention "${MODEL}" \
                                          -seed "${4}" \
                                          -encoder_type "${2}" \
                                          -decoder_type "${2}"
elif [[ "$2" == "transformer" ]]; then
	python "${DATALOC}"/OpenNMT-py/train.py -data "${DATALOC}"/data/"${1}"/prepared_data \
                                          -save_model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${MODEL}"_"${4}" \
                                          -train_steps 1000 \
                                          -valid_steps 100 \
                                          -save_checkpoint_steps 50 \
                                          -global_attention "${MODEL}" \
                                          -seed "${4}" \
                                          -encoder_type "${2}" \
                                          -decoder_type "${2}" \
                                          -layers 6 \
                                          -rnn_size 512 \
                                          -word_vec_size 512 \
                                          -transformer_ff 2048 \
                                          -heads 8 \
                                          -position_encoding \
                                          -max_generator_batches 2 \
                                          -dropout 0.1 \
                                          -batch_size 4096 \
                                          -batch_type tokens \
                                          -normalization tokens \
                                          -accum_count 2 \
                                          -optim adam \
                                          -adam_beta2 0.998 \
                                          -decay_method noam \
                                          -warmup_steps 400 \
                                          -learning_rate 2 \
                                          -max_grad_norm 0 \
                                          -param_init 0 \
                                          -param_init_glorot \
                                          -label_smoothing 0.1
fi
