#!/bin/bash
# Load Python module
module load Python/3.6.4-intel-2018a

# Set data location
DATALOC='/data/'"${USER}"'/cm-vs-wo'

# Prepare /data directories
mkdir "${DATALOC}"
mkdir "${DATALOC}"/data
mkdir "${DATALOC}"/data/vso
mkdir "${DATALOC}"/data/vos
mkdir "${DATALOC}"/data/mix

# Clone OpenNMT-py repository
git clone -b 1.0.0.rc1 --depth 1 https://github.com/OpenNMT/OpenNMT-py.git "${DATALOC}"/OpenNMT-py

# Create virtual environment
python3 -m venv "${DATALOC}"/env

# Activate virtual environment
source "${DATALOC}"/env/bin/activate

# Upgrade pip (inside virtual environment)
pip install --upgrade pip==19.3.1

# Install required packages (inside virtual environment)
pip install torch==1.3.1 torchvision==0.4.2 torchtext==0.4.0 configargparse==0.15.1
