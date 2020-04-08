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

include(${CMAKE_SOURCE_DIR}/Modules/CMakeMacroLibtoolFile.cmake)


add_library(icecc STATIC
  job.cpp
  job.h 
  comm.cpp 
  comm.h
  exitcode.cpp 
  exitcode.h
  getifaddrs.cpp 
  getifaddrs.h
  logging.cpp 
  logging.h
  ncpus.c 
  ncpus.h
  pipes.cpp 
  pipes.h
  tempfile.c 
  tempfile.h
  platform.cpp 
  platform.h
  gcc.cpp
  util.cpp
  util.h)


target_link_libraries(icecc
    PRIVATE
        LZO::lzo
        Zstd::Zstd
        dl)
        
if(Libcap-ng_FOUND)
  target_link_libraries(icecc
    PRIVATE
    Libcap-ng::Libcap-ng)
  set(CAPNG_LDADD "-lcap-ng")
endif()

target_include_directories(icecc PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include/>  # <prefix>/include
)

libtool_create_control_file(icecc)


set(prefix "${CMAKE_INSTALL_PREFIX}")
set(exec_prefix "\$\{prefix\}")
set(libdir "\$\{exec_prefix\}/lib")
set(includedir "\$\{prefix\}/include")
configure_file(icecc.pc.in icecc.pc @ONLY)
unset(prefix)
unset(exec_prefix)
unset(libdir)
unset(includedir)
unset(CAPNG_LDADD)

install(TARGETS icecc
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libicecc.la
        DESTINATION lib
        PERMISSIONS WORLD_EXECUTE OWNER_EXECUTE GROUP_EXECUTE WORLD_READ OWNER_READ GROUP_READ OWNER_WRITE
)

install(FILES comm.h
              job.h
              logging.h
        DESTINATION include/icecc
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/icecc.pc
        DESTINATION lib/pkgconfig)
