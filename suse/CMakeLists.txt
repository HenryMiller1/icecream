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

install(PROGRAMS init.icecream 
        DESTINATION etc/init.d
        RENAME icecream
)

install(FILES logrotate
        DESTINATION etc/logrotate.d
        RENAME icecream
)

install(FILES sysconfig.icecream
        DESTINATION etc/sysconfig
        RENAME icecream
)


set(IS_SUSE_HOST False)
if (EXISTS /etc/os-release)
    file(STRINGS /etc/os-release OS_RELEASE_STRINGS)
    foreach(NEXT_OS_STRING IN LISTS OS_RELEASE_STRINGS)
        if ("${NEXT_OS_STRING}" STREQUAL "ID_LIKE=\"suse\"")
            set(IS_SUSE_HOST True)
        endif()
    endforeach()
endif()    
if (EXISTS /etc/SuSE-release)
    #old SuSE host, before /etc/os-release was standardized
    set(IS_SUSE_HOST True)
endif()

if (IS_SUSE_HOST)
    install(FILES SuSEfirewall.iceccd
            DESTINATION etc/sysconfig/SuSEfirewall2.d/services
            RENAME iceccd
    )

    install(FILES SuSEfirewall.scheduler
            DESTINATION etc/sysconfig/SuSEfirewall2.d/services
            RENAME icecream-scheduler
    )
endif()
