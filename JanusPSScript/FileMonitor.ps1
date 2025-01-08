
$timeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$autoTempFile = New-Item  -Path ".\Autotemp\tmpLog$timeStamp.txt" -ItemType File -Force -Value "LTSvc folder events: "

$FileFilter = '*'  

$IncludeSubfolders = $true

$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite 

﻿$Path = 'C:\Windows\LTSvc'
$labKey = "HKLM:\SOFTWARE\LabTech\"
$labagentKey = "HKLM:\SOFTWARE\LabTech\Service"
Get-ChildItem -Path $KeyLab -Recurse -ErrorAction Ignore > .\Autotemp\baseLTkey$timeStamp.txt
Get-ChildItem -Path $labagentKey -Recurse -ErrorAction Ignore > .\Autotemp\baseLTAgentkey$timeStamp.txt

Start-Transcript -Path $autoTempFile -Append

try
{
  $watcher = New-Object -TypeName System.IO.FileSystemWatcher -Property @{
    Path = $Path
    Filter = $FileFilter
    IncludeSubdirectories = $IncludeSubfolders
    NotifyFilter = $AttributeFilter
  }

 
  $action = {
  
    $details = $event.SourceEventArgs
    $Name = $details.Name
    $FullPath = $details.FullPath
    $OldFullPath = $details.OldFullPath
    $OldName = $details.OldName
    
    $ChangeType = $details.ChangeType
    

    $Timestamp = $event.TimeGenerated
  
    $global:all = $details
    
    $text = "{0} was {1} at {2}" -f $FullPath, $ChangeType, $Timestamp 
    Write-Host ""
    Write-Host $text -ForegroundColor DarkYellow
    
  
    switch ($ChangeType)
    {
      'Changed'  { "CHANGE" }
      'Created'  { "CREATED"}
      'Deleted'  { "DELETED"
     
        Write-Host "Deletion Handler Start" -ForegroundColor Gray
        Start-Sleep -Seconds 4    
        Write-Host "Deletion Handler End" -ForegroundColor Gray
      }
      'Renamed'  { 
       
        $text = "File {0} was renamed to {1}" -f $OldName, $Name
        Write-Host $text -ForegroundColor Yellow
      }
        
   
      default   { Write-Host $_ -ForegroundColor Red -BackgroundColor White }
    }
  }

  $handlers = . {
    Register-ObjectEvent -InputObject $watcher -EventName Changed  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Created  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Deleted  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Renamed  -Action $action 
  } 


  $watcher.EnableRaisingEvents = $true

  Write-Host "Watching for changes to $Path"

  do
  {

    Wait-Event -Timeout 1

    Write-Host "." -NoNewline
        
  } while ($true)
}
finally
{
  #  CTRL+C:
  
  Stop-Transcript

  # stop monitoring
  $watcher.EnableRaisingEvents = $false 
  
  # remove the event handlers
  $handlers | ForEach-Object {
    Unregister-Event -SourceIdentifier $_.Name
  }

  $handlers | Remove-Job
  
  #
  $watcher.Dispose()
 
  
  Write-Warning "Event Handler disabled, monitoring ends."
  
}
