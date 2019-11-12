#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=5:00
#SBATCH --mem=10MB
#SBATCH --partition=short
#SBATCH --dependency=singleton

if [ "$#" -ne 3 ]; then
    echo "translate.sh: Incorrect number of arguments used, halting execution."
    exit
else
    if [[ "$3" == "last" ]]; then
        python OpenNMT-py/translate.py -model data/"${1}"/trained_model_"${2}"_step_1000.pt \
                                       -src data/"${1}"/src_test.txt \
                                       -output data/"${1}"/out_test_"${2}"_step_1000.txt \
                                       -batch_size 1
        python get_accuracy.py "${1}" "${2}" "${3}"

    elif [[ "$3" == "each" ]]; then
        for num in {50..1050..50}; do
            python OpenNMT-py/translate.py -model data/"${1}"/trained_model_"${2}"_step_"${num}".pt \
                                           -src data/"${1}"/src_test.txt \
                                           -output data/"${1}"/out_test_"${2}"_step_"${num}".txt \
                                           -batch_size 1
        done
        python get_accuracy.py "${1}" "${2}" "${3}"
    else
        echo "translate.sh: Incorrect arguments used, halting execution."
        exit
    fi
fi