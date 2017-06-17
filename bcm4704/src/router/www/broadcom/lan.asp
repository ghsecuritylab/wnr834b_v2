<!--
Copyright 2007, Broadcom Corporation
All Rights Reserved.

THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.

$Id: lan.asp,v 1.1.1.1 2010/03/05 07:31:37 reynolds Exp $
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<title>Broadcom Home Gateway Reference Design: LAN</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="style.css" media="screen">
<script language="JavaScript" type="text/javascript" src="overlib.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
function inet_aton(a)
{
	var n;

	n = a.split(/\./);
	if (n.length != 4)
		return 0;

	return ((n[0] << 24) | (n[1] << 16) | (n[2] << 8) | n[3]);
}
	
function inet_ntoa(n)
{
	var a;

	a = (n >> 24) & 255;
	a += "."
	a += (n >> 16) & 255;
	a += "."
	a += (n >> 8) & 255;
	a += "."
	a += n & 255;

	return a;
}
function guest_lan_check()
{
//Disable entry to Guest LAN if we are running on VX 
//	
	var vx = "<% nvram_match("os_name", "vx", "1"); %>";
	var ap = "<% nvram_match("router_disable", "1", "1"); %>";
	
	document.forms[0].lan_ifname.value="<% nvram_get("lan_ifname"); %>";
	document.forms[0].lan1_ifname.value="<% nvram_get("lan1_ifname"); %>";

	
	if ( (ap == "1") || (vx == "1") ){
		document.forms[0].lan1_ifname.disabled = 1;
		document.forms[0].lan1_gateway.disabled = 1;
		document.forms[0].lan1_netmask.disabled = 1;
		document.forms[0].lan1_ipaddr.disabled = 1;
		document.forms[0].lan1_proto.disabled = 1;
		document.forms[0].lan1_dhcp.disabled = 1;
		document.forms[0].lan1_lease.disabled = 1;
		document.forms[0].dhcp1_start.disabled = 1;
		document.forms[0].dhcp1_end.disabled = 1;
		document.forms[0].lan1_stp.disabled = 1;
		document.forms[0].num_lan_ifaces.value="1";
	}
	else{
		document.forms[0].num_lan_ifaces.value="2";
	}
	
		
}
function display_internal_lan()
{
	document.forms[0].write(document.forms[0].lan_ifname.value );
}

function lan_ipaddr_change()
{
	var lan_netaddr, lan_netmask, dhcp_start, dhcp_end;
	var lan1_netaddr, lan1_netmask, dhcp1_start, dhcp1_end;
	
	lan_netaddr = inet_aton(document.forms[0].lan_ipaddr.value);
	lan_netmask = inet_aton(document.forms[0].lan_netmask.value);
	lan_netaddr &= lan_netmask;

	dhcp_start = inet_aton(document.forms[0].dhcp_start.value);
	dhcp_start &= ~lan_netmask;
	dhcp_start |= lan_netaddr;
	dhcp_end = inet_aton(document.forms[0].dhcp_end.value);
	dhcp_end &= ~lan_netmask;
	dhcp_end |= lan_netaddr;

	document.forms[0].dhcp_start.value = inet_ntoa(dhcp_start);
	document.forms[0].dhcp_end.value = inet_ntoa(dhcp_end);
	
	lan1_netaddr = inet_aton(document.forms[0].lan1_ipaddr.value);
	lan1_netmask = inet_aton(document.forms[0].lan1_netmask.value);
	lan1_netaddr &= lan1_netmask;

	dhcp1_start = inet_aton(document.forms[0].dhcp1_start.value);
	dhcp1_start &= ~lan1_netmask;
	dhcp1_start |= lan1_netaddr;
	dhcp1_end = inet_aton(document.forms[0].dhcp1_end.value);
	dhcp1_end &= ~lan1_netmask;
	dhcp1_end |= lan1_netaddr;

	document.forms[0].dhcp1_start.value = inet_ntoa(dhcp1_start);
	document.forms[0].dhcp1_end.value = inet_ntoa(dhcp1_end);
	document.forms[0].lan1_lease.value = "<% nvram_get("lan1_lease"); %>";
	if (document.forms[0].lan1_lease.value == "")
		document.forms[0].lan1_lease.value = "<% nvram_get("lan_lease"); %>";
}
function lan_dhcp_change(index)
{
	var dhcp = document.forms[0].lan_dhcp[document.forms[0].lan_dhcp.selectedIndex].value;
	var dhcp1 = document.forms[0].lan1_dhcp[document.forms[0].lan1_dhcp.selectedIndex].value;
	
	if (index == "0"){
		if (document.forms[0].lan_dhcp.disabled == 1 || dhcp == "0") {
			document.forms[0].lan_gateway.disabled = 0;
			document.forms[0].lan_netmask.disabled = 0;
			document.forms[0].lan_ipaddr.disabled = 0;
		}
		else {
			document.forms[0].lan_gateway.disabled = 1;
			document.forms[0].lan_netmask.disabled = 1;
			document.forms[0].lan_ipaddr.disabled = 1;
		}
	}
	else if (index == "1"){
	
		if (document.forms[0].lan1_dhcp.disabled == 1 || dhcp1 == "0") {
			document.forms[0].lan1_netmask.disabled = 0;
			document.forms[0].lan1_ipaddr.disabled = 0;
		}
		else {
			document.forms[0].lan1_netmask.disabled = 1;
			document.forms[0].lan1_ipaddr.disabled = 1;
			document.forms[0].dhcp1_start.disabled = 1;
		
		}
	}
	
}

function lan_dhcp_server_change(index)
{
	var proto = document.forms[0].lan_proto[document.forms[0].lan_proto.selectedIndex].value;
	var proto1 = document.forms[0].lan1_proto[document.forms[0].lan1_proto.selectedIndex].value;
	
	if (index == 0){
		if (document.forms[0].lan_proto.disabled == 1 || proto == "static") {
			document.forms[0].dhcp_start.disabled = 1;
			document.forms[0].dhcp_end.disabled = 1;
			document.forms[0].lan_lease.disabled = 1;
		}
		else {
			document.forms[0].dhcp_start.disabled = 0;
			document.forms[0].dhcp_end.disabled = 0;
			document.forms[0].lan_lease.disabled = 0;
		}
	}
	else if (index == 1){
	
		if (document.forms[0].lan1_proto.disabled == 1 || proto1 == "static") {
			document.forms[0].dhcp1_start.disabled = 1;
			document.forms[0].dhcp1_end.disabled = 1;
			document.forms[0].lan1_lease.disabled = 1;
		}
		else {
			document.forms[0].dhcp1_start.disabled = 0;
			document.forms[0].dhcp1_end.disabled = 0;
			document.forms[0].lan1_lease.disabled = 0;		
		}
	}
	
}

function lan_update()
{
	var ap = "<% nvram_match("router_disable", "1", "1"); %>";
	var dhcp = "<% nvram_match("lan_proto", "static", "static"); %>";
	var dhcp1= "<% nvram_match("lan1_proto", "static", "static"); %>";
	var ure_disable = "<% nvram_get("ure_disable"); %>";
	
	
	if (ap == "1") {
		document.forms[0].lan_dhcp.disabled = 0;
		document.forms[0].lan_proto.disabled = 1;
		document.forms[0].dhcp_start.disabled = 1;
		document.forms[0].dhcp_end.disabled = 1;
		document.forms[0].lan_lease.disabled = 1;
	}
	else {
		document.forms[0].lan_dhcp.disabled = 1;
		document.forms[0].lan_proto.disabled = 0;
		document.forms[0].dhcp_start.disabled = 0;
		document.forms[0].dhcp_end.disabled = 0;
		document.forms[0].lan_lease.disabled = 0;
		document.forms[0].lan1_dhcp.disabled = 1;
		document.forms[0].lan1_proto.disabled = 0;
		document.forms[0].dhcp1_start.disabled = 0;
		document.forms[0].dhcp1_end.disabled = 0;
		document.forms[0].lan1_lease.disabled = 0;
		if(dhcp == "static") {
			document.forms[0].dhcp_start.disabled = 1;
			document.forms[0].dhcp_end.disabled = 1;
			document.forms[0].lan_lease.disabled = 1;
		}
		if(dhcp1 == "static") {
			document.forms[0].dhcp1_start.disabled = 1;
			document.forms[0].dhcp1_end.disabled = 1;
			document.forms[0].lan1_lease.disabled = 1;
		}
	}
	guest_lan_check();
	if (ure_disable == "0") {
		document.forms[0].lan1_ifname.disabled = 1;
		document.forms[0].lan1_dhcp.disabled = 1;
		document.forms[0].lan1_ipaddr.disabled = 1;
		document.forms[0].lan1_netmask.disabled = 1;
		document.forms[0].lan1_gateway.disabled = 1;
		document.forms[0].lan1_proto.disabled = 1;
		document.forms[0].dhcp1_start.disabled = 1;
		document.forms[0].dhcp1_end.disabled = 1;
		document.forms[0].lan1_lease.disabled = 1;
		document.forms[0].lan1_stp.disabled = 1;
   }
}
//-->
</script>
</head>

<body onLoad="lan_update();">
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#cc0000">
  <% asp_list(); %>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td colspan="2" class="edge"><img border="0" src="blur_new.jpg" alt=""></td>
  </tr>
  <tr>
    <td><img border="0" src="logo_new.gif" alt=""></td>
    <td width="100%" valign="top">
	<br>
	<span class="title">LAN</span><br>
	<span class="subtitle">This page allows you to configure the LAN of the router.</span>
    </td>
  </tr>
</table>

<form method="post" action="apply.cgi">
<input type="hidden" name="page" value="lan.asp">
<!-- These are set by the Javascript functions above --> 
<input type="hidden" name="num_lan_ifaces" value="2">
<input type="hidden" name="lan_ifname" value="" >
<input type="hidden" name="lan1_ifname" value="" >

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310">
	Configured Networks:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><B>Internal Network</B></td>
    <td>&nbsp;&nbsp;</td>
    <td><B>Guest Network</B></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Shows the MAC address (also known as Ethernet address) of the LAN interface.', LEFT);"
	onMouseOut="return nd();">
	MAC Address:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><% nvram_get("lan_hwaddr"); %></td>
    <td>&nbsp;&nbsp;</td>
    <td><% nvram_get("lan1_hwaddr"); %></td>
  </tr> 
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects interfaces for LAN ', LEFT);"
	onMouseOut="return nd();">
	LAN Interface:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<% nvram_get("lan_ifname"); %>
    </td>
    <td>&nbsp;&nbsp;</td>
    <td>
	<% nvram_get("lan1_ifname"); %>
    </td>
  </tr>  
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the method to use to obtain an IP address of the LAN interface.', LEFT);"
	onMouseOut="return nd();">
	Protocol:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan_dhcp" onChange="lan_dhcp_change(0);">
	  <option value="1" <% nvram_match("lan_dhcp", "1", "selected"); %>>DHCP</option>
	  <option value="0" <% nvram_match("lan_dhcp", "0", "selected"); %>>Static</option>
	</select>
    </td>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan1_dhcp" onChange="lan_dhcp_change(1);">
	  <option value="1" <% nvram_match("lan1_dhcp", "1", "selected"); %>>DHCP</option>
	  <option value="0" <% nvram_match("lan1_dhcp", "0", "selected"); %>>Static</option>
	</select>
    </td>
  </tr>  
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the IP address of the LAN interface.', LEFT);"
	onMouseOut="return nd();">
	IP Address:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_ipaddr" value="<% nvram_get("lan_ipaddr"); %>" size="15" maxlength="15" onChange="lan_ipaddr_change();"></td>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan1_ipaddr" value="<% nvram_get("lan1_ipaddr"); %>" size="15" maxlength="15" onChange="lan_ipaddr_change();"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the IP netmask of the LAN interface.', LEFT);"
	onMouseOut="return nd();">
	Subnet Mask:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_netmask" value="<% nvram_get("lan_netmask"); %>" size="15" maxlength="15" onChange="lan_ipaddr_change();"></td>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan1_netmask" value="<% nvram_get("lan1_netmask"); %>" size="15" maxlength="15" onChange="lan_ipaddr_change();"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the Default Gateway of the LAN interface.', LEFT);"
	onMouseOut="return nd();">
	Default Gateway:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_gateway" value="<% nvram_get("lan_gateway"); %>" size="15" maxlength="15"></td>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan1_gateway" value="<% nvram_get("lan1_gateway"); %>" size="15" maxlength="15"></td>
    <td></td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables DHCP Server functionality on the LAN.', LEFT);"
	onMouseOut="return nd();">
	DHCP Server:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan_proto" onChange="lan_dhcp_server_change(0);"> 
	  <option value="dhcp" <% nvram_match("lan_proto", "dhcp", "selected"); %>>Enabled</option>
	  <option value="static" <% nvram_match("lan_proto", "static", "selected"); %>>Disabled</option>
	</select>
    </td>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan1_proto" onChange="lan_dhcp_server_change(1);"> 
	  <option value="dhcp" <% nvram_match("lan1_proto", "dhcp", "selected"); %>>Enabled</option>
	  <option value="static" <% nvram_match("lan1_proto", "static", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the start of the IP address range that the DHCP Server will use.', LEFT);"
	onMouseOut="return nd();">
	DHCP Starting IP Address:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="dhcp_start" value="<% nvram_get("dhcp_start"); %>" size="15" maxlength="15"></td>
    <td>&nbsp;&nbsp;</td>
    <td><input name="dhcp1_start" value="<% nvram_get("dhcp1_start"); %>" size="15" maxlength="15"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the end of the IP address range that the DHCP Server will use.', LEFT);"
	onMouseOut="return nd();">
	DHCP Ending IP Address:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="dhcp_end" value="<% nvram_get("dhcp_end"); %>" size="15" maxlength="15"></td>
        <td>&nbsp;&nbsp;</td>
    <td><input name="dhcp1_end" value="<% nvram_get("dhcp1_end"); %>" size="15" maxlength="15"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the number of seconds DHCP leases should be valid for.', LEFT);"
	onMouseOut="return nd();">
	DHCP Lease Time:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_lease" value="<% nvram_get("lan_lease"); %>" size="6" maxlength="6"></td>
        <td>&nbsp;&nbsp;</td>
    <td><input name="lan1_lease" value="<% nvram_get("lan1_lease"); %>" size="6" maxlength="6"></td>
  </tr>
   <tr>
    <th width="310"
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	</td>
    <td>&nbsp;&nbsp;</td>
    <td>
	</td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables the use of the Ethernet 802.1d Spanning Tree Protocol to eliminate bridging loops across the LAN interfaces.', LEFT);"
	onMouseOut="return nd();">
	Spanning Tree Protocol:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan_stp">
	  <option value="1" <% nvram_match("lan_stp", "1", "selected"); %>>Enabled</option>
	  <option value="0" <% nvram_match("lan_stp", "0", "selected"); %>>Disabled</option>
	</select>
	</td>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="lan1_stp">
	  <option value="1" <% nvram_match("lan1_stp", "1", "selected"); %>>Enabled</option>
	  <option value="0" <% nvram_match("lan1_stp", "0", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>  
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310" valign="top"
	onMouseOver="return overlib('Active DHCP leases since last reboot.', LEFT);"
	onMouseOut="return nd();">
	Active DHCP Leases:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<table>
	  <tr>
	    <td class="label">Hostname</td>
	    <td class="label">MAC Address</td>
	    <td class="label">IP Address</td>
	    <td class="label">Expires In</td>
	    <td class="label">Network</td>
	  </tr>
	  <% lan_leases(); %>
	</table>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310" valign="top" rowspan="6"
	onMouseOver="return overlib('Set up static routes to the given networks.', LEFT);"
	onMouseOut="return nd();">	
	<input type="hidden" name="lan_route" value="5">
	Static Routes:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td class="label">IP Address</td>
    <td></td>
    <td class="label">Subnet Mask</td>
    <td></td>
    <td class="label">Gateway</td>
    <td></td>
    <td class="label">Metric</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_route_ipaddr0" value="<% lan_route("ipaddr", 0); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_netmask0" value="<% lan_route("netmask", 0); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_gateway0" value="<% lan_route("gateway", 0); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_metric0" value="<% lan_route("metric", 0); %>" size="2" maxlength="2"></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_route_ipaddr1" value="<% lan_route("ipaddr", 1); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_netmask1" value="<% lan_route("netmask", 1); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_gateway1" value="<% lan_route("gateway", 1); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_metric1" value="<% lan_route("metric", 1); %>" size="2" maxlength="2"></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_route_ipaddr2" value="<% lan_route("ipaddr", 2); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_netmask2" value="<% lan_route("netmask", 2); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_gateway2" value="<% lan_route("gateway", 2); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_metric2" value="<% lan_route("metric", 2); %>" size="2" maxlength="2"></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_route_ipaddr3" value="<% lan_route("ipaddr", 3); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_netmask3" value="<% lan_route("netmask", 3); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_gateway3" value="<% lan_route("gateway", 3); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_metric3" value="<% lan_route("metric", 3); %>" size="2" maxlength="2"></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="lan_route_ipaddr4" value="<% lan_route("ipaddr", 4); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_netmask4" value="<% lan_route("netmask", 4); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_gateway4" value="<% lan_route("gateway", 4); %>" size="15" maxlength="15"></td>
    <td>&nbsp;</td>
    <td><input name="lan_route_metric4" value="<% lan_route("metric", 4); %>" size="2" maxlength="2"></td>
  </tr>
</table>

<% emf_enable_display(); %>
<% emf_entries_display(); %>
<% emf_uffp_entries_display(); %>
<% emf_rtport_entries_display(); %>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="310"></td>
    <td>&nbsp;&nbsp;</td>
    <td>
	<input type="submit" name="action" value="Apply">
	<input type="reset" name="action" value="Cancel">
    </td>
  </tr>
</table>

</form>

<p class="label">&#169;2001-2007 Broadcom Corporation. All rights reserved.</p>

</body>
</html>
