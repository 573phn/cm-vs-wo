#!/usr/bin/env python3

""" Generates a parallel corpus.
    Usage: python3 scfg_generator.py [vso|vos|mix]
    Output file will be generated in [vso|vos|mix]/par_corp.txt """

from itertools import product
from sys import argv

import numpy as np


def combine_nouns_and_adjs(nouns_and_adjs):
    """ Function that places adjective between determiner and noun. """
    nouns_with_adjs = []
    for naa in nouns_and_adjs:
        for i in list(product(*naa)):
            naa_en = np.array(i).T[0][0].split()
            naa_en.insert(1, np.array(i).T[0][1])

            naa_nl = np.array(i).T[1][0].split()
            naa_nl.insert(1, np.array(i).T[1][1])

            nouns_with_adjs.append((' '.join(naa_en), ' '.join(naa_nl)))

    return nouns_with_adjs


def main():
    if len(argv) != 3:
        print('scfg_generator.py requires two arguments.')
        print('Usage: scfg_generator.py [vso|vos|mix] $USER')
    elif len(argv) == 3:
        if argv[1] in ('vos', 'vso', 'mix'):
            wo, username = argv[1:]
            dataloc = f'/data/{username}/cm-vs-wo'
            open(f'{dataloc}/data/{wo}/par_corp.txt', 'w+').close()

            nouns = [('the hare', 'de haas'),
                     ('the cat', 'de kat'),
                     ('the dog', 'de hond'),
                     ('the rabbit', 'het konijn'),
                     ('the deer', 'het hert'),
                     ('the sheep', 'het schaap')
                     ]

            verbs = [('hears', 'hoort'),
                     ('sees', 'ziet'),
                     ('follows', 'volgt'),
                     ('calls', 'roept'),
                     ('hugs', 'knuffelt'),
                     ('admires', 'bewondert')
                     ]

            adjs = [('pretty', 'mooie'),
                    ('friendly', 'vriendelijke'),
                    ('big', 'grote'),
                    ('nice', 'leuke'),
                    ('little', 'kleine'),
                    ('sweet', 'lieve')
                    ]

            nouns_with_adjs = combine_nouns_and_adjs([[nouns, adjs]])

            sent_types = [[nouns, verbs, nouns],
                          [nouns, verbs, nouns_with_adjs],
                          [nouns_with_adjs, verbs, nouns],
                          [nouns_with_adjs, verbs, nouns_with_adjs]
                          ]

            for sent_type in sent_types:
                for num, i in enumerate(list(product(*sent_type))):
                    # Print all options, both languages in SVO order:
                    # print('\t'.join(' '.join(row) for row in np.array(i).T))

                    en, nl = np.array(i).T
                    en_subj, en_verb, en_obj = en
                    nl_subj, nl_verb, nl_obj = nl

                    # Avoid subject and object being the same
                    if en_subj != en_obj and nl_subj != nl_obj:
                        with open(f'{dataloc}/data/{wo}/par_corp.txt',
                                  'a') as par_corp:
                            # Fixed order (EN:VSO NL:SVO)
                            if wo == 'vso':
                                sent = [en_verb, en_subj, en_obj, '\t',
                                        nl_subj, nl_verb, nl_obj]

                            # Fixed order (EN:VOS NL:SVO)
                            elif wo == 'vos':
                                sent = [en_verb, en_obj, en_subj, '\t',
                                        nl_subj, nl_verb, nl_obj]

                            # Mixed order (EN:VSO&VOS NL:SVO) + case marking
                            elif wo == 'mix':

                                # Makes sure there is an even amount of VSO
                                # and VOS sentences
                                if num % 2 == 0:
                                    en_subj = en_subj + '_s'
                                    en_obj = en_obj + '_o'
                                    sent = [en_verb, en_subj, en_obj, '\t',
                                            nl_subj, nl_verb, nl_obj]
                                else:
                                    en_obj = en_obj + '_o'
                                    en_subj = en_subj + '_s'
                                    sent = [en_verb, en_obj, en_subj, '\t',
                                            nl_subj, nl_verb, nl_obj]

                            par_corp.write(
                                ' '.join(sent).replace(' \t ', '\t') + '\n')

        else:
            print('Incorrect argument(s) used.')
            print('Usage: scfg_generator.py [vso|vos|mix] $USER')


if __name__ == '__main__':
    main()
