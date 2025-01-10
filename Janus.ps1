New-Item -ItemType "directory" -Path "C:\AutoJanuslog" 

[String]$searchStr = "Janus.Cryptography.RemoteAgentSettingsCrypto"
 

$oldlogFile = "C:\Windows\LTSvc\LTErrorsold.txt"
$newlogFile = "C:\Windows\LTSvc\LTErrors.txt"



#$oldlogFile = "C:\Users\LTAdmin\tempauto\testing\LTErrorsold.txt"
#$newlogFile = "C:\Users\LTAdmin\tempauto\testing\LTErrors.txt"


if ( Get-Content -Path $oldlogFile -Head 25 | ForEach-Object{ $_.Trim() } | Where-Object {$_.Contains($searchStr.Trim())} ){ Write-Host "True see top 25 Janus found skip" | Write-Output }

    elseif(Get-Content -Path $newlogFile -tail 50 | ForEach-Object{ $_.Trim() } | Where-Object {$_.Contains($searchStr.Trim())}){

                Write-Host "True see new 50 running logs" | Write-Output
                $downloadURL = "https://utilities.itsupport247.net/pstautomation/CWAutoLogCollector.exe"
                $downloadPath = "C:\AutoJanuslog\CWAutoLogCollector.exe"
                $unblockURL = $downloadPath

                Invoke-WebRequest -Uri $downloadURL -OutFile $downloadPath
                Unblock-File -Path $downloadPath
                Start-Process -FilePath $downloadPath -Verb RunAs
    } else { Write-Host "Not found" | Write-Output }
