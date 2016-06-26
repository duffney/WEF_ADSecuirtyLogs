# WEF_ADSecuirtyLogs


### Introduction
The WEF_ADSecurity or [Windows Event Forwarding for Active Directory Security Logs] is a repository designed to demonstrate setting up Windows Event Log forwarding for Active Directory Domain 
Controller logs using DSC and Group Policy. All the necessary files, scripts and resources required for setting up a WEF lab are included in this repository. Demo.ps1 is the walk through script 
for the demo. Use the files within DSC_Configs as the DSC configurations for the lab and the files within LabBuilder to assist with the creation of the lab environment.

### Demo Overview

1. [Create Lab Environment with LabBuilder](http://duffney.github.io/Creating-Labs-with-LabBuilder/)
2. Add Collector node to Event Log Readers Active Directory group
3. Configure Log Access Group Policy
4. Enable Auditing on Domain Controllers via Group Policy
5. Restart Domain Controllers to apply new Group Policies
6. Deploy xWindowsEventForwarding DSC Configuration to Collector node
7. Review Event Log Subscription
8. Prep New Domain Controller
9. Promote New Domain Controller with DSC
10. Update Event Log Subscription

### Requirements

PowerShell Version 5

Hyper-V


DSCResources: LabBuilder,xWindowsEventForwarding,xActiveDirectory (All found in DSCResources folder)


ISOFiles: [WindowsServer 2016 TP5](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview)


### Sources


Event Log Forwarding

[the-security-log-haystack-event-forwarding-and-you](https://blogs.technet.microsoft.com/askds/2011/08/29/the-security-log-haystack-event-forwarding-and-you/)

[configure-event-log-forwarding-windows-server-2012-r2](https://www.petri.com/configure-event-log-forwarding-windows-server-2012-r2)

[ultimate-guide-centralizing-windows-logs](http://www.loggly.com/ultimate-guide/centralizing-windows-logs/)


[xWindowsEventForwarding](https://github.com/PowerShell/xWindowsEventForwarding)


wecutil documentation


[msdn.microsoft.com](https://msdn.microsoft.com/en-us/library/bb736545(v=vs.85).aspx)


[technet.microsoft.com](https://technet.microsoft.com/en-us/library/cc753183(v=ws.11).aspx)