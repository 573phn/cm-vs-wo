#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=3-00:00:00
#SBATCH --mem=8000
#SBATCH --partition=gpu
#SBATCH --gres=gpu:k40:2
#SBATCH --dependency=singleton

if [ "$#" -ne 1 ]; then
    echo "$0: Incorrect number of arguments used, halting execution."
    exit
else
    python OpenNMT-py/translate.py -model data/"${1}"/trained_model_step_100000.pt -src data/"${1}"/src_test.txt -output data/"${1}"/out_test.txt
    python get_accuracy.py "${1}"
fi