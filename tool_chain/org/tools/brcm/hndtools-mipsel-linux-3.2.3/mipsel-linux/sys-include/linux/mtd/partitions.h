/*
 * MTD partitioning layer definitions
 *
 * (C) 2000 Nicolas Pitre <nico@cam.org>
 *
 * This code is GPL
 *
 * $Id: partitions.h,v 1.1.1.1 2010/03/05 07:31:00 reynolds Exp $
 */

#ifndef MTD_PARTITIONS_H
#define MTD_PARTITIONS_H

#include <linux/types.h>


/*
 * Partition definition structure:
 * 
 * An array of struct partition is passed along with a MTD object to
 * add_mtd_partitions() to create them.
 *
 * For each partition, these fields are available:
 * name: string that will be used to label the partition's MTD device.
 * size: the partition size; if defined as MTDPART_SIZ_FULL, the partition 
 * 	will extend to the end of the master MTD device.
 * offset: absolute starting position within the master MTD device; if 
 * 	defined as MTDPART_OFS_APPEND, the partition will start where the 
 * 	previous one ended; if MTDPART_OFS_NXTBLK, at the next erase block.
 * mask_flags: contains flags that have to be masked (removed) from the 
 * 	master MTD flag set for the corresponding MTD partition.
 * 	For example, to force a read-only partition, simply adding 
 * 	MTD_WRITEABLE to the mask_flags will do the trick.
 *
 * Note: writeable partitions require their size and offset be 
 * erasesize aligned (e.g. use MTDPART_OFS_NEXTBLK).
 */ 

struct mtd_partition {
	char *name;		/* identifier string */
	u_int32_t size;		/* partition size */
	u_int32_t offset;		/* offset within the master MTD space */
	u_int32_t mask_flags;	/* master MTD flags to mask out for this partition */
	struct mtd_info **mtdp;	/* pointer to store the MTD object */
};

#define MTDPART_OFS_NXTBLK	(-2)
#define MTDPART_OFS_APPEND	(-1)
#define MTDPART_SIZ_FULL	(0)


int add_mtd_partitions(struct mtd_info *, struct mtd_partition *, int);
int del_mtd_partitions(struct mtd_info *);

#endif

