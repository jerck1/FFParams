# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
skip_t=150000
for m in */ ;
do
cd $m;
	 # iterate over replicas
	 for p in {1..5};
	 do
	 cd $p; 
	 ########## Orientation #####################
         ########## STX #############################
         if [[ $m != *MEM* ]]
         then
         {
        echo 2\&aC23
        echo 2\&aC41
        echo 7\|8
        echo del 0-6
        echo q
        }|gmx make_ndx -f step7.tpr -o orientation.ndx
        gmx gangle -f traj_comp.xtc -s step7.tpr -n orientation.ndx -b $skip_t -g1 vector -group1 2 -g2 z -oall ./${m::-1}_${p}ang_t.xvg
        gmx gangle -f traj_comp.xtc -s step7.tpr -n orientation.ndx -b $skip_t -g1 vector -group1 2 -g2 z -oh ./${m::-1}_${p}ang_dist.xvg
    	fi


	cd ..
done 
cd ..
done
