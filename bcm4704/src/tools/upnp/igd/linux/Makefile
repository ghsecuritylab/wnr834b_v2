#
# Copyright 2007, Broadcom Corporation
# All Rights Reserved.
# 
# THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
# KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
# SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
#
# $Id: Makefile,v 1.1.1.1 2010/03/05 07:31:36 reynolds Exp $
#

ifndef DEBUG
#export DEBUG=1
endif

SRCBASE=../../../..
ifeq ($(PLATFORM), mipsel)
    export PATH:=/projects/hnd/tools/linux/hndtools-mipsel-linux/bin:${PATH}
    TARGET_PREFIX = mipsel-linux-
    CFLAGS += -DMIPS
else
    TARGET_PREFIX =
endif

CC = $(TARGET_PREFIX)gcc
AS = $(TARGET_PREFIX)as
AR = $(TARGET_PREFIX)ar
LD = $(TARGET_PREFIX)ld
CCPP = $(TARGET_PREFIX)g++
COMPILER = $(TARGET_PREFIX)g++
STRIP = $(TARGET_PREFIX)strip
SIZE = $(TARGET_PREFIX)size

VPATH.h = .:..:../../include:$(SRCBASE)/include:$(SRCBASE)/router/shared

vpath %.c .:..:$(SRCBASE)/shared/netconf
vpath %.h $(VPATH.h)


ifeq ($(DEBUG),1)
CFLAGS += -g -DDEBUG -UNDEBUG -DBCMDBG
else
CFLAGS += -O2 -DNDEBUG
endif
CFLAGS += -I$(subst :, -I,$(VPATH.h))
CFLAGS += -Wall -Wunused 
#CFLAGS += --trace-includes
OBJDIR=obj

# compile in the generic UPNP IGD files.
#
SOURCES = igd.c igd_desc.c wancommon.c wanipc.c ipt.c \
	  layer3.c  \
	  x_wanpppconnection.c wanppp.c \
	  mapmgr.c

# Add the OS-specific source files.
SOURCES += linux_main.c linux_net.c linux_igd.c


SOURCES.TEST = test.c shutils.c 

SOURCES.OBJ := $(SOURCES)
SOURCES.OBJ := $(patsubst %.c,$(OBJDIR)/%.o,$(SOURCES.OBJ))

TARGET = upnp
LIBS = -L../../upnp/linux -L$(SRCBASE)/router/netconf \
	-L$(SRCBASE)/router/nvram -L$(SRCBASE)/router/shared -lupnp -lnetconf -lnvram -lshared

all : $(OBJDIR) $(TARGET)

$(OBJDIR):
	mkdir -p $(OBJDIR)

wanipc.c : wanipc.h

ipt.c : wanipc.h

$(SOURCES.OBJ): upnp.h

$(OBJDIR)/%.o:	%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

# uncomment BUILD_LIBS if you want this makefile to build the netconf and itables libraries.
#BUILD_LIBS=1

ifneq ($(BUILD_LIBS),)

$(TARGET) :: libnetconf.so

$(TARGET) :: $(SRCBASE)/router/iptables/libiptables.a 

$(TARGET) :: $(SRCBASE)/router/nvram/libnvram.a 

$(SRCBASE)/router/iptables/libiptables.a : FORCE
	$(MAKE) -C $(SRCBASE)/router/iptables PLATFORM=x86 CC=$(CC) LD=$(LD) SRCBASE=../.. TOP=..
$(SRCBASE)/router/nvram/libnvram.a : FORCE
	$(MAKE) -C $(SRCBASE)/router/nvram PLATFORM=x86 CC=$(CC) LD=$(LD) SRCBASE=../.. TOP=..

$(SRCBASE)/router/netconf/libnetconf.so : $(SRCBASE)/router/iptables/libiptables.a FORCE
	$(MAKE) -C $(SRCBASE)/router/netconf DEBUG=1 PLATFORM=x86 CC=$(CC) LD=$(LD) SRCBASE=../.. TOP=..

libnetconf.so : $(SRCBASE)/router/netconf/libnetconf.so
	#	cp $(SRCBASE)/router/netconf/libnetconf.so /router/usr/lib/

endif


../../upnp/linux/libupnp.a : FORCE
	$(MAKE) -C ../../upnp/linux DEBUG=$(DEBUG) PLATFORM=x86 CC=$(CC) LD=$(LD) VENDOR=$(VENDOR)

$(TARGET) :: ../../upnp/linux/libupnp.a  $(SOURCES.OBJ)
	$(CC) -o $(TARGET) $(SOURCES.OBJ) $(LIBS)
ifneq ($(DEBUG),1)
	$(STRIP)  $(TARGET)
endif
	$(SIZE)  $(TARGET)

clean: 
	rm -rf obj 
	rm -f upnp
	$(MAKE) -C ../../upnp/linux clean
ifneq ($(BUILD_LIBS),)
	$(MAKE) -C $(SRCBASE)/router/netconf clean
	$(MAKE) -C $(SRCBASE)/router/iptables clean
	$(MAKE) -C $(SRCBASE)/router/nvram clean
endif

fptest: fptest.o
	$(CC) -o fptest fptest.o $(LIBS)

btest: btest.o
	$(CC) -o btest btest.o

FORCE:

.PHONY: FORCE clean libs
