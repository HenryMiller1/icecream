# Copyright (c) Facebook, Inc. and its affiliates.
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

#
# - Try to find Facebook zstd library
# This will define
# ZSTD_FOUND
# ZSTD_INCLUDE_DIR
# ZSTD_LIBRARY
#

find_path(Zstd_INCLUDE_DIR NAMES zstd.h)

find_library(Zstd_LIBRARY_DEBUG NAMES zstdd zstd_staticd)
find_library(Zstd_LIBRARY_RELEASE NAMES zstd zstd_static)

include(SelectLibraryConfigurations)
SELECT_LIBRARY_CONFIGURATIONS(Zstd)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(
    Zstd DEFAULT_MSG
    Zstd_LIBRARY Zstd_INCLUDE_DIR
)
if (Zstd_FOUND)
    if (NOT TARGET Zstd::Zstd)
        add_library(Zstd::Zstd UNKNOWN IMPORTED)
        set_target_properties(Zstd::Zstd PROPERTIES
                              IMPORTED_LOCATION "${Zstd_LIBRARY}"
                              INTERFACE_INCLUDE_DIRECTORIES "${Zstd_INCLUDE_DIR}")
    endif ()
endif()

mark_as_advanced(Zstd_INCLUDE_DIR Zstd_LIBRARY_DEBUG Zstd_LIBRARY_RELEASE)
