#import "VVGLContextCacheItem.hpp"




static recursive_mutex						_VVGLContextCacheArrayLock;
static vector<VVGLContextCacheItemRef>		_VVGLContextCacheArray;




VVGLContextCacheItem::VVGLContextCacheItem(const GLContextRef & inCtxToCache)	{
	using namespace std;
	cout << __PRETTY_FUNCTION__ << endl;
	
	if (inCtxToCache->version == GLVersion_2)	{
		gl2Context = inCtxToCache->newContextSharingMe();
		gl2Pool = make_shared<GLBufferPool>(gl2Context);
	
		gl4Context = CreateNewGLContextRef(NULL, CreateGL4PixelFormat());
		gl4Pool = make_shared<GLBufferPool>(gl4Context);
	}
	else if (inCtxToCache->version == GLVersion_4)	{
		gl4Context = inCtxToCache->newContextSharingMe();
		gl4Pool = make_shared<GLBufferPool>(gl4Context);
	
		gl2Context = CreateNewGLContextRef(NULL, CreateDefaultPixelFormat());
		gl2Pool = make_shared<GLBufferPool>(gl2Context);
	}
	else	{
	}
	
	
	if (gl2Context != nullptr && gl2Pool != nullptr)	{
		gl2Copier = make_shared<GLTexToTexCopier>(gl2Context->newContextSharingMe());
		gl2Copier->setPrivatePool(gl2Pool);
	}
	if (gl4Context != nullptr && gl4Pool != nullptr)	{
		gl4Copier = make_shared<GLTexToTexCopier>(gl4Context->newContextSharingMe());
		gl4Copier->setPrivatePool(gl4Pool);
	}
}
VVGLContextCacheItem::~VVGLContextCacheItem()	{
	using namespace std;
	cout << __PRETTY_FUNCTION__ << endl;
	
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




VVGLContextCacheItem & VVGLContextCacheItem::operator=(const VVGLContextCacheItem & n)	{
	gl2Context = n.getGL2Context();
	gl2Pool = n.getGL2Pool();
	gl4Context = n.getGL4Context();
	gl4Pool = n.getGL4Pool();
	gl2Copier = n.getGL2Copier();
	gl4Copier = n.getGL4Copier();
	return *this;
}
VVGLContextCacheItem & VVGLContextCacheItem::operator=(const VVGLContextCacheItemRef & n)	{
	gl2Context = n->getGL2Context();
	gl2Pool = n->getGL2Pool();
	gl4Context = n->getGL4Context();
	gl4Pool = n->getGL4Pool();
	gl2Copier = n->getGL2Copier();
	gl4Copier = n->getGL4Copier();
	return *this;
}




VVGLContextCacheItemRef GetCacheItemForContext(const CGLContextObj & inHostCtx)	{
	using namespace std;
	//cout << __PRETTY_FUNCTION__ << endl;
	
	if (inHostCtx == NULL)
		return nullptr;
	CGLPixelFormatObj		pxlFmt = CGLGetPixelFormat(inHostCtx);
	GLContextRef			wrapperCtx = make_shared<GLContext>(inHostCtx, nullptr, pxlFmt);
	return GetCacheItemForContext(wrapperCtx);
}
VVGLContextCacheItemRef GetCacheItemForContext(const GLContextRef & inHostCtx)	{
	using namespace std;
	//cout << __PRETTY_FUNCTION__ << endl;
	
	if (inHostCtx == nullptr)
		return nullptr;
	
	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);
	VVGLContextCacheItemRef			returnMe = nullptr;
	
	if (_VVGLContextCacheArray.capacity() <= 4)
		_VVGLContextCacheArray.reserve(4);
	
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
		cout << "\tcouldn't find a cached item, making a new GL context and cache item\n";
		/*
		returnMe = make_shared<VVGLContextCacheItem>(inHostCtx);
		*/
		
		GLContextRef			newCtx = CreateNewGLContextRef(inHostCtx->contextObj());
		returnMe = make_shared<VVGLContextCacheItem>(newCtx);
		returnMe->setHostGLVersion(newCtx->version);
	}
	
	return returnMe;
}
void ReturnCacheItemToPool(const VVGLContextCacheItemRef & inItem)	{
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

