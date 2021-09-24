# ilorest for Smart Array

Capture the HPE Smart Array configuration in the HPE Proliant (Gen8 - Gen10) into the JSON file trough ilorest api

Steps are shown as below:
1) login to jump hosts, which able to connect to all the ILO in all sites
2) download the files, make sure git already installed
```bash
$ git clone https://github.com/hendraw4n/ilorest.git
$ cd ilorest
```
3) put all the ILO IP Address, ILO Username as well as the Password in the ilolist.txt file, format shown as below
```bash
<ILO IP>,<ILO Username>,<ILO Password>
```
4) execute the required files and generate the script to be executed
```bash
$ chmod 755 ilorest* smartarray*
$ ./smartarray_generate_ilo_creds.sh
```
5) execute the script to generate the JSON files
```bash
$ ./smartarray_check_script.sh
```
7) you can find all the JSON output in the current directory with serial number of the server as the name of the file 


## Output expected
```bash
*** Server Info: ***
SerialNumber : SGHXXXXXXX
iLO HostName : ILOSGHXXXXXXX
ServerModel  : Synergy 480 Gen9
*** smartarray config save in SGHXXXXXXX.json ***
Logging session out.

*** Server Info: ***
SerialNumber : SGHDDDDDDD
iLO HostName : ILOSGHDDDDDDD
ServerModel  : ProLiant DL380 Gen10
*** smartarray config save in SGHDDDDDDD.json ***
Logging session out.

*** Server Info: ***
SerialNumber : SGHCCCCCCC
iLO HostName : ILOSGHCCCCCCC
ServerModel  : ProLiant BL460c Gen8
*** smartarray config save in SGHCCCCCCC.json ***
Logging session out.

*** Server Info: ***
SerialNumber : SGHBBBBBBB
iLO HostName : ILOSGHBBBBBBB
ServerModel  : ProLiant BL660c Gen9
*** smartarray config save in SGHBBBBBBB.json ***
Logging session out.
```


## RESTful Interface Tool for Linux
if facing an issue, can install the ilorest trough the following link

https://support.hpe.com/hpesc/public/swd/detail?swItemId=MTX_07ec09e5e97a4c468a99d928ff

