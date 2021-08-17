include(SetSystemIncludes)

CPMAddPackage(
    NAME benchmark
    GITHUB_REPOSITORY google/benchmark
    VERSION 1.5.2
    OPTIONS
        "BENCHMARK_ENABLE_TESTING OFF"
        "BENCHMARK_ENABLE_INSTALL OFF"
        "BENCHMARK_ENABLE_GTEST_TESTS OFF"
    EXCLUDE_FROM_ALL YES
)

set_property(TARGET benchmark PROPERTY CXX_STANDARD_REQUIRED TRUE)
set_property(TARGET benchmark PROPERTY CXX_STANDARD 17)
set_property(TARGET benchmark PROPERTY CXX_EXTENSIONS OFF)

set_target_properties(benchmark PROPERTIES FOLDER dependencies)
set_target_includes_as_system(benchmark)

get_target_property(benchmark_SOURCES benchmark SOURCES)
source_group(TREE ${benchmark_SOURCE_DIR} FILES ${benchmark_SOURCES})