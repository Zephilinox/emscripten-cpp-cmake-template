if (WIN32)
    message(WARNING "SanitizeUndefinedBehaviour will not work on windows")
    return()
endif()

#note: only nonnull undefined behaviour is ignored
add_compile_options(
    "-fsanitize=undefined"
    "-fsanitize=shift"
    "-fsanitize=shift-exponent"
    "-fsanitize=shift-base"
    "-fsanitize=integer-divide-by-zero"
    "-fsanitize=unreachable"
    "-fsanitize=vla-bound"
    "-fsanitize=null"
    "-fsanitize=return"
    "-fsanitize=signed-integer-overflow"
    "-fsanitize=bounds"
    "-fsanitize=bounds-strict"
    "-fsanitize=alignment"
    "-fsanitize=object-size"
    "-fsanitize=float-divide-by-zero"
    "-fsanitize=float-cast-overflow"
    "-fsanitize=bool"
    "-fsanitize=enum"
    "-fsanitize=vptr"
    "-fsanitize=pointer-overflow"
    "-fsanitize=builtin"
    "-g"
    "-O1"
    "-fno-omit-frame-pointer"
)
add_link_options("-fsanitize=undefined")