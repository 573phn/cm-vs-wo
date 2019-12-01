#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/translate-job-%j.log
#SBATCH --time=1:30:00
#SBATCH --mem=1GB
#SBATCH --partition=regular

echo "${@}"

HOMEDIR='/home/'"${USER}"'/cm-vs-wo'
DATADIR='/data/'"${USER}"'/cm-vs-wo'

if [[ "$5" == "last" ]]; then
  NUM=1000
  python "${DATADIR}"/OpenNMT-py/translate.py -model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}"_step_"${NUM}".pt \
                                              -src "${HOMEDIR}"/data/"${1}"/src_test.txt \
                                              -output "${DATADIR}"/data/"${1}"/out_test_"${2}"_"${3}"_"${4}"_step_"${NUM}".txt \
                                              -batch_size 1
  python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"

elif [[ "$5" == "each" ]]; then
  for NUM in {50..1000..50}; do
    python "${DATADIR}"/OpenNMT-py/translate.py -model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_"${4}"_step_"${NUM}".pt \
                                                -src "${HOMEDIR}"/data/"${1}"/src_test.txt \
                                                -output "${DATADIR}"/data/"${1}"/out_test_"${2}"_"${3}"_"${4}"_step_"${NUM}".txt \
                                                -batch_size 1

  done
  python get_accuracy.py "${1}" "${2}" "${3}" "${4}" "${5}" "${USER}"
fi
