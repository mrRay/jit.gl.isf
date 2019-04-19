#ifndef ISFFileManager_hpp
#define ISFFileManager_hpp

//#include <stdio.h>
#include <vector>
#include <mutex>
#include <utility>
#include <string>
#include <map>

#include "ISFFile.hpp"




//using namespace std;




class ISFFileManager
{
	public:
		
		virtual void populateEntries() = 0;
		virtual ISFFile fileEntryForName(const std::string & inName) = 0;
		
		virtual std::vector<std::string> fileNames() = 0;
		virtual std::vector<std::string> generatorNames() = 0;
		virtual std::vector<std::string> filterNames() = 0;
		virtual std::vector<std::string> transitionNames() = 0;
		virtual std::vector<std::string> categories() = 0;
		virtual std::vector<std::string> fileNamesForCategory(const std::string & inCategory) = 0;
		
	protected:
		std::recursive_mutex		_lock;
		std::map<std::string,ISFFile>		_fileEntries;
};




#endif /* ISFFileManager_hpp */
