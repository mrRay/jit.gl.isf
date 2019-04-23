#ifndef ISFRenderer_h
#define ISFRenderer_h

#include "VVGLContextCacheItem.hpp"
#include "MyBuffer.hpp"
#include <string>
#include "ISFVal.hpp"




class ISFRendererImpl;




/*		same basic deal as 'MyBuffer'- the GLEW headers throw errors if they're #included before max, and the max headers throw errors if they're #included before GLEW, so we keep 'em separate using a prive implementation (ISFRendererImpl). 				*/




class ISFRenderer {
public:
	ISFRendererImpl		*_pi = nullptr;
public:
	ISFRenderer();
	~ISFRenderer();

	//	this function must be called before any files are loaded or frames are rendered
	void configureWithCache(const VVGLContextCacheItemRef & inCacheItem = nullptr);

	void loadFile(const std::string * inFilePath = nullptr);
	void reloadFile();
	bool isFileLoaded();

	void setBufferForInputKey(const MyBufferRef & inBuffer, const std::string & inInputName);

	std::vector<VVISF::ISFAttrRef> params();
	std::vector<std::string> paramNames();
	VVISF::ISFAttrRef paramNamed(const std::string & inParamName);
	VVISF::ISFValType valueTypeForParamNamed(const std::string & inParamName);
	void setCurrentValForParamNamed(const VVISF::ISFVal & inVal, const std::string & inInputName);
	
	void render(const MyBufferRef & inRenderTex, const VVGL::Size & inRenderSize, const double & inRenderTime = -1.0);
};




#endif	//	ISFRenderer_h
