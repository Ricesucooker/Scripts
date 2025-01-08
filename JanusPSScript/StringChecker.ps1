$timeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

[String]$searchStr = "Janus error"
$janErr = 0 


#check for janus loop
do{
  if($File = Get-Content -Path "C:\windows\ltsvc\LTError.txt" -Tail 25 | ForEach-Object{ $_.Trim() } | Where-Object {$_.Contains($searchStr.Trim())}){
  ++$janErr
}

}until($janErr -eq 5)


#download and run colector 

if($janErr -eq 5){

$downloadURL = "https://utilities.itsupport247.net/pstautomation/CWAutoLogCollector.exe"
$downloadPath = ".\Autotemp\CWAutoLogCollector.exe"
$unblockURL = $downloadPath

Invoke-WebRequest -Uri $downloadURL -OutFile $downloadPath
Unblock-File -Path $downloadPath
Start-Process -FilePath $downloadPath -Verb RunAs

}