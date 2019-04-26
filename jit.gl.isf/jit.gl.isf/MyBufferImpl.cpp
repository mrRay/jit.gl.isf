#include "MyBufferImpl.hpp"




MyBufferImpl::MyBufferImpl() {

}
MyBufferImpl::MyBufferImpl(const VVGL::GLBufferRef & inBufferRef) {
	_buffer = inBufferRef;
}
MyBufferImpl::~MyBufferImpl() {
	_buffer = nullptr;
}


VVGL::Size MyBufferImpl::size() {
	return _buffer->size;
}
VVGL::GLBufferRef MyBufferImpl::buffer() {
	return _buffer;
}







MyBufferImpl * AllocBufferFromExistingTex_Impl(
	const int32_t & inTexName,
	const int32_t & inTexTarget,
	const VVGL::Size & inTexSize,
	const bool & inFlipped,
	const VVGL::Rect & inImgRect,
	ISFRendererImpl * inRenderer
) {
	using namespace VVGL;
	
	GLBufferRef			tmpBuffer = nullptr;

	if (inRenderer != nullptr) {
		GLBufferPoolRef		tmpPool = inRenderer->hostBufferPool();
		tmpBuffer = CreateFromExistingGLTexture(
			inTexName,
			static_cast<GLBuffer::Target>(inTexTarget),
			GLBuffer::IF_RGBA8,
			GLBuffer::PF_BGRA,
			GLBuffer::PT_UInt_8888_Rev,
			inTexSize,
			inFlipped,
			inImgRect,
			nullptr,
			nullptr,
			tmpPool);
	}
	
	return new MyBufferImpl(tmpBuffer);
}

