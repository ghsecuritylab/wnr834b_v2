/*
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 2000-2001 Silicon Graphics, Inc. All rights reserved.
 */


#ifndef _ASM_IA64_SN_HACK_H
#define _ASM_IA64_SN_HACK_H

#include <asm/sn/types.h>
#include <asm/uaccess.h>		/* for copy_??_user */

/******************************************
 * Definitions that do not exist in linux *
 ******************************************/

typedef int cred_t;	/* This is for compilation reasons */
struct cred { int x; };


#define mrlock(_s, _t, _u)
#define mrunlock(_s)

/*
 * Hardware Graph routines that are currently stubbed!
 */
#include <linux/devfs_fs_kernel.h>

#define DELAY(a)

/************************************************
 * Routines redefined to use linux equivalents. *
 ************************************************/


#define FIXME(s)

extern devfs_handle_t dummy_vrtx;
#define cpuid_to_vertex(cpuid) dummy_vrtx /* (pdaindr[cpuid].pda->p_vertex) */

#define PUTBUF_LOCK(a) { FIXME("PUTBUF_LOCK"); }
#define PUTBUF_UNLOCK(a) { FIXME("PUTBUF_UNLOCK"); }

typedef int (*splfunc_t)(void);

/* move to stubs.c yet */
#define dev_to_vhdl(dev) 0
#define get_timestamp() 0
#define us_delay(a)
#define v_mapphys(a,b,c) 0    // printk("Fixme: v_mapphys - soft->base 0x%p\n", b);
#define splhi()  0
#define spl7	splhi()
#define splx(s)

extern void * snia_kmem_alloc_node(register size_t, register int, cnodeid_t);
extern void * snia_kmem_zalloc(size_t, int);
extern void * snia_kmem_zalloc_node(register size_t, register int, cnodeid_t );
extern void * snia_kmem_zone_alloc(register zone_t *, int);
extern zone_t * snia_kmem_zone_init(register int , char *);
extern void snia_kmem_zone_free(register zone_t *, void *);
extern int is_specified(char *);
extern int cap_able(uint64_t);
extern int compare_and_swap_ptr(void **, void *, void *);

#endif /* _ASM_IA64_SN_HACK_H */
