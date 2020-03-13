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
		## SUGAR O3 density 
	#############################################
	#############################################
	if [[  $m != *MEM* ]]
	then	
		{
        echo 2\&aO3
        echo q
        }| gmx make_ndx -f step7.tpr -o ori_sugar.ndx
        {
	echo 3 
	echo 7 
	}|gmx density -f traj_comp.xtc -s step7.tpr -n ori_sugar.ndx -sl 100 -center -b $skip_t -o ./${m::-1}_${p}sugar_density.xvg -xvg no
        	#Thickness
		# -d membrane direction (Z)
		# -b ( start from frame $b) delete equilibration error
		#nano COMMANDS
		{
		echo a p
		echo q
		
		}|gmx make_ndx -f step7.tpr -o phos_in.ndx
		{
		echo 3
		echo 7
		echo q
		}|gmx density -f traj_comp.xtc   -s step7.tpr -b $skip_t -d Z -center -sl 100  -n phos_in.ndx -o ./${m::-1}_${p}p_density.xvg -xvg no
		#############################################
		#############################################
		{
		echo 3 
		echo 4
		echo q
		}|gmx density -f traj_comp.xtc   -s step7.tpr -b $skip_t -d Z -center -sl 100 -n phos_in.ndx -o ./${m::-1}_${p}water_density.xvg -xvg no
	else
	        	#Thickness
		# -d membrane direction (Z)
		# -b ( start from frame $b) delete equilibration error
		#nano COMMANDS
		{
		echo a p
		echo q
		}|gmx make_ndx -f step7.tpr -o phos_in.ndx
		{
		echo 2
		echo 6
		echo q
		}|gmx density -f traj_comp.xtc   -s step7.tpr -b $skip_t -d Z -center -sl 100  -n phos_in.ndx -o ./${m::-1}_${p}p_density.xvg -xvg no
		#############################################
		#############################################
		{
		echo 2 
		echo 3
		echo q
		}|gmx density -f traj_comp.xtc   -s step7.tpr -b $skip_t -d Z -center -sl 100  -n phos_in.ndx -o ./${m::-1}_${p}water_density.xvg -xvg no
	fi
	cd ..
done 
cd ..
done
