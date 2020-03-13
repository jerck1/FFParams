skip_t=150000
#iterate over main directories ex STX-DMPG,STX-DPPG,STXQM-DMPG
for m in MEM-MG MEM-PG
do
cd $m
cd 1
        if [[ $m = *MG* ]]
        then
            {
                    for j in {21..29}
                        do
                        echo 2\&aC$j
                        done
                    for j in {210..214}
                        do
                        echo 2\&aC$j
                        done
		        echo del 0-6
                echo q
            }|gmx make_ndx -f step7.tpr -o deu_chain1.ndx
            gmx order -f traj_comp.xtc -s step7.tpr  -n deu_chain1.ndx -b 150000 -od ./MEM-MG_1deu_ch1.xvg
            {
                        for j in {31..39}
                            do
                                    echo 2\&aC$j
                            done
                            for j in {310..314}
                            do
                                    echo 2\&aC$j
                            done
                            echo del 0-6
                            echo q
            }|gmx make_ndx -f step7.tpr -o deu_chain2.ndx
            gmx order -f traj.trr -s step7.tpr  -n deu_chain2.ndx -b $skip_t -od ./MEM-MG_1deu_ch2.xvg
        else 
            {
                    for j in {21..29}
                            do
                                    echo 2\&aC$j
                            done
                    for j in {210..216}
                            do
                                    echo 2\&aC$j
                            done
                                            echo del 0-6
                echo q
            }gmx make_ndx -f step7.tpr -o deu_chain1.ndx
            gmx order -f traj_comp.xtc -s step7.tpr  -n deu_chain1.ndx -b 100000 -od ./{m}_{p}deu_ch1.xvg
            {
                        for j in {31..39}
                            do
                                    echo 2\&aC$j
                            done
                            for j in {310..316}
                            do
                                    echo 2\&aC$j
                            done
                            echo del 0-6
                            echo q
            }|gmx make_ndx -f step7.tpr -o deu_chain2.ndx
            gmx order -f traj_comp.xtc -s step7.tpr  -n deu_chain2.ndx -b $skip_t -od ./${m}_${p}deu_ch2.xvg
        fi
        cd ..
cd ..
done

