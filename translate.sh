#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/translate-job-%j.log
#SBATCH --time=2:00:00
#SBATCH --mem=400MB
#SBATCH --partition=regular
#SBATCH --dependency=singleton

DATALOC='/data/'"${USER}"'/cm-vs-wo'

if [[ "$3" == "noat" ]]; then
    MODEL="none"
elif [[ "$3" == "attn" ]]; then
    MODEL="general"
fi

if [[ "$5" == "last" ]]; then
    NUM=1000
    python "${DATALOC}"/OpenNMT-py/translate.py -model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${MODEL}"_"${4}".pt \
                                                -src "${DATALOC}"/data/src_test.txt \
                                                -output "${DATALOC}"/data/"${1}"/out_test_"${2}"_"${MODEL}"_"${4}"_step_"${NUM}".txt \
                                                -batch_size 1
    python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"

elif [[ "$5" == "each" ]]; then
    for NUM in {50..1000..50}; do
        python "${DATALOC}"/OpenNMT-py/translate.py -model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${MODEL}"_"${4}".pt \
                                                    -src "${DATALOC}"/data/src_test.txt \
                                                    -output "${DATALOC}"/data/"${1}"/out_test_"${2}"_"${MODEL}"_"${4}"_step_"${NUM}".txt \
                                                    -batch_size 1
   
    done
    python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"
fi
