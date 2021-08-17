//SELF
#include "mylib.hpp"

//LIBS
#define DOCTEST_CONFIG_IMPLEMENT
#include <doctest/doctest.h>

//STD

auto main(int argc, char** argv) -> int
{
    doctest::Context context;
    context.applyCommandLine(argc, argv);
    context.setOption("no-breaks", static_cast<int>(true));
    context.setOption("--version", static_cast<int>(true));
    context.setOption("--count", static_cast<int>(true));
    context.setOption("--list-test-cases", static_cast<int>(true));
    context.setOption("--list-test-suites", static_cast<int>(true));
    context.setOption("--success", static_cast<int>(false));
    context.setOption("--exit", static_cast<int>(true));

    const int result = context.run();
    if (context.shouldExit())
        return result;

    return result;
}