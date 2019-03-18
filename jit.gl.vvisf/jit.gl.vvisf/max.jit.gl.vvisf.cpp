#include "max.jit.gl.vvisf.h"

#include "jit.gl.vvisf.h"
#include "ISFRenderer.hpp"
#include "ISFFileManager_Mac.hpp"




t_class				*max_jit_gl_vvisf_class;

t_symbol			*ps_jit_gl_texture;
t_symbol			*ps_jit_matrix;
t_symbol			*ps_draw;
t_symbol			*ps_out_tex_sym;
t_symbol			*ps_file;
t_symbol			*ps_clear;
t_symbol			*ps_glid;

static ISFFileManager_Mac		*fm = NULL;




int C74_EXPORT main(void)
{
	ps_jit_gl_texture = gensym("jit_gl_texture");
	ps_jit_matrix = gensym("jit_matrix");
	ps_draw = gensym("draw");
	ps_out_tex_sym = gensym("out_tex_sym");
	ps_file = gensym("file");
	ps_clear = gensym("clear");
	ps_glid = gensym("glid");
	
	if (fm == NULL)	{
		fm = new ISFFileManager_Mac;
		fm->populateEntries();
	}
	
	void			*classex;
	void			*jitclass;
	
	// initialize our Jitter class
	jit_gl_vvisf_init();	
	
	// create our Max class
	setup(
		(t_messlist **)&max_jit_gl_vvisf_class, 
		(method)max_jit_gl_vvisf_new,
		(method)max_jit_gl_vvisf_free, 
		(short)sizeof(t_max_jit_gl_vvisf),
		0L,
		A_GIMME,
		0);
	
	//	we need notify messages to get information about jitter textures we've received
	//addmess((method)max_jit_gl_vvisf_notify, (char*)"notify", A_CANT, 0);
	
	// specify a byte offset to keep additional information about our object
	classex = max_jit_classex_setup(calcoffset(t_max_jit_gl_vvisf, obex));
	
	// look up our Jitter class in the class registry
	jitclass = jit_class_findbyname(gensym("jit_gl_vvisf"));	
		
	// wrap our Jitter class with the standard methods for Jitter objects
	max_jit_classex_standard_wrap(classex, jitclass, 0);	
	
	// custom draw handler so we can output our texture.
	// override default ob3d bang/draw methods
	//addbang((method)max_jit_gl_vvisf_bang);
	addfloat((method)max_jit_gl_vvisf_float);
	max_addmethod_defer_low((method)max_jit_gl_vvisf_draw, (char*)"draw");
	
	//	use our custom assist method so we can correctly label the relevant outputs
	addmess((method)max_jit_gl_vvisf_assist, (char*)"assist", A_CANT, 0);
	
	//addmess( (method)max_jit_gl_vvisf_anything, (char*)"anything", A_GIMME, 0L );
	
	//	the 'read' method basically just sets the file attribute
	addmess((method)max_jit_gl_vvisf_read, (char*)"read", A_SYM, 0L);
	
	//	the 'inputs' method causes the object to dump a list describing its inputs (name and type) out the INPUTS outlet
	addmess((method)max_jit_gl_vvisf_getparamlist, (char*)"getparamlist", 0L);
	addmess((method)max_jit_gl_vvisf_getparam, (char*)"getparam", A_SYM, 0L);
	
	addmess((method)max_jit_gl_vvisf_all_filenames, (char*)"all_filenames", 0L);
	addmess((method)max_jit_gl_vvisf_source_filenames, (char*)"source_filenames", 0L);
	addmess((method)max_jit_gl_vvisf_filter_filenames, (char*)"filter_filenames", 0L);
	addmess((method)max_jit_gl_vvisf_transition_filenames, (char*)"transition_filenames", 0L);
	addmess((method)max_jit_gl_vvisf_all_categories, (char*)"all_categories", 0L);
	addmess((method)max_jit_gl_vvisf_category_filenames, (char*)"category_filenames", A_SYM, 0L);
	
	// add methods for 3d drawing
	max_ob3d_setup();
	
}

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv)	{
	//post("%s",__func__);
	t_max_jit_gl_vvisf			*newObjPtr;
	void			*jit_ob;
	long			attrstart;
	t_symbol		*dest_name_sym = _jit_sym_nothing;
	
	if ((newObjPtr = (t_max_jit_gl_vvisf *) max_jit_obex_new(max_jit_gl_vvisf_class, gensym("jit_gl_vvisf"))))	{
		// get first normal arg, the destination name
		attrstart = max_jit_attr_args_offset(argc,argv);
		if (attrstart&&argv) 	{
			jit_atom_arg_getsym(&dest_name_sym, 0, attrstart, argv);
		}
		
		//	allocate the input texture map
		//newObjPtr->inputToHostTexNameMap = new std::map<std::string,std::string>();
		
		// instantiate Jitter object with dest_name arg
		if ((jit_ob = jit_object_new(gensym("jit_gl_vvisf"), dest_name_sym)))	{
			// set internal jitter object instance
			max_jit_obex_jitob_set(newObjPtr, jit_ob);
			
			// process attribute arguments 
			max_jit_attr_args(newObjPtr, argc, argv);
			
			// add a general purpose outlet (rightmost)
			newObjPtr->dumpout = outlet_new(newObjPtr, NULL);
			max_jit_obex_dumpout_set(newObjPtr, newObjPtr->dumpout);
			
		
			//	this outlet spits out lists decribing the various ISF files installed in globally-available locations
			newObjPtr->filesout = outlet_new(newObjPtr, NULL);
			
			//	this outlet spits out lists describing the various inputs
			newObjPtr->inputsout = outlet_new(newObjPtr, NULL);
			
			
			// this outlet is used to send textures
			newObjPtr->texout = outlet_new(newObjPtr, "jit_gl_texture");
			
			//	give the jitter object a weak ref to the t_max_jit_gl_vvisf struct that wraps it
			t_jit_gl_vvisf		*jitob = (t_jit_gl_vvisf*)max_jit_obex_jitob_get(newObjPtr);
			if (jitob != NULL)
				jitob->maxWrapperStruct = newObjPtr;
			else
				post("ERR: couldnt set weak ref in jit obj in %s",__func__);
		}
		else 	{
			error("jit.gl.syphon_server: could not allocate object");
			freeobject((t_object *)newObjPtr);
			newObjPtr = NULL;
		}
	}
	return (newObjPtr);
}

void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x)	{
	//post("%s",__func__);
	max_jit_ob3d_detach(x);

	// lookup our internal Jitter object instance and free
	if (max_jit_obex_jitob_get(x))	{
		jit_object_free(max_jit_obex_jitob_get(x));
	}
	
	// free resources associated with our obex entry
	max_jit_obex_free(x);
}


void max_jit_gl_vvisf_assist(t_max_jit_gl_vvisf *x, void *b, long m, long a, char *s)	{
	//post("%s",__func__);
	if (m == ASSIST_INLET)	{
		sprintf(s, "Commands, or GL textures in");
	}
	else if (m == ASSIST_OUTLET)	{
		switch (a)	{
		case 0:
			sprintf(s, "Rendered GL textures out");
			break;
		case 1:
			sprintf(s, "param information (\"getparamlist\", \"getparam\" <sym>)");
			break;
		case 2:
			sprintf(s, "File information (filesDump)");
			break;
		case 3:
			sprintf(s, "Dump output");
			break;
		}
	}
}


/*
void max_jit_gl_vvisf_anything(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	post("%s, argc is %d",__func__,argc);
}
*/
void max_jit_gl_vvisf_read(t_max_jit_gl_vvisf *targetInstance, t_symbol *s)	{
	//post("%s ... %s",__func__,s->s_name);
	if (s == nil)
		return;
	
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(targetInstance);
	if (jitob != NULL)	{
		bool				foundTheFile = false;
		//	we don't know if the passed symbol is a filename or a path- assume a filename at first
		string				inStr((char*)s->s_name);
		ISFFile				fileEntry = fm->fileEntryForName(inStr);
		if (fileEntry.isValid())
			jit_attr_setsym( jitob, ps_file, gensym(fileEntry.path().c_str()) );
		else
			jit_attr_setsym(jitob, ps_file, s);
	}
	
	max_jit_gl_vvisf_draw(targetInstance, ps_draw, 0, NULL);
}
void max_jit_gl_vvisf_getparamlist(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj==NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	ISFDocRef			tmpDoc = (renderer==NULL) ? nullptr : renderer->loadedISFDoc();
	if (tmpDoc != nullptr)	{
		//	send a "clear" message out the outlet ("getparamlist clear"
		outlet_anything(targetInstance->inputsout, ps_clear, 0, 0L);
		//t_atom			tmpAtom;
		//atom_setsym(&tmpAtom, ps_clear);
		//outlet_anything(targetInstance->inputsout, gensym("getparamlist"), 1, &tmpAtom);
		
		auto				tmpAttrs = tmpDoc->inputs();
		for (const auto & tmpAttr : tmpAttrs)	{
			max_jit_gl_vvisf_getparam(targetInstance, gensym( tmpAttr->name().c_str() ));
		}
		/*
		t_atom				tmpList[2];
		auto				tmpAttrs = tmpDoc->inputs();
		for (const auto & tmpAttr : tmpAttrs)	{
			atom_setsym(tmpList+0, gensym(tmpAttr->name().c_str()));	//	input name
			
			switch (tmpAttr->type())	{
			case ISFValType_None:
				break;
			case ISFValType_Event:
				break;
			case ISFValType_Bool:
				break;
			case ISFValType_Long:
				break;
			case ISFValType_Float:
				break;
			case ISFValType_Point2D:
				break;
			case ISFValType_Color:
				break;
			case ISFValType_Cube:
				break;
			case ISFValType_Image:
				break;
			case ISFValType_Audio:
				break;
			case ISFValType_AudioFFT:
				break;
			}
			
			outlet_anything(targetInstance->inputsout, gensym("input"), 1, tmpList);
		}
		*/
	}
	
}
void max_jit_gl_vvisf_getparam(t_max_jit_gl_vvisf *targetInstance, t_symbol *s)	{
	//post("%s ... %s",__func__,s->s_name);
	if (targetInstance==NULL || s==NULL)
		return;
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj==NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	ISFDocRef			tmpDoc = (renderer==NULL) ? nullptr : renderer->loadedISFDoc();
	string				attrName = string((char*)s->s_name);
	ISFAttrRef			tmpAttr = (tmpDoc==nullptr) ? nullptr : tmpDoc->input(attrName);
	ISFVal				tmpVal;
	if (tmpAttr != nullptr)	{
		t_atom				tmpList[7];
		atom_setsym(tmpList+0, gensym( tmpAttr->name().c_str() ));	//	input name
		atom_setsym(tmpList+2, gensym( tmpAttr->description().c_str() ));	//	input description
		
		
		switch (tmpAttr->type())	{
		case ISFValType_None:
			break;
		case ISFValType_Event:
			atom_setsym(tmpList+1, gensym("event"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_Bool:
			atom_setsym(tmpList+1, gensym("bool"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			//	default
			tmpVal = tmpAttr->defaultVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+5, gensym(""));
			else
				atom_setlong(tmpList+5, (tmpVal.getBoolVal())?1:0);
			//	current
			tmpVal = tmpAttr->currentVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+6, gensym(""));
			else
				atom_setlong(tmpList+6, (tmpVal.getBoolVal())?1:0);
			break;
		case ISFValType_Long:
			atom_setsym(tmpList+1, gensym("long"));	//	type
			//	min
			tmpVal = tmpAttr->minVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+3, gensym(""));
			else
				atom_setlong(tmpList+3, tmpVal.getLongVal());
			//	max
			tmpVal = tmpAttr->maxVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+4, gensym(""));
			else
				atom_setlong(tmpList+4, tmpVal.getLongVal());
			//	default
			tmpVal = tmpAttr->defaultVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+5, gensym(""));
			else
				atom_setlong(tmpList+5, tmpVal.getLongVal());
			//	current
			tmpVal = tmpAttr->currentVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+6, gensym(""));
			else
				atom_setlong(tmpList+6, tmpVal.getLongVal());
			break;
		case ISFValType_Float:
			atom_setsym(tmpList+1, gensym("float"));	//	type
			//	min
			tmpVal = tmpAttr->minVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+3, gensym(""));
			else
				atom_setfloat(tmpList+3, tmpVal.getDoubleVal());
			//	max
			tmpVal = tmpAttr->maxVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+4, gensym(""));
			else
				atom_setfloat(tmpList+4, tmpVal.getDoubleVal());
			//	default
			tmpVal = tmpAttr->defaultVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+5, gensym(""));
			else
				atom_setfloat(tmpList+5, tmpVal.getDoubleVal());
			//	current
			tmpVal = tmpAttr->currentVal();
			if (tmpVal.isNullVal())
				atom_setsym(tmpList+6, gensym(""));
			else
				atom_setfloat(tmpList+6, tmpVal.getDoubleVal());
			break;
		case ISFValType_Point2D:
			atom_setsym(tmpList+1, gensym("point2D"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_Color:
			atom_setsym(tmpList+1, gensym("color"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_Cube:
			atom_setsym(tmpList+1, gensym("cube"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_Image:
			atom_setsym(tmpList+1, gensym("image"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_Audio:
			atom_setsym(tmpList+1, gensym("audio"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		case ISFValType_AudioFFT:
			atom_setsym(tmpList+1, gensym("audioFFT"));	//	type
			atom_setsym(tmpList+3, gensym(""));	//	min
			atom_setsym(tmpList+4, gensym(""));	//	max
			atom_setsym(tmpList+5, gensym(""));	//	default
			atom_setsym(tmpList+6, gensym(""));	//	current
			break;
		}
		
		outlet_anything(targetInstance->inputsout, gensym("param"), 7, tmpList);
	}
}


void max_jit_gl_vvisf_all_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->fileNames();
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
}
void max_jit_gl_vvisf_source_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->generatorNames();
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
}
void max_jit_gl_vvisf_filter_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->filterNames();
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
}
void max_jit_gl_vvisf_transition_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->transitionNames();
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
}
void max_jit_gl_vvisf_all_categories(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("category_clear"), 0, 0L);
	
	vector<string>		categories = fm->categories();
	t_atom				outAtom;
	
	for (const auto & category : categories)	{
		//post("\tcat is %s",category.c_str());
		atom_setsym(&outAtom, gensym( category.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("category"), 1, &outAtom);
	}
}
void max_jit_gl_vvisf_category_filenames(t_max_jit_gl_vvisf *targetInstance, t_symbol *s)	{
	//post("%s ... %s",__func__,s->s_name);
	if (targetInstance==NULL || s==NULL)
		return;
	if (fm == NULL)
		return;
	
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->fileNamesForCategory(string(s->s_name));
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
}


	/*
void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(targetInstance);
	if (jitob != NULL)
		jit_attr_setlong(jitob, gensym("needsRedraw"), 1);
	
	max_jit_gl_vvisf_draw(targetInstance, ps_draw, 0, NULL);
}
	*/
void max_jit_gl_vvisf_float(t_max_jit_gl_vvisf *targetInstance, double n)	{
	//post("%s",__func__);
	//	pass the render time to the jitter object
	t_jit_gl_vvisf			*jitob = (t_jit_gl_vvisf*)max_jit_obex_jitob_get(targetInstance);
	if (jitob == NULL)
		return;
	jitob->renderTimeOverride = n;
	/*
	jit_attr_setlong(jitob, gensym("needsRedraw"), 1);
	//	tell the jitter object to draw & output
	max_jit_gl_vvisf_draw(targetInstance, ps_draw, 0, NULL);
	*/
}


void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv)	{
	//post("%s",__func__);
	
	/*
	//	run through the entries in 'inputToHostTexNameMap', creating GLBufferRefs that wrap the various jitter textures and pushing them to the renderer
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(x);
	ISFRenderer			*renderer = jit_gl_vvisf_get_renderer(jitObj);
	auto				iter = x->inputToHostTexNameMap->begin();
	while (iter != x->inputToHostTexNameMap->end())	{
		string			&jitTextureName = iter->second;
		t_symbol		*jitTextureNameSym = gensym((char*)jitTextureName.c_str());
		renderer->applyJitGLTexToInputKey(jitTextureNameSym, iter->first);
		++iter;
	}
	*/
	
	t_atom				a;
	// get the jitter object
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	
	// call the jitter object's draw method
	jit_object_method(jitob, s, s, argc, argv);
	
	// query the texture name and send out the texture output 
	jit_atom_setsym(&a, jit_attr_getsym(jitob, ps_out_tex_sym));
	
	outlet_anything(x->texout, ps_jit_gl_texture, 1, &a);
}



