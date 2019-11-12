#!/usr/bin/env python3

""" Calculates accuracy. """

from decimal import Decimal
from sys import argv

from numpy import arange


def calculate_accuracy(corpus, model, num):
    with open(f'data/{corpus}/tgt_test.txt') as tgt_file, \
         open(f'data/{corpus}/out_test_{model}_step_{num}.txt') as out_file:
        tgt = tgt_file.readlines()
        out = out_file.readlines()

        sent_total = len(tgt)
        sent_correct = sum(1 for x, y in zip(tgt, out) if x == y)
        accuracy = Decimal(sent_correct / sent_total) * 100

        return accuracy.quantize(Decimal("1.00"))


def main():
    if len(argv) < 4 or len(argv) > 4:
        print('get_accuracy.py requires 3 arguments: [vos|vsp|mix] [attn|noat]'
              ' [last|each]')
    elif (
            len(argv) == 4 and
            argv[1] in ('vos', 'vso', 'mix') and
            argv[2] in ('attn', 'noat') and
            argv[3] in ('last', 'each')
          ):
        corpus = argv[1]
        model = argv[2]
        steps = argv[3]
        if steps == "each":
            for num in arange(50, 1050, 50):
                print(f'Accuracy after {num} steps: '
                      f'{calculate_accuracy(corpus, model, num)}% ({corpus}, '
                      f'{model})')

        elif steps == "last":
            num = 1000
            print(f'Accuracy after {num} steps: '
                  f'{calculate_accuracy(corpus, model, num)}% ({corpus}, '
                  f'{model})')

    else:
        print('Invalid arguments used. Use [vos|vsp|mix] [attn|noat] '
              '[last|each]')


if __name__ == '__main__':
    main()
