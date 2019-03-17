//
//  ISFFile.hpp
//  jit.gl.vvisf
//
//  Created by testAdmin on 3/13/19.
//

#ifndef ISFFile_hpp
#define ISFFile_hpp

#include <string>
#include <vector>

#include "VVISF.hpp"




using namespace std;
using namespace VVISF;




class ISFFile
{
	public:
		ISFFile() : _filename(""), _path(""), _type(ISFFileType_None), _description("") {}
		ISFFile(const string & inFilename, const string & inPath, const ISFFileType & inType, const string & inDescription, const vector<string> & inCategories) : _filename(inFilename), _path(inPath), _type(inType), _description(inDescription), _categories(inCategories) {}
		
		string			_filename;
		string			_path;
		ISFFileType		_type;
		string			_description;
		vector<string>		_categories;
		
		inline bool matchesFilename(const string & inFilename) const { if (inFilename==_filename) return true; return false; }
		inline bool matchesPath(const string & inPath) const { if (inPath==_path) return true; return false; }
		inline const string & filename() const { return _filename; }
		inline const string & path() const { return _path; }
		inline const ISFFileType & type() const { return _type; }
		inline const string & description() const { return _description; }
		inline const vector<string> & categories() const { return _categories; }
		
		inline bool isValid() const { if (_filename.length()<1 || _path.length()<1 || _type==ISFFileType_None) return false; return true; }
};




#endif /* ISFFile_hpp */
