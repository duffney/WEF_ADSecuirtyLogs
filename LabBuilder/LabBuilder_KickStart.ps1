Find-Module labbuilder | Install-Module

New-Lab -ConfigPath C:\WEFADSecurityLogs\WEFADSecurityLogs.xml -LabPath C:\WEFADSecurityLogs -Name WEFADSecurityLogs

#Copy Member_Default.DSC.ps1 to \WEFADSecurityLogs\DSCLibrary

#Copy Windows Server 2016 TP5 .iso to ISOFiles
Copy-Item "C:\ISOs\14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO" -Destination C:\WEFADSecurityLogs\ISOFiles\

#Modify .xml file

Install-Lab -ConfigPath C:\WEFADSecurityLogs\WEFADSecurityLogs.xml -Verbose

Add-VMDvdDrive -VMName Collector -Path C:\GitHub\WEF_ADSecuirtyLogs\DSCResources\DSCResources.iso

$Credential = Get-Credential -UserName wef\administrator -Message "Enter DA Password" 

Invoke-Command -VMName Collector -ScriptBlock {mkdir c:\scripts; Copy-Item -Path D:\DSCResources\* -Destination 'C:\Program Files\WindowsPowerShell\Modules\' -Recurse} -Credential $Credential

$Session = New-PSSession -VMName Collector -Credential $Credential

Copy-Item -Path C:\GitHub\WEF_ADSecuirtyLogs\Demo.ps1 -Destination C:\scripts -ToSession $Session -Verbose

Copy-Item -Path C:\GitHub\WEF_ADSecuirtyLogs\DSC_Configs\* -Destination C:\scripts -ToSession $Session -Verbose