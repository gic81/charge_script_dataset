#!/bin/bash
if [ "$#" -eq  "0" ]
  then
    echo ""
    echo "    Parameters are missing!"
    echo "    Usage: ./radiance_time_test.sh  execution_time_in_minutes"
    echo "    Example: ./radiance_time_test.sh log.txt 30"
    echo "" 
 else
  re='^[0-9]+$'
  if ! [[ $2 =~ $re ]] ; then
    echo ""
    echo "    Error: second parameter must be a number" 
    echo "    Usage: ./radiance_time_test.sh namefile.txt  execution_time_in_minutes"
    echo "    Example: ./radiance_time_test.sh log.txt 30" 
    echo "" >&2; exit 1
  fi 
    time=$(date +%s)
    echo -e "\n time: $time" > $1 
    #echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
    cpustat 0.333 1 >> $1
    sleep 1
    end=$((SECONDS+($2*60)))
    echo "End time: $end"
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
       #echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
       cpustat 0.333 1 >> $1 
        #ps -C radiance >/dev/null && echo "Running" || echo "Not running"
       ps -C radiance >/dev/null && running=true || running=false
  
       sleep 1 

        if ! $running $$  $first_time   #add the start part
         then
           time=$(date +%s)
            echo -e "\n" >> $1 
            echo -e "\n time: $time" >> $1
            cpustat 0.333 1 >> $1 
        fi

       if [ $SECONDS -gt $(($end - 3)) ]; then
          echo "   ***   Radiance session completed!   ***"
          echo -e "\n   ***   Radiance session completed!   ***" >> $1
          echo -e "\n Radiance has been launched $counter times" >> $1
          time=$(date +%s) 
          echo -e "\n End Time: $time" >> $1 
       fi

       if ! $running $$ ! $first_time
       then
         time=$(date +%s)
         echo -e "\n" >> $1 
         echo -e "\n time: $time" >> $1
         cpustat 0.333 1 >> $1 
         sleep 20
         ps -C radiance >/dev/null && running=true || running=false
         #echo 'first if entered first_time:' $first_time
         if ! $running
         then
           time=$(date +%s)
           echo -e "\n" >> $1 
           echo -e "\n time: $time" >> $1
           cpustat 0.333 1 >> $1 
           first_time=true
           sleep 300
           phoronix-test-suite batch-benchmark pts/radiance &
           echo "test launched entered first_time: $first_time"
           ((counter++))
         fi  
       fi
       if $first_time && ! $running
       then
         sleep 20
         ps -C radiance >/dev/null && running=true || running=false
         if ! $running
         then
           end_test=true
           first_time=false
           echo "Radiance Benchmark Ended!"
         fi  
       fi
    done & 
  echo -e "\n Radiance has been launched $counter times" >> $1
fi
