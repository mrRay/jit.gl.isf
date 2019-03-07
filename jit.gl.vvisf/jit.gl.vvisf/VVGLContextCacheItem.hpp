#include "VVISF.hpp"


/*		caches a GL context (provided on init by the host, expected to be a GL2-based context).  also creates a pool and copier that shares the context (the pool and copier create their own contexts)			*/


using namespace VVGL;
using namespace VVISF;

class VVGLContextCacheItem;
using VVGLContextCacheItemRef = shared_ptr<VVGLContextCacheItem>;


class VVGLContextCacheItem	{
	private:
		GLContextRef			gl2Context = nullptr;
		GLBufferPoolRef			gl2Pool = nullptr;
		
		GLContextRef			gl4Context = nullptr;
		GLBufferPoolRef			gl4Pool = nullptr;
		
		GLTexToTexCopierRef		gl2Copier = nullptr;
		GLTexToTexCopierRef		gl4Copier = nullptr;
	
	public:
		VVGLContextCacheItem() = default;
		VVGLContextCacheItem(const GLContextRef & inCtxToCache);	//	"retains" passed ctx, DOES NOT CREATE A NEW CTX OF THE SAME VERSION (creates a ctx of the "other" vers, so if you pass it a gl2 ctx, the gl2 ctx will be retained and a gl4 ctx will be created)
		~VVGLContextCacheItem();
		
		VVGLContextCacheItem & operator=(const VVGLContextCacheItem & n);
		VVGLContextCacheItem & operator=(const VVGLContextCacheItemRef & n);
		
		inline GLContextRef getGL2Context() const { return gl2Context; };
		inline GLBufferPoolRef getGL2Pool() const { return gl2Pool; };
		inline GLContextRef getGL4Context() const { return gl4Context; };
		inline GLBufferPoolRef getGL4Pool() const { return gl4Pool; };
		
		inline GLTexToTexCopierRef getGL2Copier() const { return gl2Copier; };
		inline GLTexToTexCopierRef getGL4Copier() const { return gl4Copier; };
};

VVGLContextCacheItemRef GetCacheItemForContext(const CGLContextObj & inHostCtx);
VVGLContextCacheItemRef GetCacheItemForContext(const GLContextRef & inHostCtx);
void ReturnCacheItemToPool(const VVGLContextCacheItemRef & inItem);
