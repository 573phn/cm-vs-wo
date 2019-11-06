#!/bin/bash
# Load Python module
module load Python

# Clone OpenNMT-py repository
git clone https://github.com/OpenNMT/OpenNMT-py.git cm-vs-wo/OpenNMT-py

# Create virtual environment
python3 -m venv cm-vs-wo/env

# Activate virtual environment
source cm-vs-wo/env/bin/activate

# Upgrade pip (inside virtual environment)
pip install --upgrade pip

# Install required packages (inside virtual environment)
pip install torch torchvision torchtext configargparse
