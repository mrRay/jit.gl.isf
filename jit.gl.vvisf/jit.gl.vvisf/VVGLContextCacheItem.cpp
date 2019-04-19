#include "VVGLContextCacheItem.hpp"

#include "VVGLContextCacheItemImpl.hpp"




//VVGLContextCacheItemRef GetCacheItemForContext(const GLContextRef & inHostCtx);

static recursive_mutex						_VVGLContextCacheArrayLock;
static vector<VVGLContextCacheItemRef>		_VVGLContextCacheArray;




VVGLContextCacheItem::VVGLContextCacheItem() {
	//cout << __PRETTY_FUNCTION__ << endl;
	_pi = new VVGLContextCacheItemImpl();
}
VVGLContextCacheItem::VVGLContextCacheItem(VVGLContextCacheItemImpl * inPrivImplAssumesOwnership) {
	//cout << __PRETTY_FUNCTION__ << endl;
	_pi = inPrivImplAssumesOwnership;
}
VVGLContextCacheItem::~VVGLContextCacheItem() {
	//cout << __PRETTY_FUNCTION__ << endl;
	if (_pi != nullptr) {
		delete _pi;
		_pi = nullptr;
	}
}




#if defined(VVGL_SDK_MAC)
bool VVGLContextCacheItem::matchesContext(const CGLContextObj & inCtx) {
	if (_pi == nullptr)
		return false;
	return _pi->matchesContext(inCtx);
}
#elif defined(VVGL_SDK_WIN)
bool VVGLContextCacheItem::matchesContext(const HGLRC & inGLCtx, const HDC & inDevCtx) {
	if (_pi == nullptr)
		return false;
	return _pi->matchesContext(inGLCtx, inDevCtx);
}
#endif




#if defined(VVGL_SDK_MAC)
VVGLContextCacheItemRef GetCacheItemForContext(const CGLContextObj & inHostCtx) {
	//	run through the array, looking for a cache item with a private implementation that matches the passed ctx
	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);

	for (auto cacheIt = _VVGLContextCacheArray.begin(); cacheIt != _VVGLContextCacheArray.end(); ++cacheIt) {
		if ((*cacheIt)->matchesContext(inHostCtx)) {
			VVGLContextCacheItemRef		returnMe = *(cacheIt);
			_VVGLContextCacheArray.erase(cacheIt);
			return returnMe;
		}
	}

	//	...if i'm here, i couldn't find a cache item matching the passed GL info- i need to create one

	if (_VVGLContextCacheArray.capacity() < 4)
		_VVGLContextCacheArray.reserve(4);
	
	VVGLContextCacheItemImpl		*newPrivImpl = new VVGLContextCacheItemImpl(inHostCtx);
	VVGLContextCacheItemRef			returnMe = (newPrivImpl==nullptr) ? nullptr : make_shared<VVGLContextCacheItem>(newPrivImpl);
	return returnMe;
}
#elif defined(VVGL_SDK_WIN)
VVGLContextCacheItemRef GetCacheItemForContext(const HGLRC & inHostCtx, const HDC & inHostDevCtx) {
	//	run through the array, looking for a cache item with a private implementation that matches the passed ctx
	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);

	for (auto cacheIt = _VVGLContextCacheArray.begin(); cacheIt != _VVGLContextCacheArray.end(); ++cacheIt) {
		if ((*cacheIt)->matchesContext(inHostCtx, inHostDevCtx))	{
			VVGLContextCacheItemRef		returnMe = *(cacheIt);
			_VVGLContextCacheArray.erase(cacheIt);
			return returnMe;
		}
	}
	
	//	...if i'm here, i couldn't find a cache item matching the passed GL info-  i need to create one

	if (_VVGLContextCacheArray.capacity() < 4)
		_VVGLContextCacheArray.reserve(4);

	VVGLContextCacheItemImpl	*newPrivImpl = new VVGLContextCacheItemImpl(inHostCtx, inHostDevCtx);
	VVGLContextCacheItemRef		returnMe = (newPrivImpl==nullptr) ? nullptr : make_shared<VVGLContextCacheItem>(newPrivImpl);
	return returnMe;
}
#endif
/*
VVGLContextCacheItemRef GetCacheItemForContext(const GLContextRef & inHostCtx) {
	//	run through the array, looking for a cache item with a private implementation that matches the passed ctx
	return nullptr;
}
*/
void ReturnCacheItemToPool(const VVGLContextCacheItemRef & inItem) {
	if (inItem == nullptr)	{
		return;
	}

	lock_guard<recursive_mutex>		lock(_VVGLContextCacheArrayLock);
	if (_VVGLContextCacheArray.size() >= _VVGLContextCacheArray.max_size()) {
		_VVGLContextCacheArray.erase(_VVGLContextCacheArray.begin());
	}
	_VVGLContextCacheArray.push_back(inItem);
}

