#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/train-job-%j.log
#SBATCH --time=2:00:00
#SBATCH --mem=1GB
#SBATCH --partition=gpu
#SBATCH --gres=gpu:k40:2

# Print arguments
echo "${@}"

# Set variables
DATADIR='/data/'"${USER}"'/cm-vs-wo'
ERROR=$(cat <<-END
  train.sh: Incorrect usage.
  Correct usage options are:
  - train.sh [vso|vos|mix] rnn [none|general]
  - train.sh [vso|vos|mix] transformer [sgd|adam] [large|small]
END
)

# Load Python module
module load Python/3.6.4-intel-2018a

# Activate virtual environment
source "${DATADIR}"/env/bin/activate

# Make environment variable to use GPUs
export CUDA_VISIBLE_DEVICES=0,1

# Train model
if [[ "$1" =~ ^(vso|vos|mix)$ ]] && [[ "$2" == "rnn" ]] && [[ "$3" =~ ^(none|general)$ ]]; then
  python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                          -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_sgd_onesize \
                                          -train_steps 1000 \
                                          -valid_steps 100 \
                                          -warmup_steps 40 \
                                          -save_checkpoint_steps 50 \
                                          -world_size 2 \
                                          -gpu_ranks 0 1 \
                                          -global_attention "${3}" \
                                          -encoder_type "${2}" \
                                          -decoder_type "${2}"

elif [[ "$1" =~ ^(vso|vos|mix)$ ]] && [[ "$2" == "transformer" ]] && [[ "$3" =~ ^(sgd|adam)$ ]] && [[ "$3" =~ ^(large|small)$ ]]; then
  if [[ "$4" == "large" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_general_"${3}"_"${4}" \
                                            -train_steps 1000 \
                                            -valid_steps 100 \
                                            -warmup_steps 40 \
                                            -save_checkpoint_steps 50 \
                                            -world_size 2 \
                                            -gpu_ranks 0 1 \
                                            -global_attention general \
                                            -encoder_type "${2}" \
                                            -decoder_type "${2}" \
                                            -layers 6 \
                                            -rnn_size 512 \
                                            -word_vec_size 512 \
                                            -position_encoding \
                                            -max_generator_batches 2 \
                                            -dropout 0.1 \
                                            -batch_size 64 \
                                            -batch_type tokens \
                                            -normalization tokens \
                                            -optim adam \
                                            -adam_beta2 0.998 \
                                            -decay_method noam \
                                            -max_grad_norm 0 \
                                            -param_init 0 \
                                            -param_init_glorot \
                                            -label_smoothing 0.1
  elif [[ "$4" == "small" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_general_"${3}"_"${4}" \
                                            -train_steps 1000 \
                                            -valid_steps 100 \
                                            -warmup_steps 40 \
                                            -save_checkpoint_steps 50 \
                                            -world_size 2 \
                                            -gpu_ranks 0 1 \
                                            -global_attention general \
                                            -encoder_type "${2}" \
                                            -decoder_type "${2}" \
                                            -layers 2 \
                                            -rnn_size 500 \
                                            -word_vec_size 500 \
                                            -position_encoding \
                                            -max_generator_batches 2 \
                                            -dropout 0.1 \
                                            -batch_size 64 \
                                            -batch_type tokens \
                                            -normalization tokens \
                                            -optim adam \
                                            -adam_beta2 0.998 \
                                            -decay_method noam \
                                            -max_grad_norm 0 \
                                            -param_init 0 \
                                            -param_init_glorot \
                                            -label_smoothing 0
  fi

else
  echo "${ERROR}"
  exit
fi
