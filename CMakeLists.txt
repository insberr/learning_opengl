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

# Copy shaders to build directory
set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/shaders") # Source directory to copy from
set(DEST_DIR "${CMAKE_BINARY_DIR}/shaders") # Destination directory to copy to
file(COPY ${SOURCE_DIR} DESTINATION ${DEST_DIR}) # Copy the files during configuration
##   Custom command to copy files again when they are edited
#add_custom_command(
#        # TARGET learning_opengl  # Replace "your_target_name_here" with the name of your target
#        OUTPUT
#        POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy_directory
#        ${SOURCE_DIR}
#        ${DEST_DIR}
#        COMMENT "Copying shader files after editing"
#)
# Copy shaders to build directory during the build process
add_custom_command(
        OUTPUT ${DEST_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${SOURCE_DIR} ${DEST_DIR}
        DEPENDS ${SOURCE_DIR}
        COMMENT "Copying files from ${SOURCE_DIR} to ${DEST_DIR}"
)
# Custom target to run the custom command
add_custom_target(copy_shaders ALL DEPENDS ${DEST_DIR})

# Create EXE
add_executable(learning_opengl main.cpp)
# Run the copy_shaders commands
add_dependencies(learning_opengl copy_shaders)

# Link libraries
target_link_libraries(learning_opengl ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES} glfw glm::glm)
