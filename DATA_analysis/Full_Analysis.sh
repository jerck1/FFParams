# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
for m in */ ;
do
cd $m;
	 # iterate over replicas
	 for p in {1..5};
	 do
	 cd $p; 
	 #### gmx tools execution 
	 #z-dimension
	{
	echo 19 0
	} | gmx energy -f ener.edr -o ./${m::-1}_${p}box_z.xvg
    ## box_xy
    #Area per lipid
	{
	echo 17 18 0
	} | gmx energy -f ener.edr -o ./${m::-1}_${p}box_xy.xvg
	##########################
	#############################################

    tail -n +26 box_xy.xvg > test.txt
    awk '{print $1" "$2*$3*2/362}' test.txt > ${m::-1}_${p}APL.xvg
    rm test.txt


    #gmx analyze -f ${m::-1}_${p}APL.xvg -ac ${m::-1}_${p}_autoco -b 100000



	#Thickness
	# -d membrane direction (Z)
	# -b ( start from frame $b) delete equilibration error
	#nano COMMANDS
	{
	echo 1 0
	}|gmx density -f traj.trr   -s step7.tpr -b 4000 -d Z  -n ../index.ndx -o ./${m::-1}_${p}p_density.xvg -xvg no
	#############################################
	#############################################
	### order parameter for STX
	        {
	#for j in {21..29}
	 #               do
	 #                       echo 2\&aC$j
	 #               done
	                for j in {210..214}
	                do
	                        echo 3\&aC$j
	                done
	                echo del 0-6
	                echo q
	                }|gmx make_ndx -f ./step7.tpr -o ./deu_chain1.ndx
	                gmx order -f traj.trr -s step7.tpr  -n ./deu_chain1.ndx -od ./${m::-1}_${p}deu_ch1.xvg

    ###########################
    ############# ORDER PARAMETER of STX #####################
    ##### 22 to 41 conjugated  chain 
    ### TODO = JOHN y DAVID atoms from acyl chian _!!!!!! 
    {

        for j in {23..48}
                        do
                            echo 2\&aC$j
                    done
                    echo del 0-6
                    echo q
    }|gmx make_ndx -f ./step7.tpr -o ./STX_ConjCh_OP.ndx

    gmx order -f traj.trr -s step7.tpr  -n ./STX_ConjCh_OP.ndx -od ./STX_ConjCh_OP.xvg




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
                }|gmx make_ndx -f step7.tpr -o deu_chain2.ndx
                gmx order -f step7_1.trr -s step7.tpr  -n deu_chain2.ndx -od ./deu_ch2.xvg

		## SUGAR O3 density 
	#############################################
	#############################################
		{
        echo 2\&aO3
        echo del 0-6
        echo q
        }| gmx make_ndx -f step7.tpr -o ori_sugar.ndx
        gmx density -f traj.trr -s step7.tpr -n ori_sugar.ndx -o ./sugar_density.xvg -xvg no
    ##############################################
    ##############################################
        ## STX orientation 
        ## TODO = John fix orientation 
        {
      	echo 2\&aC23
      	echo 2\&aC41
       	echo 7\|8
       	echo del 0-6
       	echo q
       	}|gmx make_ndx -f step7.tpr -o orientation.ndx
        gmx gangle -f traj_comp.xtc -s step7.tpr -n orientation.ndx -g1 vector -group1 2 -g2 z -oall ./${m::-1}_${p}ang_t.xvg

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
                gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -g1 dihedral -group1 $i -oall ./${m::-1}_${p}dihedral${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
                #gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -g1 dihedral -group1 $i -oh ./dihdist${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
        done
############################################################################################################################################
############################################################################################################################################

# DIFFUSION COEFFICIENT. 
				{
					if [[ $i = *MEM* ]]
					    then
        			echo 2
        			echo q
        				else
        			echo 3
        			echo q 
        		fi
        }| gmx msd -f traj_comp.xtc -s step7.tpr  -beginfit 0 -endfit 10000 -trestart 10000 -lateral z -o ./msd.xvg

############################################################################################################################################
#######################################################################################################################

cd ..
done 
cd .. 
done 
