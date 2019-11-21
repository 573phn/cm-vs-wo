#!/bin/bash
#SBATCH --job-name=cm-vs-wo
#SBATCH --output=slurm/initial-job-%j.log
#SBATCH --time=5:00
#SBATCH --mem=100MB
#SBATCH --partition=short

if [ "$#" -ne 4 ]; then
    echo "jobscript.sh: Incorrect number of arguments used, halting execution."
    exit
fi

if [[ "$1" =~ ^(preprocess|train|translate|ptt)$ ]] && \
   [[ "$2" =~ ^(vso|vos|mix|all)$ ]] && \
   [[ "$3" =~ ^(attn|noat|both)$ ]] && \
   [[ "$4" =~ ^(last|each)$ ]]; then
    # Load Python module
    module load Python

    # Activate virtual environment
    source /data/"${USER}"/cm-vs-wo/env/bin/activate

    # Make environment variable to use GPUs
    export CUDA_VISIBLE_DEVICES=0,1

    if [[ "$1" == "preprocess" ]] || [[ "$1" == "ptt" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            python /data/"${USER}"/OpenNMT-py/preprocess.py -train_src data/vso/src_train.txt \
															-train_tgt data/vso/tgt_train.txt \
															-valid_src data/vso/src_val.txt \
															-valid_tgt data/vso/tgt_val.txt \
															-save_data /data/"${USER}"/cm-vs-wo/data/vso/prepared_data
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            python /data/"${USER}"/OpenNMT-py/preprocess.py -train_src data/vos/src_train.txt \
															-train_tgt data/vos/tgt_train.txt \
															-valid_src data/vos/src_val.txt \
															-valid_tgt data/vos/tgt_val.txt \
															-save_data /data/"${USER}"/cm-vs-wo/data/vos/prepared_data
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            python /data/"${USER}"/OpenNMT-py/preprocess.py -train_src data/mix/src_train.txt \
															-train_tgt data/mix/tgt_train.txt \
															-valid_src data/mix/src_val.txt \
															-valid_tgt data/mix/tgt_val.txt \
															-save_data /data/"${USER}"/cm-vs-wo/data/mix/prepared_data
        fi
    fi

    if [[ "$1" == "train" ]] || [[ "$1" == "ptt" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh vso attn
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh vso noat
            fi
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh vos attn
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh vos noat
            fi
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh mix attn
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch train.sh mix noat
            fi
        fi
    fi

    if [[ "$1" == "translate" ]] || [[ "$1" == "ptt" ]]; then
        if [[ "$2" == "vso" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh vso attn "${4}"
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh vso noat "${4}"
            fi
        fi
        if [[ "$2" == "vos" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh vos attn "${4}"
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh vos noat "${4}"
            fi
        fi
        if [[ "$2" == "mix" ]] || [[ "$2" == "all" ]]; then
            if [[ "$3" == "attn" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh mix attn "${4}"
            fi
            if [[ "$3" == "noat" ]] || [[ "$3" == "both" ]]; then
                sbatch translate.sh mix noat "${4}"
            fi
        fi
    fi

else
    echo "jobscript.sh: Invalid arguments used, halting execution."
    exit
fi
