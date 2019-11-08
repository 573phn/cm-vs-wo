#!/usr/bin/env python3

""" Calculates accuracy. """

from decimal import Decimal
from sys import argv


def main():
    if len(argv) < 3 or len(argv) > 3:
        print(f'{argv[0]} requires 2 arguments: [vos|vsp|mix] [attn|noat]')
    elif len(argv) == 3:
        if argv[1] in ('vos', 'vso', 'mix') and argv[2] in ('attn', 'noat'):
            corpus = argv[1]
            model = argv[2]
            with open(f'data/{corpus}/tgt_test.txt', 'r') as tgt_file, \
                 open(f'data/{corpus}/out_test_{model}.txt', 'r') as out_file:
                tgt = tgt_file.readlines()
                out = out_file.readlines()

                sent_total = len(tgt)
                sent_correct = sum(1 for x, y in zip(tgt, out) if x == y)
                accuracy = Decimal(sent_correct / sent_total) * 100
                print(f'Accuracy: {accuracy.quantize(Decimal("1.00"))}%')
        else:
            print('Invalid arguments used. Use [vos|vsp|mix] [attn|noat]')


if __name__ == '__main__':
    main()
