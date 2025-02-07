New-Item -ItemType "directory" -Path "C:\AutoJanuslog" -ErrorAction SilentlyContinue

[String]$searchStr = "Janus.Cryptography.RemoteAgentSettingsCrypto"
 

$LTlogFile = "C:\Windows\LTSvc\LTErrors.txt"



if (Get-Content -Path $LTlogFile -tail 50 | ForEach-Object{ $_.Trim() } | Where-Object {$_.Contains($searchStr.Trim())}){

                Write-Host "Janus Error Found! Please reinstall LTAgent and collect logs!" | Write-Output
                $downloadURL = "https://utilities.itsupport247.net/pstautomation/CWAutoLogCollector.exe"
                $downloadPath = "C:\AutoJanuslog\CWAutoLogCollector.exe"
                $unblockURL = $downloadPath

                Invoke-WebRequest -Uri $downloadURL -OutFile $downloadPath
                Unblock-File -Path $downloadPath
                Start-Process -FilePath $downloadPath -Verb RunAs  } else { Write-Host "Agent Online" | Write-Output }