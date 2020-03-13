# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
skip_t=150000
for i in */ ;
do
cd $i;
	 # iterate over replicas
	 for x in {1..5};
	 do
	 cd $x; 
	 #### gmx tools execution 
	 #z-dimension
	{
	echo 19 0
	} | gmx energy -b $skip_t -f ener.edr -o ./box_z.xvg
## box_xy
#Area per lipid
	{
	echo 17 18 0
	} | gmx energy -b $skip_t -f ener.edr -o ./box_xy.xvg
	##########################
	#############################################
#Thickness
	# -d membrane direction (Z)
	# -b ( start from frame $b) delete equilibration error
	#nano COMMANDS
	{
	echo 1 0
	}|gmx density -f traj.trr -s step7.tpr -b $skip_t -d Z  -n ../index.ndx -o ./p_density.xvg -xvg no
	#############################################
	#############################################
### order parameter for STX
	        {
	for j in {21..29}
	                do
	                        echo 2\&aC$j
	                done
	                for j in {210..214}
	                do
	                        echo 3\&aC$j
	                done
	                echo del 0-6
	                echo q
	                }|gmx make_ndx -f ./step7.tpr -o ./deu_chain1.ndx
	                gmx order -f traj.trr -s step7.tpr -b $skip_t -n ./deu_chain1.ndx -od ./deu_ch1.xvg


	#############################################
	#############################################
##Order parameter for 2nd chain
                {
        if [[ $i = *MEM* ]]
        then
                for j in {31..39}
                do
                        echo 2\&aC$j
                done
                for j in {310..314}
                do
                        echo 2\&aC$j
                done
        else
                for j in {31..39}
                do
                        echo 3\&aC$j
                done
                for j in {310..314}
                do
                        echo 3\&aC$j
                done
        fi
                echo del 0-6
                echo q
                }|gmx make_ndx -f step7_1.tpr -o deu_chain2.ndx
                gmx order -f step7_1.trr -s step7_1.tpr  -n deu_chain2.ndx -b $skip_t -od $save_dir/deu_ch2.xvg

## SUGAR O3 density 
	#############################################
	#############################################
		{
        echo 2\&aO3
        echo del 0-6
        echo q
        }| gmx make_ndx -f step7.tpr -o ori_sugar.ndx
        gmx density -f traj.trr -s step7.tpr -n ori_sugar.ndx -b $skip_t -o ./sugar_density.xvg -xvg no
        ## STX orientation 
        ## TODO = John fix orientation 
        #{
	    #echo 2\&aC41
	    #echo 2\&aC23
      	#echo 8\|7
      	#echo 2\&aC23
      	#echo 2\&aC41
       	#echo 7\|8
       	#echo del 0-$(($j-1))
       	#echo q
       	#}|
       	#gmx make_ndx -f step7_1.tpr -o orientation.ndx
		#gmx gangle -f step7_1.xtc -s step7_1.tpr -n orientation.ndx -g1 vector -group1 2 -g2 z -oall $save_dir/ang_t.xvg

############################################################################################################################################
############################################################################################################################################

# Dihedrals 

 {
        for i in {23..47}
         do
                if [ $i != 37 ] && [ $i != 42 ]
                 then
                        echo 2\&aC$i
                 fi
         done
##Creation of dihedral groups, composed by 4 atoms
##starting from group 7
        st=7
#end=$(($st+41-23-1))
        temp=$st
##21=24-3
        for i in {7..26}
        do
                temp=$(($i+1))
                temp2=$(($i+2))
                temp3=$(($i+3))
                echo $i\|$temp\|$temp2\|$temp3
        done
        echo del 0-6
        echo q
        }| gmx make_ndx -f step7.tpr -o angle.ndx
###################################################
##Calculation of dihedral angle using groups 25 to 39, 23-41 in Melendez
##It's special creating correct names of files
#groups start counting from 0
#st=23
#end=47
#in group 33 we neglect C37
#in group 37 we neglect C42
        declare -a la
        la=(0 0 0 0)
        for i in {23..42}
         do
                for j in {0..3}
                do
                        la[$j]=$(($i+$j))
                        if [ $j -ge $((37-$i)) ]
                         then
                                la[$j]=$((${la[$j]}+1))
                         fi
                        if [ $j -ge $((41-$i)) ]
                         then
                                la[$j]=$((${la[$j]}+1))
                         fi
                done
#                       echo "la" "= " ${la[0]}" "${la[1]}" "${la[2]}" "${la[3]}
                gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -b $skip_t -g1 dihedral -group1 $i -oall ./dihedral${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
                gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -g1 -b $skip_t dihedral -group1 $i -oh ./dihdist${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
        done







	pwd
	cd .. 
	done
	cd ..
done
