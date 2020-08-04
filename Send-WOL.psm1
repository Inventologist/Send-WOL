<#
.SYNOPSIS
  Send a WOL packet to a broadcast address
.DESCRIPTION
  <Brief description of script>
.PARAMETER MAC
    The MAC address of the device that need to wake up
.PARAMETER IP
    The IP address where the WOL packet will be sent to
.PARAMETER GetFromList
    This parameter is meant to trigger the section of the funtion dealing with the CSV import.
    To use this you must put the MachineName.csv file in the same directory where this runs from.
    You must populate it with the MAC and IP.

    You should be able to populate this with Get-ADComputer, among other methods.
.PARAMETER MachineName
    Used to specify the computer name to wake up.
    ##Used only when "GetFromList" is used.
.NOTES
  Version:        1.7
  Author:         Ben Therien
  Credit:         Packet Creation and Send sections: Kelvin Tegelaar, kelvin@cyberdrain.com
  Creation Date:  2020/8/3
  Purpose/Change: Initial upload of MVP
  
.EXAMPLE
  ## Send Packet with the MAC and IP
  Send-WOL -mac 00-21-9B-5E-0E-AF -ip 10.110.152.5
  ## Send Packet from PC List
  Send-WOL -GetFromList -MachineName simone-pc
#>

Function Send-WOL {
    [CmdletBinding()]
    Param(
    [Parameter(Position=1)][string]$MAC,
    [Parameter(Position=2)][string]$IP="255.255.255.255",
    [Parameter(Position=3)][Switch]$GetFromList,
    [Parameter(Position=4)]$MachineName,
    [Parameter()][int]$Port=9
    )

    # Get MAC/IP from List
    if ($GetFromList) {
        $MACList = @()
        $ImportFile = "$PSScriptRoot\MachineList.csv"
        $MACList = Import-Csv $ImportFile
        
        [string]$MAC = ($MACList | where {$_.MachineName -eq $MachineName}).MAC
        [string]$IP = ($MACList | where {$_.MachineName -eq $MachineName}).IP
        IF (($MAC -eq "") -OR ($IP -eq "")) {
            Write-Error "Info missing for MachineName entry in $($ImportFile)";break
        } ELSE {
            Write-Host "Found Mac: $($MAC)"
            Write-Host "Found IP: $($IP)"
        }
    }
    
    #Prep/Clean Main Variables
    $Broadcast = [Net.IPAddress]::Parse($IP)
    $MAC=(($MAC.replace(":","")).replace("-","")).replace(".","")

    #Define Target
    $target=0,2,4,6,8,10 | % {[convert]::ToByte($MAC.substring($_,2),16)}

    #Prepare Magic Packet
    $packet = (,[byte]255 * 6) + ($target * 16)
 
    #UPD Client Setup and Packet Send
    $UDPclient = new-Object System.Net.Sockets.UdpClient
    $UDPclient.Connect($broadcast,$port)
    [void]$UDPclient.Send($packet, 102)
}