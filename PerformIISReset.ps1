<#
Author:Jonathan Parrilla
Created: 2/13/2015
Last Updated: 2/28/2015
#>

#Function that will perform the IIS Reset on the list of servers provided by the user.
Function PerformIISReset([String] $server)
{
    #Write-Host Waiting 20 Seconds...

    #Wait 20 seconds between servers. This is done to prevent accessibility issues from arising.
    #Start-Sleep -Seconds 20

    #Write out to the console what server it is performing IIS reset.
    Write-Host Performing IIS Reset on the following server: $server

    #Perform the IISRESET command on the server.
    IISRESET $server /noforce


}