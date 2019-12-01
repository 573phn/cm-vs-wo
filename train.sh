#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/train-job-%j.log
#SBATCH --time=3:00:00
#SBATCH --mem=3GB
#SBATCH --partition=regular

echo "${@}"

DATADIR='/data/'"${USER}"'/cm-vs-wo'

if [[ "$3" == "noat" ]]; then
    MODEL="none"
elif [[ "$3" == "attn" ]]; then
    MODEL="general"
fi

if [[ "$2" == "rnn" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}" \
                                            -train_steps 1000 \
                                            -valid_steps 100 \
                                            -warmup_steps 40 \
                                            -save_checkpoint_steps 50 \
                                            -global_attention "${MODEL}" \
                                            -seed "${4}" \
                                            -encoder_type "${2}" \
                                            -decoder_type "${2}"
elif [[ "$2" == "transformer" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}" \
                                            -train_steps 1000 \
                                            -valid_steps 100 \
                                            -warmup_steps 40 \
                                            -save_checkpoint_steps 50 \
                                            -global_attention "${MODEL}" \
                                            -seed "${4}" \
                                            -encoder_type "${2}" \
                                            -decoder_type "${2}" \
                                            -layers 6 \
                                            -rnn_size 512 \
                                            -word_vec_size 512 \
                                            -position_encoding \
                                            -max_generator_batches 2 \
                                            -dropout 0.1 \
                                            -batch_size 2048 \
                                            -batch_type tokens \
                                            -normalization tokens \
                                            -optim adam \
                                            -adam_beta2 0.998 \
                                            -decay_method noam \
                                            -max_grad_norm 0 \
                                            -param_init 0 \
                                            -param_init_glorot \
                                            -label_smoothing 0.1
fi
