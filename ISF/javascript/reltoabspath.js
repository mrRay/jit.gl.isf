
function anything()	{
	var			args = arrayfromargs(messagename, arguments);
	if (args.length != 1)	{
		post("err: number of args is wrong, bailing\n");
		return;
	}
	
	var			myPatcher;
	myPatcher = this.patcher;
	while (myPatcher.parentpatcher != null)	{
		myPatcher = myPatcher.parentpatcher;
	}
	
	var			hostPath = myPatcher.filepath;
	var			hostPathArray = hostPath.split("/");
	//	remove the filename from the array of filepath components
	hostPathArray.pop();
	
	//	if the js object has an additional argument and it's "VolumeFormat" then the path output 
	//	will be formatted "/Volumes/drive/folder" instead of "drive:/folder"
	if (jsarguments.length > 1 && jsarguments[1]=="VolumesFormat")	{
		//	if this is running on a mac, the drive name shouldn't be "drive:/folder", instead it should be "/Volumes/drive/folder"
		if (this.max.os == "macintosh")	{
			var		tmpStr = hostPathArray[0];
			if (tmpStr[tmpStr.length-1] == ":")	{
				tmpStr = tmpStr.substring(0,tmpStr.length-1);
				hostPathArray[0] = tmpStr;
				hostPathArray.splice(0, 0, "Volumes");
			}
		}
	}
	
	var			inPath = args[0];
	var			inPathArray = inPath.split("/");
	
	//	run through the path we were passed
	var			tokenDiscardCount;
	for (tokenDiscardCount=0; tokenDiscardCount<inPathArray.length; ++tokenDiscardCount)	{
		//	if the user passed ".." as a component, remove an item from the end of the host path array
		if (inPathArray[tokenDiscardCount] == "..")
			hostPathArray.pop();
		else if (inPathArray[tokenDiscardCount] == ".")	{
			//	intentionally blank
		}
		else
			break;
	}
	
	//	now modify the array of filepath components we were passed, removing the ".." tokens we just used
	var			i;
	for (i=0; i<tokenDiscardCount; ++i)	{
		inPathArray.shift();
	}
	
	//	assemble the output string by combining the arrays
	var			fullPathArray = hostPathArray.concat(inPathArray);
	var			fullPath = "";
	for (i=0; i<fullPathArray.length; ++i)	{
		if (i==0)
			fullPath = fullPathArray[i];
		else
			fullPath += "/" + fullPathArray[i];
	}
	
	outlet(0,fullPath);
}