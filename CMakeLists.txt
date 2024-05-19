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

add_executable(learning_opengl main.cpp)

# Link libraries
target_link_libraries(learning_opengl ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES} glfw glm::glm)