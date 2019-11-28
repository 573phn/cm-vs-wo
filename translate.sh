#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/translate-job-%j.log
#SBATCH --time=1:30:00
#SBATCH --mem=1GB
#SBATCH --partition=regular

echo "${@}"

DATALOC='/data/'"${USER}"'/cm-vs-wo'

if [[ "$5" == "last" ]]; then
  NUM=1000
  python "${DATALOC}"/OpenNMT-py/translate.py -model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}"_step_"${NUM}".pt \
                                              -src "${DATALOC}"/data/"${1}"/src_test.txt \
                                              -output "${DATALOC}"/data/"${1}"/out_test_"${2}"_"${3}"_"${4}"_step_"${NUM}".txt \
                                              -batch_size 1
  python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"

elif [[ "$5" == "each" ]]; then
  for NUM in {50..1000..50}; do
    python "${DATALOC}"/OpenNMT-py/translate.py -model "${DATALOC}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}"_step_"${NUM}".pt \
                                                -src "${DATALOC}"/data/"${1}"/src_test.txt \
                                                -output "${DATALOC}"/data/"${1}"/out_test_"${2}"_"${3}"_"${4}"_step_"${NUM}".txt \
                                                -batch_size 1

  done
  python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"
fi
