# Case Marking Versus Word Order in Neural Machine Translation
This project compares the accuracy of a NMT system when used on two fixed order languages versus a flexible word order language that uses case marking.

## Getting Started
These instructions will get you a copy of the project up and running on [the Peregrine HPC cluster](https://www.rug.nl/society-business/centre-for-information-technology/research/services/hpc/facilities/peregrine-hpc-cluster?lang=en). The assumption is made that you are already [logged in on the cluster](https://redmine.hpc.rug.nl/redmine/projects/peregrine/wiki/General).

### Step 1: Clone this repository
Clones the content of this repository to the cluster.
```bash
git clone https://github.com/573phn/cm-vs-wo.git
```

### Step 2: Change working directory
Changes the current working directory to the newly created `cm-vs-wo` directory.
```bash
cd cm-vs-wo
```

### Step 3: Execute `setup.sh`
Clones [the OpenNMT-py repository](https://github.com/OpenNMT/OpenNMT-py) and prepares a virtual Python 3 environment with the required packages.
```bash
./setup.sh
```

### Directory structure after setup
After going through the steps above, the directory structure should look as follows:
```bash
cm-vs-wo
├── data
├── env         # Added after executing setup.sh, contains the virtual Python 3 environment
└── OpenNMT-py  # Added after executing setup.sh, contains the OpenNMT-py repository
```

## Usage
After [getting the project up and running](#getting-started), a job script can be submitted to [the Peregrine HPC cluster](https://www.rug.nl/society-business/centre-for-information-technology/research/services/hpc/facilities/peregrine-hpc-cluster?lang=en) to pre-process data, train a model and/or translate data using the following command:
```bash
sbatch jobscript.sh [preprocess|train|translate|all] [vso|vos|mix|all]
```

### Examples
Pre-process, train and translate all three corpora at once:
```bash
sbatch jobscript.sh all all
```

Only train the VSO model (assuming the data has already been pre-processed):
```bash
sbatch jobscript.sh train vso
```

## Built with
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py) - A [PyTorch](https://pytorch.org/) port of [OpenNMT](http://opennmt.net/), an open-source neural machine translation system