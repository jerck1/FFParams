# import modules 
import numpy as np 
import matplotlib.pyplot as plt
import sys, os
### inputs 
name_log = sys.argv[1]
topol = sys.argv[2]
N_Struc = sys.argv[3]

#### extract_xyz 
'''
extract the coordinates of the structures from the relaxed scan from Gaussian16 
if Gaussian09 was used , check the line ' Input orientation' that maybe could be changed by version update.

'''
#from __future__ import print_function


print("------Automated parameter optimization from Gaussian16 and paramfit algorithm----------- \n\n\n\n\n\n\n")

print("------Extraction of scan optimized structures ------- \n\n")
def extract_all(text, target):
    linenums = []
    # Start count at 1 because files start at line 1 not 0
    count = 1
    for line in text:
        if (line.find(target)) > -1:
            linenums.append(count)
        count += 1
    return linenums

code = {"1" : "H", "2" : "He", "3" : "Li", "4" : "Be", "5" : "B", \
"6"  : "C", "7"  : "N", "8"  : "O", "9" : "F", "10" : "Ne", \
"11" : "Na" , "12" : "Mg" , "13" : "Al" , "14" : "Si" , "15" : "P", \
"16" : "S"  , "17" : "Cl" , "18" : "Ar" , "19" : "K"  , "20" : "Ca", \
"21" : "Sc" , "22" : "Ti" , "23" : "V"  , "24" : "Cr" , "25" : "Mn", \
"26" : "Fe" , "27" : "Co" , "28" : "Ni" , "29" : "Cu" , "30" : "Zn", \
"31" : "Ga" , "32" : "Ge" , "33" : "As" , "34" : "Se" , "35" : "Br", \
"36" : "Kr" , "37" : "Rb" , "38" : "Sr" , "39" : "Y"  , "40" : "Zr", \
"41" : "Nb" , "42" : "Mo" , "43" : "Tc" , "44" : "Ru" , "45" : "Rh", \
"46" : "Pd" , "47" : "Ag" , "48" : "Cd" , "49" : "In" , "50" : "Sn", \
"51" : "Sb" , "52" : "Te" , "53" : "I"  , "54" : "Xe" , "55" : "Cs", \
"56" : "Ba" , "57" : "La" , "58" : "Ce" , "59" : "Pr" , "60" : "Nd", \
"61" : "Pm" , "62" : "Sm" , "63" : "Eu" , "64" : "Gd" , "65" : "Tb", \
"66" : "Dy" , "67" : "Ho" , "68" : "Er" , "69" : "Tm" , "70" : "Yb", \
"71" : "Lu" , "72" : "Hf" , "73" : "Ta" , "74" : "W"  , "75" : "Re", \
"76" : "Os" , "77" : "Ir" , "78" : "Pt" , "79" : "Au" , "80" : "Hg", \
"81" : "Tl" , "82" : "Pb" , "83" : "Bi" , "84" : "Po" , "85" : "At", \
"86" : "Rn" , "87" : "Fr" , "88" : "Ra" , "89" : "Ac" , "90" : "Th", \
"91" : "Pa" , "92" : "U"  , "93" : "Np" , "94" : "Pu" , "95" : "Am", \
"96" : "Cm" , "97" : "Bk" , "98" : "Cf" , "99" : "Es" ,"100" : "Fm", \
"101": "Md" ,"102" : "No" ,"103" : "Lr" ,"104" : "Rf" ,"105" : "Db", \
"106": "Sg" ,"107" : "Bh" ,"108" : "Hs" ,"109" : "Mt" ,"110" : "Ds", \
"111": "Rg" ,"112" : "Uub","113" : "Uut","114" : "Uuq","115" : "Uup", \
"116": "Uuh","117" : "Uus","118" : "Uuo"}

logfile_fn = os.path.basename(sys.argv[1])
logfile_bn = os.path.splitext(logfile_fn)[0]
logfile_fh = open(logfile_fn, 'r')
text = logfile_fh.readlines()
logfile_fh.close()

# Find all lines that contain "!   Optimized Parameters   !"
opt_param_line_nums = extract_all(text, '!   Optimized Parameters   !')
# Then find all lines that have "Input orientation:"
input_orient_line_nums = extract_all(text, 'Input orientation')
# And all lines that have the ---- which we will use to find the ends of the coordinate sections
end_coor_line_nums = extract_all(text, '---------')
# Add 5 because the first actual coordinate is +5 lines
input_orient_line_nums = [x+5 for x in input_orient_line_nums]
# Make sure they're sorted
opt_param_line_nums.sort()
input_orient_line_nums.sort()
end_coor_line_nums.sort()

new_input_lns = []
count = 0
for x in reversed(input_orient_line_nums):
    if count > len(opt_param_line_nums)-1:
        break
    if x < list(reversed(opt_param_line_nums))[count]:
        new_input_lns.append(x)
        count += 1

new_input_lns.reverse()

new_end_lns = []
count = 0
for x in end_coor_line_nums:
    if count > len(new_input_lns)-1:
        break
    if x > new_input_lns[count]:
        new_end_lns.append(x)
        count += 1

intervals = zip(new_input_lns, new_end_lns)

# Now we convert each interval into a .xyz
outfile = open(logfile_bn+'.xyz','w')
for intvl in intervals:
    n_atoms = intvl[1] - intvl[0]
    outfile.write(str(n_atoms)+"\n\n")
    for x in range(intvl[0]-1, intvl[1]-1):
        column = text[x].split()
        print(code[column[1]],float(column[3]),float(column[4]),float(column[5]), file=outfile)

outfile.close()



### FINAL OF XYZ extraction. 
'''
sys.argv[1].split(".")[0]+"."+sys.argv[1].split(".")[1]+".xyz" 
write the name of the file+".xyz" from the xyz_extraction
'''

name_File=sys.argv[1].split(".")[0]+"."+sys.argv[1].split(".")[1]+".xyz"

#Extraction of number of atoms
Num=os.popen("head -1 "+ name_File).read()
Num=int(Num[0:-1])+2
split_info =str(Num)+" "+name_File+" """
#Split complete file into several structure of #Num atoms 
print("\n--- spliting  xyz files----\n\n")
os.system("split --numeric-suffixes=1 --additional-suffix=.xyz -l"+split_info)
print("-- Executing openbabel for mol2 convertion --- \n\n\n")
# Convert xyz into mol2 files
os.system("babel *.xyz -omol2 -m")
os.system("rm "+name_File)
os.system("rm "+sys.argv[1].split(".")[0]+"."+sys.argv[1].split(".")[1]+".mol2")
os.system("rm "+topol.split(".")[0]+".xyz")
os.system("rm "+topol.split(".")[0]+".mol2")

print("\n--- Executing cpptraj for generation crd file with input structures---- \n\n")

with open ('cpptrajgen.sh', 'w') as rsh:
    rsh.write('''\
#! /bin/bash
echo 'parm ' $1
for F in `ls -v *.mol2`; do
        echo 'trajin '$F
        done
echo 'trajout coord.crd'
echo 'go'                    
''')
os.system("chmod +x cpptrajgen.sh")
os.system("./cpptrajgen.sh "+sys.argv[2]+" > traj.in")
os.system("cpptraj -i traj.in")

### Selection of the number of eigenvalues from gaussian16 output


print("\n--- Extracting qm_energies for .log file ---- \n\n")
tail=0
for i,j in enumerate(range(1,60,5),start=1):
    if(int(N_Struc) in range(j,j+5)):
        tail=i
        break
temp_Eigen= name_log+" | tail -"+str(tail)
os.system("grep Eigenvalues "+temp_Eigen+" | awk '{print $3,$4,$5,$6,$7}' > Eigen_temp.txt")

import re 
'''
1-Extraction of eigenvalues and total energy
2. addtion of total energy 
'''
tot_en_line=os.popen("grep add "+sys.argv[1].split(".")[0]+"."+sys.argv[1].split(".")[1]+".log").read()

s= re.findall("\d+\.\d+", tot_en_line)

lines_Eigen = [line.rstrip('\n') for line in open("Eigen_temp.txt")]


qm_data=[]
for i in range(len(lines_Eigen)):
        for j in range(len(lines_Eigen[i].split(" "))):
                if(lines_Eigen[i].split(" ")[j]==""):
                        continue
                qm_data.append((float(lines_Eigen[i].split(" ")[j])-float(s[0])))

##Write file with qm_energies
write_qm=open("qm_data.dat","w")

for val in qm_data:
    write_qm.write('{} \n'.format(val))

write_qm.close()


print("\n--- Writing input files for paramfit ----\n")

with open ('fit_K.in', 'w') as fit_K:
    fit_K.writelines("NSTRUCTURES="+N_Struc)
    fit_K.write('''\

COORDINATE_FORMAT=TRAJECTORY

# We want to fit the K parameter
RUNTYPE=FIT
PARAMETERS_TO_FIT=K_ONLY

# Fit to quantum energies that are in units of Hartree
FUNC_TO_FIT=SUM_SQUARES_AMBER_STANDARD
QM_ENERGY_UNITS=HARTREE
    
''')

with open ("job_scatterplots.in",'w') as job_sct:
    job_sct.writelines("RUNTYPE=FIT\n")
    job_sct.writelines("ALGORITHM=NONE\n")
    job_sct.writelines("NSTRUCTURES="+N_Struc+"\n")
    job_sct.write('''\
COORDINATE_FORMAT=TRAJECTORY

# Load the paramter file
PARAMETERS_TO_FIT=LOAD
PARAMETER_FILE_NAME=prms.in

# Output dihedral scatterplots
SCATTERPLOTS=YES

        ''')

print("\n--- Executing paramfit K fitting ----\n\n" )
os.system("paramfit -i fit_K.in -p "+topol+" -c coord.crd -q qm_data.dat > K_fit.out")


## Extraction of K_fitting value of paramfit
K_val=float(os.popen("grep *K fit_K_A.out | tail -1 | awk '{print $3}' ").read())
print(K_val)
## writing scatterplot script from AMBERTOOLS ##
with open('scatterplots.sh','w') as scatterplots:
    scatterplots.write('''\
#!/bin/bash

# First the bonds
plotcmd="plot "
num=0
if test -n "$(find . -maxdepth 1 -name '*bondeq' -print -quit)"; then
for i in `ls *bondeq`; do
  title=$(head -n 1 $i)
  title=${title//#}
  title=${title//[[:space:]]}
  plotcmd="$plotcmd '$i' title '$title' with points pt 7 ps 1 lc $num,"
  (( num++ ))
done
plotcmd=${plotcmd%,}


gnuplot -persist << EOF
set key autotitle columnhead
set title "Bond Equilibrium Lengths in Sampled Conformations"
set xlabel "Equilibrium Length (Angstrom)"
set xrange [0:]
unset ytics
unset ylabel
$plotcmd

EOF
fi

if test -n "$(find . -maxdepth 1 -name '*angleq' -print -quit)"; then
# Do the angles
plotcmd="plot "
num=0
for i in `ls *angleq`; do
  title=$(head -n 1 $i)
  title=${title//#}
  title=${title//[[:space:]]}
  plotcmd="$plotcmd '$i' title '$title' with points pt 7 ps 1 lc $num,"
  (( num++ ))
done
plotcmd=${plotcmd%,}

gnuplot -persist << EOF
set key autotitle columnhead
set title "Angle Equilibrium Values in Sampled Conformations"
set xlabel "Equilibrium Phase (radians)"
unset ytics
unset ylabel
set xrange [0:3.14]
$plotcmd

EOF
fi

if test -n "$(find . -maxdepth 1 -name '*diheq' -print -quit)"; then
# Now the dihedrals
plotcmd="plot "
num=0
for i in `ls *diheq`; do
  title=$(head -n 1 $i)
  title=${title//#}
  title=${title//[[:space:]]}
  plotcmd="$plotcmd '$i' title '$title' with points pt 7 ps 1 lc $num,"
  (( num++ ))
done
plotcmd=${plotcmd%,}

gnuplot -persist << EOF
set key autotitle columnhead
set title "Dihedral Equilibrium Values in Sampled Conformations"
set xlabel "Equilibrium Phase (radians)"
set xrange [0:1.57]
unset ytics
unset ylabel
$plotcmd

EOF
fi

        ''')


# write fit_input file for final fitting with paramfit 
params_file_existance = input("Do you have the prms.in ( parameter file to optmize) ? (y/n)")
if (params_file_existance=="y"):
    print("\n Make sure that prms.in file is in the working directory ")
if ( params_file_existance=="n"):
    print(" write parameters files as prms.in")
    os.system("paramfit -p "+topol)




print("\n ----Executing paramfit scatterplots analysis ----\n\n")
os.system("paramfit -i job_scatterplots.in -p "+topol+" -c coord.crd  -q qm_data.dat  > scatterplots.out ")
os.system('chmod +x scatterplots.sh')
os.system("./scatterplots.sh scatterplots.out ")




with open ('job_fit.in', 'w') as job_fit:
    job_fit.writelines("# Run a fit to energies using the parameters defined earlier \n")
    job_fit.writelines("RUNTYPE=FIT\n")
    job_fit.writelines("COORDINATE_FORMAT=TRAJECTORY\n")
    job_fit.writelines("NSTRUCTURES="+N_Struc +"\n")
    job_fit.writelines("K="+str(K_val)+"\n")
    job_fit.write('''\
PARAMETERS_TO_FIT=LOAD
PARAMETER_FILE_NAME=prms.in
FUNC_TO_FIT=SUM_SQUARES_AMBER_STANDARD
QM_ENERGY_UNITS=HARTREE

# Use the genetic algorithm with the following settings
ALGORITHM=GENETIC
OPTIMIZATIONS=50
MAX_GENERATIONS=10000
GENERATIONS_TO_CONV=20
GENERATIONS_TO_SIMPLEX=5
GENERATIONS_WITHOUT_SIMPLEX=5
MUTATION_RATE=0.100000
PARENT_PERCENT=0.250000
SEARCH_SPACE=0.250000
SORT_MDCRDS=OFF

# Output files for later analysis
WRITE_ENERGY=fit_output_energy.dat

    ''')

print("\n ----Executing paramfit final fitting  ----\n\n")

os.system("paramfit -i job_fit.in -p "+topol+" -c coord.crd -q qm_data.dat > initial_fit.out" )

with open('plt_energy.x','w') as plt_en:
    plt_en.write('''\
        #!/bin/sh
# Gnuplot script for showing structure energies

if test -z "$1"
  then echo "Usage:"
       echo "  plot_energy.x filename"
       exit 1
fi

if ! hash gnuplot
  then echo "This script uses gnuplot, which is not installed."
       echo "Please install gnuplot or use your own plotting program."
       exit 1
fi

gnuplot -persist << EOF

set style line 1 pt 19 linecolor rgb "red"
set style line 2 pt 17 linecolor rgb "blue"
set style line 3 pt 17 linecolor rgb "black" lw 2
set pointsize 0.2

set ylabel "Energy"
set xlabel "Structure"
set title "$1"

plot "$1" using 1:2 title 'Fit Amber' with linespoints linestyle 1, \
"$1" using 1:4 title 'Initial Amber' with linespoints linestyle 2, \
"$1" using 1:3 title 'Quantum' with linespoints linestyle 3

#set term wxt
#replot

EOF

        ''')

print("\n ----THE CHANGEs IN PARAMETERS ARE :  ----\n\n")

os.system("grep *K initial_fit.out ")    
print("")
print("\n ----- the plots are ----- \n\n")
os.system("chmod +x plt_energy.x")
os.system("./plt_energy.x fit_output_energy.dat ")