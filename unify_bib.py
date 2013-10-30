#! /usr/bin/env python

import sys, os


def abort(message):
    print "ERROR: {}. aborting...".format(message)
    sys.exit(1)




if len(sys.argv) > 1:
    filename = sys.argv[1]
else:
    abort('Need input filename')

if not os.path.isfile(filename):
    abort('File does not exist: {}'.format(filename))



bib = open(filename, 'r')
data = bib.readlines()
bib.close




for l, line in enumerate(data):
    words = line.split()

    if len(words) > 0 and (words[0] == 'Author' or words[0] == 'Title' or words[0] == 'Journal'):
        for w, word in enumerate(words):
            if word.isupper():
                words[w] = word.capitalize()

    data[l] = ' '.join(words)

    print data[l]





newbib = open(filename + '.unified', 'w')
for line in data:
    newbib.write(line+'\n')
newbib.close()
