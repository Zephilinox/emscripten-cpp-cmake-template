include(ConfigureTarget)
include(CompilerWarnings)
include(FetchIMGUI)

add_library(myapp_object OBJECT
    "MyApp/Game.hpp"
    "MyApp/Game.cpp"
)

target_link_libraries(myapp_object PUBLIC mylib::mylib imgui)
target_include_directories(myapp_object PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")

if (${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
    target_link_options(myapp_object PUBLIC "-sUSE_SDL=2" "-sUSE_FREETYPE=1")
else()
    if (UNIX AND NOT APPLE)
        target_link_libraries(myapp_object PUBLIC "m" "atomic" "pthread")
    endif ()
endif()

configure_target(myapp_object "${MYAPP_CODE_COVERAGE}")
set_target_warnings(myapp_object "${MYAPP_WARNINGS_AS_ERRORS}")

add_executable(myapp "main.cpp")
add_executable(myapp::myapp ALIAS myapp)
target_link_libraries(myapp PUBLIC myapp_object)

if (${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
    set_target_properties(
        myapp
        PROPERTIES 
            SUFFIX ".html" #change to ".wasm" if you only want the wasm output
    )
endif()

configure_target(myapp "${MYAPP_CODE_COVERAGE}")
set_target_warnings(myapp "${MYAPP_WARNINGS_AS_ERRORS}")