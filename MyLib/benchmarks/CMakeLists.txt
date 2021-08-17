include(FetchGoogleBenchmark)
include(ConfigureTarget)
include(CompilerWarnings)

add_executable(mylib_benchmarks "main.cpp"
)

configure_target(mylib_benchmarks "${MYLIB_CODE_COVERAGE}")
set_target_warnings(mylib_benchmarks "${MYLIB_WARNINGS_AS_ERRORS}")

target_link_libraries(mylib_benchmarks
    PRIVATE
        mylib::mylib
        benchmark::benchmark
)

# Don't use the crosscompiling executor, if it's valgrind they will be very slow.
# We'll rely on static analysis for benchmark leaks. in theory, tests should cover it.
# Also, googlebenchmark has an intentional memory leak, so we'd need to supress it.
add_custom_target(mylib_benchmarks_execute
    COMMAND "$<TARGET_FILE:mylib_benchmarks>"
)