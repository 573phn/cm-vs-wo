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
            └── slurm
```

## Usage
After [getting the project up and running](#getting-started), a job script can be submitted to [the Peregrine HPC cluster](https://www.rug.nl/society-business/centre-for-information-technology/research/services/hpc/facilities/peregrine-hpc-cluster?lang=en). Depending on what you want to do, you can use one of the following commands:
### Reproduce thesis research
```bash
bash jobscript.sh thesis
```
This command will reproduce the research and results of my thesis. The steps it will take are as follows:
1. Makes the VOS, VSO and MIX corpus
2. Pre-processes each corpus
3. Trains the following models for each corpus:
  * RNN with Attention
  * RNN without Attention
  * Transformer with Attention
  * Transformer without Attention
4. Tests each model and calculates its accuracy per training checkpoint

### Make or pre-process corpus
```bash
bash jobscript.sh [make|preprocess] [vso|vos|mix]
```
When using `make`, the following files are created in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `par_corp.txt`: all sentences in the source and target language
* `src_train.txt`: sentences of the training set in the source language
* `tgt_train.txt`: sentences of the training set in the target language
* `src_val.txt`: sentences of the validation set in the source language
* `tgt_val.txt`: sentences of the validation set in the target language
* `src_test.txt`: sentences of the test set in the source language
* `tgt_test.txt`: sentences of the test set in the target language

When using `preprocess`, the following files are created in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `prepared_data.vocab.pt`: serialized PyTorch file containing training data
* `prepared_data.valid.0.pt`: serialized PyTorch file containing validation data
* `prepared_data.train.0.pt`: serialized PyTorch file containing vocabulary data

### Train a model
```bash
bash jobscript.sh train [vso|vos|mix] [rnn|transformer] [attn|noat] seed
```
When using `train`, the following files are created in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `trained_model_E_M_S_step_0.pt`: the trained model, where
  * E is rnn or transformer
  * M is attn (with attention) or noat (without attention)
  * S is the seed used for training the model
  * N is the number of steps (a checkpoint is saved after every 50 steps)

### Translate test set using trained model
```bash
bash jobscript.sh translate [vso|vos|mix] [rnn|transformer] [attn|noat] seed [each|last]
```
When using `translate`, the following files are created in `/data/$USER/cm-vs-wo/data/[vso|vos|mix]`:
* `out_test_E_M_S_step_N.txt`: sentences as translated by the model, where
  * E is rnn or transformer
  * M is attn (with attention) or noat (without attention)
  * S is the seed used for training the model
  * N is the number of steps the model has been trained

## Built with
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py) - A [PyTorch](https://pytorch.org/) port of [OpenNMT](http://opennmt.net/), an open-source neural machine translation system
