#ifndef MyBuffer_h
#define MyBuffer_h

#include <memory>

#include "VVGL_Geom.hpp"

class ISFRenderer;




class MyBufferImpl;
class MyBuffer;
using MyBufferRef = std::shared_ptr<MyBuffer>;




/*		VVGL/VVISF have a "GLBuffer" class that represents a GL texture, but including this class will pull in the GLEW headers used by these libs on windows.  there's nothing inherently wrong with this...but when you try to use this with max, you run into a problem: if you include the max headers first, GLEW throws an error (because this would include gl.h before GLEW).  if you include the GLEW headers first, the max headers throw an error because internally one of its defines has the same name as one of GLEW's defines.

that's why this class exists: "MyBuffer" is safe to include and use from the max/jitter code, and it's really just a wrapper around GLBuffer.				*/




class MyBuffer {
public:
	MyBufferImpl			*_pi = nullptr;
public:
	MyBuffer();
	MyBuffer(MyBufferImpl * inPrivImplAssumesOwnership);
	~MyBuffer();

	VVGL::Size size();
};




MyBufferRef CreateBufferFromExistingTex(
	const int32_t & inTexName,
	const int32_t & inTexTarget,
	const VVGL::Size & inTexSize,
	const bool & inFlipped,
	const VVGL::Rect & inImgRect,
	const ISFRenderer * inRenderer
);




#endif	//	MyBuffer_h
