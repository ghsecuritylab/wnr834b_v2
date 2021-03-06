/*  *********************************************************************
    *  Broadcom Common Firmware Environment (CFE)
    *  
    *  Physical Memory (arena) manager		File: sb1250_arena.c
    *  
    *  This module describes the physical memory available to the 
    *  firmware.
    *  
    *  Author:  Mitch Lichtenberg (mpl@broadcom.com)
    *  
    *********************************************************************  
    *
    *  Copyright 2000,2001,2002,2003
    *  Broadcom Corporation. All rights reserved.
    *  
    *  This software is furnished under license and may be used and 
    *  copied only in accordance with the following terms and 
    *  conditions.  Subject to these conditions, you may download, 
    *  copy, install, use, modify and distribute modified or unmodified 
    *  copies of this software in source and/or binary form.  No title 
    *  or ownership is transferred hereby.
    *  
    *  1) Any source code used, modified or distributed must reproduce 
    *     and retain this copyright notice and list of conditions 
    *     as they appear in the source file.
    *  
    *  2) No right is granted to use any trade name, trademark, or 
    *     logo of Broadcom Corporation.  The "Broadcom Corporation" 
    *     name may not be used to endorse or promote products derived 
    *     from this software without the prior written permission of 
    *     Broadcom Corporation.
    *  
    *  3) THIS SOFTWARE IS PROVIDED "AS-IS" AND ANY EXPRESS OR
    *     IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO, ANY IMPLIED
    *     WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
    *     PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED. IN NO EVENT 
    *     SHALL BROADCOM BE LIABLE FOR ANY DAMAGES WHATSOEVER, AND IN 
    *     PARTICULAR, BROADCOM SHALL NOT BE LIABLE FOR DIRECT, INDIRECT,
    *     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
    *     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
    *     GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
    *     BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
    *     OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
    *     TORT (INCLUDING NEGLIGENCE OR OTHERWISE), EVEN IF ADVISED OF 
    *     THE POSSIBILITY OF SUCH DAMAGE.
    ********************************************************************* */

#include "lib_types.h"
#include "lib_string.h"
#include "lib_queue.h"
#include "lib_malloc.h"
#include "lib_printf.h"
#include "lib_arena.h"

#include "cfe_error.h"

#include "cfe.h"
#include "cfe_mem.h"

#include "initdata.h"

#define _NOPROTOS_
#include "cfe_boot.h"
#undef _NOPROTOS_

#include "cpu_config.h"

#include "addrspace.h"

/*  *********************************************************************
    *  Constants
    ********************************************************************* */


#define MEG	(1024*1024)
#define KB      1024
#define PAGESIZE 4096
#define CFE_BOOTAREA_SIZE (256*KB)
#define CFE_BOOTAREA_ADDR 0x20000000


/*  *********************************************************************
    *  Globals
    ********************************************************************* */

extern arena_t cfe_arena;
uint64_t *cfe_pagetable = NULL;

extern void CPUCFG_PAGETBLINIT(uint64_t *ptaddr,unsigned int ptstart);

void cfe_bootarea_init(void);
extern void _setcontext(int64_t);


/*  *********************************************************************
    *  CFE_BOOTAREA_INIT()
    *  
    *  Initialize the page table and map our boot program area.
    *  
    *  Input parameters: 
    *  	   nothing
    *  	   
    *  Return value:
    *  	   nothing
    ********************************************************************* */

void cfe_bootarea_init(void)
{
    unsigned char *pte;
    int64_t pte_int;
    unsigned int addr = 16*MEG;
    unsigned int topmem;
    unsigned int topcfe;
    unsigned int botcfe;
    unsigned int beforecfe;
    unsigned int aftercfe;

    /*
     * Calculate the location where the boot area will 
     * live.  It lives either above or below the
     * firmware, depending on where there's more space.
     */

    /*
     * The firmware will always be loaded in the first
     * 256M.  Calculate the top of that region.  The bottom
     * of that region is always the beginning of our
     * data segment.
     */
    if (mem_totalsize > (uint64_t)(256*1024)) {
	topmem = 256*MEG;
	}
    else {
	topmem = (unsigned int) (mem_totalsize << 10);
	}
    botcfe = (unsigned int) K1_TO_PHYS(mem_bottomofmem);
    topcfe = (unsigned int) K1_TO_PHYS(mem_topofmem);

    beforecfe = botcfe;
    aftercfe = topmem-topcfe;

    if (beforecfe > aftercfe) {
	botcfe -= (PAGESIZE-1);
	botcfe &= ~(PAGESIZE-1);	/* round down to page boundary */
	addr = botcfe - CFE_BOOTAREA_SIZE;	/* this is the address */
	}
    else {
	topcfe += (PAGESIZE-1);		/* round *up* to a page address */
	topcfe &= ~(PAGESIZE-1);
	addr = topcfe;
	}
    
    mem_bootarea_start = addr;
    mem_bootarea_size = CFE_BOOTAREA_SIZE;

    /*
     * Allocate the page table
     */

    pte = KMALLOC(1024,1024);

#ifdef __long64
    pte_int = (int64_t) pte;
#else
    pte_int = (int64_t) ((int) pte);
#endif

    /* 
     * Set the CP0 CONTEXT register to point at the page table
     */

    pte_int <<= 13;
    cfe_pagetable = (uint64_t *) pte;

    _setcontext(pte_int);

    
    /*
     * Initialize page table entries
     */

    CPUCFG_PAGETBLINIT(cfe_pagetable,addr);


}

