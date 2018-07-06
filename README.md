
## For Debian and Ubuntu
<input type="text" id="ubusnat" value="wget https://git.io/fbpaR -O serverSetupSNAT && chmod +x serverSetupSNAT && ./serverSetupSNAT" readonly="true" style="width:90%" /><button onclick="copyx()">CopyXx</button>
<script language="javascript">
  function copyx() {
  var copyText = document.getElementById("ubusnat");
  copyText.select();
  document.execCommand("copy");
  copyText.value="Copied";
  copyText.disabled=true;}
</script>


### LBC Install (No SE Server Setup):

wget https://git.io/fF9lL -O lbc_install && chmod +x lbc_install && ./lbc_install

## CentOS
1. yum install wget -y

### SNAT
2.a) wget https://git.io/fF9lq -O serverSetupSNAT && chmod +x serverSetupSNAT && ./serverSetupSNAT

### LBC
2.b) wget https://git.io/fF9BZ -O serverSetup+LBC && chmod +x serverSetup+LBC && ./serverSetup+LBC

**dnsmasq IP Fixer**

wget https://git.io/fFHIB -O dnsmasqIP-fix && chmod +x dnsmasqIP-fix && ./dnsmasqIP-fix

> Note: **Use the appropriate script according to your OS. Operate your server using SE Server Manager.**

SE Server Manager Link: [Click Me](http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Windows/SoftEther_VPN_Server_and_VPN_Bridge/softether-vpnserver_vpnbridge-v4.27-9668-beta-2018.05.29-windows-x86_x64-intel.exe)

SE Client Manager Link: [Click Me](http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Windows/SoftEther_VPN_Client/softether-vpnclient-v4.27-9668-beta-2018.05.29-windows-x86_x64-intel.exe)


:heavy_check_mark: SE Server Setup

:heavy_check_mark: Ubuntu/Debian LBC and SNat Setup

:x: Pre-made hub

:heavy_check_mark: CentOS LBC, SNAT, and DNSMASQ IP Fixer
