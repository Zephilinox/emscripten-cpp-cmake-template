include(SetSystemIncludes)
include(CompilerWarnings)

CPMAddPackage(
    NAME glad
    GITHUB_REPOSITORY Dav1dde/glad
    GIT_TAG v0.1.34
    OPTIONS
        "GLAD_API gles2="
        "GLAD_SPEC gl;egl"
        "GLAD_PROFILE compatibility"
        "GLAD_ALL_EXTENSIONS ON"
        "GLAD_REPRODUCIBLE ON"
        "GLAD_NO_LOADER OFF"
        "GLAD_GENERATOR c"
    EXCLUDE_FROM_ALL "YES"
)

source_group(TREE ${glad_SOURCE_DIR} FILES ${glad_SOURCES})
set_target_properties(glad PROPERTIES FOLDER dependencies)
set_target_properties(glad-generate-files PROPERTIES FOLDER dependencies)
set_target_includes_as_system(glad)
set_target_warnings_disabled(glad)

#Note: the GLAD generator doesn't seem to generate an OpenGL ES API on Github Action runners.
#If you don't have that issue due to using your own or different runners
#  then I encourage you to use this cmake file rather than comitting the generated sources it to your repository