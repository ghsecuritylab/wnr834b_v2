/*
    Copyright 2007, Broadcom Corporation      
    All Rights Reserved.      
          
    THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY      
    KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM      
    SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS      
    FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.      

    This file was automatically generated by xml2c.pl
*/


#include "upnp_dbg.h"
#include "upnp_osl.h"
#include "upnp.h"

/* 

    Below you will find definitions for a number of Action structures.
    The second argument to those structures is a pointer to a function
    that implements that action.  Your job is to define all of the
    actions so that none of them is left unimplemented.

    As a convenience, all generated actions have been predefined to
    invoke the action 'NotImplemented', an action that will print an
    error message whenever it is invoked.  As you define functions for
    each action, be sure to remove that function name from the list of
    'NotImplemented' defines in the list below.
    
    The following are pre-defined action functions that you can use:

    NotImplemented - prints an error message on the console 
                     and returns 0 parameters to the caller.

    DefaultAction  - Returns all 'out' parameters with values
                     taken from the corresponding 'relatedStateVariable'.
                     This function actually covers the behavior of 
                     a surprisingly large number of UPnP actions.

*/

#define GetEthernetLinkStatus NotImplemented

#define VAR_EthernetLinkStatus		0

static char *EthernetLinkStatus_allowedValueList[] = { "Up", "Down", "Unavailable", NULL };

static VarTemplate StateVariables[] = {
    { "EthernetLinkStatus", "", VAR_EVENTED|VAR_STRING|VAR_LIST,  (allowedValue) { EthernetLinkStatus_allowedValueList } },
    { NULL }
};


static Action _GetEthernetLinkStatus = {
    "GetEthernetLinkStatus", GetEthernetLinkStatus,
   (Param []) {
       {"NewEthernetLinkStatus", VAR_EthernetLinkStatus, VAR_OUT},
       { 0 }
    }
};


static PAction Actions[] = {
    &_GetEthernetLinkStatus,
    NULL
};

ServiceTemplate Template_WANEthernetLinkConfig = {
    "WANEthernetLinkConfig:1",	/* name of service */
    NULL,		/* PFSVCINIT service initialization function */
    NULL,		/* PFGETVAR get service state variable function */
    NULL,		/* SVCXML service XML generation function (not used) */
    ARRAYSIZE(StateVariables)-1, /* number of state variables */
    StateVariables,     /* pointer to list of state variables */
    Actions,             /* pointer to list of actions */
    0, /* count */
    "urn:upnp-org:serviceId:WANEthernetLinkC", /* service id */
    NULL		/* schema */
};
