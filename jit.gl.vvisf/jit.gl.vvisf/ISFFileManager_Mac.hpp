#ifndef ISFFileManager_Mac_hpp
#define ISFFileManager_Mac_hpp

#include "ISFFileManager.hpp"




class ISFFileManager_Mac : virtual public ISFFileManager
{
	public:
		ISFFileManager_Mac() = default;
		
		//	clears my local map of entries, repopulates it with the appropriate directories
		virtual void populateEntries();
		//	the returned ISFFile should have its "isValid()" method queried to determine if it's valid or not (if a file entry was found or not)
		virtual ISFFile fileEntryForName(const string & inName);
		
		virtual vector<string> fileNames();
		virtual vector<string> generatorNames();
		virtual vector<string> filterNames();
		virtual vector<string> transitionNames();
		virtual vector<string> categories();
		virtual vector<string> fileNamesForCategory(const string & inCategory);
		
	private:
		void insertFilesFromDirectory(const string & inDirRaw, const bool & inRecursive=false);
};




ISFFile CreateISFFileFromPath(const string & inPath);




#endif /* ISFFileManager_Mac_hpp */
