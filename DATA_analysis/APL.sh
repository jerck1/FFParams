# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
skip_t=150000
#skip_t=0
for m in */
do
cd $m
	 # iterate over replicas
	 for p in {1..5}
	 do
	 cd $p
#	echo $(pwd)
	 #### gmx tools execution 
	 #z-dimension
	{
	echo 19 0
	} | gmx energy -f ener.edr -b $skip_t -o ./${m::-1}_${p}box_z.xvg
    ## box_xy
   #Area per lipid
	{
	echo 17 18 0
	} | gmx energy -f ener.edr -b $skip_t -o ./${m::-1}_${p}box_xy.xvg
	##########################
	#############################################
    
	if [[ $m = *15* ]]; then
		    tail -n +26 ${m::-1}_${p}box_xy.xvg > test.txt
			awk '{print $1" "$2*$3*2/362}' test.txt > ${m::-1}_${p}APL.xvg
			rm test.txt
	else
		tail -n +26 ${m::-1}_${p}box_xy.xvg > test.txt
		awk '{print $1" "$2*$3*2/128}' test.txt > ${m::-1}_${p}APL.xvg
		rm test.txt
	fi


    #gmx analyze -f ${m::-1}_${p}APL.xvg -ac ${m::-1}_${p}_autoco -b $skip_t
   	cd ..
   	done
cd ..
done
