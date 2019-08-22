
#include "VVGLContextCacheItemImpl.hpp"

#include "VVGLContextCacheItem.hpp"




using namespace std;

static recursive_mutex						_VVGLContextCacheArrayLock;
static vector<VVGLContextCacheItemRef>		_VVGLContextCacheArray;




#if defined(VVGL_SDK_MAC)
VVGLContextCacheItemImpl::VVGLContextCacheItemImpl(const CGLContextObj & inCtx) {
	//cout << __PRETTY_FUNCTION__ << endl;
	
	_crossCompatibleContexts = true;
	CGLPixelFormatObj		hostPxlFmt  = CGLGetPixelFormat(inCtx);
	GLContextRef			hostCtx = CreateGLContextRefUsing(inCtx, inCtx, hostPxlFmt);
	setHostGLVersion(hostCtx->version);

	if (hostCtx == nullptr)	{
		cout << "ERR: unable to create host ctx wrapper, " << __PRETTY_FUNCTION__ << endl;
	}
	else	{
		if (hostCtx->version == GLVersion_2)	{
			cout  << "hostCtx is GL2" << endl;
			gl2Context = hostCtx->newContextSharingMe();
			gl2Pool = (gl2Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl2Context);
			GLContextRef		copierContext = (gl2Pool==nullptr) ? nullptr : gl2Context->newContextSharingMe();
			if (copierContext != nullptr)	{
				gl2Copier = make_shared<GLTexToTexCopier>(copierContext);
				gl2Copier->setPrivatePool(gl2Pool);
			}
			
			if (_crossCompatibleContexts)	{
				gl4Context = CreateNewGLContextRef(NULL, CreateGL4PixelFormat());
				gl4Pool = (gl4Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl4Context);
				GLContextRef		copierContext = (gl4Pool==nullptr) ? nullptr : gl4Context->newContextSharingMe();
				if (copierContext != nullptr)	{
					gl4Copier = make_shared<GLTexToTexCopier>(copierContext);
					gl4Copier->setPrivatePool(gl4Pool);
				}
			}
		}
		else if (hostCtx->version == GLVersion_4)	{
			cout << "hostCtx is GL4" << endl;
			gl4Context = hostCtx->newContextSharingMe();
			gl4Pool = (gl4Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl4Context);
			GLContextRef		copierContext = (gl4Pool==nullptr) ? nullptr : gl4Context->newContextSharingMe();
			if (copierContext != nullptr)	{
				gl4Copier = make_shared<GLTexToTexCopier>(copierContext);
				gl4Copier->setPrivatePool(gl4Pool);
			}
			
			if (_crossCompatibleContexts)	{
				gl2Context = CreateNewGLContextRef(NULL, CreateCompatibilityGLPixelFormat());
				gl2Pool = (gl2Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl2Context);
				GLContextRef		copierContext = (gl2Pool==nullptr) ? nullptr : gl2Context->newContextSharingMe();
				if (copierContext != nullptr)	{
					gl2Copier = make_shared<GLTexToTexCopier>(copierContext);
					gl2Copier->setPrivatePool(gl2Pool);
				}
			}
		}
		else	{
			cout << "ERR: hostCtx is unrecognized GL vsn, " << hostCtx->version << endl;
		}
	}
}
#elif defined(VVGL_SDK_WIN)
VVGLContextCacheItemImpl::VVGLContextCacheItemImpl(const HGLRC & inHostCtx, const HDC & inHostDevCtx) {
	//cout << __PRETTY_FUNCTION__ << endl;

	_crossCompatibleContexts = false;
	hostCtx = CreateGLContextRefUsing(inHostCtx, inHostDevCtx);
	setHostGLVersion(hostCtx->version);

	if (hostCtx == nullptr) {
		cout << "ERR: unable to create host ctx wrapper, " << __PRETTY_FUNCTION__ << endl;
	}
	else {
		if (hostCtx->version == GLVersion_2)	{
			gl2Context = hostCtx->newContextSharingMe();
			if (gl2Context != nullptr)
				cout << "gl2 contexts renderer is " << gl2Context->getRenderer() << endl;
			gl2Pool = (gl2Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl2Context);
			GLContextRef		copierContext = (gl2Pool==nullptr) ? nullptr : gl2Context->newContextSharingMe();
			if (copierContext != nullptr)	{
				gl2Copier = make_shared<GLTexToTexCopier>(copierContext);
				gl2Copier->setPrivatePool(gl2Pool);
			}
			
			if (_crossCompatibleContexts)	{
				gl4Context = CreateNewGLContextRef(NULL, AllocGL4ContextAttribs().get());
				gl4Pool = (gl4Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl4Context);
				GLContextRef		copierContext = (gl4Pool==nullptr) ? nullptr : gl4Context->newContextSharingMe();
				if (copierContext != nullptr)	{
					gl4Copier = make_shared<GLTexToTexCopier>(copierContext);
					gl4Copier->setPrivatePool(gl4Pool);
				}
			}
		}
		else if (hostCtx->version == GLVersion_4)	{
			gl4Context = hostCtx->newContextSharingMe();
			if (gl4Context != nullptr)
				cout << "gl4 contexts renderer is " << gl4Context->getRenderer() << endl;
			gl4Pool = (gl4Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl4Context);
			GLContextRef		copierContext = (gl4Pool==nullptr) ? nullptr : gl4Context->newContextSharingMe();
			if (copierContext != nullptr)	{
				gl4Copier = make_shared<GLTexToTexCopier>(copierContext);
				gl4Copier->setPrivatePool(gl4Pool);
			}
			
			if (_crossCompatibleContexts)	{
				gl2Context = CreateNewGLContextRef(NULL, AllocCompatibilityContextAttribs().get());
				gl2Pool = (gl2Context==nullptr) ? nullptr : make_shared<GLBufferPool>(gl2Context);
				GLContextRef		copierContext = (gl2Pool==nullptr) ? nullptr : gl2Context->newContextSharingMe();
				if (copierContext != nullptr)	{
					gl2Copier = make_shared<GLTexToTexCopier>(copierContext);
					gl2Copier->setPrivatePool(gl2Pool);
				}
			}
		}
		else	{
		}
		
	}
}
#endif





	/*
VVGLContextCacheItemImpl::VVGLContextCacheItemImpl(const GLContextRef & inCtxToCache)	{
	using namespace std;
	cout << __PRETTY_FUNCTION__ << endl;
	
#if defined(VVGL_SDK_WIN)
	_crossCompatibleContexts = false;
#elif defined(VVGL_SDK_MAC)
	crossCompatibleContexts = true;
#endif

#if defined(VVGL_SDK_WIN)
	hostCtx = inCtxToCache;
#endif
	if (inCtxToCache == nullptr) {
		//	do nothing, intentionally blank
	}
	else if (inCtxToCache->version == GLVersion_2)	{
		gl2Context = inCtxToCache->newContextSharingMe();
#if defined(VVGL_SDK_WIN)
		gl2Context->version = inCtxToCache->version;
#endif
		gl2Pool = make_shared<GLBufferPool>(gl2Context);
		
		if (_crossCompatibleContexts)	{
#if defined(VVGL_SDK_WIN)
			const HGLRC		tmpCtx = NULL;
			gl4Context = CreateNewGLContextRef(tmpCtx, AllocGL4ContextAttribs().get());
#elif defined(VVGL_SDK_MAC)
			gl4Context = CreateNewGLContextRef(NULL, CreateGL4PixelFormat());
#endif
			if (gl4Context != nullptr)
				gl4Pool = make_shared<GLBufferPool>(gl4Context);
		}
	}
	else if (inCtxToCache->version == GLVersion_4)	{
		gl4Context = inCtxToCache->newContextSharingMe();
		gl4Pool = make_shared<GLBufferPool>(gl4Context);
		
		if (_crossCompatibleContexts)	{
#if defined(VVGL_SDK_WIN)
			const HGLRC		tmpCtx = NULL;
			gl2Context = CreateNewGLContextRef(tmpCtx, AllocGL4ContextAttribs().get());
#elif defined(VVGL_SDK_MAC)
			gl2Context = CreateNewGLContextRef(NULL, CreateDefaultPixelFormat());
#endif
			if (gl2Context != nullptr)
				gl2Pool = make_shared<GLBufferPool>(gl2Context);
		}
	}
	else	{
	}
	
	
	if (gl2Context != nullptr && gl2Pool != nullptr)	{
		GLContextRef		tmpCtx = gl2Context->newContextSharingMe();
#if defined(VVGL_SDK_WIN)
		tmpCtx->version = gl2Context->version;
#endif
		gl2Copier = make_shared<GLTexToTexCopier>(tmpCtx);
		gl2Copier->setPrivatePool(gl2Pool);
	}
	if (gl4Context != nullptr && gl4Pool != nullptr)	{
		gl4Copier = make_shared<GLTexToTexCopier>(gl4Context->newContextSharingMe());
		gl4Copier->setPrivatePool(gl4Pool);
	}
}
	*/
VVGLContextCacheItemImpl::~VVGLContextCacheItemImpl()	{
	using namespace std;
	//cout << __PRETTY_FUNCTION__ << endl;
	
	if (gl2Pool != nullptr)	{
		gl2Pool->purge();
		gl2Pool = nullptr;
	}
	if (gl4Pool != nullptr)	{
		gl4Pool->purge();
		gl4Pool = nullptr;
	}
	gl2Copier = nullptr;
	gl4Copier = nullptr;
	gl2Context = nullptr;
	gl4Context = nullptr;
}




#if defined(VVGL_SDK_MAC)
bool VVGLContextCacheItemImpl::matchesContext(const CGLContextObj & inCtx) {
	bool			returnMe = false;
	if (gl2Context != nullptr)
		returnMe |= gl2Context->sameShareGroupAs(inCtx);
	if (gl4Context != nullptr)
		returnMe |= gl4Context->sameShareGroupAs(inCtx);
	return returnMe;
}
#elif defined(VVGL_SDK_WIN)
bool VVGLContextCacheItemImpl::matchesContext(const HGLRC & inHostCtx, const HDC & inHostDevCtx) {
	if (hostCtx == nullptr)
		return false;
	return (hostCtx->context() == inHostCtx && hostCtx->deviceContext()==inHostDevCtx);
}
#endif




/*
VVGLContextCacheItemImpl & VVGLContextCacheItemImpl::operator=(const VVGLContextCacheItemImpl & n)	{
	gl2Context = n.getGL2Context();
	gl2Pool = n.getGL2Pool();
	gl4Context = n.getGL4Context();
	gl4Pool = n.getGL4Pool();
	gl2Copier = n.getGL2Copier();
	gl4Copier = n.getGL4Copier();
	return *this;
}
VVGLContextCacheItemImpl & VVGLContextCacheItemImpl::operator=(const VVGLContextCacheItemRef & n)	{
	gl2Context = n->getGL2Context();
	gl2Pool = n->getGL2Pool();
	gl4Context = n->getGL4Context();
	gl4Pool = n->getGL4Pool();
	gl2Copier = n->getGL2Copier();
	gl4Copier = n->getGL4Copier();
	return *this;
}
*/




/*
#if defined(VVGL_SDK_MAC)
VVGLContextCacheItemRef GetCacheItemForContextImpl(const CGLContextObj & inHostCtx)	{
	using namespace std;
	//cout << __PRETTY_FUNCTION__ << endl;
	
	if (inHostCtx == NULL)
		return nullptr;
	CGLPixelFormatObj		pxlFmt = CGLGetPixelFormat(inHostCtx);
	GLContextRef			wrapperCtx = make_shared<GLContext>(inHostCtx, nullptr, pxlFmt);
	return GetCacheItemForContext(wrapperCtx);
}
#elif defined(VVGL_SDK_WIN)
VVGLContextCacheItemRef GetCacheItemForContextImpl(const HGLRC & inHostCtx, const HDC & inHostDevCtx) {
	//GLContextRef		wrapperCtx = make_shared<GLContext>(inHostCtx, NULL);
	GLContextRef		wrapperCtx = CreateGLContextRefUsing(inHostCtx, inHostDevCtx);

	//	i'm not sure why yet, but on windows the GL ctx returned by max is GL2, even though the glGetString(GL_VERSION) says that it's GL4.  no idea, so i'm just manually setting the version when i create contexts in this class.  this is terrible practice, but until i figure out why i'm kinda stuck.
#if defined(VVGL_SDK_WIN)
	wrapperCtx->version = GLVersion_2;
#endif
	return GetCacheItemForContextImpl(wrapperCtx);
}
#endif
VVGLContextCacheItemRef GetCacheItemForContextImpl(const GLContextRef & inHostCtx)	{
	using namespace std;
	
	if (inHostCtx == nullptr)
		return nullptr;
	
	cout << __PRETTY_FUNCTION__ << endl;
	
	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);
	VVGLContextCacheItemRef			returnMe = nullptr;
	
	if (_VVGLContextCacheArray.capacity() < 4)
		_VVGLContextCacheArray.reserve(4);
	
#if defined(VVGL_SDK_WIN)
	//	run through the cache items in the array
	for (auto cacheIt=_VVGLContextCacheArray.begin(); cacheIt!=_VVGLContextCacheArray.end(); ++cacheIt) {
		//	get the cache item's host context (the context from the host that was originally used to create the cache item)
		GLContextRef		cacheHostCtx = (*cacheIt)->getHostContext();
		if (cacheHostCtx == nullptr)
			continue;
		//const GLContext		&cacheCtxRef = *(cacheHostCtx.get());
		if (inHostCtx->isGLMatchForContext(cacheHostCtx.get())) {
			returnMe = *cacheIt;
			_VVGLContextCacheArray.erase(cacheIt);
			break;
		}
	}
	//	if we haven't found an item to return, we have to create one!
	if (returnMe == nullptr) {
		GLContextRef		newCtx;
		if (inHostCtx->version <= GLVersion_2)	{
			newCtx = CreateNewGLContextRef(inHostCtx->context(), AllocCompatibilityContextAttribs().get());
#if defined(VVGL_SDK_WIN)
			newCtx->version = inHostCtx->version;
#endif
		}
		else {
			newCtx = CreateNewGLContextRef(inHostCtx->context(), AllocGL4ContextAttribs().get());
		}
		returnMe = make_shared<VVGLContextCacheItemImpl>(newCtx);
		returnMe->setHostGLVersion(newCtx->version);
	}
#elif defined(VVGL_SDK_MAC)
	//	run through the scenes in the gl2Pool
	for (auto cacheIt=_VVGLContextCacheArray.begin(); cacheIt!=_VVGLContextCacheArray.end(); ++cacheIt)	{
		GLContextRef		cacheItContext = (*cacheIt)->getGL2Context();
		//	if this scene's context is in the same sharegroup as the passed ctx, remove it from the gl2Pool and return it
		if (cacheItContext!=nullptr && cacheItContext->sameShareGroupAs(inHostCtx))	{
			returnMe = *cacheIt;
			_VVGLContextCacheArray.erase(cacheIt);
			break;
		}
	}
	
	//	if we haven't found an item to return, we have to create one!
	if (returnMe == nullptr)	{
		
		//returnMe = make_shared<VVGLContextCacheItemImpl>(inHostCtx);
		
		
		GLContextRef			newCtx = CreateNewGLContextRef(inHostCtx->contextObj());
		returnMe = make_shared<VVGLContextCacheItemImpl>(newCtx);
		returnMe->setHostGLVersion(newCtx->version);
	}
#endif
	cout << "\t" << __PRETTY_FUNCTION__ << " - FINISHED" << endl;
	return returnMe;
}
void ReturnCacheItemToPoolImpl(const VVGLContextCacheItemRef & inItem)	{
	using namespace std;
	//cout << __PRETTY_FUNCTION__ << endl;
	
	if (inItem == nullptr)
		return;
	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);
	if (_VVGLContextCacheArray.size() >= _VVGLContextCacheArray.max_size())	{
		_VVGLContextCacheArray.erase(_VVGLContextCacheArray.begin());
	}
	_VVGLContextCacheArray.push_back(inItem);
}
*/

