<#
Author:Jonathan Parrilla
Created: 2/23/2015
Last Updated: 2/23/2015
#>


Function WriteToLog ([String] $user, [String] $script, [String] $logName)
{
    #Get the user running this script
    #$userRunningScript =  $user
    
    #Get the current date
    $currentDate = Get-Date
    
    #Get Script Name
    #$scriptBeingRun = $script
    
    #Write to the log file whom and at what time this task was performed
    $updateLog = "$user ran $script on $currentDate" | Out-File -FilePath "C:\Automation\Logs\$logName" -Append

}