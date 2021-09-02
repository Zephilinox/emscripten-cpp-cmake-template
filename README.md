
[![MyLib](https://github.com/Zephilinox/emscripten-cpp-cmake-template/actions/workflows/MyLib.yml/badge.svg)](https://github.com/Zephilinox/emscripten-cpp-cmake-template/actions/workflows/MyLib.yml)
[![MyApp](https://github.com/Zephilinox/emscripten-cpp-cmake-template/actions/workflows/MyApp.yml/badge.svg)](https://github.com/Zephilinox/emscripten-cpp-cmake-template/actions/workflows/MyApp.yml)
[![codecov](https://codecov.io/gh/Zephilinox/emscripten-cpp-cmake-template/branch/main/graph/badge.svg)](https://codecov.io/gh/Zephilinox/emscripten-cpp-cmake-template)
[![GitHub license](https://img.shields.io/github/license/Zephilinox/emscripten-cpp-cmake-template.svg)](https://github.com/Zephilinox/emscripten-cpp-cmake-template/blob/main/LICENSE)
[![Website ricardoheath.co.uk/emscripten-cpp-cmake-template/](https://img.shields.io/website-up-down-green-red/https/ricardoheath.co.uk/emscripten-cpp-cmake-template.svg)](https://ricardoheath.co.uk/emscripten-cpp-cmake-template/)

# emscripten-cpp-cmake-template
A template for using emscripten with C++20 and CMake, and using `GLAD` and `SDL2`

- Emscripten web build, deployed to `gh-pages`. [View demo here](https://ricardoheath.co.uk/emscripten-cpp-cmake-template/)
- Linux, Mac, and Windows native builds via `Github Actions`
- Code coverage via `CodeCov`
- Code formatting via `clang-format`
- Static Analysis using `cppcheck` and `clang-tidy`
- Dynamic Analysis using `Address Sanitizer`, `Leak Sanitizer`, `Thread Sanitizer`, and `Undefined Behaviour Sanitizer`
- Unit tests ran using `Valgrind` for runtime memory analysis
- Caching builds via `ccache`
- Caching CMake dependencies via [CPM](https://github.com/cpm-cmake/CPM.cmake)
- Multi-project (Monorepo) setup, with `MyLib` for e.g. a game engine, and `MyApp` for e.g the gameplay code
- Unit tests via [Doctest](https://github.com/onqtam/doctest)
- Benchmarks via [Google Benchmark](https://github.com/google/benchmark)
- Strict compiler warnings due to [cmake/CompilerWarnings](https://github.com/Zephilinox/emscripten-cpp-cmake-template/blob/main/cmake/CompilerWarnings.cmake), taken from [cpp_starter_project](https://github.com/lefticus/cpp_starter_project/blob/master/cmake/CompilerWarnings.cmake)
- No third-party warnings due to [cmake/SetSystemIncludes](https://github.com/Zephilinox/emscripten-cpp-cmake-template/blob/main/cmake/SetSystemIncludes.cmake) and [cmake/CompilerWarnings](https://github.com/Zephilinox/emscripten-cpp-cmake-template/blob/main/cmake/CompilerWarnings.cmake)
- Building [SDL2](https://github.com/libsdl-org/SDL) from source

Note: `glad` and `KHR` were generated from [cmake/FetchGLAD](https://github.com/Zephilinox/emscripten-cpp-cmake-template/blob/main/cmake/FetchGLAD.cmake). Unfortunately the `GLAD` generator doesn't seem to generate `gles2` properly when ran on the Github Actions runners, so it was generated locally and commited to the repo instead.

`main.cpp` of MyApp is from [this Gist](https://gist.github.com/SuperV1234/5c5ad838fe5fe1bf54f9) by [SuperV1234](https://gist.github.com/SuperV1234), with changes based on static analysis and formatting, and small tweaks to get `GLAD` and `SDL` running with `gles2` in native builds.
