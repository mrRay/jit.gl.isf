#include "ISFFileManager_Win.hpp"

#include "VVISF.hpp"
//#include <unistd.h>
#include <sys/types.h>
//#include <pwd.h>
#include <algorithm>
/*
#include "jit.common.h"
#include "jit.gl.h"
//#include "ext_mess.h"
*/
#include <filesystem>




using namespace std;
using namespace VVGL;
using namespace VVISF;




void ISFFileManager_Win::populateEntries() {
	//post("%s",__func__);
	//cout << __PRETTY_FUNCTION__ << endl;
	lock_guard<recursive_mutex>		lock(_lock);

	_fileEntries.clear();

	GLContext::bootstrapGLEnvironmentIfNecessary();

	//	make a global buffer pool.  we're going to destroy it before this method exits, we just need the pool so the ISFDocs we're about to create don't throw exceptions b/c they're unable to load image resources to disk (b/c there's no buffer pool)
	GLContextRef			tmpCtx = CreateNewGLContextRef(NULL, AllocGL4ContextAttribs().get());
	tmpCtx->makeCurrent();
	CreateGlobalBufferPool(tmpCtx);

	//	add the built-in 'color bars' ISF
	addBuiltInColorBarsISF();

	//	add the files in the global ISF library
	//insertFilesFromDirectory(string("/ProgramData/ISF"), true);
	//	now add the files for the user-centric ISF library.  this will overwrite any duplicate entries from the global lib.
	
	//	under windows, the global ISF repository is /ProgramData/ISF on the boot drive
	const UINT			maxPathLen = 300;
	UINT				tmpPathLen = 0;
	TCHAR				tmpPathBuf[maxPathLen];
	//	try to get the system directory
	tmpPathLen = GetSystemDirectory(tmpPathBuf, maxPathLen);
	std::filesystem::path		rootPath;
	if (tmpPathLen > 0) {
		//wstring				tmpWStr(tmpPathBuf);
		//string				tmpStr(tmpPathBuf, tmpPathLen);
		//string				tmpStr(tmpWStr.begin(), tmpWStr.end());
		string				tmpStr(tmpPathBuf);
		
		std::filesystem::path		tmpPath(tmpStr);
		rootPath = tmpPath.root_path();
	}
	//	else we couldn't get the system directory for some reason...
	else {
		//	get the root path for the current directory, assume that's the boot drive
		std::filesystem::path		tmpPath = std::filesystem::current_path();
		rootPath = tmpPath.root_path();
	}
	
	//cout << "root path is " << rootPath << endl;
	std::filesystem::path		isfDir = rootPath;
	isfDir /= "ProgramData";
	isfDir /= "ISF";
	if (std::filesystem::exists(isfDir)) {
		insertFilesFromDirectory(isfDir.string(), true);
	}

	/*

	cout << "exists() = " << std::filesystem::exists(isfDir) << endl;
	cout << "root_name() = " << isfDir.root_name() << endl;
	cout << "root_path() = " << isfDir.root_path() << endl;
	cout << "relative_path() = " << isfDir.relative_path() << endl;
	cout << "parent_path() = " << isfDir.parent_path() << endl;
	cout << "filename() = " << isfDir.filename() << endl;
	cout << "stem() = " << isfDir.stem() << endl;
	cout << "extension() = " << isfDir.extension() << endl;

	cout << "************************" << endl;

	//	now add the default color bars ISF, so there's always at least one ISF loaded
	//string				filename = string("Default ColorBars");
	string				tmpPathStr("c:/ProgramData/ISF");
	std::filesystem::path		tmpPath(tmpPathStr);
	cout << "exists() = " << std::filesystem::exists(tmpPath) << endl;
	cout << "root_name() = " << tmpPath.root_name() << endl;
	cout << "root_path() = " << tmpPath.root_path() << endl;
	cout << "relative_path() = " << tmpPath.relative_path() << endl;
	cout << "parent_path() = " << tmpPath.parent_path() << endl;
	cout << "filename() = " << tmpPath.filename() << endl;
	cout << "stem() = " << tmpPath.stem() << endl;
	cout << "extension() = " << tmpPath.extension() << endl;
	*/

	//	DON'T FORGET TO DESTROY THIS GLOBAL BUFFER POOL
	SetGlobalBufferPool();
}

ISFFile ISFFileManager_Win::fileEntryForName(const string & inName) {
	lock_guard<recursive_mutex>		lock(_lock);
	ISFFile		returnMe = ISFFile(string(""), string(""), ISFFileType_None, string(""), vector<string>());
	try {
		returnMe = _fileEntries.at(inName);
	}
	catch (...) {
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::fileNames() {
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries) {
		returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::generatorNames() {
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries) {
		if ((fileIt.second.type() & ISFFileType_Source) == ISFFileType_Source)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::filterNames() {
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries) {
		if ((fileIt.second.type() & ISFFileType_Filter) == ISFFileType_Filter)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::transitionNames() {
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries) {
		if ((fileIt.second.type() & ISFFileType_Transition) == ISFFileType_Transition)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::categories() {
	//cout << __PRETTY_FUNCTION__ << endl;

	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	//	iterate through all the entries in the map
	for (const auto & fileIt : _fileEntries) {
		//cout << "\tchecking file " << fileIt.first << ", its cats are: ";
		//	run through every cat in this entry's categories vector
		for (const auto & fileCat : fileIt.second.categories()) {
			//cout << fileCat << " ";
			//	if the vector we're returning doesn't contain this category yet, add it
			if (find(returnMe.begin(), returnMe.end(), fileCat) == returnMe.end()) {
				returnMe.push_back(fileCat);
			}
		}
		//cout << endl;
	}
	return returnMe;
}

vector<string> ISFFileManager_Win::fileNamesForCategory(const string & inCategory) {
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	//	iterate through all the entries in the map
	for (const auto & fileIt : _fileEntries) {
		//	run through every cat in this entry's categories
		for (const auto & fileCat : fileIt.second.categories()) {
			//	if this category is a match for the passed category, add it
			if (CaseInsensitiveCompare(fileCat, inCategory)) {
				returnMe.push_back(fileIt.first);
				break;
			}
		}
	}
	return returnMe;
}


void ISFFileManager_Win::insertFilesFromDirectory(const string & inDirRaw, const bool & inRecursive) {
	//post("%s ... %s, %d",__func__,inDirRaw.c_str(),inRecursive);
	//cout << __PRETTY_FUNCTION__ << "... " << inDirRaw << " : " << inRecursive << endl;

	//	some static strings to avoid churn
	static string		*_fsstr = nullptr;
	static string		*_fragstr = nullptr;
	if (_fsstr == nullptr) {
		_fsstr = new string(".fs");
		_fragstr = new string(".frag");
	}

	filesystem::path		inDir(inDirRaw);

	for (const auto & tmpDirEntry : std::filesystem::directory_iterator(inDir)) {
		string			tmpExt = tmpDirEntry.path().extension().string();
		//cout << "\ttmpDirEntry is " << tmpDirEntry.path() << ", ext is " << tmpExt << endl;
		bool			isDir = tmpDirEntry.is_directory();
		if (!isDir && (CaseInsensitiveCompare(tmpExt, *_fsstr) || CaseInsensitiveCompare(tmpExt, *_fragstr))) {
			ISFFile			tmpFile = CreateISFFileFromPath(tmpDirEntry.path().string());
			if (tmpFile.isValid()) {
				_fileEntries[tmpFile.filename()] = tmpFile;
			}
		}
		if (inRecursive && isDir) {
			insertFilesFromDirectory(tmpDirEntry.path().string(), inRecursive);
		}
	}
}




ISFFile CreateISFFileFromPath(const string & inPath) {
	//cout << __PRETTY_FUNCTION__ << "... " << inPath << endl;
	string			filename = StringByDeletingExtension(LastPathComponent(inPath));
	string			filepath = inPath;
	//ISFFileType		type;
	//string			description;
	//vector<string>		categories;

	ISFDocRef		doc = CreateISFDocRef(filepath, nullptr, false);
	if (doc == nullptr) {
		return ISFFile(string(""), string(""), ISFFileType_None, string(""), vector<string>());
	}

	//type = doc->type();
	//description = doc->descripton();
	//categories = doc->categories();

	//return ISFFile(filename, filepath, type, description, categories);
	return ISFFile(filename, filepath, doc->type(), doc->description(), doc->categories());
}


