cmake_minimum_required(VERSION 3.20.5)

project(monkey)

option(ASAN "Address Sanitizer" OFF)
option(CCACHE "ccache" OFF)
option(GOLD "Gold linker" OFF)
option(COVERAGE "Code coverage" OFF)
option(OPTIMIZE "Compiler optimizations" ON)

# Enable compilation database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(PkgConfig REQUIRED)
find_package(fmt REQUIRED)
pkg_check_modules(JANSSON REQUIRED jansson)

if(CCACHE)
    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
    endif()
endif()

set(COMMON_COMPILE_OPTIONS -Werror -Wall -g)
set(COMMON_COMPILE_FEATURES cxx_std_17)
set(COMMON_LINK_OPTIONS "")

if(GOLD)
    list(APPEND COMMON_LINK_OPTIONS -fuse-ld=gold)
endif()

if(ASAN)
    list(APPEND COMMON_COMPILE_OPTIONS -fsanitize=address)
    list(APPEND COMMON_LINK_OPTIONS -fsanitize=address)
endif()

if(COVERAGE)
    list(APPEND COMMON_COMPILE_OPTIONS --coverage)
    list(APPEND COMMON_LINK_OPTIONS --coverage)
endif()

if(OPTIMIZE)
    list(APPEND COMMON_COMPILE_OPTIONS -O3)
endif()

add_library(jansson_ INTERFACE)
target_link_libraries(jansson_ INTERFACE ${JANSSON_LIBRARIES})
target_include_directories(jansson_ INTERFACE ${JANSSON_INCLUDE_DIRS})
target_compile_options(jansson_ INTERFACE ${JANSSON_CFLAGS_OTHER})

add_executable(dirlist
    dirlist.cc)

target_compile_options(dirlist PUBLIC ${COMMON_COMPILE_OPTIONS})
target_compile_features(dirlist PUBLIC ${COMMON_COMPILE_FEATURES})
target_link_options(dirlist PUBLIC ${COMMON_LINK_OPTIONS})
target_link_libraries(dirlist PUBLIC fmt jansson_)

add_executable(filelist
    filelist.cc)

target_compile_options(filelist PUBLIC ${COMMON_COMPILE_OPTIONS})
target_compile_features(filelist PUBLIC ${COMMON_COMPILE_FEATURES})
target_link_options(filelist PUBLIC ${COMMON_LINK_OPTIONS})
target_link_libraries(filelist PUBLIC fmt jansson_)

add_executable(scandir
    scandir.cc)

target_compile_options(scandir PUBLIC ${COMMON_COMPILE_OPTIONS})
target_compile_features(scandir PUBLIC ${COMMON_COMPILE_FEATURES})
target_link_options(scandir PUBLIC ${COMMON_LINK_OPTIONS})
target_link_libraries(scandir PUBLIC fmt jansson_)
