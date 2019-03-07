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
		recursive_mutex		_sceneLock;	//	used to lock all ivars
		
		bool			_sceneLoaded = false;	//	false on init, set to true only after either a- the shader is successfully compiled or b- the shader has failed to compile on all scenes and is officially bunk until reloaded
		bool			_sceneUsesGL4 = false;	//	false by default, set to true if the selected ISF only compiles using GL 4
		
		ISFSceneRef		_gl2Scene = nullptr;
		ISFSceneRef		_gl4Scene = nullptr;
		
	public:
		ISFRenderer() = default;
		~ISFRenderer();
		
		void configureWithCache(const VVGLContextCacheItemRef & inCacheItem=nullptr);
		
		void loadFile(const string & inFilePath);
		void reloadFile();
		ISFDocRef loadedISFDoc();
		
		void render(const double & inRenderTime=-1.0);
};




#endif /* ISFRenderer_hpp */
