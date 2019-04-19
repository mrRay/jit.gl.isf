#include "MyBuffer.hpp"

#include "MyBufferImpl.hpp"
#include "ISFRendererImpl.hpp"
#include "ISFRenderer.hpp"



MyBuffer::MyBuffer() {

}
MyBuffer::MyBuffer(MyBufferImpl * inPrivImplAssumesOwnership) {
	_pi = inPrivImplAssumesOwnership;
}
MyBuffer::~MyBuffer() {
	if (_pi != nullptr) {
		delete _pi;
		_pi = nullptr;
	}
}
VVGL::Size MyBuffer::size() {
	if (_pi == nullptr)
		return VVGL::Size(0, 0);
	return _pi->size();
}













MyBufferRef CreateBufferFromExistingTex(
	const int32_t & inTexName,
	const int32_t & inTexTarget,
	const VVGL::Size & inTexSize,
	const bool & inFlipped,
	const VVGL::Rect & inImgRect,
	const ISFRenderer * inRenderer
) {
	MyBufferImpl		*newImpl = AllocBufferFromExistingTex_Impl(inTexName, inTexTarget, inTexSize, inFlipped, inImgRect, inRenderer->_pi);
	return std::make_shared<MyBuffer>(newImpl);
	//return nullptr;
}
