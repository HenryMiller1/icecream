 
function(install_symlink filepath linkpath)
    install(CODE "message(\"Creating symlink ${filepath}->${linkpath})\")")
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${linkpath})")
endfunction()

#if (EXISTS "${filepath}")
#    message("making the link :-)")
#    execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${linkpath})
#else()
#    message(SEND_ERROR "Cannot create symlink because of missing source ${filepath}")
#endif()
