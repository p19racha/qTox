# cmake-format: off
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2019 by The qTox Project Contributors
# Copyright © 2024-2025 The TokTok team
# cmake-format: on

project(qtox_warnings)

add_library(${PROJECT_NAME} INTERFACE)
add_library(qtox::warnings ALIAS ${PROJECT_NAME})

# Simplified for GCC/Clang on Linux only
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CLANG ON)
endif()

include(CheckCXXCompilerFlag)
check_cxx_compiler_flag(-Wweak-vtables COMPILER_SUPPORTS_WARNING_WEAK_VTABLES)
check_cxx_compiler_flag(-Wdate-time COMPILER_SUPPORTS_WDATE_TIME)

target_compile_options(
  ${PROJECT_NAME}
  INTERFACE
    $<$<OR:$<BOOL:${CLANG}>,$<CXX_COMPILER_ID:GNU>>:
    -fno-common;
    -fstrict-overflow;
    -ftrapv;
    -pedantic-errors;
    -Wall;
    -Wcast-align;
    -Wdouble-promotion;
    -Wextra;
    -Wformat=2;
    -Wmissing-declarations;
    -Wnon-virtual-dtor;
    -Wnull-dereference;
    -Wold-style-cast;
    -Woverloaded-virtual;
    -Wshadow;
    -Wsign-compare;
    -Wundef;
    >
    $<$<CXX_COMPILER_ID:GNU>:
    -Wduplicated-cond;
    -Wlogical-op;
    >
    $<$<BOOL:${CLANG}>:
    -Wmissing-variable-declarations;
    -Wno-gnu-zero-variadic-macro-arguments; # Required for gtest 1.10.
    >
    $<$<BOOL:${STRICT_OPTIONS}>:
    -Werror;
    >
    $<$<BOOL:${COMPILER_SUPPORTS_WARNING_WEAK_VTABLES}>:
    -Wweak-vtables; # https://llvm.org/docs/CodingStandards.html#provide-a-virtual-method-anchor-for-classes-in-headers
    >
    $<$<BOOL:${COMPILER_SUPPORTS_WDATE_TIME}>:
    -Wdate-time; # avoid timestamps in binary for reproducible builds, not added
                 # until GCC 4.9
    >
    # Linux-specific warnings
    -Wstack-protector;
    )
