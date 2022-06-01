# charge_script_dataset



Phoenix test configuration 

$ wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_10.4.0_all.deb
$ sudo apt install gdebi-core

$ sudo gdebi phoronix-test-suite_10.4.0_all.deb
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

http://www.phoronix-test-suite.com/?k=downloads
