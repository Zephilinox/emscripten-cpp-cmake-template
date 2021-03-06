if (NOT TARGET code_coverage)
    add_library(code_coverage INTERFACE)
    target_compile_options(code_coverage INTERFACE -O0 -g --coverage)
    target_link_options(code_coverage INTERFACE --coverage)
endif()

function(target_code_coverage target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        target_link_libraries(${target} PRIVATE code_coverage)
    else()
        message(FATAL_ERROR "Tried to add Code Coverage for target '${target}' but the compiler is not GCC or Clang, so Code Coverage is not supported")
    endif()
endfunction()