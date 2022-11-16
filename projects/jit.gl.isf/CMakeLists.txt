cmake_minimum_required(VERSION 3.0)
include(${C74_SCRIPT_DIR}/max-pretarget.cmake)

# overwrite from sdk scripts
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../ISF/externals")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

include_directories( 
	"${MAX_SDK_INCLUDES}"
	"${MAX_SDK_JIT_INCLUDES}"
	"${VVISF_DIR}/include"
	"${VVGL_DIR}/include"
	"${CMAKE_CURRENT_SOURCE_DIR}"
)

add_library( 
	${PROJECT_NAME}
	MODULE

	${VVGL_SRC}
	${VVISF_SRC}

	ISFFile.cpp
	ISFFileManager.cpp
	ISFRenderer.cpp
	ISFRendererImpl.cpp
	MyBuffer.cpp
	MyBufferImpl.cpp
	VVGLContextCacheItem.cpp
	VVGLContextCacheItemImpl.cpp

	jit.gl.isf.cpp
	max.jit.gl.isf.cpp	
)

if (APPLE)
	target_sources( ${PROJECT_NAME} PRIVATE ${VVISF_MAC_SRC} ISFFileManager_Mac.mm)
	target_link_libraries( ${PROJECT_NAME} PRIVATE
		"-framework Cocoa" 
		"-framework Foundation" 
		"-framework ImageIO" 
		"-framework OpenGL" 
		"-framework IOSurface" 
		"-framework CoreGraphics" 
		"-framework CoreVideo"
		"-framework CoreMedia"
		
    )	
	target_compile_definitions( ${PROJECT_NAME} PRIVATE VVGL_SDK_MAC )
else()
	target_sources( ${PROJECT_NAME} PRIVATE ISFFileManager_Win.cpp )
	target_compile_definitions( ${PROJECT_NAME} PRIVATE VVGL_SDK_WIN )
endif()

include(${C74_SCRIPT_DIR}/max-posttarget.cmake)
