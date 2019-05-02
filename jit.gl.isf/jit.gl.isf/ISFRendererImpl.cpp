#include "ISFRendererImpl.hpp"
/*
#include "jit.common.h"
#include "jit.gl.h"
//#include "ext_mess.h"
*/
#include "VVGLContextCacheItemImpl.hpp"
#include "MyBufferImpl.hpp"




ISFRendererImpl::ISFRendererImpl()	{
}
ISFRendererImpl::~ISFRendererImpl()	{
	//post("%s",__func__);
	_gl2Scene = nullptr;
	_gl4Scene = nullptr;
}


void ISFRendererImpl::configureWithCache(const VVGLContextCacheItemRef & inCacheItem)	{
	//cout << __PRETTY_FUNCTION__ << endl;

	//	if we weren't passed a cache item, something's wrong and we need to bail right now
	if (inCacheItem == nullptr)	{
		//post("\terr: bailing, %s",__func__);
		cout << "ERR: bailing, cache item null, " << __PRETTY_FUNCTION__ << endl;
		return;
	}

	VVGLContextCacheItemImpl		*cacheItemImpl = inCacheItem->pi();
	if (cacheItemImpl == nullptr) {
		cout << "ERR: bailing, cache impl null, " << __PRETTY_FUNCTION__ << endl;
		return;
	}
	
	
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	_hostUsesGL4 = (cacheItemImpl->getHostGLVersion() == GLVersion_4) ? true : false;
	
	//	get the currently-loaded doc
	//ISFDocRef			origDoc = loadedISFDoc();
	bool				ctxChanged = false;
	
	//	get the gl2 & gl4 contexts from the cache item (these should both exist)
	GLContextRef		cacheGL2Ctx = cacheItemImpl->getGL2Context();
	GLContextRef		cacheGL4Ctx = cacheItemImpl->getGL4Context();
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
	if (cacheGL4Ctx!=nullptr && myGL4Ctx!=nullptr && !myGL4Ctx->sameShareGroupAs(cacheGL4Ctx))	{
		//	delete my gl4 scene, flag ctx as having changed
		_gl4Scene = nullptr;
		ctxChanged = true;
	}
	
	
	//	if my gl2 scene is null, create it
	if (_gl2Scene == nullptr)	{
		//cout << "\tcreating GL2 scene in " << __PRETTY_FUNCTION__ << endl;
		//	make a new gl ctx that shares the cache's context
		GLContextRef		newCtx = (cacheGL2Ctx==nullptr) ? nullptr : cacheGL2Ctx->newContextSharingMe();
		//	make a gl scene- the scene should own its own gl context (the context we just created)
		_gl2Scene = (newCtx==nullptr) ? nullptr : CreateISFSceneRefUsing(newCtx);
		if (_gl2Scene != nullptr) {
			_gl2Scene->setThrowExceptions(true);
			//	give the gl scene a ref to the cache item's buffer pool and buffer copier...
			_gl2Scene->setPrivatePool(cacheItemImpl->getGL2Pool());
			_gl2Scene->setPrivateCopier(cacheItemImpl->getGL2Copier());
			//_gl2Scene->setAlwaysRenderToFloat(true);
			ctxChanged = true;
		}
	}
	//	if my gl4 scene is null, create it
	if (_gl4Scene == nullptr)	{
		//cout << "\tcreating GL4 scene in " << __PRETTY_FUNCTION__ << endl;
		//	make a new gl ctx that shares the cache's context
		GLContextRef		newCtx = (cacheGL4Ctx==nullptr) ? nullptr : cacheGL4Ctx->newContextSharingMe();
		//	make a gl scene- the scene should own its own gl context (the context we just created)
		_gl4Scene = (newCtx==nullptr) ? nullptr : CreateISFSceneRefUsing(newCtx);
		if (_gl4Scene != nullptr)	{
			_gl4Scene->setThrowExceptions(true);
			//	give the gl scene a ref to the cache item's buffer pool and buffer copier...
			_gl4Scene->setPrivatePool(cacheItemImpl->getGL4Pool());
			_gl4Scene->setPrivateCopier(cacheItemImpl->getGL4Copier());
			//_gl4Scene->setAlwaysRenderToFloat(true);
			ctxChanged = true;
		}
	}
	
	
	//	if we had a doc loaded originally and a ctx was chagned, load it again
	if (_filepath.length()>0 && ctxChanged)	{
		//post("\tctx changed in %s, reloading file",__func__);
		//cout << "\tctx changed, reloading file from " << __PRETTY_FUNCTION__ << endl;
		loadFile(&_filepath);
	}
	
}


/*
void ISFRendererImpl::loadFile(const string & inFilePath)	{
	loadFile(&inFilePath);
}
*/
void ISFRendererImpl::loadFile(const string * inFilePath)	{
	//post("%s",__func__);
	//cout << __PRETTY_FUNCTION__ << endl;
	lock_guard<recursive_mutex>		lock(_sceneLock);
	
	if (inFilePath == nullptr)
		_filepath = string("");
	else
		_filepath = *inFilePath;
	
	//	we have to deal with a weird edge case: the windows version of this plugin embeds a hard-coded ISF 
	//	shader for color bars using the path "VDVX:COLORBARS".  we have to check to see if the path is a 
	//	match for this hard-coded string, and if it is, manually construct and load the ISFDoc.
	ISFDocRef		hardCodedColorBarsDoc = nullptr;
	if (_filepath == string("VDVX:COLORBARS")) {
		const char		*colorBarsRaw = R"(/*{
	"DESCRIPTION": "",
	"CREDIT": "VIDVOX",
	"ISFVSN": "2",
	"CATEGORIES": [
		"Generator"
	],
	"INPUTS": [
		{
			"NAME": "colorShift",
			"LABEL": "Color Shift",
			"TYPE": "float",
			"DEFAULT": 0.0,
			"MIN": 0.0,
			"MAX": 1.0
		}
	]
	
}*/




vec4 colorsArray[9];




void main()	{	
	vec4		outputPixelColor = vec4(0.0);
	vec2		loc = isf_FragNormCoord.xy;
	
	//	figure out if we are in the top, middle or bottom sections
	//	these are broken into the ratios 3/4, 1/8, 1/8
	
	//	if we are in the top section figure out which of the 9 colors to use
	if (loc.y > 0.25)	{
		colorsArray[0] = vec4(0.412, 0.412, 0.412, 1.0);
		colorsArray[1] = vec4(0.757, 0.757, 0.757, 1.0);
		colorsArray[2] = vec4(0.757, 0.757, 0.000, 1.0);
		colorsArray[3] = vec4(0.000, 0.757, 0.757, 1.0);
		colorsArray[4] = vec4(0.000, 0.757, 0.000, 1.0);
		colorsArray[5] = vec4(0.757, 0.000, 0.757, 1.0);
		colorsArray[6] = vec4(0.757, 0.000, 0.000, 1.0);
		colorsArray[7] = vec4(0.000, 0.000, 0.757, 1.0);
		colorsArray[8] = vec4(0.412, 0.412, 0.412, 1.0);
		
		int		colorIndex = int((9.0 * mod(loc.x + colorShift, 1.0)));
		
		outputPixelColor = colorsArray[colorIndex];
	}
	//	in the 'middle section we draw the black to white image
	else if (loc.y > 0.125)	{
		outputPixelColor.rgb = vec3(loc.x);
		outputPixelColor.a = 1.0;
	}
	else	{
		colorsArray[0] = vec4(0.169, 0.169, 0.169, 1.0);
		colorsArray[1] = vec4(0.019, 0.019, 0.019, 1.0);
		colorsArray[2] = vec4(1.000, 1.000, 1.000, 1.0);
		colorsArray[3] = vec4(1.000, 1.000, 1.000, 1.0);
		colorsArray[4] = vec4(0.019, 0.019, 0.019, 1.0);
		colorsArray[5] = vec4(0.000, 0.000, 0.000, 1.0);
		colorsArray[6] = vec4(0.019, 0.019, 0.019, 1.0);
		colorsArray[7] = vec4(0.038, 0.038, 0.038, 1.0);
		colorsArray[8] = vec4(0.169, 0.169, 0.169, 1.0);
		
		int		colorIndex = int((9.0 * loc.x));
		
		outputPixelColor = colorsArray[colorIndex];		
	}
	
	gl_FragColor = outputPixelColor;
}
)";
		//	...end of c++ string literal 'colorBarsRaw'
		
		string			isfString(colorBarsRaw);
		isfString.append(" ");
		hardCodedColorBarsDoc = CreateISFDocRefWith(isfString);
	}

	//	first try loading the file in gl2
	ISFDocRef			loadedDoc = nullptr;
	try {
		if (_gl2Scene == nullptr)
			throw 0;
		if (hardCodedColorBarsDoc != nullptr)
			_gl2Scene->useDoc(hardCodedColorBarsDoc);
		else if (inFilePath == nullptr)
			_gl2Scene->useFile();
		else
			_gl2Scene->useFile(*inFilePath, false);
		GLBufferPoolRef		bp2 = getGL2BufferPool();
		//if (bp2 == nullptr)
		//	post("\tERR: buffer pool null in %s",__func__);
		_gl2Scene->createAndRenderABuffer(VVGL::Size(640, 480), nullptr, bp2);
		_sceneUsesGL4 = false;
		_sceneLoaded = true;
		loadedDoc = _gl2Scene->doc();
		//cout << "\tfile loaded under gl 2!" << endl;
	}
	catch (...) {
		try {
			//	if we're here, there was an exception- try loading the file in gl4
			if (_gl4Scene == nullptr)
				throw 0;
			if (hardCodedColorBarsDoc != nullptr)
				_gl4Scene->useDoc(hardCodedColorBarsDoc);
			else if (inFilePath == nullptr)
				_gl4Scene->useFile();
			else
				_gl4Scene->useFile(*inFilePath, false);
			GLBufferPoolRef		bp4 = getGL4BufferPool();
			//if (bp4 == nullptr)
			//	post("\tERR: buffer pool null in %s",__func__);
			_gl4Scene->createAndRenderABuffer(VVGL::Size(640, 480), nullptr, bp4);
			_sceneUsesGL4 = true;
			_sceneLoaded = true;
			loadedDoc = _gl4Scene->doc();
			//cout << "\tfile loaded under gl 4!" << endl;
		}
		catch (...) {
			//post("jit.gl.isf: This shader could not be compiled, sorry! %s",_filepath);
			_sceneUsesGL4 = false;
			_sceneLoaded = false;
		}
	}

	if (_sceneLoaded && loadedDoc != nullptr && loadedDoc->type() == ISFFileType_Filter) {
		_hasInputImageKey = true;
	}
	else {
		_hasInputImageKey = false;
	}
}
void ISFRendererImpl::reloadFile()	{
	//	get the currently-loaded doc
	ISFDocRef			origDoc = loadedISFDoc();
	if (origDoc != nullptr)	{
		string			tmpStr = origDoc->path();
		loadFile(&tmpStr);
	}
}


void ISFRendererImpl::render(const MyBufferRef & inTexFromMax, const VVGL::Size & inRenderSize, const double & inRenderTime) {
	//post("%s ... %0.2f",__func__,inRenderTime);
	lock_guard<recursive_mutex>		lock(_sceneLock);

	GLBufferPoolRef		gl2Pool = (_gl2Scene == nullptr) ? nullptr : _gl2Scene->privatePool();
	GLBufferPoolRef		gl4Pool = (_gl4Scene == nullptr) ? nullptr : _gl4Scene->privatePool();

	if (_sceneLoaded) {
		ISFSceneRef			renderScene = nullptr;

		if (_sceneUsesGL4) {
			renderScene = _gl4Scene;
		}
		else {
			renderScene = _gl2Scene;
		}


		if (renderScene != nullptr) {
			try {

				if (inRenderTime >= 0.) {
					renderScene->setBaseTime(Timestamp() - Timestamp(double(inRenderTime)));
				}

				//	if the host and the scene doing the rendering are using the same version of GL then this is a simple render
				if (_hostUsesGL4 == _sceneUsesGL4) {
					//if (inRenderTime < 0.)
					GLBufferRef			tmpBuffer = inTexFromMax->_pi->buffer();
					renderScene->renderToBuffer(tmpBuffer, inRenderSize);
					//else
					//	renderScene->renderToBuffer(inTexFromMax, inRenderSize, inRenderTime);
				}
				//	else there's a GL version mismatch between the host and render scene contexts- i have to render my scene to an IOSurface, and then copy that to the destination buffer i was passed
				else if (_hostUsesGL4 != _sceneUsesGL4) {
#if defined(VVGL_SDK_MAC)
					GLBufferPoolRef		renderPool = nullptr;
					GLBufferPoolRef		maxPool = nullptr;
					GLTexToTexCopierRef		hostCompatibleCopier = nullptr;
					GLBufferRef			renderIOSfc = nullptr;
					GLBufferRef			hostIOSfc = nullptr;

					if (_sceneUsesGL4) {
						renderPool = _gl4Scene->privatePool();
						maxPool = gl2Pool;
						hostCompatibleCopier = _gl2Scene->privateCopier();
						renderIOSfc = CreateRGBATexIOSurface(inRenderSize, false, renderPool);
					}
					else {
						renderPool = _gl2Scene->privatePool();
						maxPool = gl4Pool;
						hostCompatibleCopier = _gl4Scene->privateCopier();
						renderIOSfc = CreateRGBATexIOSurface(inRenderSize, false, renderPool);
					}

					//post("\trender tex is %s",renderIOSfc->getDescriptionString().c_str());
					//post("\tmax tex is %s",inTexFromMax->getDescriptionString().c_str());

					//if (inRenderTime < 0.)
					renderScene->renderToBuffer(renderIOSfc, inRenderSize);
					//else
					//	renderScene->renderToBuffer(renderIOSfc, inRenderSize, inRenderTime);
					hostIOSfc = CreateRGBATexFromIOSurfaceID(renderIOSfc->desc.localSurfaceID, false, maxPool);

					hostCompatibleCopier->ignoreSizeCopy(hostIOSfc, inTexFromMax->_pi->buffer());
#elif defined(VVGL_SDK_WIN)
					//post("\tctx mismatch");
					cout << "ERR: ctx mismatch in " << __PRETTY_FUNCTION__ << endl;
#endif
				}
			}
			catch (...) {
				//post("err rendering frame in %s",__func__);
			}
		}
	}

	if (gl2Pool != nullptr)
		gl2Pool->housekeeping();
	if (gl4Pool != nullptr)
		gl4Pool->housekeeping();
}


void ISFRendererImpl::setBufferForInputKey(const MyBufferRef & inBuffer, const std::string & inInputName) {
	//cout << __PRETTY_FUNCTION__ << endl;
	
	lock_guard<recursive_mutex>		lock(_sceneLock);

	if (_sceneLoaded) {
		//	find the IF attribute object that corresponds to this input name

		ISFSceneRef			renderScene = nullptr;
		if (_sceneUsesGL4)	{
			renderScene = _gl4Scene;
		}
		else	{
			renderScene = _gl2Scene;
		}
		ISFDocRef			renderDoc = (renderScene == nullptr) ? nullptr : renderScene->doc();
		ISFAttrRef			attr = (renderDoc == nullptr) ? nullptr : renderDoc->input(inInputName);
		if (attr != nullptr) {
			//	get the GLBufferRef behind the "MyBuffer" PIMPL wrapper
			GLBufferRef			inBufferRaw = inBuffer->_pi->buffer();
			//	this GLBufferRef may not be compatible with the render scene- check to see if it's in the same sharegroup
			GLContextRef		renderSceneContext = (renderScene==nullptr) ? nullptr : renderScene->context();
			GLContextRef		inBufferContext = (inBufferRaw==nullptr) ? nullptr : inBufferRaw->parentBufferPool->context();
			//	if one of the contexts we need is null, bail now, we can't proceed
			if (renderSceneContext==nullptr || inBufferContext==nullptr)	{
				cout << "ERR: context null in " << __PRETTY_FUNCTION__ << endl;
			}
			//	else if the render scene's context is compatible with the input buffer's context...
			else if (renderSceneContext->sameShareGroupAs(inBufferContext))	{
				//	we can use the buffer we were passed directly
				attr->setCurrentImageBuffer(inBufferRaw);
			}
			//	...else the render scene context and the input buffer context are *not* compatible...
			else	{
#if defined(VVGL_SDK_MAC)
				//	copy the buffer we were passed (from the host) to an IOSurface-backed buffer from the host-compatible pool using the host-compatible copier
				GLBufferPoolRef		hostBP = inBufferRaw->parentBufferPool;
				GLBufferRef			hostIOSfcTex = CreateRGBATexIOSurface(inBufferRaw->srcRect.size, false, hostBP);
				GLTexToTexCopierRef		hostCopier = (_hostUsesGL4) ? _gl4Scene->privateCopier() : _gl2Scene->privateCopier();
				if (hostCopier != nullptr)
					hostCopier->ignoreSizeCopy(inBufferRaw, hostIOSfcTex);
				
				//	use the IOSurface ID of the IOSurface-backed buffer we just created to create another texture from the appropriate pool
				GLBufferPoolRef		renderBP = renderScene->privatePool();
				GLBufferRef			renderIOSfcTex = CreateRGBATexFromIOSurfaceID(hostIOSfcTex->desc.localSurfaceID, false, renderBP);
				//	make sure the render IOSfcTex "retains" the host IOSfcTex (if we recycle it then if anything wrote to the host IOSfcTex, the updated image would "appear" in the rendered scene)
				renderIOSfcTex->associatedBuffer = hostIOSfcTex;
				//	pass this texture to the attr...
				attr->setCurrentImageBuffer(renderIOSfcTex);
#elif defined(VVGL_SDK_WIN)
				cout << "ERR: ctx mismatch in " << __PRETTY_FUNCTION__ << endl;
#endif
			}
			
			
			/*
			GLBufferRef			rawBuffer = inBuffer->_pi->buffer();
			attr->setCurrentImageBuffer(rawBuffer);
			*/
		}
		else {
			cout << "ERR: no attribute found named " << inInputName << " in " << __PRETTY_FUNCTION__ << endl;
		}
	}
	else {
		cout << "ERR: no file loaded yet, " << __PRETTY_FUNCTION__ << endl;
	}
}
std::vector<VVISF::ISFAttrRef> ISFRendererImpl::params() {
	ISFDocRef			tmpDoc = loadedISFDoc();
	if (tmpDoc == nullptr)
		return std::vector<ISFAttrRef>();
	return tmpDoc->inputs();
}
std::vector<std::string> ISFRendererImpl::paramNames() {
	ISFDocRef			tmpDoc = loadedISFDoc();
	if (tmpDoc == nullptr)
		return std::vector<std::string>();
	std::vector<std::string>		returnMe;
	auto				inputAttrs = tmpDoc->inputs();
	for (const auto & inputAttr : inputAttrs) {
		returnMe.push_back(inputAttr->name());
	}
	return returnMe;
}
VVISF::ISFAttrRef ISFRendererImpl::paramNamed(const std::string & inParamName) {
	ISFDocRef			tmpDoc = loadedISFDoc();
	if (tmpDoc == nullptr)
		return nullptr;
	return tmpDoc->input(inParamName);
}
VVISF::ISFValType ISFRendererImpl::valueTypeForParamNamed(const std::string & inParamName) {
	ISFDocRef			tmpDoc = loadedISFDoc();
	if (tmpDoc == nullptr)
		return ISFValType_None;
	ISFAttrRef			attr = tmpDoc->input(inParamName);
	if (attr == nullptr)
		return ISFValType_None;
	return attr->type();
}
void ISFRendererImpl::setCurrentValForParamNamed(const VVISF::ISFVal & inVal, const std::string & inInputName) {
	ISFDocRef			tmpDoc = loadedISFDoc();
	if (tmpDoc == nullptr)
		return;
	ISFAttrRef			attr = tmpDoc->input(inInputName);
	if (attr == nullptr)
		return;
	attr->setCurrentVal(inVal);
}








ISFDocRef ISFRendererImpl::loadedISFDoc()	{
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
GLBufferPoolRef ISFRendererImpl::loadedBufferPool()	{
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
GLBufferPoolRef ISFRendererImpl::hostBufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	if (_sceneLoaded)	{
		if (_hostUsesGL4 && _gl4Scene!=nullptr)	{
			return _gl4Scene->privatePool();
		}
		else if (!_hostUsesGL4 && _gl2Scene!=nullptr)	{
			return _gl2Scene->privatePool();
		}
	}
	return nullptr;
}


GLBufferPoolRef ISFRendererImpl::getGL2BufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl2Scene==nullptr) ? nullptr : _gl2Scene->privatePool();
}
GLBufferPoolRef ISFRendererImpl::getGL4BufferPool()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl4Scene==nullptr) ? nullptr : _gl4Scene->privatePool();
}


GLTexToTexCopierRef ISFRendererImpl::getGL2TextureCopier()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl2Scene==nullptr) ? nullptr : _gl2Scene->privateCopier();
}
GLTexToTexCopierRef ISFRendererImpl::getGL4TextureCopier()	{
	lock_guard<recursive_mutex>		lock(_sceneLock);
	return (_gl4Scene==nullptr) ? nullptr : _gl4Scene->privateCopier();
}




