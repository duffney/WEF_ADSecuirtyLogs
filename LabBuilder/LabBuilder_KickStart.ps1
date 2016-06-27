Find-Module labbuilder | Install-Module

New-Lab -ConfigPath C:\WEFADSecurityLogs\WEFADSecurityLogs.xml -LabPath C:\WEFADSecurityLogs -Name WEFADSecurityLogs

#Copy Member_Default.DSC.ps1 to \WEFADSecurityLogs\DSCLibrary

#Copy Windows Server 2016 TP5 .iso to ISOFiles
Copy-Item "C:\ISOs\14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO" -Destination C:\WEFADSecurityLogs\ISOFiles\

$Content = @"
<?xml version="1.0" encoding="utf-8"?>
<labbuilderconfig xmlns="labbuilderconfig" name="WEFADSecurityLogs" version="1.0">
<description></description>
<settings labpath="C:\WEFADSecurityLogs" />
<resources>     
	<msu name="WMF5.0-WS2012R2-W81" url="https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu" />
	<msu name="WMF5.0-WS2012-W8" url="https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu" />
	<msu name="WMF5.0-WS2008R2-W7" url="https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu" />
</resources>
<switches>
<switch name="External" type="External">
    <adapters>
        <adapter name="Cluster" macaddress="00155D010701" vlan="5" />
        <adapter name="Management" macaddress="00155D010702" vlan="6" />
        <adapter name="SMB" macaddress="00155D010703" />
        <adapter name="LM" macaddress="00155D010704" />       
        </adapters>     
    </switch>
    <switch name="Internal" type="Internal" />     
    <switch name="Domain Private Site A" type="Private" vlan="2" />
    <switch name="Domain Private Site B" type="Private" vlan="3" />
    <switch name="Domain Private Site C" type="Private" vlan="4" />    
</switches>
<templatevhds isopath="ISOFiles" 
                vhdpath="VHDFiles" 
                prefix="Template " >
    <templatevhd name="Windows Server 2016 TP5 Datacenter FULL"
                 iso="14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO"
                 url="https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview"
                 vhd="Windows Server 2016 TP5 Datacenter Full.vhdx"
                 edition="Windows Server 2016 Technical Preview 5 SERVERDATACENTER"
                 ostype="Server"
                 vhdformat="vhdx" 
                 vhdtype="dynamic" 
                 generation="2" 
                 vhdsize="40GB" />
    <templatevhd name="Windows Server 2016 TP5 Datacenter CORE"
                 iso="14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO"
                 url="https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview"
                 vhd="Windows Server 2016 TP5 Datacenter Core.vhdx"
                 edition="Windows Server 2016 Technical Preview 5 SERVERDATACENTERCORE"
                 ostype="Server"
                 vhdformat="vhdx" 
                 vhdtype="dynamic" 
                 generation="2" 
                 vhdsize="25GB" />
  </templatevhds>
  
  <templates>
    <template name="Template Windows Server 2016 TP5 Datacenter FULL"
              templatevhd="Windows Server 2016 TP5 Datacenter FULL"
              memorystartupbytes="2GB"
              processorcount="1"
              administratorpassword="P@ssw0rd"
              timezone="Central Standard Time" 
              ostype="Server" />
    <template name="Template Windows Server 2016 TP5 Datacenter CORE"
              templatevhd="Windows Server 2016 TP5 Datacenter CORE"
              memorystartupbytes="2GB"
              processorcount="1"
              administratorpassword="P@ssw0rd"
              timezone="Central Standard Time" 
              ostype="Server" />
  </templates>

  <vms>   
    <vm name="DC1"
        template="Template Windows Server 2016 TP5 Datacenter FULL"
        computername="DC1"
        dynamicmemoryenabled="N">
      <dsc configname="DC_FORESTPRIMARY"
           configfile="DC_FORESTPRIMARY.DSC.ps1">
        <parameters>
          DomainName = "WEF.COM"
          DomainAdminPassword = "P@ssw0rd"
          Forwarders = @('8.8.8.8','8.8.4.4')
        </parameters>
      </dsc>
      <adapters>
        <adapter name="Internal"
                 switchname="Internal">
          <ipv4 address="192.168.2.10"
                defaultgateway="192.168.2.1"
                subnetmask="24"
                dnsserver="192.168.2.10"/>
          <ipv6 address="fd53:ccc5:895a:bc00::a"
                defaultgateway="fd53:ccc5:895a:bc00::13"
                subnetmask="64"
                dnsserver="fd53:ccc5:895a:bc00::a"/>
        </adapter>
      </adapters>
    </vm>
       <vm name="DC2"
        template="Template Windows Server 2016 TP5 Datacenter FULL"
        computername="DC2"
        memorystartupbytes="2GB"
        dynamicmemoryenabled="N">
      <dsc configname="DC_SECONDARY"
           configfile="DC_SECONDARY.DSC.ps1">
        <parameters>
          DomainName = "WEF.COM"
          DomainAdminPassword = "P@ssw0rd"
          PSDscAllowDomainUser = $True       
          InstallRSATTools = $True   
          Forwarders = @('8.8.8.8','8.8.4.4')
        </parameters>
      </dsc>
      <adapters>
        <adapter name="Internal"
                 switchname="Internal">
          <ipv4 address="192.168.2.11"
                defaultgateway="192.168.2.1"
                subnetmask="24"
                dnsserver="192.168.2.10"/>
          <ipv6 address="fd53:ccc5:895a:bc00::a"
                defaultgateway="fd53:ccc5:895a:bc00::13"
                subnetmask="64"
                dnsserver="fd53:ccc5:895a:bc00::a"/>
        </adapter>
      </adapters>              
    </vm>
    <vm name="DC3"
        template="Template Windows Server 2016 TP5 Datacenter FULL"
        computername="DC3"
        memorystartupbytes="2GB"
        dynamicmemoryenabled="N">
      <dsc configname="MEMBER_DEFAULT"
           configfile="MEMBER_DEFAULT.DSC.ps1">
        <parameters>
          DomainName = "WEF.COM"
          DomainAdminPassword = "P@ssw0rd"
          DCName = 'DC1'
          PSDscAllowDomainUser = $True
        </parameters>
      </dsc>     
      <adapters>
        <adapter name="Internal"
                 switchname="Internal">
          <ipv4 address="192.168.2.12"
                defaultgateway="192.168.2.1"
                subnetmask="24"
                dnsserver="192.168.2.10"/>
        </adapter>
      </adapters>              
    </vm>    
    <vm name="Collector"
        template="Template Windows Server 2016 TP5 Datacenter FULL"
        computername="Collector"
        memorystartupbytes="2GB"
        dynamicmemoryenabled="N">
      <dsc configname="MEMBER_DEFAULT"
           configfile="MEMBER_DEFAULT.DSC.ps1">
        <parameters>
          DomainName = "WEF.COM"
          DomainAdminPassword = "P@ssw0rd"
          DCName = 'DC1'
          PSDscAllowDomainUser = $True
        </parameters>
      </dsc>     
      <adapters>
        <adapter name="Internal"
                 switchname="Internal">
          <ipv4 address="192.168.2.13"
                defaultgateway="192.168.2.1"
                subnetmask="24"
                dnsserver="192.168.2.10"/>
        </adapter>
      </adapters>              
    </vm>         
  </vms>
</labbuilderconfig>
"@

Set-Content -Path "C:\WEFADSecurityLogs\WEFADSecurityLogs.xml" -Value $Content

Install-Lab -ConfigPath C:\WEFADSecurityLogs\WEFADSecurityLogs.xml -Verbose