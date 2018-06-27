## For Debian and Ubuntu
wget https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/ubuntu-debian/serverSetupAll && chmod +x serverSetupAll && ./serverSetupAll


### LBC Install (No SE Server Setup):
wget https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/ubuntu-debian/lbc_installAll && chmod +x lbc_installAll && ./lbc_installAll

## CentOS
1. yum install wget -y

### SNAT (Not yet fixed)
2.a) wget https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/CentOS-Fedora/serverSetupCent && chmod +x serverSetupCent && ./serverSetupCent

### LBC
2.b) wget "https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/CentOS-Fedora/serverSetup+LBC" && chmod +x "serverSetup+LBC" && ./serverSetup+LBC

**dnsmasq IP Fixer**

wget "https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/CentOS-Fedora/dnsmasqIP-fix" && chmod +x "dnsmasqIP-fix" && ./dnsmasqIP-fix

> Note: **Use the appropriate script according to your OS. Operate your server using SE Server Manager.**

SE Server Manager Link: [Click Me](http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Windows/SoftEther_VPN_Server_and_VPN_Bridge/softether-vpnserver_vpnbridge-v4.27-9668-beta-2018.05.29-windows-x86_x64-intel.exe)

SE Client Manager Link: [Click Me](http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Windows/SoftEther_VPN_Client/softether-vpnclient-v4.27-9668-beta-2018.05.29-windows-x86_x64-intel.exe)


:heavy_check_mark: SE Server Setup

:heavy_check_mark: Ubuntu/Debian LBC and SNat Setup

:x: Pre-made hub

:heavy_check_mark: CentOS LBC and DNSMASQ IP Fixer

:x: CentOS SNAT (Not yet fixed)
