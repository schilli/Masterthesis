set boundFile "2J80a.pdb"
set freeFile  "2V9Aa.pdb"
set outFile "CitAP_conf_change"

display rendermode GLSL
display shadows on
display ambientocclusion on
display projection Orthographic

display backgroundgradient off
color Display Background white

axes location off

display cuemode linear

color change rgb green 0.24 0.39 0.15

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
set boundMol [mol new $boundFile]
set freeMol  [mol new $freeFile]

# delete all representations
mol delrep all $boundMol
mol delrep all $freeMol

set boundAll [atomselect $boundMol "all"]
set freeAll  [atomselect $freeMol  "all"]
set boundSel [atomselect $boundMol "protein"]
set freeSel  [atomselect $freeMol  "protein"]
set boundCommon [atomselect $boundMol "alpha and (resid 4 to 67 or resid 90 to 130)"]
set freeCommon  [atomselect $freeMol  "alpha and (resid 4 to 67 or resid 90 to 130)"]

# superimpose molecules
set transformation [measure fit $freeCommon $boundCommon]
$freeAll move $transformation

 
# center on scene
display resetview
#set chainAcenter [list [measure center $chainA]]
#molinfo $BSLAmol set center $chainAcenter

## scale
scale by 3.1

# rotate
rotate z by 50
rotate y by -105
rotate x by  25

## translate
translate by 0.35 -0.2 0.0



# citrate bound
mol addrep $boundMol
set alpha [expr [molinfo $boundMol get numreps] - 1] 
mol modselect   $alpha $boundMol "resid 4 to 67 90 to 96 108 to 126"
mol modcolor    $alpha $boundMol ColorID 2
mol modstyle    $alpha $boundMol NewCartoon
mol modmaterial $alpha $boundMol AOChalky 

# citrate bound major loop
mol addrep $boundMol
set majorLoop [expr [molinfo $boundMol get numreps] - 1] 
mol modselect   $majorLoop $boundMol "resid 68 to 89"
mol modcolor    $majorLoop $boundMol ColorID 7
mol modstyle    $majorLoop $boundMol NewCartoon
mol modmaterial $majorLoop $boundMol AOChalky  

# citrate bound minor loop
mol addrep $boundMol
set minorLoop [expr [molinfo $boundMol get numreps] - 1] 
mol modselect   $minorLoop $boundMol "resid 97 to 107 127 to 132"
mol modcolor    $minorLoop $boundMol ColorID 23
mol modstyle    $minorLoop $boundMol NewCartoon
mol modmaterial $minorLoop $boundMol AOChalky   

# citrate free
mol addrep $freeMol
set alpha [expr [molinfo $freeMol get numreps] - 1] 
mol modselect   $alpha $freeMol "resid 4 to 96 108 to 126"
mol modcolor    $alpha $freeMol ColorID 2
mol modstyle    $alpha $freeMol NewCartoon
mol modmaterial $alpha $freeMol Edgy

# citrate free minor loop
mol addrep $freeMol
set minorLoop [expr [molinfo $freeMol get numreps] - 1] 
mol modselect   $minorLoop $freeMol "resid 97 to 107 127 to 132"
mol modcolor    $minorLoop $freeMol ColorID 1
mol modstyle    $minorLoop $freeMol NewCartoon
mol modmaterial $minorLoop $freeMol AOChalky    
 
 
# citrate
mol addrep $boundMol
set citrate [expr [molinfo $boundMol get numreps] - 1] 
mol modselect   $citrate $boundMol "resname FLC"
mol modcolor    $citrate $boundMol Element
#mol modstyle    $citrate $boundMol CPK 1.0 0.3 10.0 10.0
mol modstyle    $citrate $boundMol Licorice
mol modmaterial $citrate $boundMol AOChalky  




proc renderScene {outFile} {

    render TachyonInternal $outFile.tga
    exec convert $outFile.tga $outFile.png
}
