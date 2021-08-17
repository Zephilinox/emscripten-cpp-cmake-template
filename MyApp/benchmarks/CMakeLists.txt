include(FetchGoogleBenchmark)
include(ConfigureTarget)
include(CompilerWarnings)

add_executable(myapp_benchmarks
    "main.cpp"
)

configure_target(myapp_benchmarks ${MYAPP_CODE_COVERAGE})
set_target_warnings(myapp_benchmarks ${MYAPP_WARNINGS_AS_ERRORS})

target_link_libraries(myapp_benchmarks
    PRIVATE
        myapp_object
        benchmark::benchmark
)

# Don't use the crosscompiling executor, if it's valgrind they will be very slow.
# We'll rely on static analysis for benchmark leaks. in theory, tests should cover it.
# Also, googlebenchmark has an intentional memory leak, so we'd need to supress it.
add_custom_target(myapp_benchmarks_execute
    COMMAND "$<TARGET_FILE:myapp_benchmarks>"
)