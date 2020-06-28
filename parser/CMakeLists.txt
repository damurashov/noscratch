#
# Parser project
#

project(parser)

cmake_minimum_required(VERSION 3.10.0)

# Check if a program installed
macro(program_required PROGNAME)
    find_program(SEARCHRESULT ${PROGNAME}) 
    if(NOT SEARCHRESULT)
        message(SEND_ERROR "Unmet dependency: ${PROGNAME}")
    endif()
endmacro()

# Phony command, TODO replace it with smthng sensible later
add_custom_target(parser
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/parser.cmake) 

# Check all required programs are in place
program_required(flex)
program_required(bison)
#program_required(vally)

# Invoke parser source generation
add_custom_command(TARGET parser PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "wow" > home/sleeplynerd/.deletemetext
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
add_custom_command(TARGET parser PRE_BUILD
    COMMAND bison -d ${CMAKE_CURRENT_SOURCE_DIR}/flexbison/lang.y
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
add_custom_command(TARGET parser PRE_BUILD 
    COMMAND flex ${CMAKE_CURRENT_SOURCE_DIR}/flexbison/lang.l
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
