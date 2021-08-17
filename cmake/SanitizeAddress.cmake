if (WIN32)
    message(WARNING "SanitizeAddress will not work on windows")
    return()
endif()

add_compile_options(
    "-fsanitize=address"
    "-fno-optimize-sibling-calls"
    "-fsanitize-address-use-after-scope"
    "-g"
    "-O1"
    "-fno-omit-frame-pointer"
)
add_link_options("-fsanitize=address")