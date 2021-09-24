#!/bin/bash
#
# Copyright, 2021 - Hendrawan

login=""

display_usage() {
  echo -e "This script will check the firmware version"
  echo "usage: $(basename $0) [-hduph]"
  echo "  -h      display help"
  echo "  -u      iLO username"
  echo "  -p      iLO password"
  echo "  -H      iLO hostname"
  echo "  -n      Force no colors [Autodetect by default]"
  exit 1
}

IlorestLogout (){
  ./ilorest  --nologo logout
}

runilorest() {
  output=$(./ilorest  --nologo $1 ${login} 2>/dev/null)
  retcode=$?
  if [ ${retcode} -eq 23 ]; then
    pr_info "Unable to find Smart Storage Drive information."
    IlorestLogout
    return 1
  elif [ ${retcode} -eq 34 ]; then
    pr_info "If running locally CHIF driver is required. If running remotely, --url, --user, and --password arguments are required."
    return 1
  elif [ ${retcode} -eq 32 ]; then
    pr_info "Error: Could not authenticate. Invalid credentials, or bad username/password."
    return 1
  elif [ ${retcode} -eq 75 ]; then
    pr_info "Local Higher Security Mode is detected, please include --username and --password with iLO credentials."
    return 1
  elif [ ${retcode} -eq 5 ]; then
    pr_info "If running locally you must run this script as an Administrator."
    return 1
  elif [ ${retcode} -ne 0 ]; then
    pr_info "A general error occurred."
    return 1
    IlorestLogout
  fi
  echo "${output}"
}

pr_info() {
  echo -e "$1"
}

pr_warm() {
  echo -e "$1"
}

pr_error() {
  echo -e "$1"
}

die() { pr_error "$*" 1>&2 ; exit 1; }

while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) display_usage >&2;;
    -u|--username) shift;login=" ${login} -u $1";;
    -p|--password) shift;login=" ${login} -p $1";;
    -H|--url) shift;url=$1;;
    -n|--nocolors) colors=0;;
    *) die "invalid option: '$1'." ;;
  esac
  shift
done

if [[ -z "${login}" &&  $(id -u) -ne 0 ]]; then
  echo "This script must be run as root for local"
  exit 1
fi

ReturnCode=0
output=$(runilorest "login ${url}")
if [ $? -ne 0 ]; then
  echo ${output}
  exit 1
fi

GetServerInfo() {
  pr_info "*** Server Info: ***"
  hostname=$(runilorest "get Oem/Hpe/Manager/HostName --selector ServiceRoot." |grep -m1 HostName|cut -d= -f2)
  if [[ -z "${hostname}" ]]; then
    hostname=$(runilorest "get Oem/Hp/Manager/HostName --selector ServiceRoot." |grep -m1 HostName|cut -d= -f2)
  fi
  servershostname=$(runilorest "get HostName --selector=ComputerSystem.")
  serverserialnumber=$(runilorest "get SerialNumber --selector=ComputerSystem.")
  servermodel=$(runilorest "get Model --selector=ComputerSystem.")
  pr_info "SerialNumber : $(echo "${serverserialnumber}"|grep SerialNumber|cut -d= -f2|tr -d ' \t')"
  pr_info "iLO HostName : ${hostname}"
  pr_info "ServerModel  : $(echo "${servermodel}"|grep Model|cut -d= -f2)"
}


pr_info " "
GetServerInfo
echo "*** smartarray config save in $(echo "${serverserialnumber}"|grep SerialNumber|cut -d= -f2|tr -d ' \t').json ***"
output=$(runilorest "save --selector smartstorage -f $(echo "${serverserialnumber}"|grep SerialNumber|cut -d= -f2|tr -d ' \t').json")
if [ $? -ne 0 ]; then
  echo ${output}
  exit 1
fi
IlorestLogout
echo " "
exit ${ReturnCode}

