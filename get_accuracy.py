#!/usr/bin/env python3

""" Calculates accuracy. """

from decimal import Decimal
from sys import argv

from numpy import arange


def calculate_accuracy(wo, encdec, model, seed, num, username):
	dataloc = f'/data/{username}/cm-vs-wo'
    with open(f'{dataloc}/data/{wo}/tgt_test.txt') as tgt_file, \
         open(f'{dataloc}/data/{wo}/out_test_{encdec}_{model}_{seed}_step_{num}.txt') as out_file:

        tgt = tgt_file.readlines()
        out = out_file.readlines()

        sent_total = len(tgt)
        sent_correct = sum(1 for x, y in zip(tgt, out) if x == y)
        accuracy = Decimal(sent_correct / sent_total) * 100

        return accuracy.quantize(Decimal("1.00"))


def main():
    if len(argv) != 7:
        print('get_accuracy.py requires 6 arguments: [vso|vos|mix] [rnn|transformer] [attn|noat] seed [each|last] username')

    elif (
            len(argv) == 7 and
            argv[1] in ('vos', 'vso', 'mix') and
            argv[2] in ('rnn', 'transformer') and
            argv[3] in ('attn', 'noat') and
            argv[4].isdigit() and
            argv[5] in ('last', 'each')
          ):
        wo, encdec, model, seed, steps, username = argv[1:]

        if steps == "each":
            for num in arange(50, 1050, 50):
                print(f'Accuracy after {num} steps: '
                      f'{calculate_accuracy(wo, encdec, model, seed, num, username)}% (word order: {wo}, '
                      f'encoder/decoder: {encdec}, model: {model}, seed: {seed})')

        elif steps == "last":
            num = 1000
			print(f'Accuracy after {num} steps: '
				  f'{calculate_accuracy(wo, encdec, model, seed, num, username)}% (word order: {wo}, '
				  f'encoder/decoder: {encdec}, model: {model}, seed: {seed})')
    else:
        print('Invalid arguments used. Use [vso|vos|mix] [rnn|transformer] [attn|noat] seed [each|last] username')


if __name__ == '__main__':
    main()
