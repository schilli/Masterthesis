#! /usr/bin/env python

import sys, os
import cPickle as pickle
import numpy as np
import matplotlib.pyplot as plt
from running_average import *

# Filenames
boundDataFilename = "citrate_bound_npt_50ns_angle_GLU74CA-TYR56CA-LEU102N.dat"
freeDataFilename  = "citrate_free_md_100ns_angle_GLU74CA-TYR56CA-LEU102N.dat"
figureFilename    = "angle_GLU74CA-TYR56CA-LEU102N.pdf"

# Plot annotations
title  = 'CitA-PAS active site opening (GLU74CA-TYR56CA-LEU102N angle)'
xlabel = 'time (ns)'
ylabel = 'angle (degree)' 

# crystal structure angle
crystal_angle = 51.51 

# citrate free max time (ps) (not in data file)
freeMaxTime = 100000.0

# if data has changed process it again,
# otherwise unpickle processed data
pickleDataFilename = figureFilename + ".pickle"
boundMTime = os.path.getmtime(boundDataFilename)
freeMTime  = os.path.getmtime(freeDataFilename)

if not os.path.isfile(pickleDataFilename) or \
        os.path.getmtime(pickleDataFilename) < max(boundMTime, freeMTime):

    # load data
    boundDataFile = open(boundDataFilename, 'r')
    freeDataFile  = open(freeDataFilename, 'r')
    boundData = boundDataFile.readlines()
    freeData  = freeDataFile.readlines()
    boundDataFile.close() 
    freeDataFile.close() 

    # extract relevant data
    boundAngle = np.zeros(len(boundData), dtype=float)
    freeAngle  = np.zeros(len(freeData),  dtype=float)
    boundTime  = np.zeros(len(boundData), dtype=float)
    freeTime   = np.linspace(0.0, freeMaxTime, len(freeData))

    for i, line in enumerate(boundData):
        boundTime[i]  = float(line.split()[0])
        boundAngle[i] = float(line.split()[1])

    for i, line in enumerate(freeData):
        freeAngle[i] = float(line.split()[1])

    # Convert time to ns
    boundTime = boundTime / 1000.0
    freeTime  = freeTime / 1000.0

    # compute running average
    width = 100
    wintype = "gaussian"
    print "Starting average computation"
    boundAngleAverage = running_average(boundAngle, width, win=wintype)
    freeAngleAverage  = running_average(freeAngle,  width, win=wintype)
    print "Average computation done"

    # pickle Data
    pickleDataFile = open(pickleDataFilename, 'w')
    pickle.dump([boundAngle, freeAngle, boundTime, freeTime, \
            boundAngleAverage, freeAngleAverage], pickleDataFile)
    pickleDataFile.close()

# if pickle file is newer than data files
else:
    # unpickle data
    pickleDataFile = open(pickleDataFilename, 'r')
    [boundAngle, freeAngle, boundTime, freeTime, boundAngleAverage, freeAngleAverage] = pickle.load(pickleDataFile)
    pickleDataFile.close()

# Plot parameters
nxticks = 6
xticks  = np.linspace(0.0, max(boundTime[-1], freeTime[-1]), nxticks)
xticklabels = np.linspace(0.0, max(boundTime[-1], freeTime[-1]), nxticks) 

# set axis limits
xmin = 0
xmax = max(boundTime[-1], freeTime[-1])
ymin = 40
ymax = 110   

# create figure
fig = plt.figure()
ax  = fig.add_subplot(111)

# plot data
ax.plot([0, max(boundTime[-1], freeTime[-1])], [crystal_angle, crystal_angle], \
        'k--', label='Citrate bound crystal structure') 

lw = 2 # linewidth
ax.plot(freeTime,  freeAngleAverage,  '--', color=(0,0.9,0), label='Citrate free', linewidth=lw)
ax.plot(boundTime, boundAngleAverage, '-',  color=(0,0.9,0), label='Citrate bound', linewidth=lw+2)



# annotate plot
ax.set_xlim(xmin, xmax)
ax.set_ylim(ymin, ymax) 
ax.set_title(title)
ax.set_xlabel(xlabel)
ax.set_ylabel(ylabel)
ax.legend()

ax.set_xticks(xticks)
ax.set_xticklabels(xticklabels)

# save plot
plt.savefig(figureFilename)
plt.show()
