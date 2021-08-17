include(FetchDoctest)
include(ConfigureTarget)
include(CompilerWarnings)

add_executable(mylib_tests
    "main.cpp"
    "mylib.hpp"
)

configure_target(mylib_tests ${MYLIB_CODE_COVERAGE})
set_target_warnings(mylib_tests ${MYLIB_WARNINGS_AS_ERRORS})

target_link_libraries(mylib_tests
    PRIVATE
        mylib::mylib
        doctest::doctest
)

include("${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake")
#doctest_discover_tests(mylib_tests JUNIT_OUTPUT_DIR ".")
doctest_discover_tests(mylib_tests)