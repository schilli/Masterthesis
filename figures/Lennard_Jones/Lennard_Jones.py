#! /usr/bin/env python

import sys, os
import matplotlib.pyplot as plt
import numpy as np 


# carbon
#sig_C = 3.39967e-01
sig_C = 1.40000e-01
eps_C = 3.59824e-01

# hydrogen
#sig_H = 1.06908e-01
sig_H = 7.40000e-02
eps_H = 6.56888e-02

sigCC = sig_C
sigHH = sig_H
sigCH = 0.5 * (sig_C + sig_H)

epsCC = eps_C
epsHH = eps_H
epsCH = (eps_C * eps_H)**0.5

C6CC  = 4 * epsCC * sigCC**6
C6HH  = 4 * epsHH * sigHH**6
C6CH  = 4 * epsCH * sigCH**6

C12CC = 4 * epsCC * sigCC**12
C12HH = 4 * epsHH * sigHH**12
C12CH = 4 * epsCH * sigCH**12


n = 100
rCC = np.linspace(0.95*sigCC, 1.9*sigCC, n)
rHH = np.linspace(0.95*sigHH, 1.9*sigHH, n)
rCH = np.linspace(0.95*sigCH, 1.9*sigCH, n)

LJ_CC = 4 * epsCC * ((sigCC/rCC)**12 - (sigCC/rCC)**6)
LJ_HH = 4 * epsHH * ((sigHH/rHH)**12 - (sigHH/rHH)**6)
LJ_CH = 4 * epsCH * ((sigCH/rCH)**12 - (sigCH/rCH)**6)

LJ_CC = ((C12CC)/(rCC)**12) - ((C6CC)/(rCC)**6)
LJ_HH = ((C12HH)/(rHH)**12) - ((C6HH)/(rHH)**6)
LJ_CH = ((C12CH)/(rCH)**12) - ((C6CH)/(rCH)**6)

plt.figure()
plt.plot(10*rCC, LJ_CC, 'b', lw=2)
plt.plot(10*rHH, LJ_HH, 'r', lw=2)
plt.plot(10*rCH, LJ_CH, 'g', lw=2)
plt.plot([0, 3], [0, 0], '--k')
plt.xlabel('distance (Angstrom)')
plt.ylabel('energy (kJ/mol)')
plt.axis([0, 3, -0.4, 0.8])
plt.legend(['carbon - carbon', 'hydrogen - hydrogen', 'carbon - hydrogen'], loc='upper right')
plt.savefig('Lennard_Jones.png', bbox_inches='tight')
plt.savefig('Lennard_Jones.pdf', bbox_inches='tight')
plt.show()
