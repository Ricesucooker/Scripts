#! /bin/bash

varLTfolder="/usr/local/ltechagent"

rm -rf "$/varLTfolder/ltechagent"
rm -rf "$/varLTfolder/libltech.so"


cp ./libltech.so $varLTfolder
cp ./ltechagent $varLTfolder

systemctl start ltechagent.service
