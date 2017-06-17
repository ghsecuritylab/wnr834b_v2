/*
 * Copyright 2007, Broadcom Corporation
 * All Rights Reserved.
 * 
 * THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
 * KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
 * SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
 *
 * $Id: linux_main.c,v 1.1.1.1 2010/03/05 07:31:36 reynolds Exp $
 */

#include <errno.h>	    // for errno, of course.
#include <error.h>	    // for perror
#include <signal.h>	    // for signal, etc.
#include <assert.h>	    // for assert, of course.
#include <stdlib.h>	    // for malloc, free, etc.
#include <string.h>	    // for memset, strncasecmp, etc.
#include <stdarg.h>	    // for va_list, etc.
#include <stdio.h>	    // for printf, perror, fopen, fclose, etc.
#include <net/if.h>	    // for struct ifreq, etc.
#include <sys/ioctl.h>	    // for SIOCGIFCONF, etc.
#include <fcntl.h>	    // for fcntl, F_GETFL, etc.
#include <unistd.h>	    // for read, write, etc.
#include <arpa/inet.h>	    // for inet_aton, inet_addr, etc.
#include <time.h>	    // for time
#include <netinet/in.h>	    // for sockaddr_in
#include <wait.h>	    // for sockaddr_in


#include "ctype.h"
#include "upnp_dbg.h"
#include "upnp.h"


extern void define_variable(char *name, char *value);
extern void uuidstr_create(char *);
extern char *strip_chars(char *, char *);
extern void init_devices();
void init_event_queue(int);

extern struct net_connection *net_connections;
extern int global_exit_now;
extern struct iface *global_lans;

static void
reap(int sig)
{
	pid_t pid;
	
	if (sig == SIGPIPE)	
		return;

	while ((pid = waitpid(-1, NULL, WNOHANG)) > 0)
		UPNP_TRACE(("Reaped %d\n", pid));
}


int main(int argc, char *argv[])
{
    extern char g_wandevs[];
    extern DeviceTemplate IGDeviceTemplate;
    char **argp = &argv[1];
    char *wanif = NULL;
    char *lanif = NULL;
    int daemonize = 0;

    while (argp < &argv[argc]) {
	if (strcasecmp(*argp, "-L") == 0) {
	    lanif = *++argp;
	} 
	else if (strcasecmp(*argp, "-W") == 0) {
	    wanif = *++argp;
	    strcpy(g_wandevs, wanif);
	} 
	else if (strcasecmp(*argp, "-D") == 0) {
	    daemonize = 1;
	}
	argp++;
    }

    init_event_queue(40);

    if (lanif == NULL || wanif == NULL) {
	fprintf(stderr, "usage: %s -L lan_ifname -W wan_ifname\n", argv[0]);
    } else {
	if (daemonize && daemon(1, 1) == -1) {
	    perror("daemon");
	    exit(errno);
	}

	/* We need to have a reaper for child processes we may create.
	   That happens when we send signals to the dhcp process to
	   release an renew a lease on the external interface. */
	signal(SIGCHLD, reap);
	/* Handle the TCP -EPIPE error */
	signal(SIGPIPE, reap);
	/* For some reason that I do not understand, this process gets
	   a SIGTERM after sending SIGUSR1 to the dhcp process (to
	   renew a lease).  Ignore SIGTERM to avoid being killed when
	   this happens.  */
	//	signal(SIGTERM, SIG_IGN);
	signal(SIGUSR1, SIG_IGN);

	fprintf(stderr, "calling upnp_main\n");
	upnp_main(&IGDeviceTemplate, lanif);
    }
    
    return 0;
}

