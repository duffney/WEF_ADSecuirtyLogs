configuration Collector
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWindowsEventForwarding

    Windowsfeature RSATADPowerShell{
            Ensure = 'Present'
            Name = 'RSAT-AD-PowerShell'
    }

    xWEFCollector Enabled {
        Ensure = "Present"
        Name = "Enabled"
    }

    xWEFSubscription ADSecurity
    {
        SubscriptionID = "ADSecurity"
        Ensure = "Present"
        LogFile = 'ForwardedEvents'
        SubscriptionType = 'CollectorInitiated'
        Address = (Get-ADGroupMember 'Domain Controllers' | % {Get-ADComputer -Identity $_.SID}).DNSHostName
        DependsOn = "[xWEFCollector]Enabled","[WindowsFeature]RSATADPowerShell"
        Query = @('Security:*')
    } 
}
Collector -OutputPath c:\DSC\ 
Start-DscConfiguration -Wait -Force -Path c:\DSC\ -Verbose