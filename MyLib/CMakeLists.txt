cmake_minimum_required(VERSION 3.21)

project(mylib)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

include(CheckIsRoot)
check_project_is_root(MYLIB_IS_ROOT)

option(MYLIB_CI "We are running on CI. May change certain defaults." OFF)
if (MYLIB_CI)
    message(STATUS "MyLib running on CI")
endif()

if (MYLIB_IS_ROOT)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
        set(MYLIB_IS_ROOT_AND_NOT_EMS OFF)
    else()
        set(MYLIB_IS_ROOT_AND_NOT_EMS ON)
    endif()
else()
    set(MYLIB_IS_ROOT_AND_NOT_EMS OFF)
endif()

if (NOT CPM_SOURCE_CACHE)
    set(CPM_SOURCE_CACHE "${CMAKE_CURRENT_SOURCE_DIR}/../.cpmcache")
endif()

option(MYLIB_TESTS "Build the mylib tests" ${MYLIB_IS_ROOT_AND_NOT_EMS})
option(MYLIB_BENCHMARKS "Build the mylib benchmarks" ${MYLIB_IS_ROOT_AND_NOT_EMS})
option(MYLIB_DOWNLOAD_CPM "Download CPM. Disable if you're providing your own version of CPM" ON)
option(MYLIB_CLANG_FORMAT_CHECK "Adds the mylib_clang_format_check target" ${MYLIB_IS_ROOT})
option(MYLIB_CLANG_FORMAT_FIX "Adds the mylib_clang_format_fix target" ${MYLIB_IS_ROOT})
option(MYLIB_CPPCHECK "Adds the mylib_cppcheck target" OFF)
option(MYLIB_CLANG_TIDY_CHECK "Adds the mylib_clang_tidy_check target" OFF)
option(MYLIB_ASAN "Build with ASAN" OFF)
option(MYLIB_LSAN "Build with LSAN" OFF)
option(MYLIB_TSAN "Build with TSAN" OFF)
option(MYLIB_UBSAN "Build with UBSAN" OFF)
option(MYLIB_CODE_COVERAGE "Enable code coverage" OFF)
option(MYLIB_WARNINGS_AS_ERRORS "Treat warnings as errors" ${MYLIB_CI})
option(MYLIB_VALGRIND "Use valgrind to run all executables" OFF)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../dependencies" "${CMAKE_CURRENT_BINARY_DIR}/dependencies")

if (MYLIB_IS_ROOT)
    message(STATUS "MyLib is root")
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

if (MYLIB_DOWNLOAD_CPM)
    message(STATUS "MyLib CPM Download Enabled")
    include(DownloadCPM)
endif()

if (MYLIB_ASAN)
    message(STATUS "MyLib ASAN Enabled")
    include(SanitizeAddress)
endif()

if (MYLIB_LSAN)
    message(STATUS "MyLib LSAN Enabled")
    include(SanitizeLeaks)
endif()

if (MYLIB_TSAN)
    message(STATUS "MyLib TSAN Enabled")
    include(SanitizeThreads)
endif()

if (MYLIB_UBSAN)
    message(STATUS "MyLib UBSAN Enabled")
    include(SanitizeUndefinedBehaviour)
endif()

if (MYLIB_VALGRND)
    message(STATUS "MyLib Valgrind Enabled")
    include(Valgrind)
endif()

add_subdirectory("src")

if (MYLIB_TESTS)
    message(STATUS "MyLib Tests Enabled")
    enable_testing()
    add_subdirectory(tests)
endif()

if (MYLIB_BENCHMARKS)
    message(STATUS "MyLib Benchmarks Enabled")
    add_subdirectory(benchmarks)
endif()

set(MYLIB_LINT_PATHS
    "${CMAKE_CURRENT_SOURCE_DIR}/tests"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks"
)

if (MYLIB_CLANG_FORMAT_CHECK)
    message(STATUS "MyLib clang-format check Enabled")
    include(ClangFormat)
    create_clang_format_check(
        "mylib_clang_format_check"
        "${MYLIB_LINT_PATHS}"
    )
endif()

if (MYLIB_CLANG_FORMAT_FIX)
    message(STATUS "MyLib clang-format fix Enabled")
    include(ClangFormat)
    create_clang_format_fix(
        "mylib_clang_format_fix"
        "${MYLIB_LINT_PATHS}"
    )
endif()

if (MYLIB_CPPCHECK)
    message(STATUS "MyLib cppcheck Enabled")
    include(CPPCheck)
    cppcheck_sources(mylib_cppcheck
        "MyLib/"
        "${MYLIB_LINT_PATHS}"
    )
endif()

if (MYLIB_CLANG_TIDY_CHECK)
    message(STATUS "MyLib clang-tidy check Enabled")
    include(ClangTidy)
    create_clang_tidy_check(mylib_clang_tidy_check "MyLib/")
endif()