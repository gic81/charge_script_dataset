#!/bin/bash
if [ "$#" -eq  "0" ]
  then
    echo ""
    echo "    Parameters are missing!"
    echo "    Usage: ./hybrid_loop_test.sh namefile.txt  execution_loops"
    echo "    Example: ./hybrid_loop_test.sh log.txt 3"
    echo "    One loop duration is around 40 min"
    echo "" 
 else
  re='^[0-9]+$'
  if ! [[ $2 =~ $re ]] ; then
    echo ""
    echo "    Error: second parameter must be a number" 
    echo "    Usage: ./hybrid_loop_test.sh namefile.txt  execution_loops"
    echo "    Example: ./hybrid_loop_test.sh log.txt 3"
    echo "    One loop duration is around 40 min"
    echo "" >&2; exit 1
  fi
    echo -e "\n   ***   Easy Hybrid Test started!   ***" >> $1
    time=$(date +%s)
    echo -e "\n time: $time" >> $1  
    cpustat 0.333 1 >> $1
    sleep 1
    counter=0
    while [ $counter -lt $2 ]; do
      phoronix-test-suite batch-benchmark pts/asmfish
      #sleep 30
      sleep 300
      phoronix-test-suite batch-benchmark pts/sysbench
      #sleep 30
      sleep 300
      phoronix-test-suite batch-benchmark pts/radiance
      #sleep 30
      sleep 300
      ((counter++))
      if [ $counter -eq $2 ]; then
        end=true
        touch stop.txt
       fi   
    done &  
    
    while : 
    do
      time=$(date +%s)
      echo -e "\n time: $time" >> $1  
      cpustat 0.333 1 >> $1
      echo -e "\n " >> $1 
      sleep 1  
      if [[ -f "stop.txt" ]]; then
        break;   
      fi   
    done 
    
    rm stop.txt
    echo "   ***   Easy Hybrid Test completed!   ***"
    echo -e "\n   ***   Easy Hybrid Test completed!   ***" >> $1
    time=$(date +%s) 
    echo -e "\n End Time: $time" >> $1          
       
fi
