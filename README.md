# Word Order Versus Case Marking in Neural Machine Translation

## Initial setup on a Peregrine HPC cluster
### Step 1: Clone this repository
This will clone the content of this repository to your device.
```bash
git clone https://github.com/573phn/cm-vs-wo.git
```
### Step 2: Assign execute permission to `setup.sh`
This will allow `setup.sh` to be executed in the next step.
```bash
chmod +x ./cm-vs-wo/setup.sh
```
### Step 3: Execute `setup.sh`
Executing this file clones the OpenNMT-py repository and prepares a virtual Python 3 environment with the packages `torch`, `torchvision`, `torchtext` and `configargparse`.
```bash
./cm-vs-wo/setup.sh
```

### Folder structure after setup
After going through the three steps above, the folder structure should look as follows:
```bash
├── cm-vs-wo
│   ├── data
│   ├── env
│   └── OpenNMT-py
└── README.md
```
If there is no `env` or `OpenNMT-py` folder, something has gone wrong during the initial setup.

## Usage
After initial setup, a job script can be submitted to the Peregrine HPC cluster to pre-process data, train a model and/or translate data using the following command:
```bash
sbatch jobscript.sh [preprocess|train|translate|all] [vso|vos|mix|all]
```
### Examples
To pre-process, train and translate all three corpora at once, the command to use would be:
```bash
sbatch jobscript.sh all all
```
To only train the VSO model (assuming the data has already been pre-processed), the command would be:
```bash
sbatch jobscript.sh train vso
```