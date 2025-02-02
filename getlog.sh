#script created by woraphong mingong
#! /bin/bash

var_Hostname=$(hostname)
echo $var_Hostname

echo "Getting log for $var_Hostname"

sleep 3
mkdir -p "./$var_Hostname"
uname -a > "./$var_Hostname/$var_Hostname.txt"
ldd --version >> "./$var_Hostname/$var_Hostname.txt"
mkdir -p "./$var_Hostname/Agent"

ltFolder="/usr/local/ltechagent"
rsync -r --exclude 'uninstaller.sh' --exclude 'libltech.so' --exclude 'ltechagent' --exclude 'ltupdate' "$ltFolder/." "./$var_Hostname/Agent"

echo "comepleted collecting agent folder"
sleep 1

journalctl > "./$var_Hostname/Journalctl.txt"

echo "completed copying system logs.."


tar -czvf ./$var_Hostname.tar.gz ./$var_Hostname

echo "compress completed"

rm -rf ./$var_Hostname

echo "exiting the script in 3 second..."
sleep 3

