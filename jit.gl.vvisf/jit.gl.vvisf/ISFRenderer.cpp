#include "ISFRenderer.hpp"




ISFRenderer::~ISFRenderer()	{
	_gl2Scene = nullptr;
	_gl4Scene = nullptr;
}


void ISFRenderer::configureWithCache(const VVGLContextCacheItemRef & inCacheItem)	{
	//	if we weren't passed a cache item, something's wrong and we need to bail right now
	if (inCacheItem == nullptr)	{
		return;
	}
	
	
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	//	get the currently-loaded doc
	ISFDocRef			origDoc = loadedISFDoc();
	bool				ctxChanged = false;
	
	//	get the gl2 & gl4 contexts from the cache item (these should both exist)
	GLContextRef		cacheGL2Ctx = inCacheItem->getGL2Context();
	GLContextRef		cacheGL4Ctx = inCacheItem->getGL4Context();
	//	get the gl2 & gl4 contexts from my isf scenes (one or both of these may not exist)
	GLContextRef		myGL2Ctx = (_gl2Scene==nullptr) ? nullptr : _gl2Scene->context();
	GLContextRef		myGL4Ctx = (_gl4Scene==nullptr) ? nullptr : _gl4Scene->context();
	
	//	check the cached gl2 ctx against the isf scene gl2 ctx- if they're non-nil and there's a mismatch...
	if (cacheGL2Ctx!=nullptr && myGL2Ctx!=nullptr && !myGL2Ctx->sameShareGroupAs(cacheGL2Ctx))	{
		//	delete my gl2 scene, flag ctx as having changed
		_gl2Scene = nullptr;
		ctxChanged = true;
	}
	//	check the cached gl4 ctx against the isf scene gl4 ctx- if they're non-nil and there's a mismatch...
	if (cacheGL2Ctx!=nullptr && myGL2Ctx!=nullptr && !myGL2Ctx->sameShareGroupAs(cacheGL2Ctx))	{
		//	delete my gl4 scene, flag ctx as having changed
		_gl4Scene = nullptr;
		ctxChanged = true;
	}
	
	
	//	if my gl2 scene is null, create it
	if (_gl2Scene == nullptr)	{
		//	get the cache's gl2 ctx
		GLContextRef		cacheCtx = inCacheItem->getGL2Context();
		//	make a new gl ctx that shares the cache's context
		GLContextRef		newCtx = cacheCtx->newContextSharingMe();
		//	make a gl scene- the scene should own its own gl context (the context we just created)
		_gl2Scene = CreateISFSceneRefUsing(newCtx);
		_gl2Scene->setThrowExceptions(true);
		//	give the gl scene a ref to the cache item's buffer pool and buffer copier...
		_gl2Scene->setPrivatePool(inCacheItem->getGL2Pool());
		_gl2Scene->setPrivateCopier(inCacheItem->getGL2Copier());
		//_gl2Scene->setAlwaysRenderToFloat(true);
		ctxChanged = true;
	}
	//	if my gl4 scene is null, create it
	if (_gl4Scene == nullptr)	{
		//	get the cache's gl2 ctx
		GLContextRef		cacheCtx = inCacheItem->getGL4Context();
		//	make a new gl ctx that shares the cache's context
		GLContextRef		newCtx = cacheCtx->newContextSharingMe();
		//	make a gl scene- the scene should own its own gl context (the context we just created)
		_gl4Scene = CreateISFSceneRefUsing(newCtx);
		_gl4Scene->setThrowExceptions(true);
		//	give the gl scene a ref to the cache item's buffer pool and buffer copier...
		_gl4Scene->setPrivatePool(inCacheItem->getGL4Pool());
		_gl4Scene->setPrivateCopier(inCacheItem->getGL4Copier());
		//_gl4Scene->setAlwaysRenderToFloat(true);
		ctxChanged = true;
	}
	
	
	//	if we had a doc loaded originally and a ctx was chagned, load it again
	if (origDoc != nullptr && ctxChanged)	{
		loadFile(origDoc->path());
	}
	
}


void ISFRenderer::loadFile(const string & inFilePath)	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	if (_gl2Scene!=nullptr && _gl4Scene!=nullptr)	{
		//	first try loading the file in gl2
		try	{
			_gl2Scene->useFile(inFilePath);
			GLBufferPoolRef		bp2 = getGL2BufferPool();
			_gl2Scene->createAndRenderABuffer(VVGL::Size(640,480), nullptr, bp2);
			_sceneUsesGL4 = false;
			_sceneLoaded = true;
		}
		catch (...)	{
			//	if we're here, there was an exception- try loading the file in gl4
			try	{
				_gl4Scene->useFile(inFilePath);
				GLBufferPoolRef		bp4 = getGL4BufferPool();
				_gl4Scene->createAndRenderABuffer(VVGL::Size(640,480), nullptr, bp4);
				_sceneUsesGL4 = true;
				_sceneLoaded = true;
			}
			catch (...)	{
				_sceneUsesGL4 = false;
				_sceneLoaded = false;
			}
		}
	}
}
void ISFRenderer::reloadFile()	{
	//	get the currently-loaded doc
	ISFDocRef			origDoc = loadedISFDoc();
	if (origDoc != nullptr)	{
		loadFile(origDoc->path());
	}
}
ISFDocRef ISFRenderer::loadedISFDoc()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	if (_sceneLoaded)	{
		if (_sceneUsesGL4 && _gl4Scene!=nullptr)	{
			return _gl4Scene->doc();
		}
		else if (!_sceneUsesGL4 && _gl2Scene!=nullptr)	{
			return _gl2Scene->doc();
		}
	}
	return nullptr;
}
GLBufferPoolRef ISFRenderer::loadedBufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	if (_sceneLoaded)	{
		if (_sceneUsesGL4 && _gl4Scene!=nullptr)	{
			return _gl4Scene->privatePool();
		}
		else if (!_sceneUsesGL4 && _gl2Scene!=nullptr)	{
			return _gl2Scene->privatePool();
		}
	}
	return nullptr;
}
GLTexToTexCopierRef ISFRenderer::loadedTextureCopier()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	if (_sceneLoaded)	{
		if (_sceneUsesGL4 && _gl4Scene!=nullptr)	{
			return _gl4Scene->privateCopier();
		}
		else if (!_sceneUsesGL4 && _gl2Scene!=nullptr)	{
			return _gl2Scene->privateCopier();
		}
	}
	return nullptr;
}


GLBufferPoolRef ISFRenderer::getGL2BufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl2Scene==nullptr) ? nullptr : _gl2Scene->privatePool();
}
GLBufferPoolRef ISFRenderer::getGL4BufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl4Scene==nullptr) ? nullptr : _gl4Scene->privatePool();
}


GLTexToTexCopierRef ISFRenderer::getGL2TextureCopier()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl2Scene==nullptr) ? nullptr : _gl2Scene->privateCopier();
}
GLTexToTexCopierRef ISFRenderer::getGL4TextureCopier()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl4Scene==nullptr) ? nullptr : _gl4Scene->privateCopier();
}


void ISFRenderer::render(const GLBufferRef & inRenderTex, const VVGL::Size & inRenderSize, const double & inRenderTime)	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
}

