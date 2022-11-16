#include "max.jit.gl.isf.h"

#include "jit.gl.isf.h"
#include "jit.gl.common.h"

#include "ext_drag.h"

#include "ISFRenderer.hpp"
#include "ISFAttr.hpp"
#include "VVISF_Base.hpp"

#if defined(VVGL_SDK_MAC)
#include "ISFFileManager_Mac.hpp"
#elif defined(VVGL_SDK_WIN)
#include "ISFFileManager_Win.hpp"
#endif

#include <algorithm>



t_max_err max_jit_gl_vvisf_notify(t_max_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *sender, void *data);
void max_jit_gl_vvisf_open(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_dblclick(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_edclose(t_max_jit_gl_vvisf *x, char **ht, long size);
short max_jit_gl_vvisf_edsave(t_max_jit_gl_vvisf *x, char **ht, long size, char *fn, short vol);
void max_jit_gl_vvisf_eddidsave(t_max_jit_gl_vvisf *x, char *filename, short path);
void max_jit_gl_vvisf_getsyntax(t_max_jit_gl_vvisf *x, t_symbol **syntax);
void max_jit_gl_vvisf_watch_begin(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_watch_end(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_filechanged(t_max_jit_gl_vvisf *x, char *filename, short path);
t_atom_long max_jit_gl_vvisf_acceptsdrag(t_max_jit_gl_vvisf *x, t_object *drag, t_object *view);

t_class				*max_jit_gl_vvisf_class;

t_symbol			*ps_jit_gl_texture;
t_symbol			*ps_jit_matrix;
t_symbol			*ps_draw;
t_symbol			*ps_out_name;
t_symbol			*ps_file;
t_symbol			*ps_clear;
t_symbol			*ps_done;
t_symbol			*ps_glid;
//t_symbol			*ps_emptyString;
t_symbol			*ps_param;
t_symbol			*ps_name;
t_symbol			*ps_type;
t_symbol			*ps_label;
t_symbol			*ps_description;
t_symbol			*ps_credit;
t_symbol			*ps_vsn;
t_symbol			*ps_default;
t_symbol			*ps_min;
t_symbol			*ps_max;
t_symbol			*ps_value;
t_symbol			*ps_values;
t_symbol			*ps_labels;
t_symbol			*ps_getparamlist;
t_symbol			*ps_filenames;
t_symbol			*ps_categories;
t_symbol			*ps_category;
t_symbol			*ps_attr_modified;


#if defined(VVGL_SDK_MAC)
static ISFFileManager_Mac		*fm = NULL;
#elif defined(VVGL_SDK_WIN)
static ISFFileManager_Win		*fm = NULL;
#endif

using namespace std;

void* max_jit_gl_vvisf_getisffilemanager() {
	return fm;
}



int C74_EXPORT main(void)
{
	ps_jit_gl_texture = gensym("jit_gl_texture");
	ps_jit_matrix = gensym("jit_matrix");
	ps_draw = gensym("draw");
	ps_out_name = gensym("out_name");
	ps_file = gensym("file");
	ps_clear = gensym("clear");
	ps_done = gensym("done");
	ps_glid = gensym("glid");
	//ps_emptyString = gensym("");
	ps_param = gensym("param");
	ps_name = gensym("name");
	ps_type = gensym("type");
	ps_label = gensym("label");
	ps_description = gensym("description");
	ps_credit = gensym("credit");
	ps_vsn = gensym("vsn");
	ps_default = gensym("default");
	ps_min = gensym("min");
	ps_max = gensym("max");
	ps_value = gensym("value");
	ps_values = gensym("values");
	ps_labels = gensym("labels");
	ps_getparamlist = gensym("getparamlist");
	ps_filenames = gensym("filenames");
	ps_categories = gensym("categories");
	ps_category = gensym("category");
	ps_attr_modified = gensym("attr_modified");
	
	if (fm == NULL)	{
#if defined(VVGL_SDK_MAC)
		fm = new ISFFileManager_Mac;
#elif defined(VVGL_SDK_WIN)
		fm = new ISFFileManager_Win;
#endif
		fm->populateEntries();
	}
	
	
	t_class			*maxclass;
	t_class			*jitclass;
	
	// initialize our Jitter class
	jit_gl_vvisf_init();	
	
	// create our Max class
	maxclass = class_new("jit.gl.isf", (method)max_jit_gl_vvisf_new, (method)max_jit_gl_vvisf_free, sizeof(t_max_jit_gl_vvisf), NULL, A_GIMME, 0);
	// specify a byte offset to keep additional information about our object
	max_jit_class_obex_setup(maxclass, calcoffset(t_max_jit_gl_vvisf, obex));
	// look up our Jitter class in the class registry
	jitclass = (t_class*)jit_class_findbyname(gensym("jit_gl_vvisf"));
	// wrap our Jitter class with the standard methods for Jitter objects
	max_jit_class_wrap_standard(maxclass, jitclass, 0);

	// custom draw handler so we can output our texture.
	// override default ob3d bang/draw methods
	//addbang((method)max_jit_gl_vvisf_bang);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_float, "float", A_FLOAT, 0);
	
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_draw, (char*)"draw");
	
	//	use our custom assist method so we can correctly label the relevant outputs
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_assist, (char*)"assist", A_CANT, 0);

	class_addmethod(maxclass, (method)max_jit_gl_vvisf_dblclick, "dblclick", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_edclose, "edclose", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_edsave, "edsave", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_eddidsave, "eddidsave", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_getsyntax, "getsyntax", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_open, "open", 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_filechanged, "filechanged", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_acceptsdrag, "acceptsdrag_unlocked", A_CANT, 0);
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_acceptsdrag, "acceptsdrag_locked", A_CANT, 0);

	
	//	the 'read' method basically just sets the file attribute
	max_jit_class_addmethod_usurp_low(maxclass, (method)max_jit_gl_vvisf_read, (char*)"read");
	
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_getparamlist, (char*)"getparamlist");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_getparam, (char*)"getparam");
	
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_all_filenames, (char*)"all_filenames");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_source_filenames, (char*)"source_filenames");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_filter_filenames, (char*)"filter_filenames");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_transition_filenames, (char*)"transition_filenames");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_all_categories, (char*)"all_categories");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_category_filenames, (char*)"category_filenames");
	
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_description, (char*)"description");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_credit, (char*)"credit");
	max_jit_class_addmethod_defer_low(maxclass, (method)max_jit_gl_vvisf_vsn, (char*)"vsn");
	
	// add methods for 3d drawing
	max_jit_class_ob3d_wrap(maxclass);
	
	// override default ob3d notify handler
	class_addmethod(maxclass, (method)max_jit_gl_vvisf_notify,	"notify", A_CANT,0);
	
	class_register(CLASS_BOX, maxclass);
	max_jit_gl_vvisf_class = maxclass;
	
}

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv)	{
	//post("%s",__func__);
	t_max_jit_gl_vvisf			*newObjPtr;
	void			*jit_ob;
	long			attrstart;
	t_symbol		*dest_name_sym = _jit_sym_nothing;
	
	if ((newObjPtr = (t_max_jit_gl_vvisf *) max_jit_object_alloc(max_jit_gl_vvisf_class, gensym("jit_gl_vvisf"))))	{
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
			
			// add a general purpose outlet (rightmost)
			newObjPtr->dumpout = outlet_new(newObjPtr, NULL);
			max_jit_obex_dumpout_set(newObjPtr, newObjPtr->dumpout);
		
			//	this outlet spits out lists decribing the various ISF files installed in globally-available locations
			newObjPtr->filesout = outlet_new(newObjPtr, NULL);
			
			//	this outlet spits out lists describing the various inputs
			newObjPtr->inputsout = outlet_new(newObjPtr, NULL);
			
			// this outlet is used to send textures
			newObjPtr->texout = outlet_new(newObjPtr, "jit_gl_texture");
			
			newObjPtr->j_edit = NULL;
			newObjPtr->source = NULL;
			newObjPtr->source_length = 0;
			newObjPtr->watcher = NULL;
			
			// attach max object to jitter object to receive notifications
			max_jit_ob3d_attach(newObjPtr, (t_jit_object*)jit_ob, NULL);

			//	give the jitter object a weak ref to the t_max_jit_gl_vvisf struct that wraps it
			t_jit_gl_vvisf		*jitob = (t_jit_gl_vvisf*)max_jit_obex_jitob_get(newObjPtr);
			if (jitob != NULL)
				jitob->maxWrapperStruct = newObjPtr;
			else
				post("ERR: couldnt set weak ref in jit obj in %s",__func__);
			
			// finally process attribute arguments after object setup is complete
			max_jit_attr_args(newObjPtr, argc, argv);
		}
		else 	{
			error("jit.gl.isf: could not allocate object");
			freeobject((t_object *)newObjPtr);
			newObjPtr = NULL;
		}
	}
	return (newObjPtr);
}

void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x)	{
	max_jit_gl_vvisf_watch_end(x);
	if(x->source) {
		sysmem_lockhandle(x->source,0);
		sysmem_freehandle(x->source);
	}
	if (x->j_edit)
		freeobject((t_object *)x->j_edit);

	//post("%s",__func__);
	max_jit_ob3d_detach(x);

	// lookup our internal Jitter object instance and free
	if (max_jit_obex_jitob_get(x))	{
		jit_object_free(max_jit_obex_jitob_get(x));
	}
	
	// free resources associated with our obex entry
	max_jit_object_free(x);
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
			sprintf(s, "Parameter information outlet");
			break;
		case 2:
			sprintf(s, "File information outlet");
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
void max_jit_gl_vvisf_read(t_max_jit_gl_vvisf *targetInstance, t_symbol *sym, long argc, t_atom *argv)	{
	//post("%s ... %s",__func__,s->s_name);
	t_symbol *filesym = _jit_sym_nothing;
	if (argc && argv) {
		filesym = atom_getsym(argv);
	}
	else {
		// open the dialog for the file if unspecified
		char pathname[MAX_PATH_CHARS];
		char pathfile[MAX_PATH_CHARS];
		t_fourcc filetype = FOUR_CHAR_CODE( 'ISFS' );
		short volume = 0;
		pathfile[0] = 0;
		if (open_dialog(pathfile, &volume, &filetype, &filetype, 1)) {
			return;
		}
		path_topathname(volume, pathfile, pathname);
		filesym = gensym(pathname);
	}
	
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(targetInstance);
	if (jitob != NULL)	{
		jit_attr_setsym(jitob, ps_file, filesym);
	}
}
void max_jit_gl_vvisf_getparamlist(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj == NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	if (renderer == NULL)
		return;
	
	//	send a "getparamlist clear" message out the outlet
	t_atom				clearList;
	atom_setsym(&clearList, ps_clear);
	outlet_anything(targetInstance->inputsout, ps_getparamlist, 1, &clearList);
	
	//	send the param names: "name <paramname>"
	vector<string>			paramNames = renderer->paramNames();
	for (const string & paramName : paramNames)	{
		t_atom			tmpList[1];
		
		//atom_setsym(tmpList+0, ps_param);
		//atom_setsym(tmpList+1, ps_name);
		atom_setsym(tmpList+0, gensym( paramName.c_str() ));
		
		outlet_anything(targetInstance->inputsout, ps_name, 1, tmpList);
	}
	
	//	send a "getparamlist done" message out the outlet
	t_atom				doneList;
	atom_setsym(&doneList, ps_done);
	outlet_anything(targetInstance->inputsout, ps_getparamlist, 1, &doneList);
}
void max_jit_gl_vvisf_getparam(t_max_jit_gl_vvisf *targetInstance, t_symbol *sym, long argc, t_atom *argv)	{
	
	//post("%s ... %s",__func__,paramNameSym->s_name);
	if (targetInstance==NULL || argc<2 || argv==NULL)
		return;
	
	t_symbol *paramNameSym = atom_getsym(argv);
	t_symbol *paramTypeSym = atom_getsym(argv+1);
	
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj==NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	//ISFDocRef			tmpDoc = (renderer==NULL) ? nullptr : renderer->loadedISFDoc();
	string				attrName = string((char*)paramNameSym->s_name);
	//ISFAttrRef			tmpAttr = (tmpDoc==nullptr) ? nullptr : tmpDoc->input(attrName);
	ISFAttrRef			tmpAttr = (renderer == nullptr) ? nullptr : renderer->paramNamed(attrName);
	
	if (tmpAttr == nullptr)
		return;
	
	
	
	//	some attributes are common to all INPUT types (the values returned don't change type or format or size based on the INPUT's type)
	if (paramTypeSym == ps_type)	{
		//	return "type <param name> <param type as string>"
		t_atom			tmpList[2];
		//	param's name
		atom_setsym(tmpList+0, paramNameSym);
		//	the param's type as a string
		string			tmpStr = StringFromISFValType(tmpAttr->type());
		std::transform(tmpStr.begin(), tmpStr.end(), tmpStr.begin(), ::tolower);
		atom_setsym(tmpList+1, gensym(tmpStr.c_str()) );
		//	send the msg, then return
		outlet_anything(targetInstance->inputsout, ps_type, 2, tmpList);
		return;
	}
	else if (paramTypeSym == ps_label)	{
		//	return "label <param name> <param label, or empty string>
		t_atom			tmpList[2];
		//	param's name
		atom_setsym(tmpList+0, paramNameSym);
		//	the param's label as a string
		atom_setsym(tmpList+1, gensym(tmpAttr->label().c_str()) );
		//	send the msg, then return
		outlet_anything(targetInstance->inputsout, ps_label, 2, tmpList);
		return;
	}
	else if (paramTypeSym == ps_description)	{
		//	return "description <param name> <param description, or empty string>
		t_atom			tmpList[2];
		//	param's name
		atom_setsym(tmpList+0, paramNameSym);
		//	the param's description as a string
		atom_setsym(tmpList+1, gensym(tmpAttr->description().c_str()) );
		//	send the msg, then return
		outlet_anything(targetInstance->inputsout, ps_description, 2, tmpList);
		return;
	}
	else if (paramTypeSym == ps_values)	{
		//	return "values <param name> <list of values, or empty string>
		vector<int32_t>		&valArray = tmpAttr->valArray();
		//int					tmpListLength = max(long(1), long(valArray.size())) + 1;	//	param name + list length (or at least one empty string)
		int					tmpListLength = long(valArray.size()) + 1;	//	param name + list length
		t_atom				*tmpList = static_cast<t_atom*>(malloc(sizeof(atom) * tmpListLength));
		atom_setsym(tmpList+0, paramNameSym);
		if (valArray.size() < 1)	{
			//atom_setsym(tmpList+1, ps_emptyString);
		}
		else	{
			t_atom				*wPtr = tmpList+1;
			for (const int32_t & val : valArray)	{
				atom_setlong(wPtr, val);
				++wPtr;
			}
		}
		outlet_anything(targetInstance->inputsout, ps_values, tmpListLength, tmpList);
		free(tmpList);
		return;
	}
	else if (paramTypeSym == ps_labels)	{
		//	return "labels <param name> <list of labels, or empty string>
		vector<string>		&labelArray = tmpAttr->labelArray();
		//int					tmpListLength = max(long(1), long(labelArray.size())) + 1;	//	param name + list length (or at least one empty string)
		int					tmpListLength = long(labelArray.size()) + 1;	//	param name + list length
		t_atom				*tmpList = static_cast<t_atom*>(malloc(sizeof(atom) * tmpListLength));
		atom_setsym(tmpList+0, paramNameSym);
		if (labelArray.size() < 1)	{
			//atom_setsym(tmpList+1, ps_emptyString);
		}
		else	{
			t_atom				*wPtr = tmpList+1;
			for (const string & label : labelArray)	{
				atom_setsym(wPtr, gensym(label.c_str()) );
				++wPtr;
			}
		}
		outlet_anything(targetInstance->inputsout, ps_labels, tmpListLength, tmpList);
		free(tmpList);
		return;
	}
	
	
	//	...if we're here, the user requested the attribute of a parameter that can potentially change significantly from one attribute type to another
	
	
	switch (tmpAttr->type())	{
	case ISFValType_None:
		break;
	
	case ISFValType_Event:
	case ISFValType_Cube:
	case ISFValType_Image:
		{
			if ((paramTypeSym == ps_default) || (paramTypeSym == ps_min) || (paramTypeSym == ps_max) || (paramTypeSym == ps_value))	{
				//	return "<paramTypeSym> <param name> <empty string>"
				t_atom			tmpList[2];
				atom_setsym(tmpList+0, paramNameSym);
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
				return;
			}
		}
		break;
	case ISFValType_Bool:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <value, or empty string>"
			t_atom			tmpList[2];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setlong(tmpList+1, (tmpVal.getBoolVal()) ? 1 : 0);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 2, tmpList);
			}
			return;
		}
		break;
	case ISFValType_Long:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <value, or empty string>"
			t_atom			tmpList[2];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setlong(tmpList+1, tmpVal.getLongVal());
				outlet_anything(targetInstance->inputsout, paramTypeSym, 2, tmpList);
			}
			return;
		}
		break;
	case ISFValType_Float:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <value, or empty string>"
			t_atom			tmpList[2];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setfloat(tmpList+1, tmpVal.getDoubleVal());
				outlet_anything(targetInstance->inputsout, paramTypeSym, 2, tmpList);
			}
			return;
		}
		break;
	case ISFValType_Point2D:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <x value> <y value>
			t_atom			tmpList[3];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setfloat(tmpList+1, tmpVal.getPointValByIndex(0));
				atom_setfloat(tmpList+2, tmpVal.getPointValByIndex(1));
				outlet_anything(targetInstance->inputsout, paramTypeSym, 3, tmpList);
			}
			return;
		}
		break;
	case ISFValType_Color:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <x value> <y value>
			t_atom			tmpList[5];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setfloat(tmpList+1, tmpVal.getColorValByChannel(0));
				atom_setfloat(tmpList+2, tmpVal.getColorValByChannel(1));
				atom_setfloat(tmpList+3, tmpVal.getColorValByChannel(2));
				atom_setfloat(tmpList+4, tmpVal.getColorValByChannel(3));
				outlet_anything(targetInstance->inputsout, paramTypeSym, 5, tmpList);
			}
			return;
		}
		break;
	case ISFValType_Audio:
	case ISFValType_AudioFFT:
		{
			ISFVal			tmpVal;
			if (paramTypeSym == ps_default)
				tmpVal = tmpAttr->defaultVal();
			else if (paramTypeSym == ps_min)
				tmpVal = tmpAttr->minVal();
			else if (paramTypeSym == ps_max)
				tmpVal = tmpAttr->maxVal();	
			else if (paramTypeSym == ps_value)
				tmpVal = tmpAttr->currentVal();
			//	return "<paramTypeSym> <param name> <value, or empty string>"
			t_atom			tmpList[2];
			atom_setsym(tmpList+0, paramNameSym);
			if (tmpVal.isNullVal())	{
				//atom_setsym(tmpList+1, ps_emptyString);
				outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
			}
			else	{
				atom_setlong(tmpList+1, tmpVal.getLongVal());
				outlet_anything(targetInstance->inputsout, paramTypeSym, 2, tmpList);
			}
			return;
		}
	}
	
	//	if we're here...there's nothing to return!
	//	return "<paramTypeSym> <param name> <empty string>"
	t_atom			tmpList[2];
	atom_setsym(tmpList+0, paramNameSym);
	//atom_setsym(tmpList+1, ps_emptyString);
	outlet_anything(targetInstance->inputsout, paramTypeSym, 1, tmpList);
}


void max_jit_gl_vvisf_all_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	//	send a "filenames clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &clearAtom);
	//	send the actual filenames as a series of "name <filename>" messages
	vector<string>		filenames = fm->fileNames();
	t_atom				outAtom;
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, ps_name, 1, &outAtom);
	}
	//	send a "filenames done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &doneAtom);
}
void max_jit_gl_vvisf_source_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	//	send a "filenames clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &clearAtom);
	//	send the actual filenames as a series of "name <filename>" messages
	vector<string>		filenames = fm->generatorNames();
	t_atom				outAtom;
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, ps_name, 1, &outAtom);
	}
	//	send a "filenames done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &doneAtom);
}
void max_jit_gl_vvisf_filter_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	//	send a "filenames clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &clearAtom);
	//	send the actual filenames as a series of "name <filename>" messages
	vector<string>		filenames = fm->filterNames();
	t_atom				outAtom;
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, ps_name, 1, &outAtom);
	}
	//	send a "filenames done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &doneAtom);
}
void max_jit_gl_vvisf_transition_filenames(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	//	send a "filenames clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &clearAtom);
	//	send the actual filenames as a series of "name <filename>" messages
	vector<string>		filenames = fm->transitionNames();
	t_atom				outAtom;
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, ps_name, 1, &outAtom);
	}
	//	send a "filenames done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &doneAtom);
}
void max_jit_gl_vvisf_all_categories(t_max_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	
	if (targetInstance==NULL)
		return;
	if (fm == NULL)
		return;
	
	//	send a "categories clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_categories, 1, &clearAtom);
	//	send the actual category names as a series of "category <categoryname>" messages
	vector<string>		categories = fm->categories();
	t_atom				outAtom;
	for (const auto & category : categories)	{
		atom_setsym(&outAtom, gensym( category.c_str() ));
		outlet_anything(targetInstance->filesout, ps_category, 1, &outAtom);
	}
	//	send a "categories done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_categories, 1, &doneAtom);
	
	/*
	outlet_anything(targetInstance->filesout, gensym("category_clear"), 0, 0L);
	
	vector<string>		categories = fm->categories();
	t_atom				outAtom;
	
	for (const auto & category : categories)	{
		//post("\tcat is %s",category.c_str());
		atom_setsym(&outAtom, gensym( category.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("category"), 1, &outAtom);
	}
	*/
}
void max_jit_gl_vvisf_category_filenames(t_max_jit_gl_vvisf *targetInstance, t_symbol *sym, long argc, t_atom *argv)	{
	//post("%s ... %s",__func__,s->s_name);
	
	if (targetInstance==NULL || !argc || argv==NULL)
		return;
	if (fm == NULL)
		return;
	
	t_symbol *category = atom_getsym(argv);
	//	send a "filenames clear" message
	t_atom			clearAtom;
	atom_setsym(&clearAtom, ps_clear);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &clearAtom);
	//	send the actual filenames as a series of "name <filename>" messages
	vector<string>		filenames = fm->fileNamesForCategory(string(category->s_name));
	t_atom				outAtom;
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, ps_name, 1, &outAtom);
	}
	//	send a "filenames done" message
	t_atom			doneAtom;
	atom_setsym(&doneAtom, ps_done);
	outlet_anything(targetInstance->filesout, ps_filenames, 1, &doneAtom);
	
	/*
	outlet_anything(targetInstance->filesout, gensym("filename_clear"), 0, 0L);
	
	vector<string>		filenames = fm->fileNamesForCategory(string(s->s_name));
	t_atom				outAtom;
	
	for (const auto & filename : filenames)	{
		atom_setsym(&outAtom, gensym( filename.c_str() ));
		outlet_anything(targetInstance->filesout, gensym("filename"), 1, &outAtom);
	}
	*/
}


void max_jit_gl_vvisf_description(t_max_jit_gl_vvisf *targetInstance)	{
	if (targetInstance==NULL)
		return;
	
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj == NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	if (renderer == NULL)
		return;
	ISFDocRef			doc = renderer->loadedISFDoc();
	if (doc == nullptr)
		return;
	
	//	send a "description <actual description>" message
	string			tmpStr = doc->description();
	t_atom			msg;
	atom_setsym(&msg, gensym(tmpStr.c_str()));
	outlet_anything(targetInstance->filesout, ps_description, 1, &msg);
}
void max_jit_gl_vvisf_credit(t_max_jit_gl_vvisf *targetInstance)	{
	if (targetInstance==NULL)
		return;
	
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj == NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	if (renderer == NULL)
		return;
	ISFDocRef			doc = renderer->loadedISFDoc();
	if (doc == nullptr)
		return;
	
	//	send a "credit <actual credit>" message
	string			tmpStr = doc->credit();
	t_atom			msg;
	atom_setsym(&msg, gensym(tmpStr.c_str()));
	outlet_anything(targetInstance->filesout, ps_credit, 1, &msg);
}
void max_jit_gl_vvisf_vsn(t_max_jit_gl_vvisf *targetInstance)	{
	if (targetInstance==NULL)
		return;
	
	//	get the ISF file's INPUTS, dump them out the approrpiate outlet
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	ISFRenderer			*renderer = (jitObj == NULL) ? NULL : jit_gl_vvisf_get_renderer(jitObj);
	if (renderer == NULL)
		return;
	ISFDocRef			doc = renderer->loadedISFDoc();
	if (doc == nullptr)
		return;
	
	//	send a "vsn <actual vsn>" message
	string			tmpStr = doc->vsn();
	t_atom			msg;
	atom_setsym(&msg, gensym(tmpStr.c_str()));
	outlet_anything(targetInstance->filesout, ps_vsn, 1, &msg);
}


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
	
	t_atom				a;
	// get the jitter object
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	
	// call the jitter object's draw method
	jit_object_method(jitob, s, s, argc, argv);
	
	// query the texture name and send out the texture output 
	jit_atom_setsym(&a, jit_attr_getsym(jitob, ps_out_name));
	
	outlet_anything(x->texout, ps_jit_gl_texture, 1, &a);
}

t_max_err max_jit_gl_vvisf_notify(t_max_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *sender, void *data)
{
	if(msg == ps_attr_modified) {
		t_symbol *name = (t_symbol *)object_method((t_object *)data, _jit_sym_getname);
		if(name == ps_file) {
			max_jit_gl_vvisf_watch_begin(x);
		}
	}
	return MAX_ERR_NONE;
}

void max_jit_gl_vvisf_edclose(t_max_jit_gl_vvisf *x, char **ht, long size)
{
	//void *job = max_jit_obex_jitob_get(x);
	//if(jit_attr_getsym(job, ps_file) != _jit_sym_nothing)
		//jit_attr_setsym(job, ps_file, jit_attr_getsym(job, ps_file));
	x->j_edit = 0;
	if(x->source)
		sysmem_lockhandle(x->source,1);
}

short max_jit_gl_vvisf_edsave(t_max_jit_gl_vvisf *x, char **ht, long size, char *fn, short vol)
{
	return 0;	// did not save, let jed do it
}

void max_jit_gl_vvisf_eddidsave(t_max_jit_gl_vvisf *x, char *filename, short path)
{
	char pathname[MAX_PATH_CHARS];
	path_topathname(path, filename, pathname);
	jit_attr_setsym(max_jit_obex_jitob_get(x), ps_file, gensym(pathname));
}

void max_jit_gl_vvisf_getsyntax(t_max_jit_gl_vvisf *x, t_symbol **syntax)
{
	*syntax = gensym(".js");
}

void max_jit_gl_vvisf_open(t_max_jit_gl_vvisf *x)
{
	defer_medium(x,(method)max_jit_gl_vvisf_dblclick,0,0,0);
}

void max_jit_gl_vvisf_watch_begin(t_max_jit_gl_vvisf *x)
{
	void *job = max_jit_obex_jitob_get(x);
	t_symbol *fullpath = jit_attr_getsym(job, ps_file);
	short path = 0;
	char pathname[MAX_PATH_CHARS];
	char filename[MAX_FILENAME_CHARS];
	t_max_err err;
	
	if(!fullpath)
		return;
	
	strcpy(pathname, fullpath->s_name);
	err = path_frompathname(pathname, &path, filename);
	if (!err && filename[0] != 0) {
		max_jit_gl_vvisf_watch_end(x);
		x->watcher = filewatcher_new((t_object*)x, path, filename);
		filewatcher_start(x->watcher);
	}
}

void max_jit_gl_vvisf_watch_end(t_max_jit_gl_vvisf *x)
{
	object_free(x->watcher);
	x->watcher = NULL;
}

void max_jit_gl_vvisf_filechanged(t_max_jit_gl_vvisf *x, char *filename, short path)
{
	jit_attr_setsym(max_jit_obex_jitob_get(x), ps_file, jit_attr_getsym(max_jit_obex_jitob_get(x), ps_file));
}

void max_jit_gl_vvisf_dblclick(t_max_jit_gl_vvisf *x)
{
	t_symbol *fullpath;
	short curvol;
	void *job = max_jit_obex_jitob_get(x);
	t_filehandle fh;
	t_max_err err;
	char pathname[MAX_PATH_CHARS];
	char filename[MAX_FILENAME_CHARS];
	
	if (!x->j_edit) {
		x->j_edit = (t_object *) object_new(CLASS_NOBOX, gensym("jed"), x, 0);
	}
	else {
		object_attr_setchar(x->j_edit, gensym("visible"), 1);
		return;
	}
	
	fullpath = jit_attr_getsym(job, ps_file);
	if(!fullpath) {
		object_method(x->j_edit, gensym("settext"), "", gensym("utf-8"));
		return;
	}
	
	strcpy(pathname, fullpath->s_name);
	if(path_frompathname(pathname, &curvol, filename)) {
		object_method(x->j_edit, gensym("settext"), "", gensym("utf-8"));
		return;
	}

	object_method(x->j_edit, gensym("filename"), filename, curvol);
	
	if(x->source) {
		sysmem_lockhandle(x->source,0);
		sysmem_freehandle(x->source);
	}
	x->source = NULL;
	x->source = sysmem_newhandle(16);
	
	// open the file with read-only permissions
	err = path_opensysfile(filename,curvol,&fh, PATH_READ_PERM);
	
	if (!err) {
		sysfile_readtextfile(fh,x->source,0,TEXT_LB_UNIX);
		sysfile_close(fh);
		x->source_length = sysmem_handlesize(x->source);
		sysmem_nullterminatehandle(x->source);
	}
	else {
		object_method(x->j_edit, gensym("settext"), "", gensym("utf-8"));
		return;
	}
	
	if(x->source) {
		sysmem_lockhandle(x->source,0);
		object_method(x->j_edit, gensym("settext"), *x->source, NULL); // ddz bug -- passing utf8 here does not read in macroman files
	}
	
	object_method(x->j_edit, gensym("openwindow"));
}

t_atom_long max_jit_gl_vvisf_acceptsdrag(t_max_jit_gl_vvisf *x, t_object *drag, t_object *view)
{
	if (jdrag_matchdragrole(drag, gensym("isfshader"), 0)) {
		jdrag_object_add(drag, (t_object *)x, gensym("read"));
		return true;
	}
	return false;
}
