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

if (DocbookToMan_FOUND)
    include(${CMAKE_SOURCE_DIR}/Modules/DocbookToManUtils.cmake)

    set(man_xmls 
      man-icecc-create-env.1.xml
      man-icecc-scheduler.1.xml
      man-icecc.1.xml
      man-iceccd.1.xml
      man-icerun.1.xml
      man-icecream.7.xml      
    )
    add_docs(${man_xmls})

else()
    message("docbook-to-man executable not found, man pages will not be generated")
endif()
