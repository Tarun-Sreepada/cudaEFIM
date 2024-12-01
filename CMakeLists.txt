cmake_minimum_required(VERSION 3.18)
project(EFIM LANGUAGES CXX CUDA)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CUDA compilation with separable compilation
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

# Set the optimization and debugging flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -g")
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O3 -g")

# Add memory sanitization for C++ (host) code
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address")
endif()

# Note: CUDA does not support -fsanitize, so use external tools like cuda-memcheck.

# Auto-detect CUDA architectures
if (NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "75;80") # Detect all supported architectures automatically
endif()

# Include directories
include_directories(include)

# Add source files
add_executable(efim
    src/main.cu
    src/parse.cu
    src/mine.cu
    src/database.cu
)

# Set properties for the target
set_target_properties(efim PROPERTIES
    CUDA_ARCHITECTURES "${CMAKE_CUDA_ARCHITECTURES}"
    CUDA_SEPARABLE_COMPILATION ON
)

# Link CUDA runtime (handled automatically by CMake)
target_link_libraries(efim PRIVATE cuda)
