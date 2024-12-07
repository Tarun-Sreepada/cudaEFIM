cmake_minimum_required(VERSION 3.18)
project(cuEFIM LANGUAGES CXX CUDA)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CUDA compilation with separable compilation
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

# Set build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug) # Default to Debug mode
endif()

# Set optimization and debugging flags
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
set(CMAKE_CUDA_FLAGS_DEBUG "-O0 -g")
set(CMAKE_CUDA_FLAGS_RELEASE "-O3")

# Add a DEBUG define for Debug builds
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# Enable memory sanitization for C++ (host) code in Debug mode
if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=address")
endif()

# Auto-detect CUDA architectures
if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES native) # Adjust for your target architectures
endif()

# Include directories
include_directories(include)
include_directories(${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}) # Include CUDA headers

# Collect source files
file(GLOB_RECURSE SRC_CPP_FILES src/*.cpp) # Collect all .cpp files
file(GLOB_RECURSE SRC_CU_FILES src/*.cu)   # Collect all .cu files

# Find and link liburing
find_library(LIBURING_LIB NAMES uring REQUIRED)
if(NOT LIBURING_LIB)
    message(FATAL_ERROR "liburing not found. Please ensure it is installed and accessible.")
endif()

find_path(LIBURING_INCLUDE_DIR NAMES liburing.h REQUIRED)
if(NOT LIBURING_INCLUDE_DIR)
    message(FATAL_ERROR "liburing.h not found. Please ensure it is installed and accessible.")
endif()

include_directories(${LIBURING_INCLUDE_DIR})

# Add the executable
add_executable(cuEFIM
    main.cu   # Entry point
    ${SRC_CPP_FILES} # All .cpp files
    ${SRC_CU_FILES}  # All .cu files
)

# Set properties for the target
set_target_properties(cuEFIM PROPERTIES
    CUDA_ARCHITECTURES "${CMAKE_CUDA_ARCHITECTURES}"
    CUDA_SEPARABLE_COMPILATION ON
)

# Link liburing and CUDA runtime
target_link_libraries(cuEFIM PRIVATE ${LIBURING_LIB} cuda)

# Print nvcc version
message(STATUS "Querying nvcc version...")
execute_process(
    COMMAND ${CMAKE_CUDA_COMPILER} --version
    OUTPUT_VARIABLE NVCC_VERSION_OUTPUT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "nvcc version:\n${NVCC_VERSION_OUTPUT}")

# Print CUDA architecture
message(STATUS "CUDA architectures: ${CMAKE_CUDA_ARCHITECTURES}")




message(STATUS "--------------------------------------------------------------------")
message(STATUS "cuEFIM:")
message(STATUS "--------------------------------------------------------------------")
message(STATUS "To compile, run:")
message(STATUS "  make -j$(nproc)")
message(STATUS "--------------------------------------------------------------------")
message(STATUS "Usage Instructions for cuEFIM:")
message(STATUS "--------------------------------------------------------------------")
message(STATUS "To display help:")
message(STATUS "  ./cuEFIM -h")
message(STATUS "  ./cuEFIM --help")
message(STATUS "")
message(STATUS "To run cuEFIM:")
message(STATUS " \n ./cuEFIM --input-file /datasets/accidents_utility_spmf.txt --output-file /dev/stdout --separator \\s --min-utility 50000000 --page-size 128 --queue-depth 32 --read-method CPU --memory Device --method hash_table_shared_memory")
message(STATUS "--------------------------------------------------------------------")

