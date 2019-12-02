#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/preprocess-job-%j.log
#SBATCH --time=5:00
#SBATCH --mem=50MB
#SBATCH --partition=short

# Print arguments
echo "${@}"

# Set variables
HOMEDIR='/home/'"${USER}"'/cm-vs-wo'
DATADIR='/data/'"${USER}"'/cm-vs-wo'
ERROR=$(cat <<-END
  preprocess.sh: Incorrect usage.
  Correct usage options are:
  - preprocess.sh [vso|vos|mix]
END
)

# Load Python module
module load Python/3.6.4-intel-2018a

# Activate virtual environment
source "${DATADIR}"/env/bin/activate

# Preprocess data
if [[ "$1" =~ ^(vso|vos|mix)$ ]]; then
  python "${DATADIR}"/OpenNMT-py/preprocess.py -train_src "${HOMEDIR}"/data/"${1}"/src_train.txt \
                                               -train_tgt "${HOMEDIR}"/data/"${1}"/tgt_train.txt \
                                               -valid_src "${HOMEDIR}"/data/"${1}"/src_val.txt \
                                               -valid_tgt "${HOMEDIR}"/data/"${1}"/tgt_val.txt \
                                               -save_data "${DATADIR}"/data/"${1}"/ppd
else
  echo "${ERROR}"
  exit
fi