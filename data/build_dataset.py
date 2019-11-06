#!/usr/bin/env python3

""" Converts parallel corpus to files needed for OpenNMT-py. """

from random import shuffle, seed

import numpy as np


def main():
    seed(25)
    corpus = 'mix'
    with open(f'{corpus}/par_corp.txt', 'r') as f:
        par_corp = f.readlines()

    shuffle(par_corp)

    split_1 = int(0.8 * len(par_corp))
    split_2 = int(0.9 * len(par_corp))
    train = [tuple(line.strip().split(' \t ')) for line in par_corp[:split_1]]
    val = [tuple(line.strip().split(' \t ')) for line in par_corp[split_1:split_2]]
    test = [tuple(line.strip().split(' \t ')) for line in par_corp[split_2:]]

    print(f'Total lines in corpus: {len(par_corp)}')
    print(f'Training lines: {len(train)}')
    print(f'Validation lines: {len(val)}')
    print(f'Test lines: {len(test)}')
    # print(len(train)+len(val)+len(test))

    src_train, tgt_train = np.array(train).T
    src_val, tgt_val = np.array(val).T
    src_test, tgt_test = np.array(test).T

    with open(f'{corpus}/src_train.txt', 'w') as f:
        for line in src_train:
            f.write(f'{line}\n')

    with open(f'{corpus}/tgt_train.txt', 'w') as f:
        for line in tgt_train:
            f.write(f'{line}\n')

    with open(f'{corpus}/src_val.txt', 'w') as f:
        for line in src_val:
            f.write(f'{line}\n')

    with open(f'{corpus}/tgt_val.txt', 'w') as f:
        for line in tgt_val:
            f.write(f'{line}\n')

    with open(f'{corpus}/src_test.txt', 'w') as f:
        for line in src_test:
            f.write(f'{line}\n')

    with open(f'{corpus}/tgt_test.txt', 'w') as f:
        for line in tgt_test:
            f.write(f'{line}\n')


if __name__ == '__main__':
    main()
