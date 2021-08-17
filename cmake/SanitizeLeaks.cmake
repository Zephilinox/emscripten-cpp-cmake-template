if (WIN32)
    message(WARNING "SanitizeLeaks will not work on windows")
    return()
endif()

add_compile_options(
    "-fsanitize=leak"
    "-g"
    "-O1"
    "-fno-omit-frame-pointer"
)
add_link_options("-fsanitize=leak")