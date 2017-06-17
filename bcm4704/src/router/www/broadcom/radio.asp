<!--
Copyright 2007, Broadcom Corporation
All Rights Reserved.

THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
$ID$-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<title>Broadcom Home Gateway Reference Design: Radio</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="style.css" media="screen">
<script language="JavaScript" type="text/javascript" src="overlib.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
function wl_basic_rateset_change()
{
	var phytype = document.forms[0].wl_phytype[document.forms[0].wl_phytype.selectedIndex].value;
	var i, cur, defrs;
	
	/* Define new rateset */
	if (phytype == "a")
		defrs = new Array("Default", "All");
	else
		defrs = new Array("Default", "All", "12");

	/* Save current rateset */
	for (i = 0; i < document.forms[0].wl_rateset.length; i++) {
		if (document.forms[0].wl_rateset[i].selected) {
			cur = document.forms[0].wl_rateset[i].value;
			break;
		}
	}

	/* Reconstruct rateset array from new rateset */
	document.forms[0].wl_rateset.length = defrs.length;
	for (var i in defrs) {
		if (defrs[i].toLowerCase() == "12")
			document.forms[0].wl_rateset[i] = new Option("1 & 2 Mbps", defrs[i].toLowerCase());
		else
			document.forms[0].wl_rateset[i] = new Option(defrs[i], defrs[i].toLowerCase());
		document.forms[0].wl_rateset[i].value = defrs[i].toLowerCase();
		if (defrs[i].toLowerCase() == cur)
			document.forms[0].wl_rateset[i].selected = true;
	}
}

function wl_rate_change()
{
 	var nphy_set = "<% wl_nphy_set(); %>";
	var phytype;
	var gmode = document.forms[0].wl_gmode[document.forms[0].wl_gmode.selectedIndex].value;
	var country = document.forms[0].wl_country_code[document.forms[0].wl_country_code.selectedIndex].value;
	var channel = document.forms[0].wl_channel[document.forms[0].wl_channel.selectedIndex].value;
	var band;
	var i, cur, mcur, rates, rate;
	var radioid;
	var nmode;

	if (nphy_set == "1") {
		phytype = "n";
		band = document.forms[0].wl_nband[document.forms[0].wl_nband.selectedIndex].value;
		nmode = document.forms[0].wl_nmode[document.forms[0].wl_nmode.selectedIndex].value;
	} else {
		phytype =  document.forms[0].wl_phytype[document.forms[0].wl_phytype.selectedIndex].value;
		nmode = "0";
	}
	/* Save current rate */
	for (i = 0; i < document.forms[0].wl_rate.length; i++) {
		if (document.forms[0].wl_rate[i].selected) {
			cur = document.forms[0].wl_rate[i].value;
			break;
		}
	}

	/* Save current mcast rate */
	for (i = 0; i < document.forms[0].wl_mrate.length; i++) {
		if (document.forms[0].wl_mrate[i].selected) {
			mcur = document.forms[0].wl_mrate[i].value;
			break;
		}
	}

	/* Define new rates */
	if (phytype == "b") {
		radioid = "<% wl_radioid("b"); %>";
		if (radioid != "BCM2050" && country == "JP" && channel == 14)
			rates = new Array(0, 1, 2);
		else
			rates = new Array(0, 1, 2, 5.5, 11);
	} else if (phytype == "g") {
		/* Japan does not allow OFDM rates on channel 14 */
		if ((country == "JP" && channel == "14") || gmode == "0")
			rates = new Array(0, 1, 2, 5.5, 11);
		else
			rates = new Array(0, 1, 2, 5.5, 6, 9, 11, 12, 18, 24, 36, 48, 54);
	} else if (phytype == "a") {
		rates = new Array(0, 6, 9, 12, 18, 24, 36, 48, 54);
	} else if (phytype == "n") {
		/* Exclude auto for unicast legacy rates */
		/* 5 Ghz */
		if (band == "1") {
			rates = new Array(6, 9, 12, 18, 24, 36, 48, 54);
		} else if (band == "2") {
			/* Japan does not allow OFDM rates on channel 14 */
			if (country == "JP" && channel == "14")
				rates = new Array(1, 2, 5.5, 11);
			else	
				rates = new Array(1, 2, 5.5, 6, 9, 11, 12, 18, 24, 36, 48, 54);
		}
		/* Add auto back if nmode is disabled */
		if (nmode == "0")
			rates.unshift(0);
		if (<% nvram_get("wl_rate"); %> == 0)
			cur = 0;
	} else
		return;

	/* Reconstruct rate array from new rates */
	document.forms[0].wl_rate.length = rates.length;
	for (var i in rates) {
		rate = rates[i] * 1000000;
		if (rates[i] == 0)
			document.forms[0].wl_rate[i] = new Option("Auto", rate);
		else
			document.forms[0].wl_rate[i] = new Option(rates[i] + " Mbps", rate);
		document.forms[0].wl_rate[i].value = rate;
		if (rate == cur)
			document.forms[0].wl_rate[i].selected = true;
	}

	/* Add auto for multicast. Unshift adds element to the beginning! */
	if (phytype == "n" && nmode != "0")
		rates.unshift(0);

	/* Reconstruct multicast rate array from new rates */
	document.forms[0].wl_mrate.length = rates.length;
	for (var i in rates) {
		rate = rates[i] * 1000000;
		if (rates[i] == 0)
			document.forms[0].wl_mrate[i] = new Option("Auto", rate);
		else
			document.forms[0].wl_mrate[i] = new Option(rates[i] + " Mbps", rate);
		document.forms[0].wl_mrate[i].value = rate;
		if (rate == mcur)
			document.forms[0].wl_mrate[i].selected = true;
	}
}

function wl_country_list_change(nphy_set)
{
	var phytype;
	var band;
	var cur = 0;
	var sel = 0;

	if (nphy_set == "1") {
		phytype = "n";
		band  = document.forms[0].wl_nband[document.forms[0].wl_nband.selectedIndex].value;
	} else
		phytype =  document.forms[0].wl_phytype[document.forms[0].wl_phytype.selectedIndex].value;

	/* Save current country */
	for (i = 0; i < document.forms[0].wl_country_code.length; i++) {
		if (document.forms[0].wl_country_code[i].selected) {
			cur = document.forms[0].wl_country_code[i].value;
			break;
		}
	}

	if (phytype == "a") {
		<% wl_country_list("a"); %>
	} else if (phytype == "n") {
		if (band == "1") {
			<% wl_country_list("n", 1); %>
		} else if (band == "2") {
			<% wl_country_list("n", 2); %>
		}
	} else {
		<% wl_country_list("b"); %>
	}

	/* Reconstruct country_code array from new countries */
	document.forms[0].wl_country_code.length = countries.length;
	for (var i in countries) {
		document.forms[0].wl_country_code[i].value = countries[i];
		if (countries[i] == cur) {
			document.forms[0].wl_country_code[i].selected = true;
			sel = 1;
		}
	}

	if (sel == 0)
		document.forms[0].wl_country_code[0].selected = true;
}

function wl_channel_list_change(nphy_set)
{
	var phytype;
	var band;
	var nbw_cap;
	var nctrlsb;
	var country = document.forms[0].wl_country_code[document.forms[0].wl_country_code.selectedIndex].value;
	var channels = new Array(0);
	var cur = 0;
	var sel = 0;

	if (nphy_set == "1") {
		phytype = "n";
		band  = document.forms[0].wl_nband[document.forms[0].wl_nband.selectedIndex].value;
		nctrlsb = document.forms[0].wl_nctrlsb[document.forms[0].wl_nctrlsb.selectedIndex].value;
		nbw_cap = document.forms[0].wl_nbw_cap[document.forms[0].wl_nbw_cap.selectedIndex].value;


	} else {
		phytype =  document.forms[0].wl_phytype[document.forms[0].wl_phytype.selectedIndex].value;
	}

	/* Save current channel */
	for (i = 0; i < document.forms[0].wl_channel.length; i++) {
		if (document.forms[0].wl_channel[i].selected) {
			cur = document.forms[0].wl_channel[i].value;
			break;
		}
	}

	if (phytype == "a") {
		<% wl_channel_list("a"); %>
	} else if (phytype == "n") {
		/* 5 Ghz == a */
		if (band == "1") {
			var nsb = document.forms[0].wl_nctrlsb[document.forms[0].wl_nctrlsb.selectedIndex].value;
			if ((nbw_cap == "1") || (nbw_cap == "2")) {
				if (nsb == "upper") {
					<% wl_channel_list("n", 1, 40, "upper"); %>
				} else {
					<% wl_channel_list("n", 1, 40, "lower"); %>
				}
			} else if (nbw_cap == "0") {
				<% wl_channel_list("n", 1, 20); %>
			}
		} else if (band == "2")	 {
			var nsb = document.forms[0].wl_nctrlsb[document.forms[0].wl_nctrlsb.selectedIndex].value;
			if (nbw_cap == "1") {
				if (nsb == "upper") {
					<% wl_channel_list("n", 2, 40, "upper"); %>
				} else {
					<% wl_channel_list("n", 2, 40, "lower"); %>
				}
			} else if ((nbw_cap == "0") || (nbw_cap == "2")) {
				<% wl_channel_list("n", 2, 20); %>
			}
		}
	} else {
		<% wl_channel_list("b"); %>
	}

	/* Reconstruct channel array from new channels */
	document.forms[0].wl_channel.length = channels.length;
	for (var i in channels) {
		if (channels[i] == 0)
			document.forms[0].wl_channel[i] = new Option("Auto", channels[i]);
		else
			document.forms[0].wl_channel[i] = new Option(channels[i], channels[i]);
		document.forms[0].wl_channel[i].value = channels[i];
		if (channels[i] == cur) {
			document.forms[0].wl_channel[i].selected = true;
			sel = 1;
		}
	}

	if (sel == 0)
		document.forms[0].wl_channel[0].selected = true;
}

function wl_ewc_options(nphy_set)
{
	var bw;
	var nbw_cap;
	var band;
	var frameburst;
	var channel;
        var nmode;

	if (nphy_set == "0")
		return;

	channel = document.forms[0].wl_channel[document.forms[0].wl_channel.selectedIndex].value;

	if (channel == "0") {
		document.forms[0].wl_nctrlsb.disabled = 1;
		<% wl_nphyrates("0"); %>
		return;
	}

	document.forms[0].wl_channel.disabled = 0;
	if (document.forms[0].wl_nphyrate != null)
		document.forms[0].wl_nphyrate.disabled = 0;
	document.forms[0].wl_nctrlsb.disabled = 0;
	document.forms[0].wl_nbw_cap.disabled = 0;

	frameburst = document.forms[0].wl_frameburst[document.forms[0].wl_frameburst.selectedIndex].value;
/*
*/
	/* If nmode is disabled, allow only 20Mhz selection */
	nmode = document.forms[0].wl_nmode[document.forms[0].wl_nmode.selectedIndex].value;
        if (nmode == "0") {
		document.forms[0].wl_nbw_cap.selectedIndex = 0;
		document.forms[0].wl_nbw_cap.disabled = 1;
	}

	band = document.forms[0].wl_nband[document.forms[0].wl_nband.selectedIndex].value;
	nbw_cap = document.forms[0].wl_nbw_cap[document.forms[0].wl_nbw_cap.selectedIndex].value;

	if (((band == "1") && ((nbw_cap == "1") || (nbw_cap == "2"))) || 
	    ((band == "2") && (nbw_cap == "1"))) 
		bw = "40";
	else
		bw = "20";

	/* Control sb is allowed only for 40MHz BW Channels */	
	if (bw == "40") {
		document.forms[0].wl_nctrlsb.disabled = 0;
		<% wl_nphyrates("40"); %>
	} else if (bw == "20") {
		document.forms[0].wl_nctrlsb.selectedIndex = 0;
		document.forms[0].wl_nctrlsb.disabled = 1;
		<% wl_nphyrates("20"); %>
	}

	if (nmode == "0") {
		document.forms[0].wl_nreqd.disabled = 1;
		document.forms[0].wl_nmcsidx.disabled = 1;
		document.forms[0].wl_gmode.disabled = 0;
	} else {
		document.forms[0].wl_nreqd.disabled = 0;
		document.forms[0].wl_nmcsidx.disabled = 0;
		document.forms[0].wl_gmode.disabled = 1;
	}
}

function wl_phytype_change()
{
	var phytype = document.forms[0].wl_phytype[document.forms[0].wl_phytype.selectedIndex].value;
	var gmode = document.forms[0].wl_gmode[document.forms[0].wl_gmode.selectedIndex].value;

	if (phytype == "g") {
		document.forms[0].wl_gmode.disabled = 0;
		document.forms[0].wl_gmode_protection.disabled = 0;
	} else {
		document.forms[0].wl_gmode.disabled = 1;
	}

	if (phytype == "b" || (phytype == "g" && (gmode == "0" || gmode == "1")))
		document.forms[0].wl_plcphdr.disabled = 0;
	else
		document.forms[0].wl_plcphdr.disabled = 1;

	wl_basic_rateset_change();
}

function wl_mode_onchange()
{
	//The following variable is set when the user changes wl_mode
	document.forms[0].wl_mode_changed = 1;
	wl_mode_change();
}

function wl_mode_change()
{
	var mode = document.forms[0].wl_mode[document.forms[0].wl_mode.selectedIndex].value;
	var ure = document.forms[0].wl_ure[document.forms[0].wl_ure.selectedIndex].value;

	if (mode == "sta" || mode == "wet") {
		document.forms[0].wl_infra.disabled = 0;
/*
*/
		document.forms[0].wl_sta_retry_time.disabled = 0;
    // Provide an intelligent setting when URE or WL mode is changed
		if( document.forms[0].wl_mode_changed == 1 || 
				document.forms[0].wl_ure_changed == 1 ) {
			if( mode == "wet" ) //WET or RangeExtender
				document.forms[0].wl_sta_retry_time.value = 5;
			else if ( ure == "1" ) // Travel Router
				document.forms[0].wl_sta_retry_time.value = 300;
			else //STA
				document.forms[0].wl_sta_retry_time.value = 0;

			document.forms[0].wl_mode_changed = 0;
			document.forms[0].wl_ure_changed = 0;
		}
	}
	else {
		document.forms[0].wl_infra.disabled = 1;
/*
*/
		document.forms[0].wl_sta_retry_time.disabled = 1;
	}
}

function wl_ure_onchange()
{
	//The following variable is set when the user changes wl_ure
	document.forms[0].wl_ure_changed = 1;
	wl_ure_change();
}

function wl_ure_change()
{
	var mode = document.forms[0].wl_ure[document.forms[0].wl_ure.selectedIndex].value;
	var router_disable = "<% nvram_get("router_disable"); %>";

  if( mode == "1" ) {
		if (router_disable == "1") {
			document.forms[0].wl_mode.value = "wet";
		}
		else {
			document.forms[0].wl_mode.value = "sta";
		}
	  document.forms[0].wl_mode.disabled=1;
		document.forms[0].wl_infra.disabled = 0;
		document.forms[0].wl_lazywds.disabled = 0;
		document.forms[0].wl_wds0.disabled = 0;
		document.forms[0].wl_wds1.disabled = 0;
		document.forms[0].wl_wds2.disabled = 0;
		document.forms[0].wl_wds3.disabled = 0;
		document.forms[0].wl_wds_timeout.disabled = 0;
	}
	else {
	  document.forms[0].wl_mode.disabled=0;
	}
	wl_mode_change();
	document.forms[0].wl_ure_changed = 0;
}

function wl_gmode_options(nphy_set)
{
	var gmode = "<% nvram_get("wl_gmode"); %>";
	var index;

	if (nphy_set == "1")
		document.forms[0].wl_gmode.disabled = 1;
	else
		document.forms[0].wl_gmode.disabled = 0;

	if (gmode == "2") {
		index = document.forms[0].wl_gmode.length;
		document.forms[0].wl_gmode[index] = new Option("54g Only", "2");
		document.forms[0].wl_gmode[index].selected = true;
	}
}
function wl_afterburner_options(nphy_set)
{
	var afterburner = "<% wl_inlist("cap", "afterburner"); %>";
	var nmode = "0";
	var wme_val = document.forms[0].wl_wme[document.forms[0].wl_wme.selectedIndex].value;

	if (nphy_set == "1")
		nmode = document.forms[0].wl_nmode[document.forms[0].wl_nmode.selectedIndex].value;

	if ((nmode != "0") || (afterburner != "1") || (wme_val == "on"))
		document.forms[0].wl_afterburner.disabled = 1;
	else
		document.forms[0].wl_afterburner.disabled = 0;
}

function wl_amsdu_options(nphy_set)
{
	var amsdu;

        if (nphy_set == "0")
                return;

	amsdu = "<% wl_inlist("cap", "amsdu"); %>";
/*
*/
}

function wl_wme_options(nphy_set)
{
	var w_ind = document.forms[0].wl_wme.selectedIndex;
	var w_val = document.forms[0].wl_wme[w_ind].value;

	document.forms[0].wl_wme.disabled = 0;

	if (w_val == "off") {
		document.forms[0].wl_wme_no_ack.disabled = 1;
		document.forms[0].wl_wme_apsd.disabled = 1;
	} else {
		document.forms[0].wl_wme_no_ack.disabled = 0;
		document.forms[0].wl_wme_apsd.disabled = 0;
	}
}

function wl_ure_modes()
{
	var isap = "<% wl_inlist("cap", "ap"); %>";
	var issta = "<% wl_inlist("cap", "sta"); %>";

	if (isap != "1" || issta != "1") {
		document.forms[0].wl_ure[0].selected = 1;
		document.forms[0].wl_ure[1].disabled = 1;
	} else {
		document.forms[0].wl_ure[1].disabled = 0;
	}
}

function wl_mcs_onchange()
{
 	var nphy_set = "<% wl_nphy_set(); %>";
	var mcs_val;
	var nmode;
	if (nphy_set == "0")
		return;
	mcs_val =  document.forms[0].wl_nmcsidx[document.forms[0].wl_nmcsidx.selectedIndex].value;
	nmode = document.forms[0].wl_nmode[document.forms[0].wl_nmode.selectedIndex].value;

	/* If using 'legacy rate' then enable */
	if (mcs_val == "-2" || nmode == "0")
		document.forms[0].wl_rate.disabled = 0;
	else
		document.forms[0].wl_rate.disabled = 1;
}

function wl_recalc()
{
 	var nphy_set = "<% wl_nphy_set(); %>";

	if (nphy_set != "1")
		wl_phytype_change();
	wl_country_list_change(nphy_set);
	wl_channel_list_change(nphy_set);
	wl_mode_change();
	wl_gmode_options(nphy_set);
	wl_rate_change();
	wl_afterburner_options(nphy_set);
	wl_ewc_options(nphy_set);
	wl_amsdu_options(nphy_set);
	wl_wme_options(nphy_set);
	wl_ure_change();
	wl_ure_modes();
	wl_mcs_onchange(); /* This has to be after wl_ewc_options */
}

//-->
</script>
</head>

<body onLoad="wl_recalc();">
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<input type=hidden name="wl_mode_changed" value=0>
<input type=hidden name="wl_ure_changed" value=0>

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
	<span class="title">Radio</span><br>
	<span class="subtitle">This page allows you to configure the Physical
	Wireless interfaces.</span>
    </td>
  </tr>
</table>

<form method="post" action="radio.asp">
<input type="hidden" name="page" value="radio.asp">


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
	  <% wl_list(); %>
	</select>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  
 <tr>
    <th width="310"
	onMouseOver="return overlib('Restricts the channel set based on country requirements.', LEFT);"
	onMouseOut="return nd();">
	Country:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_country_code" onChange="wl_recalc();">
	  <option value="<% wl_cur_country(); %>" selected></option>
	</select>
	&nbsp;&nbsp;Current: <% wl_cur_country(); %>
    </td>
    <td></td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enables or disables the wireless Interface.', LEFT);"
	onMouseOut="return nd();">
	Interface:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_radio">
	  <option value="0" <% nvram_match("wl_radio", "0", "selected"); %>>Disabled</option>
	  <option value="1" <% nvram_match("wl_radio", "1", "selected"); %>>Enabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects 802.11 mode to use.', LEFT);"
	onMouseOut="return nd();">
	802.11 Band:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name=<% wl_phytype_name(); %>  onChange="wl_recalc();">
	  <% wl_phytypes(); %>
	</select>
	&nbsp;&nbsp;<% wl_cur_phytype(); %>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects a particular channel on which to operate.', LEFT);"
	onMouseOut="return nd();">
	<% wl_control_string(); %> Channel:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_channel" onChange="wl_recalc();">
	  <option value="<% nvram_get("wl_channel"); %>" selected></option>
	</select>
	&nbsp;&nbsp;<% wl_cur_channel(); %>
    </td>
  </tr>
<% wl_nphy_comment_beg(); %>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable 802.11N support.', LEFT);"
	onMouseOut="return nd();">
	802.11 n-mode:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_nmode" onChange="wl_recalc();">
	  <option value="-1" <% nvram_match("wl_nmode", "-1", "selected"); %>>Auto </option>
	  <option value="0" <% nvram_match("wl_nmode", "0", "selected"); %>>Off </option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects Channel Bandwidth', LEFT);"
	onMouseOut="return nd();">
	Bandwidth:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_nbw_cap" onChange="wl_recalc();">
	  <option value="0" <% nvram_match("wl_nbw_cap", "0", "selected"); %>>20 MHz in Both Bands</option>
	  <option value="1" <% nvram_match("wl_nbw_cap", "1", "selected"); %>>40 MHz in Both Bands</option>
	  <option value="2" <% nvram_match("wl_nbw_cap", "2", "selected"); %>>20MHz in 2.4G Band and 40MHz in 5G Band</option>
	</select>
	&nbsp;&nbsp;<% wl_cur_nbw(); %>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Specify sideband position for Control channel for 40Mhz BW', LEFT);"
	onMouseOut="return nd();">
	Sideband for Control Channel (40Mhz only):&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_nctrlsb" onChange="wl_recalc();">
	  <option value="lower" <% nvram_match("wl_nctrlsb", "lower", "selected"); %>>Lower </option>
	  <option value="upper" <% nvram_match("wl_nctrlsb", "upper", "selected"); %>>Upper </option>
	</select>
	&nbsp;&nbsp;<% wl_cur_nctrlsb(); %>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Select NPHY Rate (MCS Index)', LEFT);"
	onMouseOut="return nd();">
	NPHY Rate:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_nmcsidx" onChange="wl_mcs_onchange();">
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Select number of transmit streams to use', LEFT);"
	onMouseOut="return nd();">
	NPHY TxStreams:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_txstreams" onChange="wl_recalc();">
<% wl_txstreams_list();%>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Select number of receive streams to support', LEFT);"
	onMouseOut="return nd();">
	NPHY RxStreams:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_rxstreams";">
<% wl_rxstreams_list();%>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Require 802.11N support for clients trying to associate to this AP.', LEFT);"
	onMouseOut="return nd();">
	802.11n Support Required:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_nreqd">
	  <option value="1" <% nvram_match("wl_nreqd", "1", "selected"); %>>On </option>
	  <option value="0" <% nvram_match("wl_nreqd", "0", "selected"); %>>Off </option>
	</select>
    </td>
  </tr>
<% wl_nphy_comment_end(); %>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Set the mode to 54g Auto for the widest compatibility. Set the mode to 54g Performance for the fastest performance among 54g certified equipment. Set the mode to 54g LRS if you are experiencing difficulty with legacy 802.11b equipment.', LEFT);"
	onMouseOut="return nd();">
	54g&#8482; Mode:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_gmode" onChange="wl_recalc();">
	  <option value="1" <% nvram_match("wl_gmode", "1", "selected"); %>>54g Auto</option>
	  <option value="4" <% nvram_match("wl_gmode", "4", "selected"); %>>54g Performance</option>
	  <option value="5" <% nvram_match("wl_gmode", "5", "selected"); %>>54g LRS</option>
	  <option value="0" <% nvram_match("wl_gmode", "0", "selected"); %>>802.11b Only</option>
	</select>
    </td>
  </tr>
  <tr>
	<% wl_protection(); %>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Advertise packet priority using VLAN tag.', LEFT);"
	onMouseOut="return nd();">
	VLAN Priority Support:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_vlan_prio_mode">
	  <option value="off" <% nvram_match("wl_vlan_prio_mode", "off", "selected"); %>>Off </option>
	  <option value="on" <% nvram_match("wl_vlan_prio_mode", "on", "selected"); %>>On </option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Forces the transmission rate for the AP to a particular speed.', LEFT);"
	onMouseOut="return nd();">
	<% wl_legacy_string(); %> Rate:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_rate">
	  <!-- All a/b/g rates -->
	  <option value="0" <% nvram_match("wl_rate", "0", "selected"); %>>Auto</option>
	  <option value="1000000" <% nvram_match("wl_rate", "1000000", "selected"); %>>1 Mbps</option>
	  <option value="2000000" <% nvram_match("wl_rate", "2000000", "selected"); %>>2 Mbps</option>
	  <option value="5500000" <% nvram_match("wl_rate", "5500000", "selected"); %>>5.5 Mbps</option>
	  <option value="6000000" <% nvram_match("wl_rate", "6000000", "selected"); %>>6 Mbps</option>
	  <option value="9000000" <% nvram_match("wl_rate", "9000000", "selected"); %>>9 Mbps</option>
	  <option value="11000000" <% nvram_match("wl_rate", "11000000", "selected"); %>>11 Mbps</option>      
	  <option value="12000000" <% nvram_match("wl_rate", "12000000", "selected"); %>>12 Mbps</option>
	  <option value="18000000" <% nvram_match("wl_rate", "18000000", "selected"); %>>18 Mbps</option>
	  <option value="24000000" <% nvram_match("wl_rate", "24000000", "selected"); %>>24 Mbps</option>
	  <option value="36000000" <% nvram_match("wl_rate", "36000000", "selected"); %>>36 Mbps</option>
	  <option value="48000000" <% nvram_match("wl_rate", "48000000", "selected"); %>>48 Mbps</option>
	  <option value="54000000" <% nvram_match("wl_rate", "54000000", "selected"); %>>54 Mbps</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects the basic rates that wireless clients must support.', LEFT);"
	onMouseOut="return nd();">
	Basic Rate Set:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_rateset">
	  <option value="default" <% nvram_match("wl_rateset", "default", "selected"); %>>Default</option>
	  <option value="all" <% nvram_match("wl_rateset", "all", "selected"); %>>All</option>
	  <option value="12" <% nvram_match("wl_rateset", "12", "selected"); %>>1 & 2 Mbps</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Forces the multicast/broadcast transmission rate for the AP to a particular speed.', LEFT);"
	onMouseOut="return nd();">
	Multicast Rate:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_mrate">
	  <!-- All a/b/g rates -->
	  <option value="0" <% nvram_match("wl_mrate", "0", "selected"); %>>Auto</option>
	  <option value="1000000" <% nvram_match("wl_mrate", "1000000", "selected"); %>>1 Mbps</option>
	  <option value="2000000" <% nvram_match("wl_mrate", "2000000", "selected"); %>>2 Mbps</option>
	  <option value="5500000" <% nvram_match("wl_mrate", "5500000", "selected"); %>>5.5 Mbps</option>
	  <option value="6000000" <% nvram_match("wl_mrate", "6000000", "selected"); %>>6 Mbps</option>
	  <option value="9000000" <% nvram_match("wl_mrate", "9000000", "selected"); %>>9 Mbps</option>
	  <option value="11000000" <% nvram_match("wl_mrate", "11000000", "selected"); %>>11 Mbps</option>      
	  <option value="12000000" <% nvram_match("wl_mrate", "12000000", "selected"); %>>12 Mbps</option>
	  <option value="18000000" <% nvram_match("wl_mrate", "18000000", "selected"); %>>18 Mbps</option>
	  <option value="24000000" <% nvram_match("wl_mrate", "24000000", "selected"); %>>24 Mbps</option>
	  <option value="36000000" <% nvram_match("wl_mrate", "36000000", "selected"); %>>36 Mbps</option>
	  <option value="48000000" <% nvram_match("wl_mrate", "48000000", "selected"); %>>48 Mbps</option>
	  <option value="54000000" <% nvram_match("wl_mrate", "54000000", "selected"); %>>54 Mbps</option>
	</select>
    </td>
  </tr>
<!--
-->	
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selects a regulatory mode to use.', LEFT);"
	onMouseOut="return nd();">
	Regulatory Mode:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_reg_mode" onChange="wl_recalc();">
	  <option value="off" <% nvram_match("wl_reg_mode", "off", "selected"); %>>Off</option>
	  <option value="h" <% nvram_match("wl_reg_mode", "h", "selected"); %>>802.11H</option>
	  <option value="d" <% nvram_match("wl_reg_mode", "d", "selected"); %>>802.11D</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Number of seconds to check for radar on a channel before establishing a network. Current specs specify 60 seconds.  0 disables checking. Range 0-99. Used for 11H only', LEFT);"
	onMouseOut="return nd();">
	Pre-Network Radar Check:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<input name="wl_dfs_preism" value="<% nvram_get("wl_dfs_preism"); %>" size="2" maxlength="2">
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Number of seconds to check for radar when switching to a new channel after network has been established. Current specs specify 60 seconds.  Cannot be disabled. Range 10-99. Used for 11H only', LEFT);"
	onMouseOut="return nd();">
	In-Network Radar Check:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<input name="wl_dfs_postism" value="<% nvram_get("wl_dfs_postism"); %>" size="2" maxlength="2">
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Power Mitigation factor (in db)', LEFT);"
	onMouseOut="return nd();">
	TPC Mitigation (db):&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_tpc_db">
	  <option value="0" <% nvram_match("wl_tpc_db", "off", "selected"); %>>0 (Off)</option>
	  <option value="2" <% nvram_match("wl_tpc_db", "2", "selected"); %>>2</option>
	  <option value="3" <% nvram_match("wl_tpc_db", "3", "selected"); %>>3</option>
	  <option value="4" <% nvram_match("wl_tpc_db", "4", "selected"); %>>4</option>
	</select>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the fragmentation threshold.', LEFT);"
	onMouseOut="return nd();">
	Fragmentation Threshold:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_frag" value="<% nvram_get("wl_frag"); %>" size="4" maxlength="4"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the RTS threshold.', LEFT);"
	onMouseOut="return nd();">
	RTS Threshold:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_rts" value="<% nvram_get("wl_rts"); %>" size="4" maxlength="4"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the wakeup interval for clients in power-save mode.', LEFT);"
	onMouseOut="return nd();">
	DTIM Interval:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_dtim" value="<% nvram_get("wl_dtim"); %>" size="4" maxlength="4"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the beacon interval for the AP.', LEFT);"
	onMouseOut="return nd();">
	Beacon Interval:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_bcn" value="<% nvram_get("wl_bcn"); %>" size="4" maxlength="4"></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets whether short or long preambles are used. Short preambles improve throughput but all clients in the wireless network must support this capability if selected.', LEFT);"
	onMouseOut="return nd();">
	Preamble Type:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_plcphdr">
	  <option value="long" <% nvram_match("wl_plcphdr", "long", "selected"); %>>Long</option>
	  <option value="short" <% nvram_match("wl_plcphdr", "short", "selected"); %>>Short</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets the Associations the Driver Should Accept.', LEFT);"
	onMouseOut="return nd();">
	Max Associations Limit:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_maxassoc" value="<% nvram_get("wl_maxassoc"); %>" size="4" maxlength="4"></td>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable XPress mode', LEFT);"
	onMouseOut="return nd();">
	XPress&#8482; Technology:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_frameburst" onChange="wl_recalc();">
	  <option value="off" <% nvram_match("wl_frameburst", "off", "selected"); %>>Off</option>
	  <option value="on" <% nvram_match("wl_frameburst", "on", "selected"); %>>On</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable AfterBurner mode.  Fragmentation must be disabled (has value 2346) when AfterBurner mode is enabled', LEFT);"
	onMouseOut="return nd();">
	AfterBurner Technology:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_afterburner" onChange="wl_recalc();">
	  <option value="off" <% nvram_match("wl_afterburner", "off", "selected"); %>>Off</option>
	  <option value="auto" <% nvram_match("wl_afterburner", "auto", "selected"); %>>On</option>
	</select>
    </td>
  </tr>
  
</table>

<!--
-->	
  

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable WMM support', LEFT);"
	onMouseOut="return nd();">
	WMM Support:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_wme" onChange="wl_recalc();">
	  <option value="auto" <% nvram_match("wl_wme", "auto", "selected"); %>>Auto</option>
	  <option value="off" <% nvram_match("wl_wme", "off", "selected"); %>>Off</option>
	  <option value="on" <% nvram_match("wl_wme", "on", "selected"); %>>On</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable WMM No-Acknowledgment', LEFT);"
	onMouseOut="return nd();">
	No-Acknowledgement:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_wme_no_ack">
	  <option value="off" <% nvram_match("wl_wme_no_ack", "off", "selected"); %>>Off</option>
	  <option value="on" <% nvram_match("wl_wme_no_ack", "on", "selected"); %>>On</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Enable/Disable Automatic Power Save Delivery', LEFT);"
	onMouseOut="return nd();">
	APSD Support:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_wme_apsd">
	  <option value="off" <% nvram_match("wl_wme_apsd", "off", "selected"); %>>Off</option>
	  <option value="on" <% nvram_match("wl_wme_apsd", "on", "selected"); %>>On</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('WMM EDCA Parameters for AP.  CW value should be one less than a power of 2.  TXOP value should be a multiple of 32.', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wme_ap" value="8">
	EDCA AP Parameters:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td class="label">CWmin</td>
    <td class="label">CWmax</td>
    <td class="label">AIFSN</td>
    <td class="label">TXOP(b)<br>Limit (usec)</td>
    <td class="label">TXOP(a/g)<br>Limit (usec)</td>
    <td class="label">Admission<br>Control</td>
    <td class="label">Discard<br>Oldest First</td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AP AC_BE parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_ap_be" value="5">
	AC_BE&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_ap_be0" value="<% nvram_list("wl_wme_ap_be", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_be1" value="<% nvram_list("wl_wme_ap_be", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_be2" value="<% nvram_list("wl_wme_ap_be", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_be3" value="<% nvram_list("wl_wme_ap_be", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_be4" value="<% nvram_list("wl_wme_ap_be", 4); %>" size="6" maxlength="6"></td>
	<td>
          <select name="wl_wme_ap_be5">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_be", 5, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_be", 5, "on", "selected"); %>>On</option>
	  </select>
	</td>
	<td>
          <select name="wl_wme_ap_be6">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_be", 6, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_be", 6, "on", "selected"); %>>On</option>
	  </select>
	</td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AP AC_BK parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_ap_bk" value="5">
	AC_BK&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_ap_bk0" value="<% nvram_list("wl_wme_ap_bk", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_bk1" value="<% nvram_list("wl_wme_ap_bk", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_bk2" value="<% nvram_list("wl_wme_ap_bk", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_bk3" value="<% nvram_list("wl_wme_ap_bk", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_bk4" value="<% nvram_list("wl_wme_ap_bk", 4); %>" size="6" maxlength="6"></td>
	<td>
          <select name="wl_wme_ap_bk5">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_bk", 5, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_bk", 5, "on", "selected"); %>>On</option>
	  </select>
	</td>
	<td>
          <select name="wl_wme_ap_bk6">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_bk", 6, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_bk", 6, "on", "selected"); %>>On</option>
	  </select>
	</td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AP AC_VI parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_ap_vi" value="5">
	AC_VI&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_ap_vi0" value="<% nvram_list("wl_wme_ap_vi", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vi1" value="<% nvram_list("wl_wme_ap_vi", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vi2" value="<% nvram_list("wl_wme_ap_vi", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vi3" value="<% nvram_list("wl_wme_ap_vi", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vi4" value="<% nvram_list("wl_wme_ap_vi", 4); %>" size="6" maxlength="6"></td>
	<td>
          <select name="wl_wme_ap_vi5">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_vi", 5, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_vi", 5, "on", "selected"); %>>On</option>
	  </select>
	</td>
	<td>
          <select name="wl_wme_ap_vi6">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_vi", 6, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_vi", 6, "on", "selected"); %>>On</option>
	  </select>
	</td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AP AC_VO parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_ap_vo" value="5">
	AC_VO&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_ap_vo0" value="<% nvram_list("wl_wme_ap_vo", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vo1" value="<% nvram_list("wl_wme_ap_vo", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vo2" value="<% nvram_list("wl_wme_ap_vo", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vo3" value="<% nvram_list("wl_wme_ap_vo", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_ap_vo4" value="<% nvram_list("wl_wme_ap_vo", 4); %>" size="6" maxlength="6"></td>
	<td>
          <select name="wl_wme_ap_vo5">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_vo", 5, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_vo", 5, "on", "selected"); %>>On</option>
	  </select>
	</td>
	<td>
          <select name="wl_wme_ap_vo6">
	    <option value="off" <% nvram_indexmatch("wl_wme_ap_vo", 6, "off", "selected"); %>>Off</option>
	    <option value="on" <% nvram_indexmatch("wl_wme_ap_vo", 6, "on", "selected"); %>>On</option>
	  </select>
	</td>
  </tr>
  <tr>
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('WMM EDCA Parameters for STA.  CW value should be one less than a power of two.  TXOP limit should be a multiple of 32.', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wme_sta" value="8">
	EDCA STA Parameters:&nbsp;&nbsp;
    </th>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('STA AC_BE parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_sta_be" value="5">
	AC_BE&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_sta_be0" value="<% nvram_list("wl_wme_sta_be", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_be1" value="<% nvram_list("wl_wme_sta_be", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_be2" value="<% nvram_list("wl_wme_sta_be", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_be3" value="<% nvram_list("wl_wme_sta_be", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_be4" value="<% nvram_list("wl_wme_sta_be", 4); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_be5" value="<% nvram_list("wl_wme_sta_be", 5); %>" type="hidden"></td>
	<td><input name="wl_wme_sta_be6" value="<% nvram_list("wl_wme_sta_be", 6); %>" type="hidden"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('STA AC_BK parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_sta_bk" value="5">
	AC_BK&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_sta_bk0" value="<% nvram_list("wl_wme_sta_bk", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_bk1" value="<% nvram_list("wl_wme_sta_bk", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_bk2" value="<% nvram_list("wl_wme_sta_bk", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_bk3" value="<% nvram_list("wl_wme_sta_bk", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_bk4" value="<% nvram_list("wl_wme_sta_bk", 4); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_bk5" value="<% nvram_list("wl_wme_sta_bk", 5); %>" type="hidden"></td>
	<td><input name="wl_wme_sta_bk6" value="<% nvram_list("wl_wme_sta_bk", 6); %>" type="hidden"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('STA AC_VI parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_sta_vi" value="5">
	AC_VI&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_sta_vi0" value="<% nvram_list("wl_wme_sta_vi", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vi1" value="<% nvram_list("wl_wme_sta_vi", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vi2" value="<% nvram_list("wl_wme_sta_vi", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vi3" value="<% nvram_list("wl_wme_sta_vi", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vi4" value="<% nvram_list("wl_wme_sta_vi", 4); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vi5" value="<% nvram_list("wl_wme_sta_vi", 5); %>" type="hidden"></td>
	<td><input name="wl_wme_sta_vi6" value="<% nvram_list("wl_wme_sta_vi", 6); %>" type="hidden"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('STA AC_VO parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_sta_vo" value="5">
	AC_VO&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_sta_vo0" value="<% nvram_list("wl_wme_sta_vo", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vo1" value="<% nvram_list("wl_wme_sta_vo", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vo2" value="<% nvram_list("wl_wme_sta_vo", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vo3" value="<% nvram_list("wl_wme_sta_vo", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vo4" value="<% nvram_list("wl_wme_sta_vo", 4); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_sta_vo5" value="<% nvram_list("wl_wme_sta_vo", 5); %>" type="hidden"></td>
	<td><input name="wl_wme_sta_vo6" value="<% nvram_list("wl_wme_sta_vo", 6); %>" type="hidden"></td>
  </tr>

  <tr>
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('WMM Tx retry limits, fallback limits and max rate parameters.', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wme_txp" value="8">
	WMM TX Parameters:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td class="label">Short Retry<br>Limit</td>
    <td class="label">Short Fallbk<br>Limit</td>
    <td class="label">Long Retry<br>Limit</td>
    <td class="label">Long Fallbk<br>Limit</td>
    <td class="label">Max Rate<br>In 500 kbps<br>Disabled when 0<br></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AC_BE Tx parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_txp_be" value="5">
	AC_BE&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_txp_be0" value="<% nvram_list("wl_wme_txp_be", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_be1" value="<% nvram_list("wl_wme_txp_be", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_be2" value="<% nvram_list("wl_wme_txp_be", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_be3" value="<% nvram_list("wl_wme_txp_be", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_be4" value="<% nvram_list("wl_wme_txp_be", 4); %>" size="6" maxlength="6"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AC_BK Tx parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_txp_bk" value="5">
	AC_BK&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_txp_bk0" value="<% nvram_list("wl_wme_txp_bk", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_bk1" value="<% nvram_list("wl_wme_txp_bk", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_bk2" value="<% nvram_list("wl_wme_txp_bk", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_bk3" value="<% nvram_list("wl_wme_txp_bk", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_bk4" value="<% nvram_list("wl_wme_txp_bk", 4); %>" size="6" maxlength="6"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AC_VI Tx parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_txp_vi" value="5">
	AC_VI&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_txp_vi0" value="<% nvram_list("wl_wme_txp_vi", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vi1" value="<% nvram_list("wl_wme_txp_vi", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vi2" value="<% nvram_list("wl_wme_txp_vi", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vi3" value="<% nvram_list("wl_wme_txp_vi", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vi4" value="<% nvram_list("wl_wme_txp_vi", 4); %>" size="6" maxlength="6"></td>
  </tr>
  <tr>	
    <th width="310" valign="top" rowspan="1"
	onMouseOver="return overlib('AC_VO Tx parameters', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wme_txp_vo" value="5">
	AC_VO&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
	<td><input name="wl_wme_txp_vo0" value="<% nvram_list("wl_wme_txp_vo", 0); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vo1" value="<% nvram_list("wl_wme_txp_vo", 1); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vo2" value="<% nvram_list("wl_wme_txp_vo", 2); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vo3" value="<% nvram_list("wl_wme_txp_vo", 3); %>" size="6" maxlength="6"></td>
	<td><input name="wl_wme_txp_vo4" value="<% nvram_list("wl_wme_txp_vo", 4); %>" size="6" maxlength="6"></td>
  </tr>

</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selecting <b>Wireless Bridge</b> disables access point functionality. Only wireless bridge (also known as Wireless Distribution System or WDS) functionality will be available. Selecting <b>Access Point</b> enables access point functionality. Wireless bridge functionality will still be available and wireless stations will be able to associate to the AP.', LEFT);"
	onMouseOut="return nd();">
	Mode:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_mode" onChange="wl_mode_onchange();">
	<% wl_mode_list();%>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Sets Network.', LEFT);"
	onMouseOut="return nd();">
	Network:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_infra">
	  <option value="1" <% nvram_match("wl_infra", "1", "selected"); %>>BSS</option>
	  <option value="0" <% nvram_match("wl_infra", "0", "selected"); %>>IBSS</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
	  onMouseOver="return overlib('Enable AP & Station functions for a single radio.  If the Router Mode (on the Basic page) is Router, then this makes the product into a Travel Router. If the Router Mode is AP, then this setting turns the product into a Range Extender.', LEFT);"
	onMouseOut="return nd();">
	URE Mode:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	   <select name="wl_ure" onChange="wl_ure_onchange();">
	    <option value="0" <% wl_ure_list(0); %> >OFF</option>
	    <option value="1" <% wl_ure_list(1); %> >ON</option>
	   </select>
    </td>
  </tr>
</table>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310"
	onMouseOver="return overlib('Controls the STA behavior for the first assocaiation.  This parameter sets the time to wait between attempts to associate with the Access Point for the initial association.  Setting this to 0 seconds will cause the STA to only attempt association once.  Once the initial association is successful, the STA will always attempt re-associations.', LEFT);"
	onMouseOut="return nd();">
	STA Retry Time(sec):&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	    <td><input name="wl_sta_retry_time" value="<% nvram_get("wl_sta_retry_time"); %>" size="4" maxlength="4"></td>
    </td>
  </tr>
</table>
</p>

<p>
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="310" valign="top" rowspan="5"
	onMouseOver="return overlib('Enter the peer wireless MAC addresses of any wireless bridges that should be part of the wireless distribution system (WDS).', LEFT);"
	onMouseOut="return nd();">
	<input type="hidden" name="wl_wds" value="4">
	Bridges:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td class="label">Peer MAC Address</td>
    <td>&nbsp;&nbsp;</td>
    <td class="label">Link Status</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wds0" value="<% nvram_list("wl_wds", 0); %>" size="17" maxlength="17"></td>
    <td>&nbsp;&nbsp;</td>
    <td><% wl_wds_status(0); %></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wds1" value="<% nvram_list("wl_wds", 1); %>" size="17" maxlength="17"></td>
    <td>&nbsp;&nbsp;</td>
    <td><% wl_wds_status(1); %></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wds2" value="<% nvram_list("wl_wds", 2); %>" size="17" maxlength="17"></td>
    <td>&nbsp;&nbsp;</td>
    <td><% wl_wds_status(2); %></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wds3" value="<% nvram_list("wl_wds", 3); %>" size="17" maxlength="17"></td>
    <td>&nbsp;&nbsp;</td>
    <td><% wl_wds_status(3); %></td>
  </tr>
  <tr>
    <th width="310"
	onMouseOver="return overlib('Selecting <b>Disabled</b> disables wireless bridge restriction. Any wireless bridge (including the ones listed in <b>Remote Bridges</b>) will be granted access. Selecting <b>Enabled</b> enables wireless bridge restriction. Only those bridges listed in <b>Remote Bridges</b> will be granted access.', LEFT);"
	onMouseOut="return nd();">
	Bridge Restriction:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td>
	<select name="wl_lazywds">
	  <option value="0" <% nvram_match("wl_lazywds", "0", "selected"); %>>Enabled</option>
	  <option value="1" <% nvram_match("wl_lazywds", "1", "selected"); %>>Disabled</option>
	</select>
    </td>
  </tr>
  <tr>
    <th width="310"
    onMouseOver="return overlib('Sets the Wireless bridge link detection interval in seconds. Leave blank or set to zero to disable the detection', LEFT);"
    onMouseOut="return nd();">
    Bridge Link Detection Interval:&nbsp;&nbsp;
    </th>
    <td>&nbsp;&nbsp;</td>
    <td><input name="wl_wds_timeout" value="<% nvram_get("wl_wds_timeout"); %>" size="10" maxlength="10"></td>
  </tr>
</table>
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

<p class="label">&#169;2001-2007 Broadcom Corporation. All rights
reserved. 54g and XPress are trademarks of Broadcom Corporation.</p>

</body>
</html>
