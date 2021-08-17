include(SetSystemIncludes)
include(CompilerWarnings)

CPMAddPackage(
    NAME SDL2
    GITHUB_REPOSITORY libsdl-org/SDL
    GIT_TAG release-2.0.16
    EXCLUDE_FROM_ALL "YES"
)

set_target_properties(SDL2-static PROPERTIES FOLDER dependencies)
target_include_directories(SDL2-static SYSTEM PUBLIC
    $<BUILD_INTERFACE:${SDL2_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)
set_target_includes_as_system(SDL2-static)
set_target_warnings_disabled(SDL2-static)

if (TARGET SDL2)
    set_target_includes_as_system(SDL2)
    set_target_warnings_disabled(SDL2)
endif()

if (TARGET SDL2main)
    set_target_includes_as_system(SDL2main)
    set_target_warnings_disabled(SDL2main)
endif()

if (TARGET hidapi)
    set_target_includes_as_system(hidapi)
    set_target_warnings_disabled(hidapi)
endif()

get_target_property(SDL2_SOURCES SDL2-static SOURCES)
source_group(TREE ${SDL2_SOURCE_DIR} FILES ${SDL2_SOURCES})