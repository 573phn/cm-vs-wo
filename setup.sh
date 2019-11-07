#!/bin/bash
# Load Python module
module load Python

# Clone OpenNMT-py repository
git clone https://github.com/OpenNMT/OpenNMT-py.git

# Create virtual environment
python3 -m venv env

# Activate virtual environment
source env/bin/activate

# Upgrade pip (inside virtual environment)
pip install --upgrade pip

# Install required packages (inside virtual environment)
pip install torch torchvision torchtext configargparse
