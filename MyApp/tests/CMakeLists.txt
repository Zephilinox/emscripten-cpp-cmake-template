include(FetchDoctest)
include(ConfigureTarget)
include(CompilerWarnings)

add_executable(myapp_tests
    "main.cpp"
    "myapp.hpp"
)

configure_target(myapp_tests "${MYAPP_CODE_COVERAGE}")
set_target_warnings(myapp_tests "${MYAPP_WARNINGS_AS_ERRORS}")

target_link_libraries(myapp_tests
    PRIVATE
        myapp_object
        doctest::doctest
)

include("${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake")
#doctest_discover_tests(myapp_tests JUNIT_OUTPUT_DIR ".")
doctest_discover_tests(myapp_tests)