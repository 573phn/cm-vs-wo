#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/translate-job-%j.log
#SBATCH --time=1:00:00
#SBATCH --mem=10GB
#SBATCH --partition=gpu
#SBATCH --gres=gpu:v100:1

# Print arguments
echo "${@}"

# Set variables
HOMEDIR='/home/'"${USER}"'/cm-vs-wo'
DATADIR='/data/'"${USER}"'/cm-vs-wo'
ERROR=$(cat <<-END
  translate.sh: Incorrect usage.
  Correct usage options are:
  - translate.sh [vso|vos|mix] rnn [none|general]
  - translate.sh [vso|vos|mix] transformer [sgd|adam] [large|small] [0.0|0.1]
END
)

# Load Python module
module load Python/3.6.4-intel-2018a

# Activate virtual environment
source "${DATADIR}"/env/bin/activate

# Make environment variable to use GPUs
export CUDA_VISIBLE_DEVICES=0

if [[ "$1" =~ ^(vso|vos|mix)$ ]] && [[ "$2" == "rnn" ]] && [[ "$3" =~ ^(none|general)$ ]]; then
  for NUM in {50..1000..50}; do
    python "${DATADIR}"/OpenNMT-py/translate.py -model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_sgd_onesize_ls0_0_step_"${NUM}".pt \
                                                -src "${HOMEDIR}"/data/"${1}"/src_test.txt \
                                                -output "${DATADIR}"/data/"${1}"/out_test_"${2}"_"${3}"_sgd_onesize_ls0_0_step_"${NUM}".txt \
                                                -batch_size 1 \
                                                -gpu 0
  done
  python get_accuracy.py "${1}" rnn "${3}" "${USER}"

elif [[ "$1" =~ ^(vso|vos|mix)$ ]] && \
     [[ "$2" == "transformer" ]] && \
     [[ "$3" =~ ^(sgd|adam)$ ]] && \
     [[ "$4" =~ ^(large|small)$ ]] && \
     [[ "$5" =~ ^(0.0|0.1)$ ]]; then
  for NUM in {50..1000..50}; do
    python "${DATADIR}"/OpenNMT-py/translate.py -model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_general_"${3}"_"${4}"_ls"${5/\./_}"_step_"${NUM}".pt \
                                                -src "${HOMEDIR}"/data/"${1}"/src_test.txt \
                                                -output "${DATADIR}"/data/"${1}"/out_test_"${2}"_general_"${3}"_"${4}"_ls"${5/\./_}"_step_"${NUM}".txt \
                                                -batch_size 1 \
                                                -gpu 0
  done
  python get_accuracy.py "${1}" transformer "${3}" "${4}" "${5}" "${USER}"

else
  echo "${ERROR}"
  exit
fi
