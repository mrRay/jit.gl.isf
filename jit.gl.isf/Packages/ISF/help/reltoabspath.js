
function anything()	{
	var			args = arrayfromargs(messagename, arguments);
	if (args.length != 1)	{
		post("err: number of args is wrong, bailing\n");
		return;
	}
	
	var			myPatcher;
	myPatcher = this.patcher;
	//while (myPatcher.parentpatcher != null)	{
	//	myPatcher = myPatcher.parentPatcher;
	//}
	while (myPatcher.parentpatcher != null)	{
		myPatcher = myPatcher.parentpatcher;
	}
	
	var			hostPath = myPatcher.filepath;
	var			hostPathArray = hostPath.split("/");
	//	remove the filename from the array of filepath components
	hostPathArray.pop();
	
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