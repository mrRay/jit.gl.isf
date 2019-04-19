#ifndef VVGLContextCacheItem_h
#define VVGLContextCacheItem_h

#include <memory>

#if defined(VVGL_SDK_MAC)
	#include <OpenGL/OpenGL.h>
#elif defined(VVGL_SDK_WIN)
	#include <Windows.h>
	//#include <GL/glew.h>
	//#include <GL/wglew.h>
#endif	//	VVGL_SDK_WIN




//	private implementation class, should never need to use or work with directly
class VVGLContextCacheItemImpl;
//	"itemRef" == shared_ptr
class VVGLContextCacheItem;
using VVGLContextCacheItemRef = std::shared_ptr<VVGLContextCacheItem>;




class VVGLContextCacheItem {
private:
	//	private implementation ivar to ensure complete separation of GL stuff between VVGL/VVISF and jitter
	VVGLContextCacheItemImpl		*_pi = nullptr;

public:
	VVGLContextCacheItem();
	VVGLContextCacheItem(VVGLContextCacheItemImpl * inPrivImplAssumesOwnership);
	~VVGLContextCacheItem();

#if defined(VVGL_SDK_MAC)
	bool matchesContext(const CGLContextObj & inCtx);
#elif defined(VVGL_SDK_WIN)
	bool matchesContext(const HGLRC & inGLCtx, const HDC & inDevCtx);
#endif

	VVGLContextCacheItemImpl * pi() { return _pi; }
};






#if defined(VVGL_SDK_MAC)
VVGLContextCacheItemRef GetCacheItemForContext(const CGLContextObj & inHostCtx);
#elif defined(VVGL_SDK_WIN)
VVGLContextCacheItemRef GetCacheItemForContext(const HGLRC & inHostCtx, const HDC & inHostDevCtx);
#endif
//VVGLContextCacheItemRef GetCacheItemForContext(const GLContextRef & inHostCtx);
void ReturnCacheItemToPool(const VVGLContextCacheItemRef & inItem);




#endif	//	VVGLContextCacheItem_h
