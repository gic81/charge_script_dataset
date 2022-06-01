#!/bin/bash
if [ "$#" -eq  "0" ]
  then
    echo ""
    echo "    Parameters are missing!"
    echo "    Usage: ./sysbench_time_test.sh  execution_time_in_minutes"
    echo "    Example: ./sysbench_time_test.sh log.txt 30"
    echo "" 
 else
  re='^[0-9]+$'
  if ! [[ $2 =~ $re ]] ; then
    echo ""
    echo "    Error: second parameter must be a number" 
    echo "    Usage: ./sysbench_time_test.sh namefile.txt  execution_time_in_minutes"
    echo "    Example: ./sysbench_time_test.sh log.txt 30" 
    echo "" >&2; exit 1
  fi 
    time=$(date +%s)
    echo -e "\n time: $time" > $1 
    echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
    sleep 1
    end=$((SECONDS+($2*60)))
    echo "End time: $end sec"
    echo -e "\n End time: $end sec" >> $1
    end_test=false
    first_time=false
    running=false
    counter=0

    while [ $SECONDS -le $end ]; do
       echo -e "\n Script running time: $SECONDS sec" >> $1 
       time=$(date +%s)
       echo -e "\n" >> $1 
       echo -e "\n time: $time" >> $1 
       echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
        #ps -C sysbench >/dev/null && echo "Running" || echo "Not running"
       ps -C sysbench >/dev/null && running=true || running=false
  
       sleep 1 
       if [ $SECONDS -gt $(($end - 3)) ]; then
          echo "   ***   Sysbench session completed!   ***"
          echo -e "\n   ***   Sysbench session completed!   ***" >> $1
          echo -e "\n - Sysbench has been launched $counter times" >> $1
          time=$(date +%s) 
          echo -e "\n End Time: $time" >> $1 
       fi
       if ! $running $$ ! $first_time
       then
         sleep 40
         ps -C sysbench >/dev/null && running=true || running=false
         #echo 'first if entered first_time:' $first_time
         if ! $running
         then
           first_time=true
           phoronix-test-suite batch-benchmark pts/sysbench &
           echo "test launched entered first_time: $first_time"
           ((counter++))
         fi  
       fi
       if $first_time && ! $running
       then
         sleep 40
         ps -C sysbench >/dev/null && running=true || running=false
         if ! $running
         then
           end_test=true
           first_time=false
           echo "Sysbench Benchmark Ended!"
         fi  
       fi
    done & 
  echo -e "\n Sysbench has been launched $counter times" >> $1
fi
