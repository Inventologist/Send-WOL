# Send-WOL
 Send WOL Packet to wake a WOL compatible computer
 
 ## To IP or NOT to IP?
 I had some difficult times with this script, as there are so many different power states 
 
 ## How to Load Module
 You can download the psm1 file and do an Import-Module on it, or you can have it auto load and update with "Get-Git" https://github.com/Inventologist/Get-Git
 
 Just insert the following command into your script and the Send-WOL module will download, expand, and auto load:</br>
 ```powershell
 Invoke-Expression ('$GHDLUri="https://github.com/Inventologist/Send-WOL/archive/master.zip";$GHUser="Inventologist";$GHRepo="Send-WOL";$ForceRefresh="Yes"' + (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/Inventologist/Get-Git/master/Get-Git.ps1'))
 ```
 
 ## Example command
 When using the -GetFromList, it will pull from the MachineName.csv file.  There is an entry in there for "simone-pc"</br>
  ```powershell
 Send-WOL -GetFromList -MachineName simone-pc
 ```
Or you could use it with the MAC or MAC/IP
  ```powershell
 Send-WOL -mac 00-21-9B-5E-0E-AF -ip 10.110.152.5
 ```
