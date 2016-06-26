New-Lab -ConfigPath g:\WEFADSecurityLogs\WEFADSecurityLogs.xml -LabPath G:\WEFADSecurityLogs -Name WEFADSecurityLogs

<#
Copy Member_Default.DSC.ps1 to \WEFADSecurityLogs\DSCLibrary
Copy Windows Server 2016 TP5 .iso to ISOFiles
#>

$Content = @"
"@

Set-Content -Path "E:\OmahaPSUG_WEF\OmahaPSUG_WEF.xml" -Value $Content

Install-Lab -ConfigPath G:\WEFADSecurityLogs\WEFADSecurityLogs.xml -Verbose