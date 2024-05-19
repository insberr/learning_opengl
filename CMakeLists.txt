cmake_minimum_required(VERSION 3.28)
project(learning_opengl)

set(CMAKE_CXX_STANDARD 23)

# Find packages
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_package(glfw3 REQUIRED)
find_package(glm REQUIRED)

# Include directories
include_directories(${OPENGL_INCLUDE_DIRS} ${GLEW_INCLUDE_DIRS} ${GLFW_INCLUDE_DIRS} ${GLM_INCLUDE_DIRS})

# Specify the source directory to copy from
set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/shaders")
# Specify the destination directory to copy to (usually the build directory)
set(DEST_DIR "${CMAKE_BINARY_DIR}/")
# Copy files during the configuration phase
file(COPY ${SOURCE_DIR} DESTINATION ${DEST_DIR})

add_executable(learning_opengl main.cpp)

# Link libraries
target_link_libraries(learning_opengl ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES} glfw glm::glm)