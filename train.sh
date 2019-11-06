#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=3-00:00:00
#SBATCH --mem=8000
#SBATCH --partition=gpu
#SBATCH --gres=gpu:k40:2

if [ "$#" -ne 1 ]; then
    echo "$0: Incorrect number of arguments used, halting execution."
    exit
else
    python OpenNMT-py/train.py -data data/"${1}"/prepared_data -save_model data/"${1}"/trained_model -world_size 2 -gpu_ranks 0 1
fi