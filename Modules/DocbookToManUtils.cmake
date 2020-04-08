#Copyright 2020 Brian Hall as part of the icecream program
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

function(add_docs)
	foreach(xmlfile IN LISTS ARGN)
		get_filename_component(xmlfileext "${xmlfile}" EXT)
		get_filename_component(xmlbasename "${xmlfile}" NAME_WE)
		string(REGEX MATCH "([1-9])" man_number "${xmlfileext}")
		set(man_number ${CMAKE_MATCH_1})
		string(REPLACE "man-" "" docfilename "${xmlbasename}")
		string(CONCAT targetfilename "${docfilename}" "." "${man_number}")
		list(APPEND doc_targets ${targetfilename})
	    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${targetfilename}
                               COMMAND ${DocbookToMan_EXE} ${CMAKE_CURRENT_SOURCE_DIR}/${xmlfile}
	                       MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/${xmlfile}
	    ) 	

		string(CONCAT docpath "share/man/man" "${man_number}")	
	    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${targetfilename}
            	DESTINATION ${docpath}
        )	    
	endforeach()
	

	add_custom_target(docs ALL
						DEPENDS ${doc_targets})
endfunction()

