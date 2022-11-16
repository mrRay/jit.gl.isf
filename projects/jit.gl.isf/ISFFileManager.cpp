#include "ISFFileManager.hpp"





using namespace std;




void ISFFileManager::addBuiltInColorBarsISF() {
	//	the "path" to this "file" is "VDVX:COLORBARS".  this is how we're dealing with a hard-coded ISF with no actual path in an infrastructure built around paths.
	ISFFile				file("Default Color Bars", "VDVX:COLORBARS", ISFFileType_Source, "", vector<string>());
	_fileEntries[file.filename()] = file;
}



