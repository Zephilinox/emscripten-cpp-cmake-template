function(cppcheck_sources target_name string_that_must_be_in_path sources)
    find_program(CPPCHECK cppcheck)
    if (NOT CPPCHECK)
        message(ERROR "Failed to find cppcheck")
    endif()
    
    find_package(Python3)
    if (NOT Python3_FOUND)
        message(ERROR "Failed to find 'python3'. It is required to use cppcheck")
    endif()

    if (NOT CMAKE_EXPORT_COMPILE_COMMANDS)
        message(ERROR "'CMAKE_EXPORT_COMPILE_COMMANDS' is not set. It is required to use cppcheck")
    endif()

    set(FILTER_COMPILE_COMMANDS_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/../scripts/filter-compile-commands.py")
    if (NOT EXISTS "${FILTER_COMPILE_COMMANDS_SCRIPT}")
        message(ERROR "'${FILTER_COMPILE_COMMANDS_SCRIPT}' does not exist. It is required to use cppcheck")
    endif()

    set(CPPCHECK_DIR "${CMAKE_CURRENT_BINARY_DIR}/cppcheck")
    set(CPPCHECK_COMMANDS
        "--enable=all"
        "--cppcheck-build-dir=${CPPCHECK_DIR}"
        "--error-exitcode=2"
        "--inline-suppr"
        "--suppress=missingIncludeSystem"
        "--suppress=preprocessorErrorDirective"
        "--suppress=unmatchedSuppression"
        "--project=compile_commands_filtered.json"
    )

    add_custom_target("${target_name}"
        COMMAND
            "${Python3_EXECUTABLE}"
            "${FILTER_COMPILE_COMMANDS_SCRIPT}"
            "${CMAKE_BINARY_DIR}/compile_commands.json"
            "${CMAKE_BINARY_DIR}/compile_commands_filtered.json"
            "_deps"
            "${string_that_must_be_in_path}"
        COMMAND
            "${CMAKE_COMMAND}" "-E" "make_directory" "${CPPCHECK_DIR}"
        COMMAND
            "${CPPCHECK}" "${CPPCHECK_COMMANDS}" "${sources}"
        COMMENT
            "Running cppcheck"
        COMMAND_EXPAND_LISTS
        VERBATIM
    )
endfunction()