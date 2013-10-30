#! /usr/bin/env python

import sys, os
import matplotlib.pyplot as plt
import numpy as np 
import mdp


xmin = 0
xmax = 1.0
n = 1000
sd = 0.1


xvalues = np.linspace(xmin, xmax, n)
yvalues = xvalues + np.random.normal(loc=0, scale=sd, size=len(xvalues))
xvalues = xvalues + np.random.normal(loc=0, scale=sd, size=len(xvalues))


data = np.array([xvalues, yvalues]).transpose()

#pcanode = mdp.nodes.PCANode()
#pcanode.train(data)
#v = pcanode.get_projmatrix()

#c = np.cov(data)
#(w, v) = np.linalg.eig(c)


plt.figure()
plt.plot(xvalues, yvalues, '.b', ms=10)
plt.plot([-0.5, 1.5], [-0.5, 1.5], 'r', lw=4)
plt.plot([-0.5, 1.5], [1.5, -0.5], 'g', lw=4)
plt.axis([-0.5, 1.5, -0.5, 1.5])
#plt.plot(v[0], 'r', lw=2)
#plt.plot(v[1], 'g', lw=2)
#plt.axis('equal')
plt.xlabel('x')
plt.ylabel('y')
plt.legend(['data', '1st principal component', '2nd principal component'], loc='lower right')
plt.savefig('PCA_figure.png', bbox_inches='tight')
plt.savefig('PCA_figure.pdf', bbox_inches='tight')
plt.show()
