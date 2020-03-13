# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
skip_t=150000
for m in */ ;
do
cd $m;
	 # iterate over replicas
	 for p in {1..5};
	 do
	 cd $p; 
	 #### gmx tools execution 
	 ########## DIHEDRALLS  #####################
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
                gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -b $skip_t -g1 dihedral -group1 $i -oall ./${m::-1}_${p}dihedral${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
                #gmx gangle -f traj_comp.xtc -s step7.tpr -n angle.ndx -g1 dihedral -group1 $i -oh ./dihdist${la[0]}-${la[1]}-${la[2]}-${la[3]}.xvg
        done


         ########## Orientation #####################
         ########## STX #############################

         {
        echo 2\&aC23
        echo 2\&aC41
        echo 7\|8
        echo del 0-6
        echo q
        }|gmx make_ndx -f step7.tpr -o orientation.ndx
        gmx gangle -f traj_comp.xtc -s step7.tpr -n orientation.ndx -b $skip_t -g1 vector -group1 2 -g2 z -oall ./${m::-1}_${p}ang_t.xvg
	cd ..
done
cd ..
done
