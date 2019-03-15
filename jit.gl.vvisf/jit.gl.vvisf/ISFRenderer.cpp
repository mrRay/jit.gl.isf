#include "ISFRenderer.hpp"

#include "jit.common.h"
#include "jit.gl.h"
//#include "ext_mess.h"




static t_symbol			*ps_glid_r = NULL;
static t_symbol			*ps_width_r = NULL;
static t_symbol			*ps_height_r = NULL;
static t_symbol			*ps_gltarget_r = NULL;
static t_symbol			*ps_flip_r = NULL;



ISFRenderer::ISFRenderer()	{
	if (ps_glid_r == NULL)	{
		ps_glid_r = gensym("glid");
		ps_width_r = gensym("width");
		ps_height_r = gensym("height");
		ps_gltarget_r = gensym("gltarget");
		ps_flip_r = gensym("flip");
	}
	//_parentJitterObject = inParentJitterObject;
}
ISFRenderer::~ISFRenderer()	{
	//post("%s",__func__);
	_gl2Scene = nullptr;
	_gl4Scene = nullptr;
}


void ISFRenderer::configureWithCache(const VVGLContextCacheItemRef & inCacheItem)	{
	//post("%s",__func__);
	//	if we weren't passed a cache item, something's wrong and we need to bail right now
	if (inCacheItem == nullptr)	{
		//post("\terr: bailing, %s",__func__);
		return;
	}
	
	
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	_hostUsesGL4 = (inCacheItem->getHostGLVersion() == GLVersion_4) ? true : false;
	
	//	get the currently-loaded doc
	//ISFDocRef			origDoc = loadedISFDoc();
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
	if (_filepath.length()>0 && ctxChanged)	{
		//post("\tctx changed in %s, reloading file",__func__);
		loadFile(&_filepath);
	}
	
}


/*
void ISFRenderer::loadFile(const string & inFilePath)	{
	loadFile(&inFilePath);
}
*/
void ISFRenderer::loadFile(const string * inFilePath)	{
	//post("%s",__func__);
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	if (inFilePath == nullptr)
		_filepath = string("");
	else
		_filepath = *inFilePath;
	
	if (_gl2Scene!=nullptr && _gl4Scene!=nullptr)	{
		ISFDocRef		loadedDoc = nullptr;
		//	first try loading the file in gl2
		try	{
			if (inFilePath==nullptr)
				_gl2Scene->useFile();
			else
				_gl2Scene->useFile(*inFilePath);
			GLBufferPoolRef		bp2 = getGL2BufferPool();
			//if (bp2 == nullptr)
			//	post("\tERR: buffer pool null in %s",__func__);
			_gl2Scene->createAndRenderABuffer(VVGL::Size(640,480), nullptr, bp2);
			_sceneUsesGL4 = false;
			_sceneLoaded = true;
			loadedDoc = _gl2Scene->doc();
		}
		catch (...)	{
			//	if we're here, there was an exception- try loading the file in gl4
			try	{
				if (inFilePath==nullptr)
					_gl4Scene->useFile();
				else
					_gl4Scene->useFile(*inFilePath);
				GLBufferPoolRef		bp4 = getGL4BufferPool();
				//if (bp4 == nullptr)
				//	post("\tERR: buffer pool null in %s",__func__);
				_gl4Scene->createAndRenderABuffer(VVGL::Size(640,480), nullptr, bp4);
				_sceneUsesGL4 = true;
				_sceneLoaded = true;
				loadedDoc = _gl4Scene->doc();
			}
			catch (...)	{
				_sceneUsesGL4 = false;
				_sceneLoaded = false;
			}
		}
		
		if (_sceneLoaded && loadedDoc != nullptr && loadedDoc->type()==ISFFileType_Filter)	{
			_hasInputImageKey = true;
		}
		else	{
			_hasInputImageKey = false;
		}
	}
	else	{
		//post("\tERR: a scene is null in %s",__func__);
	}
}
void ISFRenderer::reloadFile()	{
	//	get the currently-loaded doc
	ISFDocRef			origDoc = loadedISFDoc();
	if (origDoc != nullptr)	{
		string			tmpStr = origDoc->path();
		loadFile(&tmpStr);
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
ISFSceneRef ISFRenderer::loadedISFScene()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	if (_sceneLoaded)	{
		if (_sceneUsesGL4 && _gl4Scene!=nullptr)	{
			return _gl4Scene;
		}
		else if (!_sceneUsesGL4 && _gl2Scene!=nullptr)	{
			return _gl2Scene;
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
bool ISFRenderer::hasInputImageKey()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return _hasInputImageKey;
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


void ISFRenderer::render(const GLBufferRef & inTexFromMax, const VVGL::Size & inRenderSize, const double & inRenderTime)	{
	//post("%s ... %0.2f",__func__,inRenderTime);
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	GLBufferPoolRef		gl2Pool = (_gl2Scene==nullptr) ? nullptr : _gl2Scene->privatePool();
	GLBufferPoolRef		gl4Pool = (_gl4Scene==nullptr) ? nullptr : _gl4Scene->privatePool();
	
	if (_sceneLoaded)	{
		ISFSceneRef			renderScene = nullptr;
		
		if (_sceneUsesGL4)	{
			renderScene = _gl4Scene;
		}
		else	{
			renderScene = _gl2Scene;
		}
		
		
		if (renderScene != nullptr)	{
			try	{
				//	if the host and the scene doing the rendering are using the same version of GL then this is a simple render
				if (_hostUsesGL4 == _sceneUsesGL4)	{
					if (inRenderTime < 0.)
						renderScene->renderToBuffer(inTexFromMax, inRenderSize);
					else
						renderScene->renderToBuffer(inTexFromMax, inRenderSize, inRenderTime);
				}
				//	else there's a GL version mismatch between the host and render scene contexts- i have to render my scene to an IOSurface, and then copy that to the destination buffer i was passed
				else	{
					//post("\tctx mismatch");
					GLBufferPoolRef		renderPool = nullptr;
					GLBufferPoolRef		maxPool = nullptr;
					GLTexToTexCopierRef		hostCompatibleCopier = nullptr;
					GLBufferRef			renderIOSfc = nullptr;
					GLBufferRef			hostIOSfc = nullptr;
					
					if (_sceneUsesGL4)	{
						renderPool = _gl4Scene->privatePool();
						maxPool = gl2Pool;
						hostCompatibleCopier = _gl2Scene->privateCopier();
						renderIOSfc = CreateRGBATexIOSurface(inRenderSize, false, renderPool);
					}
					else	{
						renderPool = _gl2Scene->privatePool();
						maxPool = gl4Pool;
						hostCompatibleCopier = _gl4Scene->privateCopier();
						renderIOSfc = CreateRGBATexIOSurface(inRenderSize, false, renderPool);
					}
					
					//post("\trender tex is %s",renderIOSfc->getDescriptionString().c_str());
					//post("\tmax tex is %s",inTexFromMax->getDescriptionString().c_str());
					
					if (inRenderTime < 0.)
						renderScene->renderToBuffer(renderIOSfc, inRenderSize);
					else
						renderScene->renderToBuffer(renderIOSfc, inRenderSize, inRenderTime);
					hostIOSfc = CreateRGBATexFromIOSurfaceID(renderIOSfc->desc.localSurfaceID, false, maxPool);
					
					hostCompatibleCopier->ignoreSizeCopy(hostIOSfc, inTexFromMax);
				}
			}
			catch (...)	{
				//post("err rendering frame in %s",__func__);
			}
		}
	}
	
	if (gl2Pool != nullptr)
		gl2Pool->housekeeping();
	if (gl4Pool != nullptr)
		gl4Pool->housekeeping();
}


GLBufferRef ISFRenderer::applyJitGLTexToInputKey(void *inJitGLTexNameSym, const string & inInputName)	{
	//post("%s",__func__);
	
	GLBufferRef			returnMe = nullptr;
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	if (_sceneLoaded)	{
		//	find the IF attribute object that corresponds to this input name
		
		ISFSceneRef			renderScene = nullptr;
		if (_sceneUsesGL4)
			renderScene = _gl4Scene;
		else
			renderScene = _gl2Scene;
		ISFDocRef			renderDoc = (renderScene==nullptr) ? nullptr : renderScene->doc();
		ISFAttrRef			attr = (renderDoc==nullptr) ? nullptr : renderDoc->input(inInputName);
		if (attr != nullptr)	{
			//GLBufferRef			wrapperTex = nullptr;
			if (inJitGLTexNameSym != NULL)	{
				void				*jitTexture = jit_object_findregistered(static_cast<t_symbol*>(inJitGLTexNameSym));
				//if (jitTexture == NULL || jit_object_method(jitTexture, _jit_sym_class_jit_matrix) == NULL)
				//if (jitTexture == NULL || jit_object_method(jitTexture, _jit_sym_jit_matrix) == NULL)
				//if (jitTexture == NULL || jit_object_method(jitTexture, ps_jit_gl_texture) == NULL)
				if (jitTexture == NULL)	{
					post("ERR: cant find jitter object registered for %s",static_cast<t_symbol*>(inJitGLTexNameSym)->s_name);
				}
				else	{
					//GLuint width = jit_attr_getlong(texture,ps_width);
					//GLuint height = jit_attr_getlong(texture,ps_height);
					//GLuint texTarget = jit_attr_getlong(texture, ps_gltarget);
					//t_jit_gl_context			ctx = jit_gl_get_context();
					//if (ctx == NULL)
					//	post("ERR: couldnt retrieve ctx in %s",__func__);
					//else
					//	jit_ob3d_set_context(_parentJitterObject);
					//t_symbol			*tmpClassName = jit_object_classname(jitTexture);
					//post("texture is %p, class name check is %s",jitTexture,tmpClassName->s_name);
					
					uint32_t			texName = jit_attr_getlong(jitTexture, ps_glid_r);
					//VVGL::Size			tmpSize = VVGL::Size(jitObj->dim[0], jitObj->dim[1]);
					VVGL::Size			tmpSize;
					tmpSize.width = (double)jit_attr_getlong(jitTexture, ps_width_r);
					tmpSize.height = (double)jit_attr_getlong(jitTexture, ps_height_r);
					//post("tex name is %d, dims are %f x %f",texName,tmpSize.width,tmpSize.height);
					VVGL::Rect			tmpRect = VVGL::Rect(0, 0, tmpSize.width, tmpSize.height);
					GLBufferPoolRef		tmpPool = _gl2Scene->privatePool();
					bool				tmpFlipped = (jit_attr_getlong(jitTexture, ps_flip_r)>0) ? false : true;
					returnMe = CreateFromExistingGLTexture(
						texName,	//	inTexName The name of the OpenGL texture that will be used to populate the GLBuffer.
						//GLBuffer::Target_Rect,	//	inTexTarget The texture target of the OpenGL texture (GLBuffer::Target)
						(GLBuffer::Target)jit_attr_getlong(jitTexture, ps_gltarget_r),
						GLBuffer::IF_RGBA8,	//	inTexIntFmt The internal format of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
						GLBuffer::PF_BGRA,	//	inTexPxlFmt The pixel format of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
						GLBuffer::PT_UInt_8888_Rev,	//	inTexPxlType The pixel type of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
						tmpSize,	//	inTexSize The Size of the OpenGL texture, in pixels.
						tmpFlipped,	//	inTexFlipped Whether or not the image in the OpenGL texture is flipped.
						tmpRect,	//	inImgRectInTex The region of the texture (bottom-left origin, in pixels) that contains the image.
						nullptr,	//	inReleaseCallbackContext An arbitrary pointer stored (weakly) with the GLBuffer- this pointer is passed to the release callback.  If you want to store a pointer from another SDK, this is the appropriate place to do so.
						nullptr,	//	inReleaseCallback A callback function or lambda that will be executed when the GLBuffer is deallocated.  If the GLBuffer needs to release any other resources when it's freed, this is the appropriate place to do so.
						tmpPool	//	inPoolRef The pool that the GLBuffer should be created with.  When the GLBuffer is freed, its underlying GL resources will be returned to this pool (where they will be either freed or recycled).
					);
					attr->setCurrentImageBuffer(returnMe);
				}
			}
			else	{
				attr->setCurrentImageBuffer(returnMe);
			}
		}
		else
			post("ERR: no attribute found named %s in %s",static_cast<t_symbol*>(inJitGLTexNameSym)->s_name,__func__);
	}
	else
		post("ERR: no file loaded yet, %s",__func__);
	
	return returnMe;
}

