#pragma once
#ifndef ISFFileManager_Win_hpp
#define ISFFileManager_Win_hpp

#include "ISFFileManager.hpp"




class ISFFileManager_Win : virtual public ISFFileManager
{
public:
	ISFFileManager_Win() = default;

	//	clears my local map of entries, repopulates it with the appropriate directories
	virtual void populateEntries();
	//	the returned ISFFile should have its "isValid()" method queried to determine if it's valid or not (if a file entry was found or not)
	virtual ISFFile fileEntryForName(const std::string & inName);

	virtual std::vector<std::string> fileNames();
	virtual std::vector<std::string> generatorNames();
	virtual std::vector<std::string> filterNames();
	virtual std::vector<std::string> transitionNames();
	virtual std::vector<std::string> categories();
	virtual std::vector<std::string> fileNamesForCategory(const std::string & inCategory);

private:
	void insertFilesFromDirectory(const std::string & inDirRaw, const bool & inRecursive = false);
};




ISFFile CreateISFFileFromPath(const std::string & inPath);




#endif /* ISFFileManager_Win_hpp */
