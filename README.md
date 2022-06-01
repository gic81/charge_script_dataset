# Charge script to create a computer power consumption log

These script allow to create log files that contains the Computer resources consumption, for the time desired from the user who launch them.
They are based on Phoronix Test Suite and on linux bash commands Htop and Cpustat.

The installation instruction for Ubuntu/Debian like follows:

Phoenix test configuration 

$ download from http://www.phoronix-test-suite.com/?k=downloads

$ sudo apt install gdebi-core

$ sudo gdebi phoronix-test-suite_xx.x.x_all.deb
$ sudo apt install pkg-config


Install tests

$ phoronix-test-suite install-test pts/asmfish
$ phoronix-test-suite install-test pts/radiance
$ phoronix-test-suite install-test pts/sysbench

$ phoronix-test-suite batch-setup

    Save test results when in batch mode (Y/n): n
    Run all test options (Y/n): y

Htop Script configuration

$ sudo apt install htop

$ sudo apt install aha

$ sudo apt install html2text


cpustat Script configuration 

sudo snap install cpustat


To launch the script, just give them the pemission and run them. (E.g.:  ./test_no_charge.sh)
The launching parameters guide will be visualized each time the scripts are runned without parameters
as in the example below. 

Parameters are missing!
Usage: ./test_no_charge.sh namefile.txt  execution_time_in_minutes
Example: ./test_no_charge.sh log.txt 30


