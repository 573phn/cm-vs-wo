#!/bin/bash
# Load Python module
module load Python

# Set data location
DATALOC='/data/'"${USER}"'/cm-vs-wo'

# Prepare /data directories
mkdir /data/"${USER}"/cm-vs-wo
mkdir /data/"${USER}"/cm-vs-wo/data
mkdir /data/"${USER}"/cm-vs-wo/data/vso
mkdir /data/"${USER}"/cm-vs-wo/data/vos
mkdir /data/"${USER}"/cm-vs-wo/data/mix

# Clone OpenNMT-py repository
git clone https://github.com/OpenNMT/OpenNMT-py.git "${DATALOC}"/OpenNMT-py

# Create virtual environment
python3 -m venv "${DATALOC}"/env

# Activate virtual environment
source "${DATALOC}"/env/bin/activate

# Upgrade pip (inside virtual environment)
pip install --upgrade pip

# Install required packages (inside virtual environment)
pip install torch torchvision torchtext configargparse
