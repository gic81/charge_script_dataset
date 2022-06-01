#!/bin/bash
if [ "$#" -eq  "0" ]
  then
    echo ""
    echo "    Parameters are missing!"
    echo "    Usage: ./test_no_charge.sh namefile.txt  execution_time_in_minutes"
    echo "    Example: ./test_no_charge.sh log.txt 30"
    echo "" 
 else
  re='^[0-9]+$'
  if ! [[ $2 =~ $re ]] ; then
    echo ""
    echo "    Error: second parameter must be a number" 
    echo "    Usage: ./test_no_charge.sh namefile.txt  execution_time_in_minutes"
    echo "    Example: ./test_no_charge.sh log.txt 30" 
    echo "" >&2; exit 1
  fi
    time=$(date +%s)
    echo -e "\n time: $time" > $1  
    echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
    sleep 1
    end=$((SECONDS+($2*60)))
    echo "End time: $end sec"
    echo -e "\n End time: $end sec \n" >> $1
    while [ $SECONDS -lt $end ]; do
       time=$(date +%s)
       echo -e "\n time: $time" >> $1  
       echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help" | grep -v "xml version=" >> $1
       echo -e "\n " >> $1 
       sleep 1 
       if [ $SECONDS -eq $end ]; then
          echo "   ***   Test no charge completed!   ***"
          echo -e "\n   ***   Test no charge completed!   ***" >> $1
          time=$(date +%s) 
          echo -e "\n End Time: $time" >> $1 
       fi
    done &  

fi
