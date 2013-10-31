#! /usr/bin/env python

import sys, os
import cPickle as pickle
import numpy as np
import matplotlib.pyplot as plt
from running_average import *

# ============================================================================ #

def get_data(filename, width, wintype):
    datafile = open(filename, 'r')
    data = datafile.readlines()
    datafile.close()

    times  = np.zeros(len(data), dtype=float)
    values = np.zeros(len(data), dtype=float)

    for i, line in enumerate(data):
        times[i]  = float(line.split()[0])
        values[i] = float(line.split()[1]) 

    # Convert time to ns
    times = times / 1000.0 

    average = running_average(values, width, win=wintype)
    print "Running average computed"

    return (average, times)

# ============================================================================ #

# Filenames
boundData_LG_Filename = "citrate_bound_npt_50ns_distance_LEU102N-GLU74CA.dat"
boundData_LT_Filename = "citrate_bound_npt_50ns_distance_LEU102N-TYR56CA.dat"
freeData_LG_Filename  = "citrate_free_md_100ns_distance_LEU102N-GLU74CA.dat"
freeData_LT_Filename  = "citrate_free_md_100ns_distance_LEU102N-TYR56CA.dat"
figureFilename      = "distances.pdf"

# Plot annotations
title  = 'CitA-PAS active site opening (distances)'
xlabel = 'time (ns)'
ylabel = 'distance (Angstrom)' 

# crystal structure distances
crystal_dist_LEU_TYR = 9.312
crystal_dist_LEU_GLU = 9.939 

# citrate free max time (ps) (not in data file)
freeMaxTime = 100000.0

# if data has changed process it again,
# otherwise unpickle processed data
pickleDataFilename = figureFilename + ".pickle"
bound_LG_MTime = os.path.getmtime(boundData_LG_Filename)
bound_LT_MTime = os.path.getmtime(boundData_LT_Filename)
free_LG_MTime  = os.path.getmtime(freeData_LG_Filename)
free_LT_MTime  = os.path.getmtime(freeData_LT_Filename)
maxTime = max(bound_LG_MTime, bound_LT_MTime, free_LG_MTime, free_LT_MTime)

if not os.path.isfile(pickleDataFilename) or \
        os.path.getmtime(pickleDataFilename) < maxTime:

    width = 100
    wintype = "gaussian"
    (bound_LG_average, bound_LG_time) = get_data(boundData_LG_Filename, width, wintype)
    (bound_LT_average, bound_LT_time) = get_data(boundData_LT_Filename, width, wintype)
    (free_LG_average, free_LG_time) = get_data(freeData_LG_Filename, width, wintype)
    (free_LT_average, free_LT_time) = get_data(freeData_LT_Filename, width, wintype)

    # convert to angstrom
    bound_LG_average = 10 * bound_LG_average
    bound_LT_average = 10 * bound_LT_average

    boundTime = bound_LG_time
    #freeTime  = free_LG_time
    freeTime   = np.linspace(0.0, freeMaxTime, len(free_LG_average)) / 1000.0

    # pickle Data
    pickleDataFile = open(pickleDataFilename, 'w')
    pickle.dump([bound_LG_average, bound_LT_average, free_LG_average, free_LT_average, boundTime, freeTime], pickleDataFile)
    pickleDataFile.close()

# if pickle file is newer than data files
else:
    # unpickle data
    pickleDataFile = open(pickleDataFilename, 'r')
    [bound_LG_average, bound_LT_average, free_LG_average, free_LT_average, boundTime, freeTime] = pickle.load(pickleDataFile)
    pickleDataFile.close()

# Plot parameters
nxticks = 6
xticks  = np.linspace(0.0, max(boundTime[-1], freeTime[-1]), nxticks)
xticklabels = np.linspace(0.0, max(boundTime[-1], freeTime[-1]), nxticks) 

# set axis limits
xmin = 0
xmax = max(boundTime[-1], freeTime[-1])
ymin = 5
ymax = 22

# create figure
fig = plt.figure()
ax  = fig.add_subplot(111)

# plot data
ax.plot([0, max(boundTime[-1], freeTime[-1])], [crystal_dist_LEU_GLU, crystal_dist_LEU_GLU], \
        'b:', label='Citrate bound LEU - GLU crystal')
ax.plot([0, max(boundTime[-1], freeTime[-1])], [crystal_dist_LEU_TYR, crystal_dist_LEU_TYR], \
        'r:', label='Citrate bound LEU - TYR crystal')  

lw = 2 # linewidth
ax.plot(freeTime,  free_LG_average,  'b--', label='Citrate free LEU - GLU', linewidth=lw)
ax.plot(freeTime,  free_LT_average,  'r--', label='Citrate free LEU - TYR', linewidth=lw)
ax.plot(boundTime, bound_LG_average, 'b-', label='Citrate bound LEU - GLU', linewidth=lw+2)
ax.plot(boundTime, bound_LT_average, 'r-', label='Citrate bound LEU - TYR', linewidth=lw+2)


# annotate plot
ax.set_xlim(xmin, xmax)
ax.set_ylim(ymin, ymax) 
ax.set_title(title)
ax.set_xlabel(xlabel)
ax.set_ylabel(ylabel)
#ax.legend(loc='upper right')
lgd = ax.legend(bbox_to_anchor=(1.05, 0.7), loc=2, borderaxespad=0.)

ax.set_xticks(xticks)
ax.set_xticklabels(xticklabels)

# save plot
plt.savefig(figureFilename, bbox_extra_artists=(lgd,), bbox_inches='tight')
plt.show()
