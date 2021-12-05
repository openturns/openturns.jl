cmake_minimum_required (VERSION 3.0)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif ()

project (openturns.jl)

find_package (JlCxx REQUIRED)
find_package (OpenTURNS REQUIRED)
message (STATUS "Found OpenTURNS: ${OPENTURNS_ROOT_DIR} (found version \"${OPENTURNS_VERSION_STRING}\")")

add_library (openturns_julia MODULE src/openturns_julia.cpp src/JuliaEvaluation.cxx src/JuliaFunction.cxx)
target_link_libraries (openturns_julia OT ${Julia_LIBRARY} JlCxx::cxxwrap_julia)
set_target_properties (openturns_julia PROPERTIES PREFIX "")

set (JULIA_INSTALL_PATH share/julia/stdlib/v1.0 CACHE PATH "Julia install directory")

install (FILES src/openturns.jl DESTINATION ${JULIA_INSTALL_PATH})
install (TARGETS openturns_julia DESTINATION lib)

enable_testing ()

add_test (NAME trigger_recompile COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/src/openturns.jl ${PROJECT_BINARY_DIR}/openturns.jl)

macro (ot_add_test name)
  add_test (NAME ${name} COMMAND ${Julia_EXECUTABLE} ${PROJECT_SOURCE_DIR}/test/t_${name}.jl)
  set_tests_properties(${name} PROPERTIES ENVIRONMENT "JULIA_LOAD_PATH=${PROJECT_BINARY_DIR}:;LD_LIBRARY_PATH=${PROJECT_BINARY_DIR}")

  if ("${name}" STREQUAL "import")
    set_tests_properties(${name} PROPERTIES DEPENDS trigger_recompile)
  else ()
    set_tests_properties(${name} PROPERTIES DEPENDS import)
  endif ()
endmacro ()

ot_add_test (import)
ot_add_test (base)
ot_add_test (distribution)
ot_add_test (function)
ot_add_test (montecarlo)
