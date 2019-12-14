#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/train-job-%j.log
#SBATCH --time=10:00
#SBATCH --mem=10GB
#SBATCH --partition=gpu
#SBATCH --gres=gpu:v100:1

# Print arguments
echo "${@}"

# Set variables
DATADIR='/data/'"${USER}"'/cm-vs-wo'
ERROR=$(cat <<-END
  train.sh: Incorrect usage.
  Correct usage options are:
  - train.sh [vso|vos|mix] rnn [none|general]
  - train.sh [vso|vos|mix] transformer [sgd|adam] [large|small] [0.0|0.1]
END
)

# Load Python module
module load Python/3.6.4-intel-2018a

# Activate virtual environment
source "${DATADIR}"/env/bin/activate

# Make environment variable to use GPUs
export CUDA_VISIBLE_DEVICES=0

# Train model
if [[ "$1" =~ ^(vso|vos|mix)$ ]] && [[ "$2" == "rnn" ]] && [[ "$3" =~ ^(none|general)$ ]]; then
  python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                          -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_"${3}"_sgd_onesize_ls0_0 \
                                          -encoder_type rnn \
                                          -decoder_type rnn \
                                          -train_steps 1000 \
                                          -warmup_steps 40 \
                                          -valid_steps 100 \
                                          -save_checkpoint_steps 50 \
                                          -world_size 1 \
                                          -gpu_ranks 0 \
                                          -global_attention "${3}"

elif [[ "$1" =~ ^(vso|vos|mix)$ ]] && \
     [[ "$2" == "transformer" ]] && \
     [[ "$3" =~ ^(sgd|adam)$ ]] && \
     [[ "$4" =~ ^(large|small)$ ]] && \
     [[ "$5" =~ ^(0.0|0.1)$ ]]; then
  if [[ "$4" == "large" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_general_"${3}"_"${4}"_ls"${5/\./\_}" \
                                            -layers 6 \
                                            -rnn_size 512 \
                                            -word_vec_size 512 \
                                            -transformer_ff 2048 \
                                            -heads 8 \
                                            -encoder_type transformer \
                                            -decoder_type transformer \
                                            -position_encoding \
                                            -train_steps 1000 \
                                            -max_generator_batches 2 \
                                            -dropout 0.1 \
                                            -batch_size 64 \
                                            -batch_type sents \
                                            -normalization sents \
                                            -accum_count 2 \
                                            -optim "${3}" \
                                            -adam_beta2 0.998 \
                                            -decay_method noam \
                                            -warmup_steps 40 \
                                            -learning_rate 2 \
                                            -max_grad_norm 0 \
                                            -param_init 0 \
                                            -param_init_glorot \
                                            -label_smoothing "${5}" \
                                            -valid_steps 100 \
                                            -save_checkpoint_steps 50 \
                                            -world_size 1 \
                                            -gpu_ranks 0

  elif [[ "$4" == "small" ]]; then
    python "${DATADIR}"/OpenNMT-py/train.py -data "${DATADIR}"/data/"${1}"/ppd \
                                            -save_model "${DATADIR}"/data/"${1}"/trained_model_"${2}"_general_"${3}"_"${4}"_ls"${5/\./\_}" \
                                            -layers 2 \
                                            -rnn_size 512 \
                                            -word_vec_size 512 \
                                            -transformer_ff 2048 \
                                            -heads 8 \
                                            -encoder_type transformer \
                                            -decoder_type transformer \
                                            -position_encoding \
                                            -train_steps 1000 \
                                            -max_generator_batches 2 \
                                            -dropout 0.1 \
                                            -batch_size 64 \
                                            -batch_type sents \
                                            -normalization sents \
                                            -accum_count 2 \
                                            -optim "${3}" \
                                            -adam_beta2 0.998 \
                                            -decay_method noam \
                                            -warmup_steps 40 \
                                            -learning_rate 2 \
                                            -max_grad_norm 0 \
                                            -param_init 0 \
                                            -param_init_glorot \
                                            -label_smoothing "${5}" \
                                            -valid_steps 100 \
                                            -save_checkpoint_steps 50 \
                                            -world_size 1 \
                                            -gpu_ranks 0
  fi

else
  echo "${ERROR}"
  exit
fi
