display rendermode GLSL
display shadows on
display ambientocclusion on

display backgroundgradient off
color Display Background white

#display backgroundgradient on
#color Display BackgroundTop white
#color Display BackgroundBot white






# clear all molecules
if {[molinfo num] > 0} {
    mol delete all
}

# load BSLA from PDB
#set BSLAmol [mol pdbload 1I6W]
set BSLAmol [mol new 1I6W.pdb]

# delete all representations
mol delrep all $BSLAmol
 
# make selections
set water  [atomselect $BSLAmol "water"]
set chainA [atomselect $BSLAmol "protein and chain A"]

# center on chain A
display resetview
set chainAcenter [list [measure center $chainA]]
molinfo $BSLAmol set center $chainAcenter


# chainA representation
mol addrep $BSLAmol
set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect $rep1 $BSLAmol "protein and chain A"
#mol modcolor  $rep1 $BSLAmol Structure
mol modcolor  $rep1 $BSLAmol ColorID 2
mol modstyle  $rep1 $BSLAmol NewCartoon

# catalytic triad representation
mol addrep $BSLAmol
set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect $rep1 $BSLAmol "chain A and resid 77 133 156"
mol modcolor  $rep1 $BSLAmol Element
#mol modstyle  $rep1 $BSLAmol Licorice 
mol modstyle  $rep1 $BSLAmol CPK 1.000000 0.300000 10.000000 10.000000
