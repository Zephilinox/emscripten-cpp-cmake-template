//SELF

//LIBS
#include <benchmark/benchmark.h>

auto main(int argc, char** argv) -> int
{
    benchmark::Initialize(&argc, argv);
    benchmark::RunSpecifiedBenchmarks();

    return 0;
}