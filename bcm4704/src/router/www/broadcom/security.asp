<!--
Copyright 2007, Broadcom Corporation
All Rights Reserved.

THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.

$Id: security.asp,v 1.1.1.1 2010/03/05 07:31:37 reynolds Exp $
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<title>Broadcom Home Gateway Reference Design: Security</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="style.css" media="screen">
<script language="JavaScript" type="text/javascript" src="overlib.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
function wl_key_update()
{
	var mode = document.forms[0].wl_auth_mode[document.forms[0].wl_auth_mode.selectedIndex].value;
	var wep = document.forms[0].wl_wep[document.forms[0].wl_wep.selectedIndex].value;
	var wpa= document.forms[0].wl_akm_wpa[document.forms[0].wl_akm_wpa.selectedIndex].value;
	var psk = document.forms[0].wl_akm_psk[document.forms[0].wl_akm_psk.selectedIndex].value;
	var wl_ibss = <% wl_ibss_mode(); %>;
/*
#ifdef BCMWPA2
*/
	var wpa2 = document.forms[0].wl_akm_wpa2[document.forms[0].wl_akm_wpa2.selectedIndex].value;
	var psk2 = document.forms[0].wl_akm_psk2[document.forms[0].wl_akm_psk2.selectedIndex].value;
	var brcm_psk = document.forms[0].wl_akm_brcm_psk[document.forms[0].wl_akm_brcm_psk.selectedIndex].value;
/*
#endif
*/
	var i, cur, algos;

	/* enable network key 1 to 4 */
	if (wep == "enabled") {
		if (document.forms[0].wl_akm_wpa.disabled == 0 && wpa == "enabled" ||
			document.forms[0].wl_akm_psk.disabled == 0 && psk == "enabled"
/*
#ifdef BCMWPA2
*/
			|| document.forms[0].wl_akm_wpa2.disabled == 0 && wpa2 == "enabled"
			|| document.forms[0].wl_akm_psk2.disabled == 0 && psk2 == "enabled"
			|| document.forms[0].wl_akm_brcm_psk.disabled == 0 && brcm_psk == "enabled"
/*
#endif
*/
			|| mode == "radius") {
			document.forms[0].wl_key1.disabled = 1;
			document.forms[0].wl_key4.disabled = 1;
		}
		else {
			document.forms[0].wl_key1.disabled = 0;
			document.forms[0].wl_key4.disabled = 0;
		}
		document.forms[0].wl_key2.disabled = 0;
		document.forms[0].wl_key3.disabled = 0;
	}
	else {
		document.forms[0].wl_key1.disabled = 1;
		document.forms[0].wl_key2.disabled = 1;
		document.forms[0].wl_key3.disabled = 1;
		document.forms[0].wl_key4.disabled = 1;
	}

	/* Save current network key index */
	for (i = 0; i < document.forms[0].wl_key.length; i++) {
		if (document.forms[0].wl_key[i].selected) {
			cur = document.forms[0].wl_key[i].value;
			break;
		}
	}

	/* Define new network key indices */
	if (mode == "radius" ||
		document.forms[0].wl_akm_wpa.disabled == 0 && wpa == "enabled" ||
		document.forms[0].wl_akm_psk.disabled == 0 && psk == "enabled"
/*
#ifdef BCMWPA2
*/
		|| document.forms[0].wl_akm_wpa2.disabled == 0 && wpa2 == "enabled"
		|| document.forms[0].wl_akm_psk2.disabled == 0 && psk2 == "enabled"
		|| document.forms[0].wl_akm_brcm_psk.disabled == 0 && brcm_psk == "enabled"
/*
#endif
*/
		)
		algos = new Array("2", "3");
	else
		algos = new Array("1", "2", "3", "4");

	/* Reconstruct network key indices array from new network key indices */
	document.forms[0].wl_key.length = algos.length;
	for (var i in algos) {
		document.forms[0].wl_key[i] = new Option(algos[i], algos[i]);
		document.forms[0].wl_key[i].value = algos[i];
		if (document.forms[0].wl_key[i].value == cur)
			document.forms[0].wl_key[i].selected = true;
	}

	/* enable key index */
	if (wep == "enabled")
		document.forms[0].wl_key.disabled = 0;
	else
		document.forms[0].wl_key.disabled = 1;
	
	/* enable gtk rotation interval */
	if ((wep == "enabled") || (wl_ibss == "1"))
		document.forms[0].wl_wpa_gtk_rekey.disabled = 1;
	else {
		if (document.forms[0].wl_akm_wpa.disabled == 0 && wpa == "enabled" ||
			document.forms[0].wl_akm_psk.disabled == 0 && psk == "enabled"
/*
#ifdef BCMWPA2
*/
			|| document.forms[0].wl_akm_wpa2.disabled == 0 && wpa2 == "enabled"
			|| document.forms[0].wl_akm_psk2.disabled == 0 && psk2 == "enabled"
			|| document.forms[0].wl_akm_brcm_psk.disabled == 0 && brcm_psk == "enabled"
/*
#endif
*/
			)
			document.forms[0].wl_wpa_gtk_rekey.disabled = 0;
		else
			document.forms[0].wl_wpa_gtk_rekey.disabled = 1;
	}
}

/*
*/

function wl_wps_change()
{
	if(document.forms[0].wl_wsc_mode) {

	if (document.forms[0].wl_wsc_mode.value == "disabled") {

			document.forms[0].wsc_device_name.disabled = 1;
			document.forms[0].wl_wsc_reg.disabled = 1;
			document.forms[0].wsc_config_state.disabled = 1;
	}
	if (document.forms[0].wl_wsc_mode.value == "enabled") {

			document.forms[0].wsc_device_name.disabled = 0;
			document.forms[0].wl_wsc_reg.disabled = 0;
			document.forms[0].wsc_config_state.disabled = 0;
	}
	}
}

function wl_wps_config_change()
{
			wl_wps_change();

			if ((document.forms[0].wl_wsc_mode.value == "enabled")&&(document.forms[0].wsc_config_state.value == "disabled")) {

			document.forms[0].wl_auth.value = "0";
			document.forms[0].wl_auth_mode.value = "none";
			document.forms[0].wl_akm_wpa.value = "disabled";
			document.forms[0].wl_akm_psk.value = "disabled";
			document.forms[0].wl_akm_wpa2.value = "disabled";
			document.forms[0].wl_akm_psk2.value = "disabled";
			document.forms[0].wl_akm_brcm_psk.value = "disabled";
			document.forms[0].wl_preauth.disabled = 1;
			document.forms[0].wl_preauth.value = "disabled";
			document.forms[0].wl_wep.value = "disabled";
			document.forms[0].wl_wpa_psk.value = "";
		}
}

/*
*/

function wl_auth_change()
{
	var auth = document.forms[0].wl_auth[document.forms[0].wl_auth.selectedIndex].value;
	var wl_ure = <% wl_ure_enabled(); %>;
	var wl_ibss = <% wl_ibss_mode(); %>;

	if (auth == "1") {
		document.forms[0].wl_akm_wpa.disabled = 1;
		document.forms[0].wl_akm_psk.disabled = 1;
/*
#ifdef BCMWPA2
*/
		document.forms[0].wl_akm_wpa2.disabled = 1;
		document.forms[0].wl_akm_psk2.disabled = 1;
		document.forms[0].wl_akm_brcm_psk.disabled = 1;
		document.forms[0].wl_preauth.disabled = 1;
/*
#endif
*/
		document.forms[0].wl_wpa_psk.disabled = 1;
		document.forms[0].wl_crypto.disabled = 1;

	}
	else {
		if ((wl_ure == "1") || (wl_ibss == "1")) {
			document.forms[0].wl_akm_wpa.disabled = 1;
    		}
	  	else {
			document.forms[0].wl_akm_wpa.disabled = 0;
    		}
		if (wl_ibss == "1") {
			document.forms[0].wl_akm_psk.disabled = 1;
		}
		else {
			document.forms[0].wl_akm_psk.disabled = 0;
		}
/*
#ifdef BCMWPA2
*/
		if ((wl_ure == "1") || (wl_ibss == "1")) {
			document.forms[0].wl_akm_wpa2.disabled = 1;
			document.forms[0].wl_preauth.disabled = 1;
			document.forms[0].wl_akm_psk2.disabled = 1;
			document.forms[0].wl_akm_brcm_psk.disabled = 0;
    		}
	  	else {
			document.forms[0].wl_akm_wpa2.disabled = 0;
			document.forms[0].wl_akm_psk2.disabled = 0;
			document.forms[0].wl_akm_brcm_psk.disabled = 1;
    		}
/*
#endif
*/
		document.forms[0].wl_wpa_psk.disabled = 0;
		document.forms[0].wl_crypto.disabled = 0;
	}

	wl_key_update();
/* 
*/
	//if (document.forms[0].wl_wsc_mode.value == "enabled") {
	//	document.forms[0].wl_wsc_reg.value = "enabled";
	//	document.forms[0].wsc_config_state.value = "enabled";
	//}
/*
*/
}

function wl_auth_mode_change()
{
	var mode = document.forms[0].wl_auth_mode[document.forms[0].wl_auth_mode.selectedIndex].value;
	var wpa = document.forms[0].wl_akm_wpa[document.forms[0].wl_akm_wpa.selectedIndex].value;
	var psk = document.forms[0].wl_akm_psk[document.forms[0].wl_akm_psk.selectedIndex].value;
/*
#ifdef BCMWPA2
*/
	var wpa2 = document.forms[0].wl_akm_wpa2[document.forms[0].wl_akm_wpa2.selectedIndex].value;
	var psk2 = document.forms[0].wl_akm_psk2[document.forms[0].wl_akm_psk2.selectedIndex].value;
	var brcm_psk = document.forms[0].wl_akm_brcm_psk[document.forms[0].wl_akm_brcm_psk.selectedIndex].value;
/*
#endif
*/
	
	/* enable radius IP, port, password */
	if (mode == "radius" ||
		document.forms[0].wl_akm_wpa.disabled == 0 && wpa == "enabled"
/*
#ifdef BCMWPA2
*/
		|| document.forms[0].wl_akm_wpa2.disabled == 0 && wpa2 == "enabled"
/*
#endif
*/
		) {
		document.forms[0].wl_radius_ipaddr.disabled = 0;
		document.forms[0].wl_radius_port.disabled = 0;
		document.forms[0].wl_radius_key.disabled = 0;
	} else {
		document.forms[0].wl_radius_ipaddr.disabled = 1;
		document.forms[0].wl_radius_port.disabled = 1;
		document.forms[0].wl_radius_key.disabled = 1;
	}

	/* enable network re-auth interval */
	if (mode == "radius" ||
		document.forms[0].wl_akm_wpa.disabled == 0 && wpa == "enabled"
/*
#ifdef BCMWPA2
*/
		|| document.forms[0].wl_akm_wpa2.disabled == 0 && wpa2 == "enabled"
/*
#endif
*/
		)
		document.forms[0].wl_net_reauth.disabled = 0;
	else
		document.forms[0].wl_net_reauth.disabled = 1;
	
	wl_key_update();
/*
*/
	//if (document.forms[0].wl_wsc_mode.value == "enabled") {
	//	document.forms[0].wl_wsc_reg.value = "enabled";
	//	document.forms[0].wsc_config_state.value = "enabled";
	//}
/*
*/ 
}

function wl_akm_change()
{
	var mode = document.forms[0].wl_auth_mode[document.forms[0].wl_auth_mode.selectedIndex].value;
	var wpa = document.forms[0].wl_akm_wpa[document.forms[0].wl_akm_wpa.selectedIndex].value;
	var psk = document.forms[0].wl_akm_psk[document.forms[0].wl_akm_psk.selectedIndex].value;
/*
*/
	//if (document.forms[0].wl_wsc_mode.value == "enabled") {
	//	
	//	document.forms[0].wl_wsc_reg.value = "enabled";
	//	document.forms[0].wsc_config_state.value = "enabled";
	//}
/*
*/ 		
/*	
#ifdef BCMWPA2
*/
	var wpa2 = document.forms[0].wl_akm_wpa2[document.forms[0].wl_akm_wpa2.selectedIndex].value;
	var psk2 = document.forms[0].wl_akm_psk2[document.forms[0].wl_akm_psk2.selectedIndex].value;
	var brcm_psk = document.forms[0].wl_akm_brcm_psk[document.forms[0].wl_akm_brcm_psk.selectedIndex].value;
/*
#endif
*/

	/* enable Pre-shared Key */
	if (psk == "enabled"
/*
#ifdef BCMWPA2
*/
		|| psk2 == "enabled" || brcm_psk == "enabled"
/*
#endif
*/
		)
		document.forms[0].wl_wpa_psk.disabled = 0;
	else
		document.forms[0].wl_wpa_psk.disabled = 1;

	/* enable radius options */
	if (mode == "radius" || wpa == "enabled"
/*
#ifdef BCMWPA2
*/
		|| wpa2 == "enabled"
/*
#endif
*/
		) {
		document.forms[0].wl_radius_ipaddr.disabled = 0;
		document.forms[0].wl_radius_port.disabled = 0;
		document.forms[0].wl_radius_key.disabled = 0;
	}
	else {
		document.forms[0].wl_radius_ipaddr.disabled = 1;
		document.forms[0].wl_radius_port.disabled = 1;
		document.forms[0].wl_radius_key.disabled = 1;
	}

	/* enable crypto */
	if (wpa == "enabled" || psk == "enabled" 
/*
#ifdef BCMWPA2
*/
		|| wpa2 == "enabled" || psk2 == "enabled" || brcm_psk == "enabled" 
/*
#endif
*/
		)
		document.forms[0].wl_crypto.disabled = 0;
	else		
		document.forms[0].wl_crypto.disabled = 1;

	/* enable re-auth interval */
	if (mode == "radius" || wpa == "enabled"
/*
#ifdef BCMWPA2
*/
		|| wpa2 == "enabled"
/*
#endif
*/
		)
		document.forms[0].wl_net_reauth.disabled = 0;
	else 
		document.forms[0].wl_net_reauth.disabled = 1;

/*
#ifdef BCMWPA2
*/
		if (wpa2 == "enabled")
			document.forms[0].wl_preauth.disabled = 0;
		else 
			document.forms[0].wl_preauth.disabled = 1;

		if ((wpa2 == "enabled") || (psk2 == "enabled") || (brcm_psk == "enabled")) {
			document.forms[0].wl_wep.selectedIndex = 1;
			document.forms[0].wl_wep.disabled = 1;
		} else {
			document.forms[0].wl_wep.disabled = 0;
		}

/*
#endif
*/
	wl_key_update();
}


function wl_wep_change()
{
	wl_key_update();
/*
*/
	//if (document.forms[0].wl_wsc_mode.value == "enabled") {
	//	document.forms[0].wl_wsc_reg.value = "enabled";
	//	document.forms[0].wsc_config_state.value = "Configed";
	//}
/*
*/
}

/*
*/
function wl_psk_onchange()
{
	//if (document.forms[0].wl_wsc_mode.value == "enabled") {
	//	document.forms[0].wl_wsc_reg.value = "enabled";
	//	document.forms[0].wsc_config_state.value = "enabled";
	//}
}
/*
*/

function wl_security_update()
{
	var i, cur, algos;
	var wl_ure = <% wl_ure_enabled(); %>;
	var wl_ibss = <% wl_ibss_mode(); %>;

	/* Save current crypto algorithm */
	for (i = 0; i < document.forms[0].wl_crypto.length; i++) {
		if (document.forms[0].wl_crypto[i].selected) {
			cur = document.forms[0].wl_crypto[i].value;
			break;
		}
	}

	/* Define new crypto algorithms */
	if (<% wl_corerev(); %> >= 3) {
		if (wl_ibss == "1") 
			algos = new Array("AES");
		else
			algos = new Array("TKIP", "AES", "TKIP+AES");
	} else {
		if (wl_ibss == "0") 
			algos = new Array("TKIP");
		else
			algos = new Array("");
	}

	/* Reconstruct algorithm array from new crypto algorithms */
	document.forms[0].wl_crypto.length = algos.length;
	for (var i in algos) {
		document.forms[0].wl_crypto[i] = new Option(algos[i], algos[i].toLowerCase());
		document.forms[0].wl_crypto[i].value = algos[i].toLowerCase();
		if (document.forms[0].wl_crypto[i].value == cur)
			document.forms[0].wl_crypto[i].selected = true;
	}

	wl_auth_change();
	wl_auth_mode_change();
	wl_akm_change();
	wl_wep_change();
/*
*/
 	wl_wps_change();	
/*
*/

	if ((wl_ure == "1") || (wl_ibss == "1")) {
		document.forms[0].wl_auth_mode.disabled = 1;
  	}
	else {
		document.forms[0].wl_auth_mode.disabled = 0;
  	}

}

function wpapsk_window() 
{
	var psk_window = window.open("", "", "toolbar=no,scrollbars=yes,width=400,height=100");
	psk_window.document.write("The WPA passphrase is <% nvram_get("wl_wpa_psk"); %>");
	psk_window.document.close();
}
//-->
</script>
</head>

<body onLoad="wl_security_update();">
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
	<span class="title">SECURITY</span><br>
	<span class="subtitle">This page allows you to configure
	security for the wireless LAN interfaces.</span>
    </td>
  </tr>
</table>

<form method="post" action="security.asp">
<input type="hidden" name="page" value="security.asp">

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects which wireless interface to configure.', LEFT);"
	onMouseOut="return nd();">
	Wireless Interface:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_unit" onChange="submit();">
	  <% wl_list("INCLUDE_SSID" , "INCLUDE_VIFS"); %>
	</select>
    </td>
    <td>
	<button type="submit" name="action" value="Select">Select</button>
    </td>
  </tr>
</table>

<p>
<!--
-->
<% wsc_display(); %>
<!--
-->

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects 802.11 authentication method. Open or Shared.', LEFT);"
	onMouseOut="return nd();">
	802.11 Authentication:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_auth" onChange="wl_auth_change();">
	  <option value="1" <% nvram_match("wl_auth", "1", "selected"); %>>Shared</option>
	  <option value="0" <% nvram_invmatch("wl_auth", "1", "selected"); %>>Open</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects Network authentication type.', LEFT);"
	onMouseOut="return nd();">
	802.1X Authentication:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_auth_mode" onChange="wl_auth_mode_change();">
	  <option value="radius" <% nvram_match("wl_auth_mode", "radius", "selected"); %>>Enabled</option>
	  <option value="none" <% nvram_invmatch("wl_auth_mode", "radius", "selected"); %>>Disabled</option>
 	</select>
    </td>
  </tr>
  <tr>	
    <th width="310"
	onMouseOver="return overlib('Enables/Disables WPA Authenticated Key Management suite.', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_akm" value="">
	WPA:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_akm_wpa" onChange="wl_akm_change();">
	  <option value="enabled" <% nvram_inlist("wl_akm", "wpa", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invinlist("wl_akm", "wpa", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables/Disables WPA-PSK Authenticated Key Management suite.', LEFT);"
	onMouseOut="return nd();">
	WPA-PSK:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_akm_psk" onChange="wl_akm_change();">
	  <option value="enabled" <% nvram_inlist("wl_akm", "psk", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invinlist("wl_akm", "psk", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
<!--
#ifdef BCMWPA2
-->	
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables/Disables WPA2 Authenticated Key Management suite.', LEFT);"
	onMouseOut="return nd();">
	WPA2:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_akm_wpa2" onChange="wl_akm_change();">
	  <option value="enabled" <% nvram_inlist("wl_akm", "wpa2", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invinlist("wl_akm", "wpa2", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables/Disables WPA2-PSK Authenticated Key Management suite.', LEFT);"
	onMouseOut="return nd();">
	WPA2-PSK:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_akm_psk2" onChange="wl_akm_change();">
	  <option value="enabled" <% nvram_inlist("wl_akm", "psk2", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invinlist("wl_akm", "psk2", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables/Disables BRCM-PSK Authenticated Key Management suite.', LEFT);"
	onMouseOut="return nd();">
	BRCM-PSK:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_akm_brcm_psk" onChange="wl_akm_change();">
	  <option value="enabled" <% nvram_inlist("wl_akm", "brcm_psk", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invinlist("wl_akm", "brcm_psk", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310">WPA2 Preauthentication:&nbsp;&nbsp;</th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_preauth">
	  <option value="disabled" <% nvram_match("wl_preauth", "0", "selected"); %>>Disabled</option>
	  <option value="enabled" <% nvram_invmatch("wl_preauth", "0", "selected"); %>>Enabled</option>
 	</select>
    </td>
  </tr>
<!--
#endif
-->	
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables or disables WEP data encryption. Selecting <b>Enabled</b> enables WEP data encryption and requires that a valid network key be set and selected unless <b>802.1X</b> is enabled.', LEFT);"
	onMouseOut="return nd();">
	WEP Encryption:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_wep" onChange="wl_wep_change();">
	  <option value="enabled" <% nvram_match("wl_wep", "enabled", "selected"); %>>Enabled</option>
	  <option value="disabled" <% nvram_invmatch("wl_wep", "enabled", "selected"); %>>Disabled</option>
 	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects the WPA data encryption algorithm.', LEFT);"
	onMouseOut="return nd();">
	WPA Encryption:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_crypto">
	  <option value="tkip" <% nvram_match("wl_crypto", "tkip", "selected"); %>>TKIP</option>
	  <option value="aes" <% nvram_match("wl_crypto", "aes", "selected"); %>>AES</option>
	  <option value="tkip+aes" <% nvram_match("wl_crypto", "tkip+aes", "selected"); %>>TKIP+AES</option>
 	</select>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the IP address of the RADIUS server to use for authentication and dynamic key derivation.', LEFT);"
	onMouseOut="return nd();">
	RADIUS Server:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_radius_ipaddr" value="<% nvram_get("wl_radius_ipaddr"); %>" size="15" maxlength="15"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the UDP port number of the RADIUS server. The port number is usually 1812 or 1645 and depends upon the server.', LEFT);"
	onMouseOut="return nd();">
	RADIUS Port:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_radius_port" value="<% nvram_get("wl_radius_port"); %>" size="5" maxlength="5"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the shared secret for the RADIUS connection.', LEFT);"
	onMouseOut="return nd();">
	RADIUS Key:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_radius_key" value="<% nvram_get("wl_radius_key"); %>" type="password"></td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the WPA passphrase.', LEFT);"
	onMouseOut="return nd();">
	WPA passphrase:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wpa_psk" value="<% nvram_get("wl_wpa_psk"); %>" type="password" onChange="wl_psk_onchange();" ></td>
    <td>&nbsp;&nbsp;</td>
    <td> <A HREF="javascript:wpapsk_window()">Click here to display</A></td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enter 5 ASCII characters or 10 hexadecimal digits for a 64-bit key. Enter 13 ASCII characters or 26 hexadecimal digits for a 128-bit key.', LEFT);"
	onMouseOut="return nd();">
	Network Key 1:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_key1" value="<% nvram_get("wl_key1"); %>" size="26" maxlength="26" type="password"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enter 5 ASCII characters or 10 hexadecimal digits for a 64-bit key. Enter 13 ASCII characters or 26 hexadecimal digits for a 128-bit key.', LEFT);"
	onMouseOut="return nd();">
	Network Key 2:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_key2" value="<% nvram_get("wl_key2"); %>" size="26" maxlength="26" type="password"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enter 5 ASCII characters or 10 hexadecimal digits for a 64-bit key. Enter 13 ASCII characters or 26 hexadecimal digits for a 128-bit key.', LEFT);"
	onMouseOut="return nd();">
	Network Key 3:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_key3" value="<% nvram_get("wl_key3"); %>" size="26" maxlength="26" type="password"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enter 5 ASCII characters or 10 hexadecimal digits for a 64-bit key. Enter 13 ASCII characters or 26 hexadecimal digits for a 128-bit key.', LEFT);"
	onMouseOut="return nd();">
	Network Key 4:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_key4" value="<% nvram_get("wl_key4"); %>" size="26" maxlength="26" type="password"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects which network key is used for encrypting outbound data and/or authenticating clients.', LEFT);"
	onMouseOut="return nd();">
	Current Network Key:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_key">
	  <option value="1" <% nvram_match("wl_key", "1", "selected"); %>>1</option>
	  <option value="2" <% nvram_match("wl_key", "2", "selected"); %>>2</option>
	  <option value="3" <% nvram_match("wl_key", "3", "selected"); %>>3</option>
	  <option value="4" <% nvram_match("wl_key", "4", "selected"); %>>4</option>
	</select>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the Network Key Rotation interval in seconds. Leave blank or set to zero to disable the rotation.', LEFT);"
	onMouseOut="return nd();">
	Network Key Rotation Interval:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wpa_gtk_rekey" value="<% nvram_get("wl_wpa_gtk_rekey"); %>" size="10" maxlength="10"></td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the Network Re-authentication interval in seconds. Leave blank or set to zero to disable periodic network re-authentication.', LEFT);"
	onMouseOut="return nd();">
	Network Re-auth Interval:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_net_reauth" value="<% nvram_get("wl_net_reauth"); %>" size="10" maxlength="10"></td>
  </tr>
</table>

<!--
-->	

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

<p class="label">&#169;2001-2007 Broadcom Corporation. All rights reserved. 54g is a trademark of Broadcom Corporation.</p>

</body>
</html>
