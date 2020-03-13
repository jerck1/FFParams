# iterate over the main directories  e.i DPPG DMPG STXDMPG STX DPPG
skip_t=150000
for m in */ ;
do
cd $m;
	 # iterate over replicas
	 for p in {1..5};
	 do
	 cd $p;


	 ######## order parameter for STX ################
	 #################################################
	if [[ $m != *MEM* ]]
	then
    {

        for j in {23..48}
                        do
                            echo 2\&aC$j
                    done
                    echo del 0-6
                    echo q
    }|gmx make_ndx -f ./step7.tpr -o ./STX_ConjCh_OP.ndx
    gmx order -f traj.trr -s step7.tpr  -n ./STX_ConjCh_OP.ndx -b $skip_t -od ./${m::-1}_${p}STX_ConjCh_OP.xvg
	fi 
  	######## order parameter chain 1  ###############
	#################################################

	 {
        if [[ $m = *MEM* ]]
        then
                for j in {21..29}
                do
                        echo 2\&aC$j
                done
                for j in {210..214}
                do
                        echo 2\&aC$j
                done
        else
                for j in {21..29}
                do
                        echo 3\&aC$j
                done
                for j in {210..214}
                do
                        echo 3\&aC$j
                done
        fi
                echo del 0-6
                echo q
        }|gmx make_ndx -f step7.tpr -o deu_chain1.ndx
        gmx order -f traj.trr -s step7.tpr  -n deu_chain1.ndx -b $skip_t -od ./${m::-1}_${p}deu_ch1.xvg



	 ######## order parameter chain 2  ################
	 #################################################



          {
        if [[ $m = *MEM* ]]
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
        gmx order -f traj.trr -s step7.tpr  -n deu_chain2.ndx -b $skip_t -od ./${m::-1}_${p}deu_ch2.xvg


   	cd ..
   	done
cd ..
done
