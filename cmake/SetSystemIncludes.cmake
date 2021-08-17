function(set_target_includes_as_system target)
    # Modify interface includes to be interface system includes
    get_target_property(benchmark_includes ${target} INTERFACE_INCLUDE_DIRECTORIES)
    set_property(TARGET ${target} PROPERTY INTERFACE_SYSTEM_INCLUDE_DIRECTORIES ${benchmark_includes})

    # Modify includes to be system includes
    get_target_property(benchmark_includes ${target} INCLUDE_DIRECTORIES)
    set_property(TARGET ${target} PROPERTY INCLUDE_SYSTEM_DIRECTORIES ${benchmark_includes})
endfunction()