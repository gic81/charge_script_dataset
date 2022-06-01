#!/bin/bash
if [ "$#" -eq  "0" ]
  then
    echo ""
    echo "    Parameters are missing!"
    echo "    Usage: ./hybrid_time_test.sh  execution_time_in_minutes"
    echo "    Example: ./hybrid_time_test.sh log.txt 30"
    echo "" 
 else
  re='^[0-9]+$'
  if ! [[ $2 =~ $re ]] ; then
    echo ""
    echo "    Error: second parameter must be a number" 
    echo "    Usage: ./hybrid_time_test.sh namefile.txt  execution_time_in_minutes"
    echo "    Example: ./hybrid_time_test.sh log.txt 30" 
    echo "" >&2; exit 1
  fi 
    time=$(date +%s)
    echo -e "\n time: $time" > $1 
    #echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
    cpustat 0.333 1 >> $1
    sleep 1
    end=$((SECONDS+($2*60)))
    echo "End time: $end sec"
    echo -e "\n End time: $end sec" >> $1
    end_test=false
    first_time=false
    running=false
    counter_asmfish=0
    counter_sysbench=0
    counter_radiance=0
    type_test=1

    while [ $SECONDS -le $end ]; do
       echo -e "\n Script running time: $SECONDS sec" >> $1 
       time=$(date +%s)
       echo -e "\n" >> $1 
       echo -e "\n time: $time" >> $1 
       cpustat 0.333 1 >> $1
       if [ $type_test -eq 1 ]; then  #Asmfish
        ps -C asmfish >/dev/null && echo "Asmfish Running" || echo "Asmfish Not running"
        ps -C asmfish >/dev/null && running=true || running=false
       fi
       if [ $type_test -eq 2 ]; then #Sysbench
        ps -C sysbench >/dev/null && echo "Sysbench Running" || echo "Sysbench Not running"
        ps -C sysbench >/dev/null && running=true || running=false
       fi
       if [ $type_test -eq 3 ]; then #Radiance
        ps -C radiance >/dev/null && echo "Radiance Running" || echo "Radiance Not running"
        ps -C radiance >/dev/null && running=true || running=false
       fi
       
       sleep 1 
       
       if ! $running $$  $first_time   #add the start part
         then
           time=$(date +%s)
            echo -e "\n" >> $1 
            echo -e "\n time: $time" >> $1
            cpustat 0.333 1 >> $1 
         fi  
       
       if [ $SECONDS -gt $(($end - 3)) ]; then
          echo "   ***   Hybrid session completed!   ***"
          echo -e "\n   ***   Hybrid session completed!   ***" >> $1
          echo -e "\n -  Asmfish has been launched $counter_asmfish times" >> $1
          echo -e "\n -  Sysbench has been launched $counter_sysbench times" >> $1
          echo -e "\n -  Radiance has been launched $counter_radiance times" >> $1
          time=$(date +%s) 
          echo -e "\n End Time: $time" >> $1 
       fi
       
       if ! $running $$ ! $first_time
       then
         time=$(date +%s)
          echo -e "\n" >> $1 
          echo -e "\n time: $time" >> $1
          cpustat 0.333 1 >> $1 
          if [ $type_test -eq 1 ]; then #Asmfish
            sleep 20
            ps -C asmfish >/dev/null && running=true || running=false
          fi
          if [ $type_test -eq 2 ]; then #Sysbench
            sleep 40
            ps -C sysbench >/dev/null && running=true || running=false
          fi
          if [ $type_test -eq 3 ]; then #Radiance
            sleep 20
            ps -C radiance >/dev/null && running=true || running=false
          fi

         if ! $running
         then
           time=$(date +%s)
           echo -e "\n" >> $1 
           echo -e "\n time: $time" >> $1
           cpustat 0.333 1 >> $1 
           first_time=true
            if [ $type_test -eq 1 ]; then #Asmfish
              phoronix-test-suite batch-benchmark pts/asmfish &
              echo "Asmfish test launched entered first_time: $first_time"
              ((counter_asmfish++))
            fi
            if [ $type_test -eq 2 ]; then #Sysbench
             phoronix-test-suite batch-benchmark pts/sysbench &
             echo "Sysbench test launched entered first_time: $first_time"
             ((counter_sysbench++))
            fi
            if [ $type_test -eq 3 ]; then #Radiance
             phoronix-test-suite batch-benchmark pts/radiance &
             echo "Radiance test launched entered first_time: $first_time"
             ((counter_radiance++))
            fi           
            ((type_test++))
            if [ $type_test -gt 3 ]; then
              type_test=1
            fi          
         fi  
       fi

       if $first_time && ! $running
       then
         if [ $type_test -eq 1 ]; then #Asmfish
            sleep 20
            ps -C asmfish >/dev/null && running=true || running=false
          fi
          if [ $type_test -eq 2 ]; then #Sysbench
            sleep 40
            ps -C sysbench >/dev/null && running=true || running=false
          fi
          if [ $type_test -eq 3 ]; then #Radiance
            sleep 20
            ps -C radiance >/dev/null && running=true || running=false
          fi
         if ! $running
         then
           end_test=true
           first_time=false
           echo "Hybrid Benchmark Ended!"
         fi  
       fi      
    done & 
  echo -e "\n Asmfish has been launched $counter_asmfish times" >> $1
  echo -e "\n Sysbench has been launched $counter_sysbench times" >> $1
  echo -e "\n Radiance has been launched $counter_radiance times" >> $1
fi
