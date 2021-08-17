macro(check_can_run_clang_format)
    find_program(CLANG_FORMAT clang-format)
    if (NOT CLANG_FORMAT)
        message(SEND_ERROR "Failed to find clang-format")
    endif()

    find_package(Python3)
    if (NOT Python3_FOUND)
        message(SEND_ERROR "Failed to find python3")
    endif()

    set(RUN_CLANG_FORMAT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../scripts/run-clang-format.py")
    if (NOT EXISTS "${RUN_CLANG_FORMAT_FILE}")
        message(SEND_ERROR "Failed to find '${RUN_CLANG_FORMAT_FILE}'")
    endif()

    set(CLANG_FORMAT_COMMAND "${Python3_EXECUTABLE}" "${RUN_CLANG_FORMAT_FILE}")
endmacro()

function(create_clang_format_check target directories)
    check_can_run_clang_format()

    add_custom_target(${target}
        COMMAND
            ${CLANG_FORMAT_COMMAND}
            "-r"
            ${directories}
    )
endfunction()

function(create_clang_format_fix target directories)
    check_can_run_clang_format()

    add_custom_target(${target}
        COMMAND
            ${CLANG_FORMAT_COMMAND}
            "-r"
            "-i"
            ${directories}
    )
endfunction()