#*******************************
#Author: Jonathan Parrilla
#Created: 2/15/2015
#Last Updated: 3/2/2015
#*******************************

#Import the function that will perform the reset.
. PerformIISReset.ps1

. WriteToLog.ps1

#Clear the console screen
Clear-Host

#Called in order to draw the GUI frame.
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Define Error boolean
$AnyError = $false

#****DEFINES THE GUI FRAME****#

#Creates a new form/frame
$iisResetGuiWindow = New-Object System.Windows.Forms.Form 

#Title text for the frame
$iisResetGuiWindow.Text = "IIS Reset"

#Size of the frame
#$iisResetGuiWindow.Size = New-Object System.Drawing.Size(350,310)
$iisResetGuiWindow.Size = New-Object System.Drawing.Size(800,600)

#Form/frame's start position. 
$iisResetGuiWindow.StartPosition = "CenterScreen"

#****DEFINES THE PERFORM RESET BUTTON****#

#Create the button object
$PerformResetButton = New-Object System.Windows.Forms.Button

#Location of the button on the GUI frame (Starting at top-left)
$PerformResetButton.Location = New-Object System.Drawing.Size(10,540)

#Size of the button
$PerformResetButton.Size = New-Object System.Drawing.Size(125,23)

#Text on the button
$PerformResetButton.Text = "Perform IIS Reset"

#Define $servers variable. Assign it nothing.
$servers

#Define $successfulServers variable. Assign it nothing.
$successfulServers

#Actions to be performed when a user clicks on 'Perform IIS Reset' button
$PerformResetButton.Add_Click(
{

    #Checks to see if user entered any servers.
    if($boxForServers.TextLength -eq 0)
    {
        #Write-Host NO SERVERS PROVIDED!!!
        
        #If no servers were provided, let the user know.
        $resultsLabel.Text = "
        NO SERVERS PROVIDED!!!!!
         
        Please provide AT LEAST 1 Server.
        
        Thank you."

        $AnyError = $true

    }
    else
    {
        if($AnyError -eq $true)
        {
            $resultsLabel.Text = ""
        }
        
        #Assign the servers entered by the users to $servers
        $servers = $boxForServers.Text;
    
        #Output the list of servers to a file. (this will split them into individual items)
        $servers | Out-File -FilePath "C:\Automation\PlaceForTextFiles\iisResetServers.txt"


        #Get the list of servers from the file.
        $servers = Get-Content "C:\Automation\PlaceForTextFiles\iisResetServers.txt"

        #Change the results lable title and give two lines of space (hence why the double quote is two lines below)
        $resultsLabel.Text = "IIS Reset Results:
    
"
        #For each server provided...
        foreach($server in $servers)
        {
            #Call the PerformIISReset function and pass it the current server. This will return a pass or a fail.
            $IISresetResults = PerformIISReset $server
        
            #Add this server and its result to the results label to display on the GUI. I added two new lines per server for formatting. Hence the double quites being so low.
            $resultsLabel.text = $resultsLabel.text + $server + " - " + $IISresetResults + "

"
            #Wait 20 seconds BEFORE doing the next server on the list.
            Write-Host Waiting 20 seconds...
            Start-Sleep -Seconds 20
        }
    
        #Reset the servers and successfulServers variables to null
        $servers = ""  
    
        #Get the user running this script.
        $user =  $env:USERNAME
    
        #Define the script name
        $scriptName = "GUI_IIS_Reset.ps1"

        #Define the log name
        $logName = "IIS_Reset.txt"
    
        #Call WriteToLog function and pass it the user, script name, and log name.
        WriteToLog $user $scriptName $logName
    
        Write-Host ""
        Write-Host IIS Reset Completed Successfully. 
        Write-Host Log file updated.
    }
   
})

#$OKButton.Add_Click({$x=$objTextBox.Text;$objForm.Close()})
$iisResetGuiWindow.Controls.Add($PerformResetButton)

#****DEFINES THE CANCEL BUTTON****#

#Create button. Define location, size, text and its 'on-click' response.
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(160,540)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$iisResetGuiWindow.Close()})

#Add the button the GUI
$iisResetGuiWindow.Controls.Add($CancelButton)

#****DEFINES THE LABEL WITH INSTRUCTIONS****#

#Create the label. Define location, size, and text.
$instructionLabel = New-Object System.Windows.Forms.Label
$instructionLabel.Location = New-Object System.Drawing.Size(10,20) 
$instructionLabel.Size = New-Object System.Drawing.Size(280,20) 
$instructionLabel.Text = "Please enter the webservers below:"

#Add the lable to the GUI
$iisResetGuiWindow.Controls.Add($instructionLabel) 


#****DEFINES THE LABEL WITH RESULTS****#

#Create the label. Define location, size, and text.
$resultsLabel = New-Object System.Windows.Forms.Label
$resultsLabel.Location = New-Object System.Drawing.Size(300,20) 
$resultsLabel.Size = New-Object System.Drawing.Size(350,400) 
$resultsLabel.Text = "IIS Reset Results will be displayed here."



#Add the lable to the GUI
$iisResetGuiWindow.Controls.Add($resultsLabel)

#****DEFINES THE TEXT BOX TO INPUT SERVERS****#

#Create the box. Define its location and size.
$boxForServers = New-Object System.Windows.Forms.TextBox 
$boxForServers.Location = New-Object System.Drawing.Size(10,40) 
$boxForServers.Size = New-Object System.Drawing.Size(260,475)

#Set it to multiline, have it accept return key strokes, and scroll bars.
$boxForServers.multiline = $true
$boxForServers.AcceptsReturn = $true
$boxForServers.ScrollBars = 'Both'

#Add box to the GUI
$iisResetGuiWindow.Controls.Add($boxForServers) 

#Make the GUI Window the Top most form.
$iisResetGuiWindow.Topmost = $True

#Activate the GUI window
$iisResetGuiWindow.Add_Shown({$iisResetGuiWindow.Activate()})

#Display the GUI Window
[void] $iisResetGuiWindow.ShowDialog()

#******************** END OF SCRIPT *******************************
