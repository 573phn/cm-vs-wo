#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/initial-job-%j.log
#SBATCH --time=5:00
#SBATCH --mem=50MB
#SBATCH --partition=regular

echo "${@}"

ERROR=$(cat <<-END
  jobscript.sh: Incorrect usage.
  Correct usage options are:
  - jobscript.sh [make|preprocess] [vso|vos|mix]
  - jobscript.sh train [vso|vos|mix] [rnn|transformer] [attn|noat] seed
  - jobscript.sh translate [vso|vos|mix] [rnn|transformer] [attn|noat] seed [each|last]
END
)

HOMEDIR='/home/'"${USER}"'/cm-vs-wo'
DATADIR='/data/'"${USER}"'/cm-vs-wo'

# Load Python module
module load Python/3.6.4-intel-2018a

# Activate virtual environment
source "${DATADIR}"/env/bin/activate

if [ "$#" -eq 1 ] && [[ "$1" == "thesis" ]]; then
  for WO in vso vos mix; do
    python data/scfg_generator.py "${WO}" "${USER}"
    python data/build_dataset.py "${WO}" "${USER}"
    python "${DATADIR}"/OpenNMT-py/preprocess.py -train_src "${HOMEDIR}"/data/"${WO}"/src_train.txt \
                                                 -train_tgt "${HOMEDIR}"/data/"${WO}"/tgt_train.txt \
                                                 -valid_src "${HOMEDIR}"/data/"${WO}"/src_val.txt \
                                                 -valid_tgt "${HOMEDIR}"/data/"${WO}"/tgt_val.txt \
                                                 -save_data "${DATADIR}"/data/"${WO}"/ppd
    for ENCDEC in rnn transformer; do
      for MODEL in attn noat; do
        sbatch train.sh "${WO}" "${ENCDEC}" "${MODEL}" -1
      done
    done
  done
  sbatch delay.sh

elif [ "$#" -eq 2 ]; then
  if [[ "$1" =~ ^(make|preprocess)$ ]] && [[ "$2" =~ ^(vso|vos|mix)$ ]]; then
    if [[ "$1" == "make" ]]; then
      python data/scfg_generator.py "${2}" "${USER}"
      python data/build_dataset.py "${2}" "${USER}"
    elif [[ "$1" == "preprocess" ]]; then
      python "${DATADIR}"/OpenNMT-py/preprocess.py -train_src "${HOMEDIR}"/data/"${2}"/src_train.txt \
                                                   -train_tgt "${HOMEDIR}"/data/"${2}"/tgt_train.txt \
                                                   -valid_src "${HOMEDIR}"/data/"${2}"/src_val.txt \
                                                   -valid_tgt "${HOMEDIR}"/data/"${2}"/tgt_val.txt \
                                                   -save_data "${DATADIR}"/data/"${2}"/ppd
    fi
  else
    echo "${ERROR}"
    exit
  fi
elif [ "$#" -eq 5 ]; then
  if [[ "$1" == "train" ]] && \
     [[ "$2" =~ ^(vso|vos|mix)$ ]] && \
     [[ "$3" =~ ^(rnn|transformer)$ ]] && \
     [[ "$4" =~ ^(attn|noat)$ ]] && \
     [[ "$5" =~ ^-?[0-9]+$ ]]; then
    sbatch "${1}".sh "${2}" "${3}" "${4}" "${5}"
  else
    echo "${ERROR}"
    exit
  fi
elif [ "$#" -eq 6 ]; then
  if [[ "$1" == "translate" ]] && \
     [[ "$2" =~ ^(vso|vos|mix)$ ]] && \
     [[ "$3" =~ ^(rnn|transformer)$ ]] && \
     [[ "$4" =~ ^(attn|noat)$ ]] && \
     [[ "$5" =~ ^-?[0-9]+$ ]] && \
     [[ "$6" =~ ^(each|last)$ ]]; then
    sbatch "${1}".sh "${2}" "${3}" "${4}" "${5}" "${6}"
  else
    echo "${ERROR}"
    exit
  fi
else
  echo "${ERROR}"
  exit
fi
