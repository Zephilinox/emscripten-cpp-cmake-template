include(SetSystemIncludes)
include(CompilerWarnings)

CPMAddPackage(
    NAME imgui
    GITHUB_REPOSITORY ocornut/imgui
    VERSION 1.84.1
    DOWNLOAD_ONLY # IMGUI does not provide a CMakeLists.txt
)

add_library(imgui STATIC
    "${imgui_SOURCE_DIR}/imgui.h"
    "${imgui_SOURCE_DIR}/imgui_internal.h"
    "${imgui_SOURCE_DIR}/imstb_rectpack.h"
    "${imgui_SOURCE_DIR}/imstb_textedit.h"
    "${imgui_SOURCE_DIR}/imstb_truetype.h"

    "${imgui_SOURCE_DIR}/imgui.cpp"
    "${imgui_SOURCE_DIR}/imgui_demo.cpp"
    "${imgui_SOURCE_DIR}/imgui_draw.cpp"
    "${imgui_SOURCE_DIR}/imgui_tables.cpp"
    "${imgui_SOURCE_DIR}/imgui_widgets.cpp"

    "${imgui_SOURCE_DIR}/backends/imgui_impl_sdl.h"
    "${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.h"

    "${imgui_SOURCE_DIR}/backends/imgui_impl_sdl.cpp"
    "${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp"
)
add_library(imgui::imgui ALIAS imgui)

if (${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
    target_compile_options(imgui PUBLIC "-sUSE_SDL=2;-sUSE_FREETYPE=1")
else()
    if (NOT TARGET glad)
        message(SEND_ERROR
            "IMGUI needs an OpenGL loader, such as glad. Please modify this script if you are not using glad, otherwise, make sure glad is available before including imgui")
    endif()

    if (NOT TARGET SDL2-static)
        message(SEND_ERROR
            "IMGUI needs to specify an implementation, such as sdl. Please modify this script if you are not using sdl, otherwise, make sure sdl is available before including imgui")
    endif()

    target_link_libraries(imgui SDL2-static)
    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLAD GL_GLEXT_PROTOTYPES=1)
endif()

target_include_directories(imgui SYSTEM PUBLIC
    "${imgui_SOURCE_DIR}" # Frustratingly, IMGUI sources are in the root of the repository
)

set_target_warnings_disabled(imgui)
set_target_properties(imgui PROPERTIES FOLDER dependencies)

# Make all IMGUI files visible, even if we're only using a few
file(GLOB_RECURSE imgui_sources CONFIGURE_DEPENDS ${imgui_SOURCE_DIR}/*.hpp ${imgui_SOURCE_DIR}/*.h ${imgui_SOURCE_DIR}/*.c ${imgui_SOURCE_DIR}/*.cpp)
source_group(TREE ${imgui_SOURCE_DIR} FILES ${imgui_sources})