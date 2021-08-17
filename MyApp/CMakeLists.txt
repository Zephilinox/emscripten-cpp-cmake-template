cmake_minimum_required(VERSION 3.21)

project(myapp)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

include(CheckIsRoot)
check_project_is_root(MYAPP_IS_ROOT)

add_subdirectory("../MyLib" "${CMAKE_CURRENT_BINARY_DIR}/MyLib")

option(MYAPP_CI "We are running on CI. May change certain defaults." OFF)
if (MYAPP_CI)
    message(STATUS "MyApp running on CI")
endif()

if (MYAPP_IS_ROOT)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
        set(MYAPP_IS_ROOT_AND_NOT_EMS OFF)
    else()
        set(MYAPP_IS_ROOT_AND_NOT_EMS ON)
    endif()
else()
    set(MYAPP_IS_ROOT_AND_NOT_EMS OFF)
endif()

if (NOT CPM_SOURCE_CACHE)
    set(CPM_SOURCE_CACHE "${CMAKE_CURRENT_SOURCE_DIR}/../.cpmcache")
endif()

option(MYAPP_TESTS "Build the myapp tests" ${MYAPP_IS_ROOT_AND_NOT_EMS})
option(MYAPP_BENCHMARKS "Build the myapp benchmarks" ${MYAPP_IS_ROOT_AND_NOT_EMS})
option(MYAPP_INSTALL "Enable cmake install for the myapp" ${MYAPP_IS_ROOT})
option(MYAPP_DOWNLOAD_CPM "Download CPM. Disable if you're providing your own version of CPM" ON)
option(MYAPP_CLANG_FORMAT_CHECK "Adds the myapp_clang_format_check target" ${MYAPP_IS_ROOT})
option(MYAPP_CLANG_FORMAT_FIX "Adds the myapp_clang_format_fix target" ${MYAPP_IS_ROOT})
option(MYAPP_CPPCHECK "Adds the myapp_cppcheck target" OFF)
option(MYAPP_CLANG_TIDY_CHECK "Adds the myapp_clang_tidy_check target" OFF)
option(MYAPP_ASAN "Build with ASAN" OFF)
option(MYAPP_LSAN "Build with LSAN" OFF)
option(MYAPP_TSAN "Build with TSAN" OFF)
option(MYAPP_UBSAN "Build with UBSAN" OFF)
option(MYAPP_CODE_COVERAGE "Enable code coverage" OFF)
option(MYAPP_WARNINGS_AS_ERRORS "Treat warnings as errors" ${MYAPP_CI})
option(MYAPP_VALGRIND "Use valgrind to run all executables" OFF)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../dependencies" "${CMAKE_CURRENT_BINARY_DIR}/dependencies")

if (MYAPP_IS_ROOT)
    message(STATUS "MyApp is root")
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

if (MYAPP_DOWNLOAD_CPM)
    message(STATUS "MyApp CPM Download Enabled")
    include(DownloadCPM)
endif()

if (MYAPP_ASAN)
    message(STATUS "MyApp ASAN Enabled")
    include(SanitizeAddress)
endif()

if (MYAPP_LSAN)
    message(STATUS "MyApp LSAN Enabled")
    include(SanitizeLeaks)
endif()

if (MYAPP_TSAN)
    message(STATUS "MyApp TSAN Enabled")
    include(SanitizeThreads)
endif()

if (MYAPP_UBSAN)
    message(STATUS "MyApp UBSAN Enabled")
    include(SanitizeUndefinedBehaviour)
endif()

if (MYAPP_VALGRND)
    message(STATUS "MyApp Valgrind Enabled")
    include(Valgrind)
endif()

add_subdirectory("src")

if (MYAPP_INSTALL)
    message(STATUS "MyApp Install Enabled")
    install(
        DIRECTORY "$<TARGET_FILE_DIR:myapp>"
        DESTINATION "."
    )
endif()

if (MYAPP_EXAMPLES)
    message(STATUS "MyApp Examples Enabled")
    add_subdirectory(examples)
endif()

if (MYAPP_TESTS)
    message(STATUS "MyApp Tests Enabled")
    enable_testing()
    add_subdirectory(tests)
endif()

if (MYAPP_BENCHMARKS)
    message(STATUS "MyApp Benchmarks Enabled")
    add_subdirectory(benchmarks)
endif()

set(MYAPP_LINT_PATHS
    "${CMAKE_CURRENT_SOURCE_DIR}/tests"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks"
)

if (MYAPP_CLANG_FORMAT_CHECK)
    message(STATUS "MyApp clang-format check Enabled")
    include(ClangFormat)
    create_clang_format_check(
        "myapp_clang_format_check"
        "${MYAPP_LINT_PATHS}"
    )
endif()

if (MYAPP_CLANG_FORMAT_FIX)
    message(STATUS "MyApp clang-format fix Enabled")
    include(ClangFormat)
    create_clang_format_fix(
        "myapp_clang_format_fix"
        "${MYAPP_LINT_PATHS}"
    )
endif()

if (MYAPP_CPPCHECK)
    message(STATUS "MyApp cppcheck Enabled")
    include(CPPCheck)
    cppcheck_sources(myapp_cppcheck
        "MyApp/"
        "${MYAPP_LINT_PATHS}"
    )
endif()

if (MYAPP_CLANG_TIDY_CHECK)
    message(STATUS "MyApp clang-tidy check Enabled")
    include(ClangTidy)
    create_clang_tidy_check(myapp_clang_tidy_check "MyApp/")
endif()