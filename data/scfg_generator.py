#!/usr/bin/env python3

""" Run 'python3 scfg_generator.py' to generate all possible sentences. Run
    'python3 scfg_generator.py > filename.txt' to generate all possible
    sentences and save them to a file. Adjust filename and add directory if
    needed. """

from itertools import product

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
    corpus = 'vso'

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
        for i in list(product(*sent_type)):
            # Print all options, both languages in SVO order:
            # print('\t'.join(' '.join(row) for row in np.array(i).T))

            en, nl = np.array(i).T
            en_subj, en_verb, en_obj = en
            nl_subj, nl_verb, nl_obj = nl

            if en_subj != en_obj and nl_subj != nl_obj:     # Avoid subject and object being the same
                if corpus == 'svo':     # Fixed order (EN:SVO NL:SVO)
                    print(en_subj, en_verb, en_obj, '\t', nl_subj, nl_verb, nl_obj)

                elif corpus == 'vso':   # Fixed order (EN:VSO NL:SVO)
                    print(en_verb, en_subj, en_obj, '\t', nl_subj, nl_verb, nl_obj)

                elif corpus == 'vos':   # Fixed order (EN:VOS NL:SVO)
                    print(en_verb, en_obj, en_subj, '\t', nl_subj, nl_verb, nl_obj)

                elif corpus == 'mix':   # Mixed order (EN:VSO&VOS NL:SVO) + case marking
                    print(en_verb, en_subj + '_s', en_obj + '_o', '\t', nl_subj, nl_verb, nl_obj)
                    print(en_verb, en_obj + '_o', en_subj + '_s', '\t', nl_subj, nl_verb, nl_obj)


if __name__ == '__main__':
    main()
