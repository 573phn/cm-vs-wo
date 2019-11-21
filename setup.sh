#!/bin/bash
# Load Python module
module load Python

# Clone OpenNMT-py repository
git clone https://github.com/OpenNMT/OpenNMT-py.git /data/"${USER}"/OpenNMT-py

# Prepare /data directories
mkdir /data/"${USER}"/cm-vs-wo
mkdir /data/"${USER}"/cm-vs-wo/data
mkdir /data/"${USER}"/cm-vs-wo/data/vso
mkdir /data/"${USER}"/cm-vs-wo/data/vos
mkdir /data/"${USER}"/cm-vs-wo/data/mix

# Create virtual environment
python3 -m venv /data/"${USER}"/cm-vs-wo/env

# Activate virtual environment
source /data/"${USER}"/cm-vs-wo/env/bin/activate

# Upgrade pip (inside virtual environment)
pip install --upgrade pip

# Install required packages (inside virtual environment)
pip install torch torchvision torchtext configargparse
