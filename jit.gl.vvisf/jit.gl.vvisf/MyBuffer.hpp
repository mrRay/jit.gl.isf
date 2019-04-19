#ifndef MyBuffer_h
#define MyBuffer_h

#include <memory>

#include "VVGL_Geom.hpp"

class ISFRenderer;




class MyBufferImpl;
class MyBuffer;
using MyBufferRef = std::shared_ptr<MyBuffer>;




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
