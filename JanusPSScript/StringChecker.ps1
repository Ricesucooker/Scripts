$timeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

[String]$searchStr = "Janus.Cryptography.RemoteAgentSettingsCrypt"
$janErr = 0 

Write-Host "looking for error string"
#check for janus loop
do{
  Write-Host "..."
  if($File =  Get-Content -Path C:\Windows\LTSvc\LTErrors.txt -Tail 25 | ForEach-Object{ $_.Trim() } | Where-Object {$_.Contains($searchStr.Trim())}){
  ++$janErr
}

}until($janErr -eq 5)


#download and run colector 

if($janErr -eq 5){

$labKey = "HKLM:\SOFTWARE\LabTech\"
$labagentKey = "HKLM:\SOFTWARE\LabTech\Service"
Get-ChildItem -Path $KeyLab -Recurse -ErrorAction Ignore > .\Autotemp\baseLTkey$timeStamp.txt
Get-ChildItem -Path $labagentKey -Recurse -ErrorAction Ignore > .\Autotemp\baseLTAgentkey$timeStamp.txt

$downloadURL = "https://utilities.itsupport247.net/pstautomation/CWAutoLogCollector.exe"
$downloadPath = ".\Autotemp\CWAutoLogCollector.exe"
$unblockURL = $downloadPath

Invoke-WebRequest -Uri $downloadURL -OutFile $downloadPath
Unblock-File -Path $downloadPath
Start-Process -FilePath $downloadPath -Verb RunAs

}
