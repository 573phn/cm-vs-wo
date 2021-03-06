#!/usr/bin/env python3

""" Calculates accuracy. """

from decimal import Decimal
from sys import argv

from numpy import arange


def calculate_accuracy(wo, encdec, ga, optim, size, ls, num, username):
    datadir = f'/data/{username}/cm-vs-wo'
    homedir = f'/home/{username}/cm-vs-wo'
    with open(f'{homedir}/data/{wo}/tgt_test.txt') as tgt_file, \
         open(f'{datadir}/data/{wo}/out_test_{encdec}_{ga}_{optim}_{size}_ls'
              f'{ls.replace(".", "_")}_step_{num}.txt') as out_file:

        tgt = tgt_file.readlines()
        out = out_file.readlines()

        sent_total = len(tgt)
        sent_correct = sum(1 for x, y in zip(tgt, out) if x == y)
        accuracy = Decimal(sent_correct / sent_total) * 100

    return accuracy.quantize(Decimal("1.00"))


def main():
    error = '''get_accuracy.py: Incorrect usage.\n
               Correct usage options are:\n
              - get_accuracy.py [vso|vos|mix] rnn [none|general] $USER\n
              - get_accuracy.py [vso|vos|mix] transformer [sgd|adam]
              [large|small] [0.0|0.1] $USER\n'''
    if (
            len(argv) == 5 and
            argv[1] in ('vos', 'vso', 'mix') and
            argv[2] == 'rnn' and
            argv[3] in ('none', 'general')
    ):
        wo = argv[1]
        encdec = argv[2]
        ga = argv[3]
        optim = 'sgd'
        size = 'onesize'
        ls = '0.0'
        username = argv[4]
        print(wo, encdec, ga, optim, size, ls)
        print(f'(steps, accuracy)')
        for num in arange(50, 1050, 50):
            acc = calculate_accuracy(wo, encdec, ga, optim, size, ls, num,
                                     username)
            print(f'({num}, {acc})')
    elif (
            len(argv) == 7 and
            argv[1] in ('vos', 'vso', 'mix') and
            argv[2] == 'transformer' and
            argv[3] in ('sgd', 'adam') and
            argv[4] in ('large', 'small') and
            argv[5] in ('0.0', '0.1')
    ):
        wo = argv[1]
        encdec = argv[2]
        ga = 'general'
        optim = argv[3]
        size = argv[4]
        ls = argv[5]
        username = argv[6]
        print(wo, encdec, ga, optim, size, ls)
        print(f'(steps, accuracy)')
        for num in arange(50, 1050, 50):
            acc = calculate_accuracy(wo, encdec, ga, optim, size, ls, num,
                                     username)
            print(f'({num}, {acc})')
    else:
        print(error)


if __name__ == '__main__':
    main()
