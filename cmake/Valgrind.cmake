find_program(Valgrind valgrind)
if (NOT Valgrind)
    message(SEND_ERROR "Valgrind could not be found")
endif()

if (CMAKE_CROSSCOMPILING_EMULATOR)
    message(SEND_ERROR "Valgrind can not be used with a cross-compiling emulator, as we will set it as the emulator")
endif()

if (NOT CMAKE_CROSSCOMPILING)
    set(CMAKE_CROSSCOMPILING ON)
endif()

set(CMAKE_CROSSCOMPILING_EMULATOR "valgrind"
    "--leak-check=full"
    "--show-leak-kinds=all"
    "--track-origins=yes"
    "--error-exitcode=1"
)