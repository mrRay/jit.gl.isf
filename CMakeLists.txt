cmake_minimum_required(VERSION 3.19)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_XCODE_GENERATE_SCHEME ON)
set(CMAKE_SUPPRESS_REGENERATION ON)

set(CMAKE_OSX_ARCHITECTURES x86_64;arm64)

set(C74_SCRIPT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/max-sdk-base/script")

project(ISF VERSION 1.0.3 LANGUAGES C CXX OBJC OBJCXX)

set(VVISF_DIR "${CMAKE_CURRENT_SOURCE_DIR}/VVISF-GL/VVISF")

set(VVGL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/VVISF-GL/VVGL")

set(VVGL_SRC
	"${VVGL_DIR}/src/GLBuffer.cpp"
	"${VVGL_DIR}/src/GLBufferPool.cpp"
	"${VVGL_DIR}/src/GLCPUToTexCopier.cpp"
	"${VVGL_DIR}/src/GLCachedProperty.cpp"
	"${VVGL_DIR}/src/GLContext.cpp"
	"${VVGL_DIR}/src/GLContextWindowBacking.cpp"
	"${VVGL_DIR}/src/GLQtCtxWrapper.cpp"
	"${VVGL_DIR}/src/GLScene.cpp"
	"${VVGL_DIR}/src/GLTexToCPUCopier.cpp"
	"${VVGL_DIR}/src/GLTexToTexCopier.cpp"
	"${VVGL_DIR}/src/VVGL_Geom.cpp"
	"${VVGL_DIR}/src/VVGL_StringUtils.cpp"
)

set(VVISF_SRC
	"${VVISF_DIR}/src/ISFAttr.cpp"
	"${VVISF_DIR}/src/ISFDoc.cpp"
	"${VVISF_DIR}/src/ISFPassTarget.cpp"
	"${VVISF_DIR}/src/ISFScene.cpp"
	"${VVISF_DIR}/src/ISFVal.cpp"
	"${VVISF_DIR}/src/VVISF_Base.cpp"
	"${VVISF_DIR}/src/VVISF_StringUtils.cpp"
)

set(VVISF_MAC_SRC
	"${VVGL_DIR}/src/GLBufferPool_CocoaAdditions.mm"
	"${VVGL_DIR}/src/GLContext.mm"
	"${VVISF_DIR}/src/VVISF_Base.mm"
)

add_subdirectory("projects/jit.gl.isf")