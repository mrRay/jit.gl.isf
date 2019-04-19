#ifndef VVGLContextCacheItemImpl_h
#define VVGLContextCacheItemImpl_h

#include "VVISF.hpp"


/*		caches a GL context (provided on init by the host, expected to be a GL2-based context).  also creates a pool and copier that shares the context (the pool and copier create their own contexts)			*/


using namespace VVGL;
using namespace VVISF;

//class VVGLContextCacheItemImpl;
//using VVGLContextCacheItemImplRef = shared_ptr<VVGLContextCacheItemImpl>;


class VVGLContextCacheItemImpl	{
	private:
		GLVersion				hostGLVersion = GLVersion_2;
		
		bool					_crossCompatibleContexts;

		GLContextRef			hostCtx = nullptr;	//	this is a "wrapper" around the host GL context- it doesn't actually "own" the underlying GL context.  stuff shares me.

		GLContextRef			gl2Context = nullptr;	//	this is the shared ctx for gl2 contexts
		GLBufferPoolRef			gl2Pool = nullptr;
		
		GLContextRef			gl4Context = nullptr;	//	this is the shared ctx for gl4 contexts
		GLBufferPoolRef			gl4Pool = nullptr;
		
		GLTexToTexCopierRef		gl2Copier = nullptr;
		GLTexToTexCopierRef		gl4Copier = nullptr;
	
	public:
		VVGLContextCacheItemImpl() = default;
		//VVGLContextCacheItemImpl(const GLContextRef & inCtxToCache);	//	"retains" passed ctx, DOES NOT CREATE A NEW CTX OF THE SAME VERSION (creates a ctx of the "other" vers, so if you pass it a gl2 ctx, the gl2 ctx will be retained and a gl4 ctx will be created)
#if defined(VVGL_SDK_MAC)
		VVGLContextCacheItemImpl(const CGLContextObj & inCtx);
#elif defined(VVGL_SDK_WIN)
		VVGLContextCacheItemImpl(const HGLRC & inHostCtx, const HDC & inHostDevCtx);
#endif
		~VVGLContextCacheItemImpl();
		
		//VVGLContextCacheItemImpl & operator=(const VVGLContextCacheItemImpl & n);
		//VVGLContextCacheItemImpl & operator=(const VVGLContextCacheItemRef & n);
		
#if defined(VVGL_SDK_WIN)
		inline GLContextRef getHostContext() const { return hostCtx; }
#endif


#if defined(VVGL_SDK_MAC)
		bool matchesContext(const CGLContextObj & inCtx);
#elif defined(VVGL_SDK_WIN)
		bool matchesContext(const HGLRC & inHostCtx, const HDC & inHostDevCtx);
#endif

		inline GLContextRef getGL2Context() const { return gl2Context; }
		inline GLBufferPoolRef getGL2Pool() const { return gl2Pool; }
		inline GLContextRef getGL4Context() const { return gl4Context; }
		inline GLBufferPoolRef getGL4Pool() const { return gl4Pool; }
		
		inline GLTexToTexCopierRef getGL2Copier() const { return gl2Copier; }
		inline GLTexToTexCopierRef getGL4Copier() const { return gl4Copier; }
		
		inline void setHostGLVersion(const GLVersion & n) { hostGLVersion=n; }
		inline GLVersion getHostGLVersion() { return hostGLVersion; }

	private:
		//void generalInit();
};

/*
#if defined(VVGL_SDK_MAC)
VVGLContextCacheItemImplRef GetCacheItemForContextImpl(const CGLContextObj & inHostCtx);
#elif defined(VVGL_SDK_WIN)
VVGLContextCacheItemImplRef GetCacheItemForContextImpl(const HGLRC & inHostCtx, const HDC & inHostDevCtx);
#endif
VVGLContextCacheItemImplRef GetCacheItemForContextImpl(const GLContextRef & inHostCtx);
void ReturnCacheItemToPoolImpl(const VVGLContextCacheItemImplRef & inItem);
*/



#endif	//	VVGLContextCacheItemImpl_h