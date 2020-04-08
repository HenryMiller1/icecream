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


#todo latter: - this is needed before tests
#     icecc-create-env
#    icecc-create-env.in

#todo - move this to a new location
add_library(md5 OBJECT
    md5.c
    md5.h
)

add_executable(icecc-bin
    argv.c
    argv.h
    arg.cpp
    client.h
    cpp.cpp
    local.cpp
    main.cpp
    remote.cpp
    safeguard.cpp
    util.cpp
    util.h
    $<TARGET_OBJECTS:md5>
)
set_target_properties(icecc-bin
  PROPERTIES OUTPUT_NAME icecc)

target_compile_definitions(icecc-bin
  PRIVATE
    "-DPLIBDIR=\"${CMAKE_INSTALL_PREFIX}/libexec/icecc\"")

target_link_libraries(icecc-bin
    icecc
)

install(TARGETS icecc-bin 
        RUNTIME DESTINATION bin
)

set(PKGLIBEXECDIR "${CMAKE_INSTALL_PREFIX}/libexec/icecc")
configure_file(icecc-create-env.in icecc-create-env @ONLY)
configure_file(icecc-test-env.in icecc-test-env @ONLY)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/icecc-create-env
    ${CMAKE_CURRENT_BINARY_DIR}/icecc-test-env
    DESTINATION bin
    PERMISSIONS WORLD_EXECUTE OWNER_EXECUTE GROUP_EXECUTE WORLD_READ OWNER_READ GROUP_READ OWNER_WRITE
)

include(${CMAKE_SOURCE_DIR}/Modules/install_symlink.cmake)
install_symlink(${CMAKE_INSTALL_PREFIX}/bin/icecc ${CMAKE_INSTALL_PREFIX}/bin/icerun)

install_symlink(${CMAKE_INSTALL_PREFIX}/bin/icecc-create-env ${CMAKE_INSTALL_PREFIX}/libexec/icecc/icecc-create-env)

set(compilers g++ gcc c++ cc ${CLANG_SYMLINK_WRAPPERS})
install(DIRECTORY DESTINATION ${CMAKE_INSTALL_PREFIX}/libexec/icecc/bin)
foreach(link IN LISTS compilers) 
    install_symlink(${CMAKE_INSTALL_PREFIX}/bin/icecc ${CMAKE_INSTALL_PREFIX}/libexec/icecc/bin/${link})
endforeach()
