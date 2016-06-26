#Install RSAT
If ((Get-WindowsFeature -Name RSAT-AD-PowerShell).InstallState -eq 'Installed'){Write-Output "Installed"}else{Install-WindowsFeature RSAT-AD-PowerShell -Verbose }
If ((Get-WindowsFeature -Name GPMC).InstallState -eq 'Installed'){Write-Output "Installed"}else{Install-WindowsFeature GPMC -Verbose }

#Add Collector to Event Log Readers Group
Set-ADGroup -Add:@{'Member'="CN=COLLECTOR,CN=Computers,DC=WEF,DC=COM"} -Identity:"CN=Event Log Readers,CN=Builtin,DC=WEF,DC=COM" -Server:"DC1.WEF.COM" -Verbose
Get-ADGroupMember -Identity 'Event Log Readers'

#Review GPO Settings [Allow Network Service Account Read & Enabling Auditing]
Start-Process C:\windows\system32\gpmc.msc

<#
Configur Log Access
Computer Management > Preferences > Administrative Template > Windows Component > Event Log Service > Security > Configure log Access
Value: O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;S-1-5-20)

Enable Active Directory Auditing
Computer Management > Polices > Windows Settings > Security Settings > Local Polices > Audit Policy
#>

#Reboot DCs to apply GPO change
$DCs = (Get-ADDomainController -filter *).Name
$DCs | % {Restart-Computer -ComputerName $_ -Wait -For PowerShell -Force}

#Install xWindowsEventForwarding
Install-Module xWindowsEventForwarding -Confirm:$false

psedit c:\scripts\Collector.ps1

#Start Event Viewer
Start-Process "c:\windows\system32\eventvwr.msc" -ArgumentList "/s"


#Install xActiveDirectory
Install-Module xActiveDirectory -Confirm:$false

#Obtain Self Signed Cert
$cert = Invoke-Command -scriptblock { 
    Get-ChildItem Cert:\LocalMachine\my | 
    Where-Object {$_.Issuer -eq 'CN=DC3'}
    } -ComputerName DC3

if (-not (Test-Path c:\certs)){mkdir -Path c:\certs}
Export-Certificate -Cert $Cert -FilePath $env:systemdrive:\Certs\DC3.cer -Force     

#Copy xActiveDirectory to DC3
$params =@{
    Path = (Get-Module xActiveDirectory -ListAvailable).ModuleBase
    Destination = "$env:SystemDrive\Program Files\WindowsPowerShell\Modules\xActiveDirectory"
    ToSession = $Session
    Force = $true
    Recurse = $true
    Verbose = $true

}

Copy-Item @params

#Promote DC3
psedit c:\scripts\NewDomainController.ps1

#View, Remove, update current subscription
cmd /c wecutil es
cmd /c wecutil gs adsecurity
cmd /c wecutil ds ADSecurity 


#Method 1: Nuke
$Subs = cmd /c wecutil es
if ($Subs -contains 'ADSecurity'){
    Write-Output "Removing Subscription [ADSecurity]"
    cmd /c wecutil ds ADSecurity
}

#Method 2: Compare
$EventSources = cmd /c wecutil gs adsecurity | Select-String -SimpleMatch "Address" | % {($_).tostring().split(':')[1].trim()}
$DCs = (Get-ADDomainController -filter *).HostName

if ((Compare-Object $DCs $EventSources).length -eq 0){
    Write-Output "Removing Subscription [ADSecurity]"
    cmd /c wecutil ds ADSecurity
}

#Re-apply WEF DSC Config
Start-DscConfiguration -Wait -Force -Path c:\DSC\ -Verbose

#Verify Subscription exists
cmd /c wecutil gs adsecurity