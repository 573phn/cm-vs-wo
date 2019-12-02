# Case Marking Versus Word Order in Neural Machine Translation
This project compares the accuracy of a NMT system when used on two fixed order languages versus a flexible word order language that uses case marking.

## Getting Started
These instructions will get you a copy of the project up and running on [the Peregrine HPC cluster](https://www.rug.nl/society-business/centre-for-information-technology/research/services/hpc/facilities/peregrine-hpc-cluster?lang=en). The assumption is made that you are already [logged in on the cluster](https://redmine.hpc.rug.nl/redmine/projects/peregrine/wiki/General).

### Step 1: Clone this repository
Clones the content of this repository to the cluster.
```bash
git clone https://github.com/573phn/cm-vs-wo.git /home/$USER/cm-vs-wo
```

### Step 2: Change working directory
Changes the current working directory to the newly created `cm-vs-wo` directory.
```bash
cd /home/$USER/cm-vs-wo
```

### Step 3: Execute `setup.sh`
Clones [the OpenNMT-py repository](https://github.com/OpenNMT/OpenNMT-py) and prepares a virtual Python 3 environment in `/data/$USER/cm-vs-wo`.
```bash
./setup.sh
```

### Directory structure after setup
After going through the steps above, the directory structure should look as follows:
```bash
/
├── data
│   └── $USER
│       └── cm-vs-wo
│           ├── data
│           │   ├── mix
│           │   ├── vos
│           │   └── vso
│           ├── env
│           └── OpenNMT-py
└── home
    └── $USER
        └── cm-vs-wo
            ├── data
            │   ├── mix
            │   ├── vos
            │   └── vso
            └── slurm
```

## Usage
After [getting the project up and running](#getting-started), a job script can be submitted to [the Peregrine HPC cluster](https://www.rug.nl/society-business/centre-for-information-technology/research/services/hpc/facilities/peregrine-hpc-cluster?lang=en). Depending on what you want to do, you can use one of the following commands:
### Reproduce thesis research
```bash
sbatch thesis.sh
```
This command will reproduce the research and results of my thesis. The steps it will take are as follows:
1. Pre-processes each corpus
2. Trains the following models for each corpus:
  * LSTM with Attention
  * LSTM without Attention
  * Transformer with with Adam optimization (large)
  * Transformer with with SGD optimization (large)
  * Transformer with with Adam optimization (small)
  * Transformer with with SGD optimization (small)
4. Tests each model and calculates its accuracy per training checkpoint

### Make or pre-process corpus
```bash
sbatch preprocess.sh [vso|vos|mix]
```
Creates the following files in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `ppd.vocab.pt`: serialized PyTorch file containing training data
* `ppd.valid.0.pt`: serialized PyTorch file containing validation data
* `ppd.train.0.pt`: serialized PyTorch file containing vocabulary data

### Train a model
```bash
sbatch train.sh [vso|vos|mix] rnn [none|general]
sbatch train.sh [vso|vos|mix] transformer [sgd|adam] [large|small]
```
Creates the following files in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `trained_model_[vso|vos|mix]_[rnn|transformer]_[adam|sgd]_[large|small|onesize]_step_N.pt`: the trained model, where
  * `[vso|vos|mix]` is the word order
  * `[rnn|transformer]` is the model used
  * `[adam|sgd]` is the optimization method
  * `[large|small|onesize]` is the size of the model, this is large or small fo Transformer and onesize for RNN
  * `N` is the number of steps (a checkpoint is saved after every 50 steps)

### Translate test set using trained model
```bash
sbatch translate.sh [vso|vos|mix] rnn [none|general]
sbatch translate.sh [vso|vos|mix] transformer [sgd|adam] [large|small]
```
Creates the following files in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `out_test_[vso|vos|mix]_[rnn|transformer]_[adam|sgd]_[large|small|onesize]_step_N.txt`: sentences as translated by the model, where
  * `[vso|vos|mix]` is the word order
  * `[rnn|transformer]` is the model used
  * `[adam|sgd]` is the optimization method
  * `[large|small|onesize]` is the size of the model, this is large or small fo Transformer and onesize for RNN
  * `N` is the number of steps the model has been trained
Accuracy scores are printed to the slurm log file in `/home/$USER/cm-vs-wo/slurm/translate-job-ID.log`, where ID is the job ID.

## Built with
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py) - A [PyTorch](https://pytorch.org/) port of [OpenNMT](http://opennmt.net/), an open-source neural machine translation system
