#ifndef ISFRenderer_hpp
#define ISFRenderer_hpp

#include "VVISF.hpp"
#include "VVGLContextCacheItem.hpp"
#include <mutex>




using namespace std;
using namespace VVGL;
using namespace VVISF;




class ISFRenderer	{
	private:
		std::recursive_mutex		_sceneLock;	//	used to lock all ivars
		
		bool			_hostUsesGL4 = false;
		bool			_sceneLoaded = false;	//	false on init, set to true only after either a- the shader is successfully compiled or b- the shader has failed to compile on all scenes and is officially bunk until reloaded
		bool			_sceneUsesGL4 = false;	//	false by default, set to true if the selected ISF only compiles using GL 4
		
		ISFSceneRef		_gl2Scene = nullptr;
		ISFSceneRef		_gl4Scene = nullptr;
		
		std::string		_filepath = string("");
		
	public:
		ISFRenderer() = default;
		~ISFRenderer();
		
		//	this function must be called before any files are loaded or frames are rendered
		void configureWithCache(const VVGLContextCacheItemRef & inCacheItem=nullptr);
		
		//void loadFile(const string & inFilePath);
		void loadFile(const string * inFilePath=nullptr);
		void reloadFile();
		ISFDocRef loadedISFDoc();
		ISFSceneRef loadedISFScene();
		GLBufferPoolRef loadedBufferPool();
		GLTexToTexCopierRef loadedTextureCopier();
		
		GLBufferPoolRef getGL2BufferPool();
		GLBufferPoolRef getGL4BufferPool();
		
		GLTexToTexCopierRef getGL2TextureCopier();
		GLTexToTexCopierRef getGL4TextureCopier();
		
		void render(const GLBufferRef & inRenderTex, const VVGL::Size & inRenderSize, const double & inRenderTime=-1.0);
};




#endif /* ISFRenderer_hpp */
