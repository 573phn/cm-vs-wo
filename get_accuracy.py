#!/usr/bin/env python3

""" Calculates accuracy. """

from decimal import Decimal
from sys import argv


def main():
    if len(argv) < 2:
        print('Add one of the following arguments: vos, vso, mix')
    elif len(argv) > 2:
        print('Too many arguments')
    elif len(argv) == 2:
        if argv[1] in ('vos', 'vso', 'mix'):
            corpus = argv[1]
            with open(f'data/{corpus}/tgt_test.txt', 'r') as tgt_file, \
                    open(f'data/{corpus}/out_test.txt', 'r') as out_file:
                tgt = tgt_file.readlines()
                out = out_file.readlines()

                accuracy = Decimal(sum(1 for x, y in zip(tgt, out) if x == y) / len(tgt)) * 100
                print(f'Accuracy: {accuracy.quantize(Decimal("1.00"))}%')
        else:
            print('Incorrect argument. Use one of the following: vos, vso, mix')


if __name__ == '__main__':
    main()
