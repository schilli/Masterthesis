# clear all molecules
if {[molinfo num] > 0} {
    mol delete all
}

set complex_file "prod01_protein_centered.gro"

set CitAindex "resid < 128"
set BSLAindex "resid > 154"
set Linkindex "resid > 127 and resid < 155"


# default coloring and style methods
mol default color "structure"
mol default style "NewCartoon"


set complex [mol new $complex_file]


set CitA [atomselect $complex $CitAindex]
set BSLA [atomselect $complex $BSLAindex]


set CitACOM [list [measure center $CitA]]
set BSLACOM [list [measure center $BSLA]]
 
 
proc vmd_draw_arrow {mol start end c} {
    # an arrow is made of a cylinder and a cone
    set middle [vecadd $start [vecscale 0.7 [vecsub $end $start]]]
    graphics $mol color $c
    graphics $mol material AOChalky
    graphics $mol cylinder $start $middle radius 0.50 resolution 20
    graphics $mol cone $middle $end radius 2.00 resolution 20
}

#draw arrow $CitACOM $BSLACOM
set BSLACOM {68.44 69.48 18.49}
set CitACOM {72.88 57.97 49.78}
set Lys34 {87.48 48.62 50.38}
set Pro71 {79.95 58.94 35.70}
set Thr199 {68.95 55.81 5.91}

set x {87.48 48.62 50.38}
set y {76.250   62.174   33.290}
set z {81.622   71.965   55.134}

set x2 {83.040   60.130   19.090}
set y2 {71.8097   73.6835    2.0001}
set z2 {77.182   83.475   23.844} 

set Ref {69.3921   43.9596   -4.9955}

draw arrow $CitACOM $BSLACOM magenta
draw arrow $CitACOM $Lys34 red
draw arrow $CitACOM $y green
draw arrow $CitACOM $z blue

draw arrow $BSLACOM $x2 red
draw arrow $BSLACOM $y2 green
draw arrow $BSLACOM $z2 blue
draw arrow $BSLACOM $Ref yellow




mol delrep all $complex

#set material AOChalky
set material Glass1

mol addrep $complex
set CitArep [expr [molinfo $complex get numreps] - 1]
mol modselect   $CitArep $complex $CitAindex
mol modcolor    $CitArep $complex ColorID 3
mol modstyle    $CitArep $complex NewCartoon
mol modmaterial $CitArep $complex $material

mol addrep $complex
set BSLArep [expr [molinfo $complex get numreps] - 1]
mol modselect   $BSLArep $complex $BSLAindex
mol modcolor    $BSLArep $complex ColorID 10
mol modstyle    $BSLArep $complex NewCartoon
mol modmaterial $BSLArep $complex $material

mol addrep $complex
set Linkrep [expr [molinfo $complex get numreps] - 1]
mol modselect   $Linkrep $complex $Linkindex
mol modcolor    $Linkrep $complex ColorID 8
mol modstyle    $Linkrep $complex NewCartoon
mol modmaterial $Linkrep $complex $material

#mol addrep $complex
#set Resrep [expr [molinfo $complex get numreps] - 1]
#mol modselect   $Resrep $complex "resid 31 68"
#mol modcolor    $Resrep $complex ColorID 8
#mol modstyle    $Resrep $complex cpk
#mol modmaterial $Resrep $complex Opaque



axes location Off
display rendermode GLSL
display shadows on
display ambientocclusion on
display projection Orthographic
color Display BackgroundTop white
color Display BackgroundBot white
