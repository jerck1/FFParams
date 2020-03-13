#!/bin/bash
#sys=(DMPG_assembling DPPG_assembling STX_DMPG_assembling STX_DPPG_assembling STX_DMPG_QM_assembling STX_DPPG_QM_assembling STX_15_DMPG_assembling STX_15_DPPG_assembling)
#sys2=(DMPG DPPG STX_DMPG STX_DPPG STX_QM_DMPG STX_QM_DPPG STX_15_DMPG STX_15_DPPG)
#start_dir=$(pwd)
skip_time=150000
for i in */ ;
do
cd $i;
	for x in {1..5};
	do
	cd $x;
	save_dir=$start_dir/${sys[$i]}
	#cd ../${sys[$i]}/${sys2[$i]}/gromacs
	cd $save_dir
	gmx analyze -f APL.xvg -ac -b 100000
	cd $start_dir
	done
done
