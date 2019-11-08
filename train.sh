#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=30:00
#SBATCH --mem=6GB
#SBATCH --partition=gpu
#SBATCH --gres=gpu:k40:2

if [ "$#" -ne 2 ]; then
    echo "$0: Incorrect number of arguments used, halting execution."
    exit
else
    if [[ "$2" == "noat" ]]; then
        MODEL="none"
    else
        MODEL="general"
    fi

    python OpenNMT-py/train.py -data data/"${1}"/prepared_data \
                               -save_model data/"${1}"/trained_model_"${2}" \
                               -world_size 2 \
                               -gpu_ranks 0 1 \
                               -train_steps 1000 \
                               -valid_steps 100 \
                               -save_checkpoint_steps 50 \
                               -global_attention "${MODEL}"
fi