skip_t=100000
#iterate over main directories ex STX-DMPG,STX-DPPG,STXQM-DMPG
for m in */ ;
do
cd $m;
	 # iterate over replicas
	 for p in {1..5};
	 do
	 cd $p;
                if [[ $m != *MEM* ]]
                then

                ######## order parameter for STX ################
                        #################################################
                ### calculate order parameter of conjugated chain in STX
                {
                # carbons in conjugated chain 23 .. 48 without 37 and 42 ( methyl )
                for j in 23 24 25 26 27 28 29 30 31 32 33 34 35 36 38 39 40 41 43 44 45 46 47
                        do
                        echo 2\&aC$j
                        done
                        echo del 0-6
                        echo q
                }|gmx make_ndx -f ./step7.tpr -o ./STX_ConjCh_OP.ndx
                gmx order -f traj_comp.xtc -s step7.tpr -d z -n ./STX_ConjCh_OP.ndx -b $skip_t -od ./${m::-1}_${p}STX_ConjCh_OP.xvg
                ### calculate order parameter of acyl chain 
                {
                for i in 15 14 13 12 11 10 9 8 7 6 5 3 2 1  
                        do
                        echo 2\&aC$i 

                        done
                        echo del 0-6
                        echo q
                }|gmx make_ndx -f ./step7.tpr -o ./acyl_ind.ndx
                gmx order -f ./traj_comp.xtc -s ./step7.tpr -d z  -n acyl_ind.ndx -od ./${m::-1}_${p}STX_ACYL_OP.xvg

                fi
                

                #echo "Calculation done  in "$m$p

        cd ..
        done
cd ..
done
