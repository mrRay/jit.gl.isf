#ifndef ISFFileManager_hpp
#define ISFFileManager_hpp

//#include <stdio.h>
#include <vector>
#include <mutex>
#include <utility>
#include <string>
#include <map>

#include "ISFFile.hpp"




using namespace std;




class ISFFileManager
{
	public:
		
		virtual void populateEntries() = 0;
		virtual ISFFile fileEntryForName(const string & inName) = 0;
		
		virtual vector<string> fileNames() = 0;
		virtual vector<string> generatorNames() = 0;
		virtual vector<string> filterNames() = 0;
		virtual vector<string> transitionNames() = 0;
		virtual vector<string> categories() = 0;
		virtual vector<string> fileNamesForCategory(const string & inCategory) = 0;
		
	protected:
		recursive_mutex		_lock;
		map<string,ISFFile>		_fileEntries;
};




#endif /* ISFFileManager_hpp */
