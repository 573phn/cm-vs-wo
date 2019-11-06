#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --time=3-00:00:00
#SBATCH --mem=8000
#SBATCH --partition=gpu
#SBATCH --gres=gpu:k40:2

if [ "$#" -ne 2 ]; then
    echo "Incorrect number of arguments used, halting execution."
    exit
fi

if [[ "$1" =~ ^(preprocess|train|translate|all)$ ]] && [[ "$2" =~ ^(vso|vos|mix|all)$ ]]; then
    # Load Python module
    module load Python

    # Activate virtual environment
    source env/bin/activate

    # Make environment variable to use GPUs
    export CUDA_VISIBLE_DEVICES=0,1

    if [[ "$1" == "preprocess" ]] || [[ "$1" == "all" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/preprocess.py -train_src data/vso/src_train.txt -train_tgt data/vso/tgt_train.txt -valid_src data/vso/src_val.txt -valid_tgt data/vso/tgt_val.txt -save_data data/vso/prepared_data
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/preprocess.py -train_src data/vos/src_train.txt -train_tgt data/vos/tgt_train.txt -valid_src data/vos/src_val.txt -valid_tgt data/vos/tgt_val.txt -save_data data/vos/prepared_data
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/preprocess.py -train_src data/mix/src_train.txt -train_tgt data/mix/tgt_train.txt -valid_src data/mix/src_val.txt -valid_tgt data/mix/tgt_val.txt -save_data data/mix/prepared_data
        fi
    fi

    if [[ "$1" == "train" ]]; then
        if [[ "$2" == "vso" ]]; then
            python OpenNMT-py/train.py -data data/vso/prepared_data -save_model data/vso/trained_model -world_size 2 -gpu_ranks 0 1
        elif [[ "$2" == "vos" ]]; then
            python OpenNMT-py/train.py -data data/vos/prepared_data -save_model data/vos/trained_model -world_size 2 -gpu_ranks 0 1
        elif [[ "$2" == "mix" ]]; then
            python OpenNMT-py/train.py -data data/mix/prepared_data -save_model data/mix/trained_model -world_size 2 -gpu_ranks 0 1
        elif [[ "$2" == "all" ]]; then
            sbatch train.sh vso
            sbatch train.sh vos
            sbatch train.sh mix
        fi
    elif [[ "$1" == "all" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            sbatch train.sh vso
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            sbatch train.sh vos
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            sbatch train.sh mix
        fi
    fi

    if [[ "$1" == "translate" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/translate.py -model data/vso/trained_model_step_100000.pt -src data/vso/src-test.txt -output data/vso/out_test.txt
            python get_accuracy.py vso
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/translate.py -model data/vos/trained_model_step_100000.pt -src data/vos/src-test.txt -output data/vos/out_test.txt
            python get_accuracy.py vos
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            python OpenNMT-py/translate.py -model data/mix/trained_model_step_100000.pt -src data/mix/src-test.txt -output data/mix/out_test.txt
            python get_accuracy.py mix
        fi

    elif [[ "$1" == "all" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            sbatch translate.sh vso
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            sbatch translate.sh vos
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            sbatch translate.sh mix
        fi
    fi

else
    echo "Invalid arguments used, halting execution."
    exit
fi