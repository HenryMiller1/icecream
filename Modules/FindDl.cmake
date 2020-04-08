#  Copyright (c) 2020 libbitcoin developers
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

###############################################################################
# Finddl
#
# Use this module by invoking find_package with the form::
#
#   find_package( dl
#     [REQUIRED]             # Fail with error if dl is not found
#   )
#
#   Defines the following for use:
#
#   dl_FOUND        - True if headers and requested libraries were found
#   dl_LIBRARIES    - dl libraries to be linked
#   dl_LIBS         - dl libraries to be linked
#

if (DEFINED dl_FIND_VERSION)
    message( SEND_ERROR "Library 'dl' unable to process specified version: ${dl_FIND_VERSION}" )
endif()

if (MSVC)
    message( STATUS "MSVC environment detection for 'dl' not currently supported." )
    set( dl_FOUND false )
else ()
    # required
    if ( dl_FIND_REQUIRED )
        set( _dl_REQUIRED "REQUIRED" )
    endif()

    find_library(dl_LIBRARIES dl)

    if (dl_LIBRARIES-NOTFOUND)
        set( dl_FOUND false )
    else ()
        set( dl_FOUND true )
        set( dl_LIBS "-ldl" )
    endif()
endif()

if ( dl_FIND_REQUIRED AND ( NOT dl_FOUND ) )
    message( SEND_ERROR "Library 'dl'  not found." )
endif()

MARK_AS_ADVANCED(dl_LIBRARIES)