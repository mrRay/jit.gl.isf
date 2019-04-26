#ifndef ISFRendererImpl_hpp
#define ISFRendererImpl_hpp

#include "VVISF.hpp"
#include "VVGLContextCacheItem.hpp"
#include "MyBuffer.hpp"
#include <mutex>




using namespace std;
using namespace VVGL;
using namespace VVISF;




class ISFRendererImpl	{
	private:
		std::recursive_mutex		_sceneLock;	//	used to lock all ivars

		bool			_hostUsesGL4 = false;
		bool			_sceneLoaded = false;	//	false on init, set to true only after either a- the shader is successfully compiled or b- the shader has failed to compile on all scenes and is officially bunk until reloaded
		bool			_sceneUsesGL4 = false;	//	false by default, set to true if the selected ISF only compiles using GL 4
		bool			_hasInputImageKey = false;
		
		ISFSceneRef		_gl2Scene = nullptr;
		ISFSceneRef		_gl4Scene = nullptr;
		
		std::string		_filepath = string("");
		
	public:
		ISFRendererImpl();
		~ISFRendererImpl();
		
		//	this function must be called before any files are loaded or frames are rendered
		void configureWithCache(const VVGLContextCacheItemRef & inCacheItem=nullptr);
		
		//void loadFile(const string & inFilePath);
		void loadFile(const string * inFilePath=nullptr);
		void reloadFile();
		bool isFileLoaded() { return _sceneLoaded; }
		
		//GLBufferRef applyJitGLTexToInputKey(void *inJitGLTexNameSym, const string & inInputName);
		void setBufferForInputKey(const MyBufferRef & inBuffer, const std::string & inInputName);

		std::vector<VVISF::ISFAttrRef> params();
		std::vector<std::string> paramNames();
		VVISF::ISFAttrRef paramNamed(const std::string & inParamName);
		VVISF::ISFValType valueTypeForParamNamed(const std::string & inParamName);
		void setCurrentValForParamNamed(const VVISF::ISFVal & inVal, const std::string & inInputName);
		//std::vector<std::string> & labelArrayForParamNamed(const std::string & inInputName);
		//std::vector<int32_t> & valsArrayForParamNamed(const std::string & inInputName);
		
		void render(const MyBufferRef & inRenderTex, const VVGL::Size & inRenderSize, const double & inRenderTime=-1.0);


		ISFDocRef loadedISFDoc();
		//ISFSceneRef loadedISFScene();
		GLBufferPoolRef loadedBufferPool();
		GLBufferPoolRef hostBufferPool();
		//GLTexToTexCopierRef loadedTextureCopier();
		//bool hasInputImageKey();
		
		GLBufferPoolRef getGL2BufferPool();
		GLBufferPoolRef getGL4BufferPool();
		
		GLTexToTexCopierRef getGL2TextureCopier();
		GLTexToTexCopierRef getGL4TextureCopier();
};




#endif /* ISFRendererImpl_hpp */
