include(CompilerWarnings)

if (NOT TARGET glad)
    # Prefer using cmake/FetchGLAD over this, if possible

    add_library(glad
        "${CMAKE_CURRENT_SOURCE_DIR}/glad/glad.h"
        "${CMAKE_CURRENT_SOURCE_DIR}/glad/glad.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/KHR/khrplatform.h"
    )
    target_include_directories(glad SYSTEM PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
    set_target_warnings_disabled(glad)
    get_target_property(glad_SOURCES glad SOURCES)
    source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${glad_SOURCES})
    set_target_properties(glad PROPERTIES FOLDER dependencies)
endif()

# Note: other dependencies are fetched via CPM, such as cmake/FetchIMGUI.cmake