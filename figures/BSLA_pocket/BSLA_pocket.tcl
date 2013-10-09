set  inFile "1I6W_hydrogen.pdb"
set outFile "BSLA_pocket"

display rendermode GLSL
display shadows on
display ambientocclusion on

display backgroundgradient off
color Display Background white

#display backgroundgradient on
#color Display BackgroundTop white
#color Display BackgroundBot white

axes location off


# new material
material add copy Edgy
set materials [material list]
set numMaterials [llength $materials]
material rename [lindex $materials [expr $numMaterials - 1]] EdgyTransparent
material change opacity EdgyTransparent 0.4




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


# chainA representation
#mol addrep $BSLAmol
#set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect $rep1 $BSLAmol "protein and chain A"
#mol modcolor  $rep1 $BSLAmol ColorID 2
#mol modstyle  $rep1 $BSLAmol NewCartoon

# catalytic triad representation
mol addrep $BSLAmol
set rep1 [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect $rep1 $BSLAmol "chain A and resid 77 133 156"
mol modcolor  $rep1 $BSLAmol Element
mol modstyle  $rep1 $BSLAmol CPK 1.000000 0.300000 10.000000 10.000000

# surface
mol addrep $BSLAmol
set surfaceRep [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $surfaceRep $BSLAmol "protein and chain A and not resid 77 133 134 135 136 137 156"
mol modcolor    $surfaceRep $BSLAmol ColorID 2
mol modstyle    $surfaceRep $BSLAmol MSMS 2.50 3.0 0.0 0.0
mol modmaterial $surfaceRep $BSLAmol Edgy

# transparent surface
#mol addrep $BSLAmol
#set surfaceRep2 [expr [molinfo $BSLAmol get numreps] - 1] 
#mol modselect   $surfaceRep2 $BSLAmol "same residue as (protein and chain A and within 5 of resid 77 133 156)"
#mol modcolor    $surfaceRep2 $BSLAmol ColorID 2
#mol modstyle    $surfaceRep2 $BSLAmol MSMS 2.2 1.0 0.0 1.0 
#mol modmaterial $surfaceRep2 $BSLAmol Edgy
 
# transparent surface
mol addrep $BSLAmol
set surfaceRep2 [expr [molinfo $BSLAmol get numreps] - 1] 
mol modselect   $surfaceRep2 $BSLAmol "same residue as (protein and chain A and within 5 of resid 77 133 156)"
mol modcolor    $surfaceRep2 $BSLAmol ColorID 2
mol modstyle    $surfaceRep2 $BSLAmol MSMS 2.2 1.0 0.0 0.0 
mol modmaterial $surfaceRep2 $BSLAmol EdgyTransparent



proc renderScene {outFile} {

    render TachyonInternal $outFile.tga
    exec convert $outFile.tga $outFile.png
