/****************************************************************************
 *                                                                          *
 *                         GNAT COMPILER COMPONENTS                         *
 *                                                                          *
 *                                  A D A                                   *
 *                                                                          *
 *                              C Header File                               *
 *                                                                          *
 *                            $Revision: 1.1.1.1 $
 *                                                                          *
 *          Copyright (C) 1992-2001 Free Software Foundation, Inc.          *
 *                                                                          *
 * GNAT is free software;  you can  redistribute it  and/or modify it under *
 * terms of the  GNU General Public License as published  by the Free Soft- *
 * ware  Foundation;  either version 2,  or (at your option) any later ver- *
 * sion.  GNAT is distributed in the hope that it will be useful, but WITH- *
 * OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY *
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License *
 * for  more details.  You should have  received  a copy of the GNU General *
 * Public License  distributed with GNAT;  see file COPYING.  If not, write *
 * to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, *
 * MA 02111-1307, USA.                                                      *
 *                                                                          *
 * As a  special  exception,  if you  link  this file  with other  files to *
 * produce an executable,  this file does not by itself cause the resulting *
 * executable to be covered by the GNU General Public License. This except- *
 * ion does not  however invalidate  any other reasons  why the  executable *
 * file might be covered by the  GNU Public License.                        *
 *                                                                          *
 * GNAT was originally developed  by the GNAT team at  New York University. *
 * Extensive contributions were provided by Ada Core Technologies Inc.      *
 *                                                                          *
 ****************************************************************************/

/* This file contains some standard macros for performing Ada-like
   operations. These are used to aid in the translation of other headers. */

/* Inlined functions in header are preceded by INLINE, which is normally set
   to extern inline for GCC, but may be set to static for use in standard 
   ANSI-C.  */

#ifndef INLINE
#ifdef __GNUC__
#define INLINE static inline
#else
#define INLINE static
#endif
#endif

/* Define a macro to concatenate two strings.  Write it for ANSI C and
   for traditional C.  */

#ifdef __STDC__
#define CAT(A,B) A##B
#else
#define _ECHO(A) A
#define CAT(A,B) ECHO(A)B
#endif

/* The following macro definition simulates the effect of a declaration of 
   a subtype, where the first two parameters give the name of the type and
   subtype, and the third and fourth parameters give the subtype range. The
   effect is to compile a typedef defining the subtype as a synonym for the 
   type, together with two constants defining the end points.  */

#define SUBTYPE(SUBTYPE,TYPE,FIRST,LAST)    \
  typedef TYPE SUBTYPE;		    \
  static const SUBTYPE CAT (SUBTYPE,__First) = FIRST; \
  static const SUBTYPE CAT (SUBTYPE,__Last) = LAST;

/* The following definitions provide the equivalent of the Ada IN and NOT IN
   operators, assuming that the subtype involved has been defined using the 
   SUBTYPE macro defined above.  */

#define IN(VALUE,SUBTYPE) \
  (((VALUE) >= CAT (SUBTYPE,__First)) && ((VALUE) <= CAT (SUBTYPE,__Last)))
