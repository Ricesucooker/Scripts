#script created by Woraphong Mingsong
#! /bin/bash

var_Hostname=$(hostname)
echo $var_Hostname


if [ -d ./$hostname ]; then

rm -rf "./$var_Hostname"
else
mkdir -p "./$var_Hostname"
fi 


echo "Getting log for $var_Hostname"

sleep 3

uname -a > "./$var_Hostname/$var_Hostname.txt"
ldd --version >> "./$var_Hostname/$var_Hostname.txt"
mkdir -p "./$var_Hostname/Agent"

ltFolder="/usr/local/ltechagent"
rsync -r --exclude 'uninstaller.sh' --exclude 'libltech.so' --exclude 'ltechagent' --exclude 'ltupdate' "$ltFolder/." "./$var_Hostname/Agent"

echo "completed collecting agent folder"
sleep 1

journalctl > "./$var_Hostname/Journalctl.txt"

dmesg | grep ltechagent > "./$var_Hostname/LTdmesg.txt"
dmesg > "./$var_Hostname/dmesg.txt"

echo "completed copying system logs.."


if [ -d ./$hostname.tar.gz ]; then

rm -rf "./$var_Hostname.tar.gz"
else
tar -czvf ./$var_Hostname.tar.gz ./$var_Hostname
fi 

echo "compress completed"

rm -rf ./$var_Hostname

echo "exiting the script in 3 seconds..."
sleep 3

