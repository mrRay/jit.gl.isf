#include "ISFRenderer.hpp"

#include "ISFRendererImpl.hpp"
#include "MyBuffer.hpp"



ISFRenderer::ISFRenderer() {
	_pi = new ISFRendererImpl();
}

ISFRenderer::~ISFRenderer() {
	if (_pi != nullptr)	{
		delete _pi;
		_pi = nullptr;
	}
}

void ISFRenderer::configureWithCache(const VVGLContextCacheItemRef & inCacheItem) {
	if (_pi == nullptr)
		return;
	_pi->configureWithCache(inCacheItem);
}

void ISFRenderer::loadFile(const std::string * inFilePath) {
	if (_pi == nullptr)
		return;
	_pi->loadFile(inFilePath);
}
void ISFRenderer::reloadFile() {
	if (_pi == nullptr)
		return;
	_pi->reloadFile();
}
bool ISFRenderer::isFileLoaded()	{
	if (_pi == nullptr)
		return false;
	return _pi->isFileLoaded();
}



void ISFRenderer::setBufferForInputKey(const MyBufferRef & inBuffer, const std::string & inInputName) {
	if (_pi == nullptr)
		return;
	_pi->setBufferForInputKey(inBuffer, inInputName);
}
std::vector<VVISF::ISFAttrRef> ISFRenderer::params() {
	if (_pi == nullptr)
		return std::vector<ISFAttrRef>();
	return _pi->params();
}
std::vector<std::string> ISFRenderer::paramNames() {
	if (_pi == nullptr)
		return std::vector<std::string>();
	return _pi->paramNames();
}
VVISF::ISFAttrRef ISFRenderer::paramNamed(const std::string & inParamName) {
	if (_pi == nullptr)
		return nullptr;
	return _pi->paramNamed(inParamName);
}
VVISF::ISFValType ISFRenderer::valueTypeForParamNamed(const std::string & inParamName) {
	if (_pi == nullptr)
		return ISFValType_None;
	return _pi->valueTypeForParamNamed(inParamName);
}
void ISFRenderer::setCurrentValForParamNamed(const VVISF::ISFVal & inVal, const std::string & inInputName) {
	if (_pi == nullptr)
		return;
	_pi->setCurrentValForParamNamed(inVal, inInputName);
}




void ISFRenderer::render(const MyBufferRef & inRenderTex, const VVGL::Size & inRenderSize, const double & inRenderTime) {
	if (_pi == nullptr)
		return;
	_pi->render(inRenderTex, inRenderSize, inRenderTime);
}


