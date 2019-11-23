#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/initial-job-%j.log
#SBATCH --time=5:00
#SBATCH --mem=100MB
#SBATCH --partition=short

ERROR=$(cat <<-END
    jobscript.sh: Incorrect usage.
    Correct usage options are:
    - jobscript.sh [make|preprocess] [vso|vos|mix]
    - jobscript.sh [train|translate] [attn|noat] [rnn|transformer] seed
END
)

DATALOC='/data/'"${USER}"'/cm-vs-wo'

# Load Python module
module load Python

# Activate virtual environment
source "${DATALOC}"/env/bin/activate

if [ "$#" -eq 1 ] && [[ "$1" == "thesis" ]]; then
    for WO in vso vos mix; do
        python data/build_dataset.py "${WO}" "${USER}"
        python "${DATALOC}"/OpenNMT-py/preprocess.py -train_src "${DATALOC}"/data/"${WO}"/src_train.txt \
                                                     -train_tgt "${DATALOC}"/data/"${WO}"/tgt_train.txt \
                                                     -valid_src "${DATALOC}"/data/"${WO}"/src_val.txt \
                                                     -valid_tgt "${DATALOC}"/data/"${WO}"/tgt_val.txt \
                                                     -save_data "${DATALOC}"/data/"${WO}"/prepared_data
        for ENCDEC in rnn transformer; do
            for MODEL in attn noat; do
                sbatch "${ACTION}".sh "${WO}" "${ENCDEC}" "${MODEL}" -1
            done
        done
        # Translate nog toevoegen (each/last step)
    done
elif [ "$#" -eq 2 ]; then
    if [[ "$1" =~ ^(make|preprocess)$ ]] && [[ "$2" =~ ^(vso|vos|mix)$ ]]; then
        if [[ "$1" == "make" ]]; then
            python data/build_dataset.py "${2}" "${USER}"
        elif [[ "$1" == "preprocess" ]]; then
            python "${DATALOC}"/OpenNMT-py/preprocess.py -train_src "${DATALOC}"/data/"${2}"/src_train.txt \
                                                         -train_tgt "${DATALOC}"/data/"${2}"/tgt_train.txt \
                                                         -valid_src "${DATALOC}"/data/"${2}"/src_val.txt \
                                                         -valid_tgt "${DATALOC}"/data/"${2}"/tgt_val.txt \
                                                         -save_data "${DATALOC}"/data/"${2}"/prepared_data
        fi
    else
        echo "${ERROR}"
        exit
    fi
elif [ "$#" -eq 4 ]; then
    if [[ "$1" =~ ^(train|translate)$ ]] && \
       [[ "$2" =~ ^(rnn|tranformer)$ ]] \
       [[ "$3" =~ ^(attn|noat)$ ]] \
       [[ "$4" =~ ^-?[0-9]+$ ]]; then
        sbatch "${1}".sh "${2}" "${3}" "${4}"
    else
        echo "${ERROR}"
        exit
    fi
else
    echo "${ERROR}"
    exit
fi
