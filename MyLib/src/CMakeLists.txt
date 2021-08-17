include(ConfigureTarget)
include(CompilerWarnings)

add_library(mylib
    "MyLib/Library.hpp"
    "MyLib/Library.cpp"
)
add_library(mylib::mylib ALIAS mylib)

target_include_directories(mylib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")

if(${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
    target_link_options(mylib PUBLIC "-sUSE_SDL=2" "-sUSE_FREETYPE=1")
else()
    include(FetchSDL2)
    find_package(OpenGL)

    # glad is available from a previous call to add_subdirectory("dependencies")
    target_link_libraries(mylib PUBLIC SDL2-static OpenGL::GL glad)

    if (UNIX AND NOT APPLE)
        target_link_libraries(mylib PUBLIC "m" "atomic" "pthread")
    endif ()
endif()

configure_target(mylib "${MYLIB_CODE_COVERAGE}")
set_target_warnings(mylib "${MYLIB_WARNINGS_AS_ERRORS}")