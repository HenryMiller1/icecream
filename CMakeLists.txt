#   This file is part of Icecream.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# =============
# CMake init
# =============
cmake_minimum_required(VERSION 3.12)

# ====================
# Version informations
# ====================
# Stable versions: x.y.z , where z < 50
# Development versions: x.y.90
# Pre-release versions: x.y.z, where z = 90 + X in rcX (1.1rc1 = 1.1.91)
project(icecc VERSION 1.3.90 LANGUAGES CXX C)

set(PACKAGE "icecc")
set(PACKAGE_BUGREPORT "")
set(TARNAME "")
set(PACKAGE_URL "")
set(PACKAGE_NAME "${PACKAGE}")
set(PACKAGE_VERSION "${icecc_VERSION}") #get rid of this one later
set(PACKAGE_STRING "${PACKAGE} ${icecc_VERSION}")


if(NOT TARNAME)
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "-" TARNAME "${PACKAGE}")
endif()    
set(PACKAGE_TARNAME "${TARNAME}")


SET(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/Modules
    ${CMAKE_MODULE_PATH})

if(NOT DEFINED RUNDIR)
    set(RUNDIR "/opt/icecream/var/run")
endif()
if(NOT DEFINED BINDIR)
    set(BINDIR "${CMAKE_INSTALL_PREFIX}/bin")
endif()

# ===========================
# Set up C++11 and compile flags
# ===========================
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF) # avoid possible mixed standard libraries

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # using Clang
    # The code has numerous cast alignment warnings that only clang warns about,
    # and it probably(?) doesn't matter in practice.
    set(cast_align "")
    # Clang is not so overzealous like GCC and doesn't warn about cases which
    # are very unlikely to be problems (e.g. function argument shadowing
    # a function elsewhere), so it's not so annoying.
    set(wshadow "-Wshadow")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # using GCC
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    # using Intel C++
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # using Visual Studio C++
endif()

set(CFLAGS "-g -Wall -Wextra \
    -Wshadow -Wpointer-arith ${cast_align} -Wwrite-strings \
    -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes \
    -Wnested-externs -Wundef ${CFLAGS}"
)
set(CXXFLAGS " -g -Wall -Wextra -Wpointer-arith $cast_align ${wshadow} -Wwrite-strings -Wundef ${CXXFLAGS}")

if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
    set(CFLAGS "${CFLAGS} -g -O0")
    set(CXXFLAGS "${CXXFLAGS} -g -O0")
else()
    set(CFLAGS "${CFLAGS} -DNDEBUG")
    set(CXXFLAGS "${CXXFLAGS} -DNDEBUG")
endif()

# Detect inline keyword
if (MSVC)
    set (inline __inline)
elseif(CMAKE_COMPILER_IS_GNUC)
    set (inline __inline__)
endif()

# ===========================
# Find required base packages
# ===========================
if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    find_package(Libcap-ng)
    if (Libcap-ng_FOUND)
        set(HAVE_LIBCAP_NG 1)
    endif()
endif()
find_package(LZO REQUIRED)
find_package(TAR REQUIRED)
find_package(Zstd REQUIRED)
find_package(LibArchive REQUIRED)
find_package(Dl REQUIRED)

# =============
# Documentation
# =============
find_package(DocbookToMan)


########################################################################
### Checks for header files

# Some of these are needed by popt (or other libraries included in the future).
include(${CMAKE_SOURCE_DIR}/Modules/CheckSTDC.cmake)
include(CheckIncludeFiles)
CHECK_INCLUDE_FILES("memory.h" HAVE_MEMORY_H)
CHECK_INCLUDE_FILES("sys/stat.h" HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILES("unistd.h" HAVE_UNISTD_H)
CHECK_INCLUDE_FILES("stdint.h" HAVE_STDINT_H)
CHECK_INCLUDE_FILES("stdlib.h" HAVE_STDLIB_H)
CHECK_INCLUDE_FILES("strings.h" HAVE_STRINGS_H)
CHECK_INCLUDE_FILES("string.h" HAVE_STRING_H)
CHECK_INCLUDE_FILES("inttypes.h" HAVE_INTTYPES_H)
CHECK_INCLUDE_FILES("sys/signal.h" HAVE_SYS_SIGNAL_H)
CHECK_INCLUDE_FILES("ifaddrs.h" HAVE_IFADDRS_H)
CHECK_INCLUDE_FILES("kinfo.h" HAVE_KINFO_H)
CHECK_INCLUDE_FILES("sys/param.h" HAVE_SYS_PARAM_H)
CHECK_INCLUDE_FILES("devstat.h" HAVE_DEVSTAT_H)
CHECK_INCLUDE_FILES("sys/socketvar.h" HAVE_SYS_SOCKETVAR_H)
CHECK_INCLUDE_FILES("sys/vfs.h" HAVE_SYS_VFS_H)
CHECK_INCLUDE_FILES("mach/host_info.h" HAVE_MACH_HOST_INFO_H)
CHECK_INCLUDE_FILES("sys/types.h" HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILES("arpa/nameser.h" HAVE_ARPA_NAMESER_H)
CHECK_INCLUDE_FILES("netinet/in.h" HAVE_INET_IN_H)
CHECK_INCLUDE_FILES("resolv.h" HAVE_RESOLV_H)
CHECK_INCLUDE_FILES("netinet/tcp.h" HAVE_NETINET_TCP_H)
CHECK_INCLUDE_FILES("netinet/tcp_var.h" HAVE_NETINET_TCP_VAR_H)
CHECK_INCLUDE_FILES("sys/user.h" HAVE_SYS_USER_H)
CHECK_INCLUDE_FILES("dlfcn.h" HAVE_DLFCN_H)
CHECK_INCLUDE_FILES("archive_entry.h" HAVE_ARCHIVE_ENTRY_H)
CHECK_INCLUDE_FILES("archive.h" HAVE_ARCHIVE_H_) #trailing underscore is on purpose, the code expects this.


######################################################################
### Checks for types
include(CheckTypeSize)
set(SYMBOL_INCLUDES "sys/types.h;sys/socket.h;netinet/in.h")
if (HAVE_ARPA_NAMESER_H)
    list(APPEND SYMBOL_INCLUDES "arpa/nameser.h")
endif()
set(PREV_INCLUDES  ${CMAKE_EXTRA_INCLUDE_FILES})
set(CMAKE_EXTRA_INCLUDE_FILES "sys/types.h;sys/socket.h;netinet/in.h")
CHECK_TYPE_SIZE(sa_family_t SA_FAMILY_T)
if (HAVE_SA_FAMILY_T)
    set(HAVE_SA_FAMILY_T 1) # preserve format consistency
endif()
CHECK_TYPE_SIZE(socklen_t SOCKLEN_T)
if (HAVE_SOCKLEN_T)
    set(HAVE_SOCKLEN_T 1) # preserve format consistency
endif()
CHECK_TYPE_SIZE(in_port_t IN_PORT_T)
if (HAVE_IN_PORT_T)
    set(HAVE_IN_PORT_T 1) # preserve format consistency
endif()
CHECK_TYPE_SIZE(in_addr_t IN_ADDR_T)
if (HAVE_IN_ADDR_T)
    set(HAVE_IN_ADDR_T 1) # preserve format consistency
endif()

set(CMAKE_EXTRA_INCLUDE_FILES "net/if.h")
include(${CMAKE_SOURCE_DIR}/Modules/CheckStructMember.cmake)
CHECK_STRUCT_MEMBER("ifreq" "ifr_dstaddr" "net/if.h" HAVE_IFR_DSTADDR)
set(CMAKE_EXTRA_INCLUDE_FILES ${PREV_INCLUDES})

########################################################################
### Checks for libraries.

# The following test taken from the cvs sources via Samba:
# If we can't find connect, try looking in -lsocket, -lnsl, and -linet.
# The Irix 5 libc.so has connect and gethostbyname, but Irix 5 also has
# libsocket.so which has a bad implementation of gethostbyname (it
# only looks in /etc/hosts), so we only look for -lsocket if we need
# it.
include(CheckSymbolExists)
CHECK_SYMBOL_EXISTS("connect" "sys/socket.h" HAVE_CONNECT)
if (${HAVE_CONNECT} EQUAL 0)
#    *-lnsl*
    CHECK_LIBRARY_EXISTS("nsl_s" "printf" "" HAVE_NSL_S)
#    *-lnsl*
    CHECK_LIBRARY_EXISTS("nsl" "printf" "" HAVE_NSL)
#    *-lsocket*
    CHECK_LIBRARY_EXISTS("socket" "connect" "" HAVE_SOCKET_CONNECT)
#    *-linet*
    CHECK_LIBRARY_EXISTS("inet" "connect" "" HAVE_INET_CONNECT)
    if (${HAVE_SOCKET_CONNECT} EQUAL 1 OR ${HAVE_INET_CONNECT} EQUAL  1)       
        set(HAVE_CONNECT "1")
    endif()
endif()

CHECK_SYMBOL_EXISTS("flock" "sys/file.h" HAVE_FLOCK)
CHECK_SYMBOL_EXISTS("lockf" "unistd.h" HAVE_LOCKF)
CHECK_SYMBOL_EXISTS("strsignal" "string.h" HAVE_STRSIGNAL)
CHECK_SYMBOL_EXISTS("getloadavg" "stdlib.h" HAVE_GETLOADAVG)

include(CheckCSourceCompiles)
set(PREV_REQ_LIBS ${CMAKE_REQUIRED_LIBRARIES})
set(CMAKE_REQUIRED_LIBRARIES "archive")
CHECK_C_SOURCE_COMPILES("
    #include <archive.h>

    int main(void) {
        struct archive *a;
        archive_read_support_filter_xz(a);
    }
  "
  HAVE_LIBARCHIVE_XZ
  )
CHECK_C_SOURCE_COMPILES("
    #include <archive.h>

    int main(void) {
        struct archive *a;
        archive_read_support_filter_zstd(a);
    }
  "
  HAVE_LIBARCHIVE_ZSTD
  )
set(CMAKE_REQUIRED_LIBRARIES ${PREV_REQ_LIBS})
 
# In DragonFlyBSD daemon needs to be linked against libkinfo.
if( ${CMAKE_SYSTEM} MATCHES "dragonfly")
  set(LIB_KINFO "-lkinfo")
else()
  set(LIB_KINFO "")
endif()

########################################################################
### CLang specific configuration
# AC_CHECK_PROG(CLANG,clang,clang)
option(CLANG_REWRITE_INCLUDES "Use by default Clang's -frewrite-includes option." ON)
if (CLANG_REWRITE_INCLUDES)
    set(HAVE_CLANG_REWRITE_INCLUDES 1)
elseif(NOT CLANG_REWRITE_INCLUDES)
    # do not enable
else()
    # test to see if clang supports rewrite-includes nd if so enabled.
#     if test -n "$CLANG"; then
#         AC_MSG_CHECKING([whether clang -Werror works for unknown options])
#         $CLANG -Werror -totallybogusoption -E - >/dev/null 2>/dev/null
#         if test $? -eq 0; then
#             AC_MSG_RESULT(no)
#             # can't detect if the option is supported, but that's too old clang anyway
#         else
#             AC_MSG_RESULT(yes)
#             AC_MSG_CHECKING([for clang -E -frewrite-includes])
#             $CLANG -Werror -E -frewrite-includes - >/dev/null 2>/dev/null
#             if test $? -eq 0; then
#                 AC_MSG_RESULT(yes)
#                 AC_DEFINE(HAVE_CLANG_REWRITE_INCLUDES, 1, [Define to 1 if clang supports -frewrite-includes])
#             else
#                 AC_MSG_RESULT(no)
#             fi
#         fi
#     fi
endif()

option(CLANG_WRAPPERS "Use symlink wrappers for clang/clang++" ON)
if (CLANG_WRAPPERS)
    set(CLANG_SYMLINK_WRAPPERS "clang clang++")
elseif(NOT CLANG_WRAPPERS)
    set(CLANG_SYMLINK_WRAPPERS "")
else()
#  look for clang and enable wrappers if clang is available
#     if test -n "$CLANG"; then
#         CLANG_SYMLINK_WRAPPERS='clang clang++'
#     fi   
endif()

########################################################################
### GCC specific configuration
option(GCC_COLOR_DIAGNOSTICS "Assume by default GCC has -fdiagnostics-color=auto option." ON)
if (GCC_COLOR_DIAGNOSTICS)
    set(HAVE_GCC_COLOR_DIAGNOSTICS 1)
elseif(NOT GCC_COLOR_DIAGNOSTICS)
    # do not enable
else()
    # Assume by default GCC has -fdiagnostics-color=auto option.
    set(HAVE_GCC_COLOR_DIAGNOSTICS 1)
endif()

option(GCC_SHOW_CARET "Assume by default GCC has -fdiagnostics-show-caret option." ON)
if (GCC_SHOW_CARET)
    set(HAVE_GCC_SHOW_CARET 1)
elseif(NOT GCC_SHOW_CARET)
    # do not enable
else()
    # Assume by default GCC has -fdiagnostics-show-caret option.
    set(HAVE_GCC_SHOW_CARET 1)
#  test if GCC supports show-caret and if so, enable.
#     AC_CHECK_PROG(GCC_BIN,gcc,gcc)
#     if test -n "$GCC_BIN"; then
#         AC_MSG_CHECKING([for gcc -fdiagnostics-show-caret])
#         $GCC_BIN -Werror -E -fdiagnostics-show-caret - >/dev/null 2>/dev/null
#         if test $? -eq 0; then
#             AC_MSG_RESULT(yes)
#             AC_DEFINE(HAVE_GCC_SHOW_CARET, 1, [Define to 1 if gcc supports -fdiagnostics-show-caret])
#         else
#             AC_MSG_RESULT(no)
#         fi
#     fi
endif()

option(GCC_FDIRECTIVES_ONLY "Use by default GCC's -fdirectives-only option." ON)
if (GCC_FDIRECTIVES_ONLY)
    set(HAVE_GCC_FDIRECTIVES_ONLY 1)
elseif(NOT GCC_FDIRECTIVES_ONLY)
    # do not enable
else()
    # Assume by default GCC's -fdirectives-only option.
    set(HAVE_GCC_FDIRECTIVES_ONLY 1)
#  test if GCC supports fdirectives-only and if so, enable.
#     AC_CHECK_PROG(GCC_BIN,gcc,gcc)
#     AC_MSG_CHECKING([whether $GCC_BIN -Werror works for unknown options])
#     $GCC_BIN -Werror -totallybogusoption -E - >/dev/null 2>/dev/null
#     if test $? -eq 0; then
#         AC_MSG_RESULT(no)
#         # can't detect if the option is supported, but that's too old clang anyway
#     else
#         AC_MSG_RESULT(yes)
#         AC_MSG_CHECKING([for $GCC_BIN -E -fdirectives-only])
#         $GCC_BIN -Werror -E -fdirectives-only - >/dev/null 2>/dev/null
#         if test $? -eq 0; then
#             AC_MSG_RESULT(yes)
#             AC_DEFINE(HAVE_GCC_FDIRECTIVES_ONLY, 1, [Define to 1 if gcc supports -fdirectives-only])
#         else
#             AC_MSG_RESULT(no)
#         fi
#     fi
endif()

########################################################################
### Santizing
if (${CXXFLAGS} MATCHES "-fsanitize")
    set(SANITIZER_USED 1)
else()
    set(SANITIZER_USED 0)
endif()
message(STATUS "Checking for -fsanitize= usage: ${SANITIZER_USED}")

configure_file(cmake-config.h.in ${PROJECT_BINARY_DIR}/config.h @ONLY)

include_directories(${PROJECT_BINARY_DIR})

add_subdirectory(client)
add_subdirectory(compilerwrapper)
add_subdirectory(daemon)
add_subdirectory(doc)
add_subdirectory(scheduler)
add_subdirectory(services)
add_subdirectory(suse)

#if(NOT DEFINED BUILD_EXPERIMENTAL)
#    message(SEND_ERROR "Cmake build is experimental and should not be used")
#else()
    message("The following things are known not to be finsihed/working in this build")
    message("Using this build implies you are working to fix something in this list")
    message("    Create cmake install configuration - not sure what is left here")
    message("    build on OSX")
    message("    tests")
    message("    building downstream projects (icemon)")
    message("")
    message("There are likely more")
#endif()

# Leftover commands from the configure.ac that I'm not sure we need.
#AC_DISABLE_SHARED # must static link?
#AC_ENABLE_STATIC  # must static link?
