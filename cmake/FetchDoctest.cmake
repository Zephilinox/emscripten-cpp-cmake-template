include(SetSystemIncludes)

CPMAddPackage(
    NAME doctest
    GITHUB_REPOSITORY onqtam/doctest
    GIT_TAG 2.4.5
    EXCLUDE_FROM_ALL "YES"
    OPTIONS
        "DOCTEST_WITH_MAIN_IN_STATIC_LIB OFF"
)

file(GLOB_RECURSE doctest_SOURCES CONFIGURE_DEPENDS ${doctest_SOURCE_DIR}/*.hpp ${doctest_SOURCE_DIR}/*.h ${doctest_SOURCE_DIR}/*.c ${doctest_SOURCE_DIR}/*.cpp)

source_group(TREE ${doctest_SOURCE_DIR} FILES ${doctest_SOURCES})
set_target_properties(doctest PROPERTIES FOLDER dependencies)
set_target_includes_as_system(doctest)