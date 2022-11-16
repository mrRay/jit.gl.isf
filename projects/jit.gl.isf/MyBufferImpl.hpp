#ifndef MyBufferImpl_h
#define MyBufferImpl_h

#include "VVGL.hpp"

#include "ISFRendererImpl.hpp"




class MyBufferImpl {
private:
	VVGL::GLBufferRef		_buffer = nullptr;
public:
	MyBufferImpl();
	MyBufferImpl(const VVGL::GLBufferRef & inBufferRef = nullptr);
	~MyBufferImpl();

	VVGL::Size size();
	bool flipped();
	VVGL::GLBufferRef buffer();
};




MyBufferImpl * AllocBufferFromExistingTex_Impl(
	const int32_t & inTexName,
	const int32_t & inTexTarget,
	const VVGL::Size & inTexSize,
	const bool & inFlipped,
	const VVGL::Rect & inImgRect,
	ISFRendererImpl * inRenderer
);




#endif	//	MyBufferImpl_h
