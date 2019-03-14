#include "ISFFileManager_Mac.hpp"

#include "VVISF.hpp"
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <algorithm>

#include "jit.common.h"
#include "jit.gl.h"
//#include "ext_mess.h"




using namespace std;
using namespace VVGL;
using namespace VVISF;





@interface VVISFSpecialClassName : NSObject
@end
@implementation VVISFSpecialClassName
@end




NSString *RealHomeDirectory() {
    struct passwd *pw = getpwuid(getuid());
    assert(pw);
    return [NSString stringWithUTF8String:pw->pw_dir];
}




void ISFFileManager_Mac::populateEntries(){
	//post("%s",__func__);
	lock_guard<recursive_mutex>		lock(_lock);
	
	_fileEntries.clear();
	
	@autoreleasepool	{
		//	make a global buffer pool.  we're going to destroy it before this method exits, we just need the pool so the ISFDocs we're about to create don't throw exceptions b/c they're unable to load image resources to disk (b/c there's no buffer pool)
		CreateGlobalBufferPool();
		
		//	add the files in the global ISF library
		insertFilesFromDirectory(string([@"/Library/Graphics/ISF" UTF8String]), true);
		//	now add the files for the user-centric ISF library.  this will overwrite any duplicate entries from the global lib.
		insertFilesFromDirectory(string([[RealHomeDirectory() stringByAppendingPathComponent:@"Library/Graphics/ISF"] UTF8String]), true);
		
		//	now add the default color bars ISF, so there's always at least one ISF loaded
		string				filename = string("Default ColorBars");
		NSString			*tmpPath = [[NSBundle bundleForClass:[VVISFSpecialClassName class]] pathForResource:@"Default ColorBars" ofType:@"fs"];
		if (tmpPath != nil)	{
			string				filepath = string([tmpPath UTF8String]);
			string				description = string("Default Color Bars");
			vector<string>		cats;
			cats.push_back(string("Vidvox"));
			ISFFile				tmpFile = ISFFile(filename, filepath, ISFFileType_Source, description, cats);
			//_fileEntries[filename] = tmpFile;
			_fileEntries.emplace(filename, tmpFile);
		}
		//	DON'T FORGET TO DESTROY THIS GLOBAL BUFFER POOL
		SetGlobalBufferPool();
		
	}
}

ISFFile ISFFileManager_Mac::fileEntryForName(const string & inName)	{
	lock_guard<recursive_mutex>		lock(_lock);
	ISFFile		returnMe = ISFFile(string(""), string(""), ISFFileType_None, string(""), vector<string>());
	try	{
		returnMe = _fileEntries.at(inName);
	}
	catch (...)	{
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::fileNames()	{
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries)	{
		returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::generatorNames()	{
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries)	{
		if ((fileIt.second.type() & ISFFileType_Source)==ISFFileType_Source)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::filterNames()	{
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries)	{
		if ((fileIt.second.type() & ISFFileType_Filter)==ISFFileType_Filter)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::transitionNames()	{
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	returnMe.reserve(_fileEntries.size());
	for (const auto & fileIt : _fileEntries)	{
		if ((fileIt.second.type() & ISFFileType_Transition)==ISFFileType_Transition)
			returnMe.push_back(fileIt.first);
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::categories()	{
	//cout << __PRETTY_FUNCTION__ << endl;
	
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	//	iterate through all the entries in the map
	for (const auto & fileIt : _fileEntries)	{
		//cout << "\tchecking file " << fileIt.first << ", its cats are: ";
		//	run through every cat in this entry's categories vector
		for (const auto & fileCat : fileIt.second.categories())	{
			//cout << fileCat << " ";
			//	if the vector we're returning doesn't contain this category yet, add it
			if (find(returnMe.begin(), returnMe.end(), fileCat) == returnMe.end())	{
				returnMe.push_back(fileCat);
			}
		}
		//cout << endl;
	}
	return returnMe;
}

vector<string> ISFFileManager_Mac::fileNamesForCategory(const string & inCategory)	{
	lock_guard<recursive_mutex>		lock(_lock);
	vector<string>		returnMe;
	//	iterate through all the entries in the map
	for (const auto & fileIt : _fileEntries)	{
		//	run through every cat in this entry's categories
		for (const auto & fileCat : fileIt.second.categories())	{
			//	if this category is a match for the passed category, add it
			if (CaseInsensitiveCompare(fileCat, inCategory))	{
				returnMe.push_back(fileIt.first);
				break;
			}
		}
	}
	return returnMe;
}


void ISFFileManager_Mac::insertFilesFromDirectory(const string & inDirRaw, const bool & inRecursive)	{
	//post("%s ... %s, %d",__func__,inDirRaw.c_str(),inRecursive);
	
	//	some static strings to avoid churn
	static string		*_fsstr = nullptr;
	static string		*_fragstr = nullptr;
	if (_fsstr == nullptr)	{
		_fsstr = new string("fs");
		_fragstr = new string("frag");
	}
	
	@autoreleasepool	{
		NSFileManager		*fm = [NSFileManager defaultManager];
		NSString			*inDir = [NSString stringWithUTF8String:StringByDeletingLastAndAddingFirstSlash(inDirRaw).c_str()];
		NSArray				*filenames = [fm contentsOfDirectoryAtPath:inDir error:nil];
		//	run through the files
		for (NSString *filename in filenames)	{
			string				filenameStdStr = string([filename UTF8String]);
			string				fullpath = FmtString("%s/%s",[inDir UTF8String],[filename UTF8String]);
			string				extension = PathFileExtension(filenameStdStr);
			BOOL				isDir = NO;
			
			if ([fm fileExistsAtPath:[NSString stringWithUTF8String:fullpath.c_str()] isDirectory:&isDir])	{
				//	if it's not a directory and the extension suggests that it's a frag shader
				if (!isDir && (CaseInsensitiveCompare(extension,*_fsstr) || CaseInsensitiveCompare(extension,*_fragstr)))	{
					ISFFile			tmpFile = CreateISFFileFromPath(fullpath);
					if (tmpFile.isValid())	{
						//_fileEntries[tmpFile.filename()] = tmpFile;
						_fileEntries.emplace(tmpFile.filename(), tmpFile);
					}
				}
				//	if this is supposed to be recursive and this is a directory...
				if (inRecursive && isDir)	{
					insertFilesFromDirectory(fullpath, inRecursive);
				}
			}
		}
	}
	
}




ISFFile CreateISFFileFromPath(const string & inPath)	{
	string			filename = StringByDeletingExtension(LastPathComponent(inPath));
	string			filepath = inPath;
	//ISFFileType		type;
	//string			description;
	//vector<string>		categories;
	
	ISFDocRef		doc = CreateISFDocRef(filepath, nullptr, false);
	if (doc == nullptr)	{
		return ISFFile(string(""), string(""), ISFFileType_None, string(""), vector<string>());
	}
	
	//type = doc->type();
	//description = doc->descripton();
	//categories = doc->categories();
	
	//return ISFFile(filename, filepath, type, description, categories);
	return ISFFile(filename, filepath, doc->type(), doc->description(), doc->categories());
}


