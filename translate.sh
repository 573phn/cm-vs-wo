#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=5:00
#SBATCH --mem=10MB
#SBATCH --partition=short
#SBATCH --dependency=singleton

if [ "$#" -ne 2 ]; then
    echo "$0: Incorrect number of arguments used, halting execution."
    exit
else
    python OpenNMT-py/translate.py -model data/"${1}"/trained_model_"${2}"_step_10000.pt \
                                   -src data/"${1}"/src_test.txt \
                                   -output data/"${1}"/out_test_"${2}".txt \
                                   -batch_size 1
    python get_accuracy.py "${1}" "${2}"
fi