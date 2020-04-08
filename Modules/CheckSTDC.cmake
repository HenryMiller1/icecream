# Copyright (c) 2020 Jonathan Slenders as part of the icecream program
#
#Redistribution and use in source and binary forms, with or without modification, 
#are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this 
#list of conditions and the following disclaimer.
#
#2. Redistributions in binary form must reproduce the above copyright notice, 
#this list of conditions and the following disclaimer in the documentation and/or 
#other materials provided with the distribution.
#
#3. Neither the name of the copyright holder nor the names of its contributors 
#may be used to endorse or promote products derived from this software without 
#specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
#WARRANTIES OF MERCHANTABILIYT AND FITNESS FOR A PARTICULAR PURPOSE ARE 
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
#ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
#LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON 
#ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

message(STATUS "Checking whether system has ANSI C header files")
include(CheckPrototypeExists)
include(CheckIncludeFiles)

check_include_files("dlfcn.h;stdint.h;stddef.h;inttypes.h;stdlib.h;strings.h;string.h;float.h" StandardHeadersExist)
if(StandardHeadersExist)
	check_prototype_exists(memchr string.h memchrExists)
	if(memchrExists)
		check_prototype_exists(free stdlib.h freeExists)
		if(freeExists)
			message(STATUS "ANSI C header files - found")
			set(STDC_HEADERS 1 CACHE INTERNAL "System has ANSI C header files")
			set(HAVE_STRINGS_H 1)
			set(HAVE_STRING_H 1)
			set(HAVE_FLOAT_H 1)
			set(HAVE_STDLIB_H 1)
			set(HAVE_STDDEF_H 1)
			set(HAVE_STDINT_H 1)
			set(HAVE_INTTYPES_H 1)
			set(HAVE_DLFCN_H 1)
		endif(freeExists)
	endif(memchrExists)
endif(StandardHeadersExist)

if(NOT STDC_HEADERS)
	message(STATUS "ANSI C header files - not found")
	set(STDC_HEADERS 0 CACHE INTERNAL "System has ANSI C header files")
endif(NOT STDC_HEADERS)

check_include_files(unistd.h HAVE_UNISTD_H)

include(CheckDIRSymbolExists)
check_dirsymbol_exists("sys/stat.h;sys/types.h;dirent.h" HAVE_DIRENT_H)
if (HAVE_DIRENT_H)
	set(HAVE_SYS_STAT_H 1)
	set(HAVE_SYS_TYPES_H 1)
endif (HAVE_DIRENT_H)