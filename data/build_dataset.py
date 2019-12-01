#!/usr/bin/env python3

""" Converts parallel corpus to files needed for OpenNMT-py. """

from random import shuffle, seed
from sys import argv

import numpy as np


def main():
    if len(argv) != 3:
        print('build_dataset.py requires two arguments.')
        print('Usage: build_dataset.py [vso|vos|mix] $USER')
        
    elif len(argv) == 3:
        if argv[1] in ('vos', 'vso', 'mix'):
            wo = argv[1]
            homedir = f'/home/{argv[2]}/cm-vs-wo'
            seed(25)

            with open(f'{homedir}/data/{wo}/par_corp.txt', 'r') as f:
                par_corp = f.readlines()

            par_corp.sort()
            shuffle(par_corp)

            split_1 = int(0.8 * len(par_corp))
            split_2 = int(0.9 * len(par_corp))

            train = []
            for line in par_corp[:split_1]:
                train.append(tuple(line.strip().split('\t')))
            val = []
            for line in par_corp[split_1:split_2]:
                val.append(tuple(line.strip().split('\t')))
            test = []
            for line in par_corp[split_2:]:
                test.append(tuple(line.strip().split('\t')))

            # print(f'Total lines in corpus: {len(par_corp)}')
            # print(f'Training lines: {len(train)}')
            # print(f'Validation lines: {len(val)}')
            # print(f'Test lines: {len(test)}')
            # print(len(train)+len(val)+len(test))

            src_train, tgt_train = np.array(train).T
            src_val, tgt_val = np.array(val).T
            src_test, tgt_test = np.array(test).T

            with open(f'{homedir}/data/{wo}/src_train.txt', 'w') as f:
                for line in src_train:
                    f.write(f'{line}\n')

            with open(f'{homedir}/data/{wo}/tgt_train.txt', 'w') as f:
                for line in tgt_train:
                    f.write(f'{line}\n')

            with open(f'{homedir}/data/{wo}/src_val.txt', 'w') as f:
                for line in src_val:
                    f.write(f'{line}\n')

            with open(f'{homedir}/data/{wo}/tgt_val.txt', 'w') as f:
                for line in tgt_val:
                    f.write(f'{line}\n')

            with open(f'{homedir}/data/{wo}/src_test.txt', 'w') as f:
                for line in src_test:
                    f.write(f'{line}\n')

            with open(f'{homedir}/data/{wo}/tgt_test.txt', 'w') as f:
                for line in tgt_test:
                    f.write(f'{line}\n')
        else:
            print('Incorrect argument(s) used.')
            print('Usage: build_dataset.py [vso|vos|mix] $USER')


if __name__ == '__main__':
    main()
