function(create_clang_tidy_check target_name string_that_must_be_in_path)
    find_program(ClangTidy clang-tidy)
    if (NOT ClangTidy)
        message(ERROR "Failed to find clang-tidy")
    endif()
    
    find_package(Python3)
    if (NOT Python3_FOUND)
        message(ERROR "Failed to find 'python3'. It is required to use clang-tidy")
    endif()

    if (NOT CMAKE_EXPORT_COMPILE_COMMANDS)
        message(ERROR "'CMAKE_EXPORT_COMPILE_COMMANDS' is not set. It is required to use clang-tidy")
    endif()

    set(FILTER_COMPILE_COMMANDS_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/../scripts/filter-compile-commands.py")
    if (NOT EXISTS "${FILTER_COMPILE_COMMANDS_SCRIPT}")
        message(ERROR "'${FILTER_COMPILE_COMMANDS_SCRIPT}' does not exist. It is required to use clang-tidy")
    endif()

    set(RUN_CLANG_TIDY_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/../scripts/run-clang-tidy.py")
    if (NOT EXISTS "${RUN_CLANG_TIDY_SCRIPT}")
        message(ERROR "'${RUN_CLANG_TIDY_SCRIPT}' does not exist. It is required to use clang-tidy")
    endif()

    set(CLANG_TIDY_COMMANDS
        "-p=${CMAKE_BINARY_DIR}"
        "-db=compile_commands_filtered.json"
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
            "${Python3_EXECUTABLE}"
            "${RUN_CLANG_TIDY_SCRIPT}"
            "${CLANG_TIDY_COMMANDS}"
        COMMENT
            "Running clang-tidy"
        COMMAND_EXPAND_LISTS
        VERBATIM
    )
endfunction()