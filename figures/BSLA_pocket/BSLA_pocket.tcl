#set  inFile "1I6W_hydrogen.pdb"
set  inFile "1R50_hydrogen.pdb"
set outFile "BSLA_pocket"

display rendermode GLSL
display shadows on
display ambientocclusion on
display projection Orthographic

display backgroundgradient off
color Display Background white

#display backgroundgradient on
#color Display BackgroundTop white
#color Display BackgroundBot white

axes location off
display cuemode linear


# define new materials, but only once
if {![info exists materialsDefined]} {

    set materialsDefined 1

    # new material
    material add copy Edgy
    set materials [material list]
    set numMaterials [llength $materials]
    material rename [lindex $materials [expr $numMaterials - 1]] EdgyTransparent
    material change opacity EdgyTransparent 0.4 

}




# clear all molecules
if {[molinfo num] > 0} {
    mol delete all
}

# load BSLA from PDB
set BSLAmol [mol new $inFile]

# delete all representations
mol delrep all $BSLAmol
 
# make selections
set water  [atomselect $BSLAmol "water"]
set chainA [atomselect $BSLAmol "protein and chain A"]

# center on chain A
display resetview
set chainAcenter [list [measure center $chainA]]
molinfo $BSLAmol set center $chainAcenter

# scale
scale by 3.0

# rotate
rotate z by -90
rotate y by  25
rotate x by  -5

# translate
translate by 0.0 -0.1 0.0





## chainA representation
#mol addrep $BSLAmol
#set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect $rep1 $BSLAmol "protein and chain A"
#mol modcolor  $rep1 $BSLAmol ColorID 2
#mol modstyle  $rep1 $BSLAmol NewCartoon
#mol modmaterial $rep1 $BSLAmol EdgyTransparent
#
#
## catalytic triad representation
#mol addrep $BSLAmol
#set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect   $rep1 $BSLAmol "chain A and resid 77 133 156"
#mol modcolor    $rep1 $BSLAmol Element
#mol modstyle    $rep1 $BSLAmol CPK 1.0 0.3 10.0 10.0
#mol modmaterial $rep1 $BSLAmol Edgy
#
#
## surface
#mol addrep $BSLAmol
#set surfaceRep [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect   $surfaceRep $BSLAmol "protein and chain A and not resid 77 133 134 135 136 137 156 and not (resid 12 78 and name N or resid 12 78 and hydrogen)"
#mol modcolor    $surfaceRep $BSLAmol ColorID 6
#mol modstyle    $surfaceRep $BSLAmol MSMS 2.50 3.0 0.0 0.0
#mol modmaterial $surfaceRep $BSLAmol Edgy
#
#
## oxyanion hole
#mol addrep $BSLAmol
#set oxyanionHole [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect   $oxyanionHole $BSLAmol "chain A and resid 12 78 and name N H"
#mol modcolor    $oxyanionHole $BSLAmol Element
#mol modstyle    $oxyanionHole $BSLAmol VDW 1.0 12.0
#mol modmaterial $oxyanionHole $BSLAmol Edgy 
#
#
## ligand
#mol addrep $BSLAmol
#set ligand [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect   $ligand $BSLAmol "chain A and resname SIL and not hydrogen"
#mol modcolor    $ligand $BSLAmol Element
#mol modstyle    $ligand $BSLAmol Licorice
#mol modmaterial $ligand $BSLAmol Glass3
 


# Alternative representations

# protein
mol addrep $BSLAmol
set chainA [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $chainA $BSLAmol "protein and chain A and not hydrogen and not resid 77 133 134 135 136 137 156 and not (resid 12 78 and name N H)"
mol modcolor    $chainA $BSLAmol ColorID 2
mol modstyle    $chainA $BSLAmol VDW 1.0 12.0
mol modmaterial $chainA $BSLAmol AOChalky

# catalytic triad representation
mol addrep $BSLAmol
set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $rep1 $BSLAmol "chain A and resid 77 133 156 and (sidechain or backbone)"
mol modcolor    $rep1 $BSLAmol Element
mol modstyle    $rep1 $BSLAmol CPK 1.0 0.3 10.0 10.0
mol modmaterial $rep1 $BSLAmol AOChalky

# ligand
mol addrep $BSLAmol
set ligand [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $ligand $BSLAmol "chain A and resname SIL and not hydrogen"
mol modcolor    $ligand $BSLAmol Element
mol modstyle    $ligand $BSLAmol Licorice
mol modmaterial $ligand $BSLAmol AOChalky

# loop
mol addrep $BSLAmol
set loop [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $loop $BSLAmol "protein and chain A and not hydrogen and resid 134 135 136 137 138"
mol modcolor    $loop $BSLAmol ColorID 2
mol modstyle    $loop $BSLAmol NewCartoon
mol modmaterial $loop $BSLAmol EdgyTransparent

# oxyanion hole
mol addrep $BSLAmol
set oxyanionHole [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $oxyanionHole $BSLAmol "chain A and resid 12 78 and name N H"
mol modcolor    $oxyanionHole $BSLAmol Element
mol modstyle    $oxyanionHole $BSLAmol VDW 1.0 12.0
mol modmaterial $oxyanionHole $BSLAmol AOChalky






proc renderScene {outFile} {

    render TachyonInternal $outFile.tga
    exec convert $outFile.tga $outFile.png
}
