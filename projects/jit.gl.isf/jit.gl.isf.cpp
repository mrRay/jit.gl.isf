
#include "jit.gl.isf.h"

#include "max.jit.gl.isf.h"

#include "ext_preferences.h"

#include "VVGLContextCacheItem.hpp"

//#include "VVGL_Geom.hpp"
#include "ISFAttr.hpp"
#include "VVISF_Base.hpp"
#include "MyBuffer.hpp"

#if defined(VVGL_SDK_MAC)
#include "ISFFileManager_Mac.hpp"
#elif defined(VVGL_SDK_WIN)
#include "ISFFileManager_Win.hpp"
#endif



void			*_jit_gl_vvisf_class;


// symbols
t_symbol			*ps_file_j;
t_symbol			*ps_texture_j;
t_symbol			*ps_width_j;
t_symbol			*ps_height_j;
t_symbol			*ps_glid_j;
t_symbol			*ps_flip_j;
t_symbol			*ps_automatic_j;
t_symbol			*ps_drawto_j;
t_symbol			*ps_draw_j;
//t_symbol			*ps_needsRedraw_j;
t_symbol			*ps_willfree_j;
t_symbol			*ps_free_j;
t_symbol			*ps_jit_gl_texture_j;
t_symbol			*ps_gltarget_j;

static bool isGL3 = false;



#define TI targetInstance




//
// Function implementations
//
#pragma mark -
#pragma mark Init, New, Cleanup




t_jit_err jit_gl_vvisf_init(void)	{
	//post("%s",__func__);
	//	symbols
	ps_file_j = gensym("file");
	ps_texture_j = gensym("texture");
	ps_width_j = gensym("width");
	ps_height_j = gensym("height");
	ps_glid_j = gensym("glid");
	ps_flip_j = gensym("flip");
	ps_automatic_j = gensym("automatic");
	ps_drawto_j = gensym("drawto");
	ps_draw_j = gensym("draw");
	//ps_needsRedraw_j = gensym("needsRedraw");
	ps_willfree_j = gensym("willfree");
	ps_free_j = gensym("free");
	ps_jit_gl_texture_j = gensym("jit_gl_texture");
	ps_gltarget_j = gensym("gltarget");
	
	// setup our OB3D flags to indicate our capabilities.
	long			ob3d_flags = JIT_OB3D_NO_MATRIXOUTPUT; // no matrix output
	ob3d_flags |= JIT_OB3D_NO_ROTATION_SCALE;
	ob3d_flags |= JIT_OB3D_NO_POLY_VARS;
	ob3d_flags |= JIT_OB3D_NO_BLEND;
	ob3d_flags |= JIT_OB3D_NO_TEXTURE;
	ob3d_flags |= JIT_OB3D_NO_DEPTH;
	ob3d_flags |= JIT_OB3D_NO_ANTIALIAS;
	ob3d_flags |= JIT_OB3D_NO_FOG;
	ob3d_flags |= JIT_OB3D_NO_LIGHTING_MATERIAL;
	ob3d_flags |= JIT_OB3D_NO_COLOR;
	ob3d_flags |= JIT_OB3D_NO_TEXTURE;
	ob3d_flags |= JIT_OB3D_NO_SHADER;
	ob3d_flags |= JIT_OB3D_NO_BOUNDS;
	ob3d_flags |= JIT_OB3D_NO_POSITION;
	
	_jit_gl_vvisf_class = jit_class_new(
		"jit_gl_vvisf", 
		(method)jit_gl_vvisf_new,
		(method)jit_gl_vvisf_free,
		sizeof(t_jit_gl_vvisf),
		A_DEFSYM,
		0L);
	
	// set up object extension for 3d object, customized with flags
	
	void			*ob3d;
	ob3d = jit_ob3d_setup(
		_jit_gl_vvisf_class, 
		calcoffset(t_jit_gl_vvisf, ob3d), 
		ob3d_flags);
	
	// define our dest_closing and dest_changed methods. 
	// these methods are called by jit.gl.render when the 
	// destination context closes or changes: for example, when 
	// the user moves the window from one monitor to another. Any 
	// resources your object keeps in the OpenGL machine 
	// (e.g. textures, display lists, vertex shaders, etc.) 
	// will need to be freed when closing, and rebuilt when it has 
	// changed. In this object, these functions do nothing, and 
	// could be omitted.
	
	// OB3D methods
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_dest_closing, "dest_closing", A_CANT, 0L );
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_dest_changed, "dest_changed", A_CANT, 0L );
	
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_notify, (char*)"notify", A_CANT, 0L);
	
	// define our OB3D draw method.  called in automatic mode by
	// jit.gl.render or otherwise through ob3d when banged. this
	// method is A_CANT because our draw setup needs to happen
	// in the ob3d beforehand to initialize OpenGL state
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_draw, "ob3d_draw", A_CANT, 0L );
	
	// must register for ob3d use
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_object_register, "register", A_CANT, 0L );
	
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_jit_gl_texture, "jit_gl_texture", A_GIMME, 0L);
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_jit_matrix, "jit_matrix", A_USURP_LOW, 0);
	
	//	this method is how you pass input values to the isf object
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_setParamValue, "param", A_GIMME, 0L );
	
	// add attributes
	long				attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_USURP_LOW;

	t_jit_object		*attr;
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"adapt",
		_jit_sym_long,
		attrflags,
		(method)jit_gl_vvisf_getattr_adapt,
		(method)jit_gl_vvisf_setattr_adapt,
		calcoffset(t_jit_gl_vvisf,adapt));
	jit_class_addattr(_jit_gl_vvisf_class, attr);
	CLASS_ATTR_STYLE_LABEL((t_class*)_jit_gl_vvisf_class, "adapt", 0, "onoff", "Adapt");

	attr = (t_jit_object*)jit_object_new(
		 _jit_sym_jit_attr_offset,
		 "optimize",
		 _jit_sym_long,
		 attrflags,
		 (method)0L,
		 (method)0L,
		 calcoffset(t_jit_gl_vvisf,optimize));
	jit_class_addattr(_jit_gl_vvisf_class, attr);
	CLASS_ATTR_ATTR_PARSE((t_class*)_jit_gl_vvisf_class,"optimize","invisible",USESYM(long),0,"1");

	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset_array,
		"dim",
		_jit_sym_long,
		2,
		attrflags,
		(method)jit_gl_vvisf_getattr_dim,
		(method)jit_gl_vvisf_setattr_dim,
		0/*fix*/,
		calcoffset(t_jit_gl_vvisf,dim));
	jit_class_addattr(_jit_gl_vvisf_class, attr);	
	object_addattr_parse(attr,"label",_jit_sym_symbol,0,"Dimensions");
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"file",
		_jit_sym_symbol,
		attrflags,
		(method)0L,
		jit_gl_vvisf_setattr_file,
		calcoffset(t_jit_gl_vvisf, file)); 
	jit_class_addattr(_jit_gl_vvisf_class, attr);
	object_addattr_parse(attr,"label",_jit_sym_symbol,0,"File");
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"out_name",
		_jit_sym_symbol,
		(method)jit_gl_vvisf_setattr_out_name,
		(method)jit_gl_vvisf_getattr_out_name,
		(method)0L,
		0);	
	jit_class_addattr(_jit_gl_vvisf_class,attr);
	object_addattr_parse(attr,"label",_jit_sym_symbol,0,"\"Output Texture Name\"");
	
	//attr = (t_jit_object*)jit_object_new(
	//	_jit_sym_jit_attr_offset,
	//	"needsRedraw",
	//	_jit_sym_long,
	//	attrflags,
	//	jit_gl_vvisf_getattr_needsRedraw,
	//	jit_gl_vvisf_setattr_needsRedraw,
	//	calcoffset(t_jit_gl_vvisf, needsRedraw));
	//jit_class_addattr(_jit_gl_vvisf_class, attr);
	
	jit_class_register(_jit_gl_vvisf_class);

	isGL3 = (preferences_getsym("glengine") == gensym("gl3"));
	return JIT_ERR_NONE;
}

t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name)	{
	//post("%s",__func__);
	t_jit_gl_vvisf			*targetInstance;
	
	// make jit object
	if ((targetInstance = (t_jit_gl_vvisf *)jit_object_alloc(_jit_gl_vvisf_class)))	{
		
		TI->isfRenderer = new ISFRenderer(/*targetInstance*/);
		TI->pending_file_read = 0;
		TI->pending_tex_params = NULL;
		TI->pending_params = NULL;

		TI->adapt = 1;
		TI->optimize = 0;
		
		TI->renderTimeOverride = -1.0;
		
		//	allocate the various texture maps
		TI->inputToHostTexNameMap = new std::map<std::string,std::string>();
		TI->inputToClientGLTexPtrMap = new std::map<std::string,t_jit_object*>();
		
		// TODO : is this right ? 
		// set up attributes
		jit_attr_setsym(TI->file, _jit_sym_name, ps_file_j);
		
		//jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
		
		// instantiate a single internal jit.gl.texture should we need it.
		TI->outputTexObj = (t_jit_object*)jit_object_new(ps_jit_gl_texture,dest_name);
		if (TI->outputTexObj != NULL)	{
			t_atom_long dim[2];
			// set texture attributes.
			jit_attr_setsym(TI->outputTexObj, _jit_sym_name, jit_symbol_unique());
			jit_attr_setsym(TI->outputTexObj, gensym("defaultimage"), gensym("white"));
			jit_attr_setlong(TI->outputTexObj, gensym("rectangle"), 1);
			//jit_attr_setlong(TI->outputTexObj, ps_flip_j, 0);
			
			dim[0] = TI->dim[0] = 640;
			dim[1] = TI->dim[1] = 480;
			for (int i=0; i<2; ++i)
				TI->lastAdaptDims[i] = TI->dim[i];
			jit_attr_setlong_array(TI->outputTexObj, _jit_sym_dim, 2, dim);
		}
		else	{
			post("jit.gl.isf: ERR: creating internal texture object");
			jit_object_error((t_object *)targetInstance,(char*)"jit.gl.isf: could not create texture");
		}
		
		// create and attach ob3d
		jit_ob3d_new(targetInstance, dest_name);
		
	} 
	else 	{
		targetInstance = NULL;
	}

	return targetInstance;
}

void jit_gl_vvisf_free(t_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	//NSAutoreleasePool			*pool = [[NSAutoreleasePool alloc] init];
	
	//if (TI->syClient != NULL)	{
	//	[TI->syClient release];
	//	TI->syClient = nil;
	//}
	
	//[pool drain];

	if (TI->isfRenderer != NULL)	{
		delete TI->isfRenderer;
		TI->isfRenderer = NULL;
	}
	
	
	{
		//	run through the input name to host texture name map, unregistering for notification on all of the textures in it
		auto			iter = TI->inputToHostTexNameMap->begin();
		while (iter != TI->inputToHostTexNameMap->end())	{
			t_symbol		*textureSym = gensym((char*)iter->second.c_str());
			if (textureSym != NULL)	{
				jit_object_detach(textureSym, TI);
			}
			++iter;
		}
		//	delete the actual input name to host texture name map
		if (TI->inputToHostTexNameMap != nullptr)	{
			delete TI->inputToHostTexNameMap;
			TI->inputToHostTexNameMap = nullptr;
		}
	}
	
	{
		//	run through the client textures i created, freeing them
		auto			iter = TI->inputToClientGLTexPtrMap->begin();
		while (iter != TI->inputToClientGLTexPtrMap->end())	{
			auto			txPtr = iter->second;
			if (txPtr != NULL)	{
				jit_object_free(txPtr);
			}
			++iter;
		}
		//	delete the actual client texture map
		if (TI->inputToClientGLTexPtrMap != nullptr)	{
			delete TI->inputToClientGLTexPtrMap;
			TI->inputToClientGLTexPtrMap = nullptr;
		}
	}
	

	// free our ob3d data 
	if(targetInstance)
		jit_ob3d_free(targetInstance);
	
	// free our internal texture
	if(TI->outputTexObj)
		jit_object_free(TI->outputTexObj);
	
	if(TI->pending_tex_params)
		object_free(TI->pending_tex_params);
	if(TI->pending_params)
		object_free(TI->pending_params);

}


#pragma mark -
#pragma mark misc funcs


/*
void jit_gl_vvisf_loadFile(t_jit_gl_vvisf *targetInstance, const string & inFilePath)	{
	//post("%s ... %s",__func__,inFilePath.c_str());
}
*/
void jit_gl_vvisf_setParamValue(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	
	using namespace std;
	using namespace VVISF;

	//post("%s, argc is %d",__func__,argc);
	
	if (argv == NULL || atom_gettype(argv) != A_SYM)
		return;
	
	if(!TI->isfRenderer->isFileLoaded()) {
		//post("jit.gl.isf: file not yet loaded");
		if(!TI->pending_params)
			TI->pending_params = hashtab_new(11);
		hashtab_store(TI->pending_params, atom_getsym(argv), (t_object*)atomarray_new(argc, argv));
		return;
	}
	
	//	's' would ordinarily be the message/method name, but in this case it's the name of the input
	t_atom				*inputNameAtom = argv;
	string				inputName = string( (char*)jit_atom_getsym(inputNameAtom)->s_name );
	t_atom				*argAtoms = argv + 1;
	ISFAttrRef			attr = TI->isfRenderer->paramNamed(inputName);
	if (attr == nullptr)	{
		post("jit.gl.isf: ERR: unrecognized param \"%s\"",inputName.c_str());
		return;
	}
	
	
	//	flag myself as needing to redraw
	//jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
	
	
	//	get the host context, we'll need to restore it later
#if defined(VVGL_SDK_WIN)
	HGLRC				origGLCtx = wglGetCurrentContext();
	HDC					origDevCtx = wglGetCurrentDC();
#elif defined(VVGL_SDK_MAC)
	CGLContextObj		origCglCtx = CGLGetCurrentContext();
#endif
	
	
	//	based on the type of the attribute, assemble a value from the input values, showing a warning if we can't
	switch (attr->type())	{
	case ISFValType_None:	//	unrecognized value type, do nothing
		break;
	case ISFValType_Event:	//	event-type ISF attribute
		//attr->setCurrentVal(ISFEventVal(true));
		TI->isfRenderer->setCurrentValForParamNamed(ISFEventVal(true), inputName);
		break;
	case ISFValType_Bool:	//	bool-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			//attr->setCurrentVal( (jit_atom_getlong(argAtoms)>0) ? ISFBoolVal(true) : ISFBoolVal(false) );
			TI->isfRenderer->setCurrentValForParamNamed((jit_atom_getlong(argAtoms) > 0) ? ISFBoolVal(true) : ISFBoolVal(false), inputName);
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			//attr->setCurrentVal( (jit_atom_getlong(argAtoms)>0.0) ? ISFBoolVal(true) : ISFBoolVal(false) );
			TI->isfRenderer->setCurrentValForParamNamed( (jit_atom_getlong(argAtoms)>0.0) ? ISFBoolVal(true) : ISFBoolVal(false), inputName );
			break;
		default:
			post("jit.gl.isf: ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Long:	//	long-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			//attr->setCurrentVal( ISFLongVal(jit_atom_getlong(argAtoms)) );
			TI->isfRenderer->setCurrentValForParamNamed(ISFLongVal(jit_atom_getlong(argAtoms)), inputName);
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			//attr->setCurrentVal( ISFLongVal(jit_atom_getlong(argAtoms)) );
			TI->isfRenderer->setCurrentValForParamNamed(ISFLongVal(jit_atom_getlong(argAtoms)), inputName);
			break;
		case A_SYM:
		case A_DEFSYM:
			{
				string			tmpStr = std::string( (char*)jit_atom_getsym(argAtoms)->s_name );
				vector<string>		&labels = attr->labelArray();
				vector<int32_t>		&vals = attr->valArray();
				//vector<string>		&labels = TI->isfRenderer->labelArrayForParamNamed(inputName);
				//vector<int32_t>		&vals = TI->isfRenderer->valsArrayForParamNamed(inputName);;
				int					tmpIndex = 0;
				int					foundIndex = -1;
				if (labels.size() < 1)
					post("jit.gl.isf: ERR: arg is wrong type, attr %s is a long",s->s_name);
				else	{
					for (const string & label : labels)	{
						if (label == tmpStr)	{
							if (tmpIndex>=0 && tmpIndex<vals.size())	{
								//attr->setCurrentVal( ISFLongVal(vals[tmpIndex]) );
								TI->isfRenderer->setCurrentValForParamNamed(ISFLongVal(vals[tmpIndex]), inputName);
							}
							else	{
								post("jit.gl.isf: ERR: label is valid, but doesn't have matching value");
							}
							foundIndex = tmpIndex;
							break;
						}
						++tmpIndex;
					}
					if (foundIndex < 0)	{
						post("jit.gl.isf: ERR: arg is wrong type, attr %s is a long",s->s_name);
					}
				}
			}
			break;
		default:
			post("jit.gl.isf: ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Float:	//	float-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			//attr->setCurrentVal( ISFFloatVal(jit_atom_getfloat(argAtoms)) );
			TI->isfRenderer->setCurrentValForParamNamed( ISFFloatVal(jit_atom_getfloat(argAtoms)), inputName );
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			//attr->setCurrentVal( ISFFloatVal(jit_atom_getfloat(argAtoms)) );
			TI->isfRenderer->setCurrentValForParamNamed( ISFFloatVal(jit_atom_getfloat(argAtoms)), inputName );
			break;
		default:
			post("jit.gl.isf: ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Point2D:	//	point-type ISF attribute
		{
			if (argc == 3)	{
				t_atom		*firstAtom = argAtoms;
				t_atom		*secondAtom = argAtoms + 1;
				ISFVal		tmpPointVal = ISFPoint2DVal(jit_atom_getfloat(firstAtom), jit_atom_getfloat(secondAtom));
				//attr->setCurrentVal(tmpPointVal);
				TI->isfRenderer->setCurrentValForParamNamed(tmpPointVal, inputName);
			}
		}
		break;
	case ISFValType_Color:	//	color-type ISF attribute
		{
			if (argc >= 4)	{
				t_atom		*firstAtom = argAtoms;
				t_atom		*secondAtom = argAtoms + 1;
				t_atom		*thirdAtom = argAtoms + 2;
				t_atom		*fourthAtom = (argc == 4) ? argAtoms + 3 : NULL;
				ISFVal		tmpColorVal;
				if (fourthAtom == NULL)
					tmpColorVal = ISFColorVal(jit_atom_getfloat(firstAtom), jit_atom_getfloat(secondAtom), jit_atom_getfloat(thirdAtom), 1.0);
				else
					tmpColorVal = ISFColorVal(jit_atom_getfloat(firstAtom), jit_atom_getfloat(secondAtom), jit_atom_getfloat(thirdAtom), jit_atom_getfloat(fourthAtom));
				//attr->setCurrentVal(tmpColorVal);
				TI->isfRenderer->setCurrentValForParamNamed(tmpColorVal, inputName);
			}
		}
		break;
	case ISFValType_Cube:	//	cube-type ISF attribute: unhandled
		break;
	case ISFValType_Image:	//	image-type ISF attribute
	case ISFValType_Audio:	//	audio-type ISF attribute
	case ISFValType_AudioFFT:	//	audio-FFT-type ISF attribute
		{
			// push any texture params onto our linklist to process in the draw call
			if(!TI->pending_tex_params)
				TI->pending_tex_params = hashtab_new(7);
			hashtab_store(TI->pending_tex_params, atom_getsym(inputNameAtom), (t_object*)atomarray_new(argc, argv));
		}
		break;
	}
	
	
	//	restore the original GL context
#if defined(VVGL_SDK_WIN)
	if (origDevCtx != NULL && origGLCtx != NULL) {
		wglMakeCurrent(origDevCtx, origGLCtx);
	}
#elif defined(VVGL_SDK_MAC)
	if (origCglCtx != NULL)	{
		CGLSetCurrentContext(origCglCtx);
	}
#endif
	
}

bool jit_gl_vvisf_setup_jitter_texture(t_jit_gl_vvisf *targetInstance, t_symbol *texName) {
	// our texture has to be bound in the new context before we can use it
	// http://cycling74.com/forums/topic.php?id=29197
	t_jit_gl_drawinfo			drawInfo;
	if(jit_gl_drawinfo_setup(targetInstance, &drawInfo)) {
		return false;
	}
	if(isGL3) {
		jit_ob3d_state_begin((t_jit_object*)targetInstance);
	}
	jit_gl_bindtexture(&drawInfo, texName, 0);
	jit_gl_unbindtexture(&drawInfo, texName, 0);
	return true;
}

typedef struct _tex_param_info {
	t_jit_gl_vvisf 		*targetInstance;
	t_jit_gl_context	ctx;
}t_tex_param_info;

void jit_gl_vvisf_do_set_params(t_hashtab_entry *e, t_tex_param_info *tpinfo) {
	long argc;
	t_atom *argv = NULL;
	atomarray_getatoms((t_atomarray*)e->value, &argc, &argv);
	jit_gl_set_context(tpinfo->ctx);
	jit_gl_vvisf_setParamValue(tpinfo->targetInstance, gensym("param"), argc, argv);
}

void jit_gl_vvisf_do_set_tex_params(t_hashtab_entry *e, t_tex_param_info *tpinfo) {
	using namespace std;
	using namespace VVISF;
	t_jit_gl_vvisf *TI = tpinfo->targetInstance;
	long argc;
	t_atom *argv = NULL;
	atomarray_getatoms((t_atomarray*)e->value, &argc, &argv);
	
	jit_gl_set_context(tpinfo->ctx);

	if(argc == 3 && argv) {
		t_atom				*inputNameAtom = argv;
		string				inputName = string( (char*)jit_atom_getsym(inputNameAtom)->s_name );
		t_atom				*argAtoms = argv + 1;
		ISFAttrRef			attr = TI->isfRenderer->paramNamed(inputName);

		t_atom		*firstAtom = argAtoms;
		t_atom		*secondAtom = firstAtom + 1;
		//post("argc is %d",argc);
		long		firstType = atom_gettype(firstAtom);
		//long		secondType = atom_gettype(secondAtom);
		if ( (firstType == A_SYM || firstType == A_DEFSYM) )	{
			//std::string			msgSymString = std::string( (char*)av->a_w.w_sym->s_name );
			t_symbol			*firstMsgSym = jit_atom_getsym(firstAtom);
			t_symbol			*secondMsgSym = jit_atom_getsym(secondAtom);
			if (firstMsgSym != NULL && secondMsgSym != NULL)	{
				
				//	if this is a jitter gl texture...
				if (TI->optimize && firstMsgSym == ps_jit_gl_texture)	{
					
					//	the second msg sym is the name of the incoming jitter texture.  check to see if we're already registered as an observer
					bool				alreadyRegistered = false;
					
					auto				inputNameIt = TI->inputToHostTexNameMap->find(inputName);
					if (inputNameIt != TI->inputToHostTexNameMap->end()) {
						string				oldJitTexName = inputNameIt->second;
						t_symbol			*oldJitTexNameSym = gensym((char*)oldJitTexName.c_str());
						if (oldJitTexNameSym != NULL) {
							//	if it's the same texture then we're already registered
							if (oldJitTexNameSym == secondMsgSym)
								alreadyRegistered = true;
							//	else it's not the same texture, we have to unregister the old!
							else
								jit_object_detach(oldJitTexNameSym, TI);
						}
					}
					
					//	if we aren't already registered as an observer of the passed texture, we need to do so
					if (!alreadyRegistered)	{
						//	attach to the jitter texture we were passed...
						if (jit_object_attach(secondMsgSym, targetInstance) == NULL)
							post("jit.gl.isf: ERR: unable to attach the jitter object to the param texture, %s",__func__);
						else	{
							//	store a record of this attachment in our map so we know to unattach later
							TI->inputToHostTexNameMap->emplace( std::make_pair(inputName, std::string((char*)secondMsgSym->s_name)) );
							
							//	if we allocated a jit gl texture for this same input name (for GL textures), free it and delete it from the client texture map so there aren't two possible texture source for the same input name
							
							auto				inputNameIt = TI->inputToClientGLTexPtrMap->find(inputName);
							if (inputNameIt != TI->inputToClientGLTexPtrMap->end()) {
								t_jit_object		*clientTex = (t_jit_object*)inputNameIt->second;
								if (clientTex != NULL) {
									jit_object_free(clientTex);
								}
								TI->inputToClientGLTexPtrMap->erase(inputName);
							}
						}
					}
					
					//	finally, pass the jitter texture object to the ISFRenderer, which will "wrap" it with a GLBufferRef from the appropriate pool/GL version to render
					//GLBufferRef			wrapperTex = renderer->applyJitGLTexToInputKey(secondMsgSym, inputName);
					MyBufferRef			wrapperTex = jit_gl_vvisf_apply_jit_tex_for_input_key(TI, secondMsgSym, inputName);
					//	if this was the input image, we need to update the target instance's last adapt dims, so we know what res to render at next time we're told to do so
					if (inputName == string("inputImage") && wrapperTex != nullptr)	{
						TI->lastAdaptDims[0] = wrapperTex->size().width;
						TI->lastAdaptDims[1] = wrapperTex->size().height;
						//post("inputImage detected from GL tex, adapting to res %d x %d",TI->lastAdaptDims[0],TI->lastAdaptDims[1]);
					}
				}
				//	else if this is a jitter matrix (CPU-based)...
				else if (!TI->optimize || firstMsgSym == ps_jit_matrix)	{
					//post("input named %s rxed a jitter matrix",inputName.c_str());
					
					//	try to get an existing client texture for the input name
					t_jit_object		*clientTex = NULL;
					
					auto				clientIt = TI->inputToClientGLTexPtrMap->find(inputName);
					if (clientIt != TI->inputToClientGLTexPtrMap->end()) {
						clientTex = clientIt->second;
					}
					
					//	if we don't already have an existing client texture...
					if (clientTex == NULL)	{
						//	make a client texture, set it up
						clientTex = (t_jit_object*)jit_object_new(ps_jit_gl_texture, jit_attr_getsym(TI, ps_drawto_j));
						if (clientTex != NULL)	{
							//	add the client texture to the map
							TI->inputToClientGLTexPtrMap->emplace(inputName, clientTex);
							
							//	if we're attached to a host gl texture under this name as an observer, un-attach and remove the record of the attachment from the host texture name map
							auto			tmpIt = TI->inputToHostTexNameMap->find(inputName);
							if (tmpIt != TI->inputToHostTexNameMap->end()) {
								string			jitHostTexName = tmpIt->second;
								t_symbol		*jitHostTexNameSym = gensym((char*)jitHostTexName.c_str());
								if (jitHostTexNameSym != NULL) {
									jit_object_detach(jitHostTexNameSym, TI);
									TI->inputToHostTexNameMap->erase(inputName);
								}
							}
						}
					}
					
					if (clientTex != NULL)	{
						jit_attr_setlong(clientTex, ps_flip_j, firstMsgSym == ps_jit_matrix || isGL3 ? 0 : 1);
						//	pass the jitter matrix to our client gl texture
						jit_object_method(clientTex, jit_atom_getsym(argv+1), jit_atom_getsym(argv+1), argc-2, argv+2);
						
						//	get the name of our client texture, pass it to the renderer, which will "wrap" it in a GLBufferRef from the appropriate pool/GL version to render
						//GLBufferRef			wrapperTex = (clientTexSym==NULL) ? NULL : renderer->applyJitGLTexToInputKey(clientTexSym, inputName);
						MyBufferRef			wrapperTex = jit_gl_vvisf_apply_jit_tex_for_input_key(TI, jit_attr_getsym(clientTex, _jit_sym_name), inputName);
						//	if this was the input image, we need to update the target instance's last adapt dims, so we know what res to render at next time we're told to do so
						if (inputName == string("inputImage") && wrapperTex != nullptr)	{
							TI->lastAdaptDims[0] = wrapperTex->size().width;
							TI->lastAdaptDims[1] = wrapperTex->size().height;
							//post("inputImage detected from matrix texture, adapting to res %d x %d",TI->lastAdaptDims[0],TI->lastAdaptDims[1]);
						}
					}
					else
						post("jit.gl.isf: ERR: clientTex NULL in %s",__func__);
				}
				
			}
			else
				post("jit.gl.isf: ERR: arg is wrong type, attr %s is an image and requires a GL texture for input",inputName.c_str());
		}
		else
			post("jit.gl.isf: ERR: arg is wrong type, attr %s is an image and requires a GL texture for input",inputName.c_str());
	}
}

t_jit_err jit_gl_vvisf_jit_matrix(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	
	//	create a "param" message with "inputImage" as the input name so we don't have to rewrite anything
	t_atom			msg[3];
	jit_atom_setsym(msg, gensym("inputImage"));
	jit_atom_setsym(msg+1, s);
	jit_atom_setsym(msg+2, jit_atom_getsym(argv));
	
	jit_object_method(TI, gensym("param"), gensym("param"), 3, msg);
	
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_jit_gl_texture(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	//post("%s",__func__);
	
	//	create a "param" message with "inputImage" as the input name so we don't have to rewrite anything
	t_atom			msg[3];
	jit_atom_setsym(msg, gensym("inputImage"));
	jit_atom_setsym(msg+1, s);
	jit_atom_setsym(msg+2, jit_atom_getsym(argv));
	
	jit_object_method(TI, gensym("param"), gensym("param"), 3, msg);
	
	return JIT_ERR_NONE;
	
}

void jit_gl_vvisf_notify(t_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *ob, void *data)	{
	//post("%s ... %s %s",__func__,msg->s_name,s->s_name);
	
	if (msg == ps_willfree_j || msg == ps_free_j)	{
		
		//	get the host context, we'll need to restore it later
#if defined(VVGL_SDK_WIN)
		HGLRC				origGLCtx = wglGetCurrentContext();
		HDC					origDevCtx = wglGetCurrentDC();
#elif defined(VVGL_SDK_MAC)
		CGLContextObj		origCglCtx = CGLGetCurrentContext();
#endif
		
		//	get the name of the jitter texture being freed as a std::string
		std::string			jitTextureName = std::string((char*)s->s_name);
		//	run through the map of input names/jitter texture names
		auto			iter = x->inputToHostTexNameMap->begin();
		while (iter != x->inputToHostTexNameMap->end())	{
			//	if this item in the map matches the texture being freed...
			if (iter->second == jitTextureName)	{
				//	detach from the jitter object, we no longer want to be notified as to its changes (is this safe to do now, in a notify callback?)
				jit_object_detach(s, x);
				//	tell the ISF renderer to clear out the texture for this attribute 
				//renderer->applyJitGLTexToInputKey(NULL, iter->first);
				jit_gl_vvisf_apply_jit_tex_for_input_key(x, NULL, iter->first);

				//	delete the item from the map (this automatically increments the iterator)
				iter = x->inputToHostTexNameMap->erase(iter);
			}
			//	else this item in the map doesn't match the texture being freed- increment the iterator and check the next...
			else
				++iter;
		}
		
		//	restore the original GL context
#if defined(VVGL_SDK_WIN)
		if (origDevCtx != NULL && origGLCtx != NULL) {
			wglMakeCurrent(origDevCtx, origGLCtx);
		}
#elif defined(VVGL_SDK_MAC)
		if (origCglCtx != NULL)	{
			CGLSetCurrentContext(origCglCtx);
		}
#endif
		
		
	}
	
}


#pragma mark -
#pragma mark ctx change


t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance)	{
	//std::cout << __PRETTY_FUNCTION__ << std::endl;
	
	
#if defined(VVGL_SDK_WIN)
	HGLRC				origGLCtx = wglGetCurrentContext();
	HDC					origDevCtx = wglGetCurrentDC();
	if (origGLCtx == NULL || origDevCtx == NULL) {
		post("jit.gl.isf: ERR: no host GL ctx");
		return JIT_ERR_INVALID_PTR;
	}
	VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(origGLCtx, origDevCtx);
	//GLContextRef		tmpCtx = CreateGLContextRefUsing(origGLCtx, origDevCtx);
	//cout << "tmpCtx from host renderer is " << tmpCtx->getRenderer() << endl;
#elif defined(VVGL_SDK_MAC)
	//	get the current GL context on this thread- if there isn't one, bail
	CGLContextObj				hostCtx = CGLGetCurrentContext();
	if (hostCtx == NULL)	{
		post("jit.gl.isf: ERR: no host GL ctx");
		return JIT_ERR_INVALID_PTR;
	}
	//	get the cache item for the current context- the cache item contains buffer pools and shared contexts (GL2 + GL4) used to create the renderer's contexts
	VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(hostCtx);
#endif
	
	//	if there's no cached context item, something has gone horribly wrong- bail
	if (cacheItem == nullptr)	{
		post("jit.gl.isf: ERR: couldnt find cache ctx");
		return JIT_ERR_INVALID_PTR;
	}
	
	//	tell the renderer to update using the cache item- this will create all the contexts and reload the file if necessary
	TI->isfRenderer->configureWithCache(cacheItem);
	
	//	restore the original GL context
#if defined(VVGL_SDK_WIN)
	if (origDevCtx != NULL && origGLCtx != NULL) {
		wglMakeCurrent(origDevCtx, origGLCtx);
	}
#elif defined(VVGL_SDK_MAC)
	if (hostCtx != NULL)	{
		CGLSetCurrentContext(hostCtx);
	}
#endif
	
	//	get the jit.gl.texture object we render into for output
	if (TI->outputTexObj != NULL)	{
		jit_attr_setsym(TI->outputTexObj, ps_drawto_j, jit_attr_getsym(targetInstance, ps_drawto_j));
	}
	else
		post("jit.gl.isf: ERR: outputTexObj null in %s",__func__);
	//	flag the needsRedraw attribute so i know i need to render a new frame
	//jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
	
	//	don't forget to return the cache item to the pool!
	ReturnCacheItemToPool(cacheItem);
	
	
	return JIT_ERR_NONE;
}

#pragma mark -
#pragma mark Draw

/*
static VVGL::Timestamp			nowStamp = VVGL::Timestamp();
*/

t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	//cout << __PRETTY_FUNCTION__ << ", " << VVGL::Timestamp()-nowStamp << endl;
	if (!targetInstance)
		return JIT_ERR_INVALID_PTR;
	
	if (TI->pending_file_read) {
		if (!jit_gl_vvisf_do_set_file(TI)) {
			jit_object_error((t_object*)targetInstance, (char*)"shader would not compile! (%s)", TI->file->s_name);
		}
		TI->pending_file_read = 0;
	}
	
	t_jit_gl_context ctx = jit_gl_get_context();
	if(!ctx) {
		jit_object_error((t_object*)targetInstance, (char*)"no context!");
		return JIT_ERR_GENERIC;
	}
	
	//	get the host context, use that to retrieve the cache item which holds the shared contexts, buffer pools, and buffer copiers
#if defined(VVGL_SDK_WIN)
	HGLRC				origGLCtx = wglGetCurrentContext();
	HDC					origDevCtx = wglGetCurrentDC();
	if (origGLCtx == NULL) {
		post("jit.gl.isf: ERR: no host GL ctx");
		return JIT_ERR_INVALID_PTR;
	}
	VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(origGLCtx, origDevCtx);
#elif defined(VVGL_SDK_MAC)
	CGLContextObj		origCglCtx = CGLGetCurrentContext();
	VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(origCglCtx);
#endif

	// process any general params received prior to completion of file load
	if(TI->pending_params) {
		t_tex_param_info tpinfo;
		tpinfo.targetInstance = TI;
		tpinfo.ctx = ctx;
		hashtab_funall(TI->pending_params, (method)jit_gl_vvisf_do_set_params, &tpinfo);
		object_free(TI->pending_params);
		TI->pending_params = NULL;
	}
	
	// process any texture params received since last drawcall
	if(TI->pending_tex_params) {
		t_tex_param_info tpinfo;
		tpinfo.targetInstance = TI;
		tpinfo.ctx = ctx;
		hashtab_funall(TI->pending_tex_params, (method)jit_gl_vvisf_do_set_tex_params, &tpinfo);
		object_free(TI->pending_tex_params);
		TI->pending_tex_params = NULL;
	}
	//post("\trendering a frame...");
	
	//	calculate the size at which we should be rendering
	VVGL::Size			renderSize = VVGL::Size(TI->dim[0], TI->dim[1]);
	if (TI->adapt)
		renderSize = VVGL::Size(TI->lastAdaptDims[0], TI->lastAdaptDims[1]);
	t_atom_long			renderSizeAtoms[2];
	renderSizeAtoms[0] = long(renderSize.width);
	renderSizeAtoms[1] = long(renderSize.height);
	//	get the size of the internal texture object
	VVGL::Size			tmpSize = VVGL::Size(1,1);
	if (TI->outputTexObj != NULL)	{
		tmpSize.width = (double)jit_attr_getlong(TI->outputTexObj, ps_width_j);
		tmpSize.height = (double)jit_attr_getlong(TI->outputTexObj, ps_height_j);
	}
	//	if the render size doesn't match the size of the internal texture object, update the internal texture size
	if (renderSize != tmpSize && TI->outputTexObj != NULL)	{
		//	first update the texture's size attr
		jit_attr_setlong_array(TI->outputTexObj, _jit_sym_dim, 2, renderSizeAtoms);
		//	restore the original GL context
		jit_gl_set_context(ctx);
		if(!jit_gl_vvisf_setup_jitter_texture(targetInstance, jit_attr_getsym(TI->outputTexObj, _jit_sym_name))) {
			jit_object_error((t_object*)targetInstance, (char*)"failed to setup output texture");
			return JIT_ERR_INVALID_PTR;
		}
	}
	
	if (cacheItem != nullptr)	{
		TI->isfRenderer->configureWithCache(cacheItem);
		ReturnCacheItemToPool(cacheItem);
	}
	//	create a GLBufferRef that "wraps" the jitter texture
	uint32_t			texName = jit_attr_getlong(TI->outputTexObj, ps_glid_j);
	VVGL::Rect			tmpRect = VVGL::Rect(0, 0, renderSize.width, renderSize.height);
	MyBufferRef			wrapperTex = CreateBufferFromExistingTex(
		texName,
		GL_TEXTURE_RECTANGLE_EXT,
		renderSize,
		false,
		tmpRect,
		TI->isfRenderer);
	
	//	tell the renderer to render into the wrapper GLBufferRef we made around the jit.gl.texture object we own
	TI->isfRenderer->render(wrapperTex, renderSize, TI->renderTimeOverride);
	//	always reset the renderTimeOverride
	TI->renderTimeOverride = -1.0;
	
	//	update the 'flip' flag on the output texture
	jit_attr_setlong(TI->outputTexObj, ps_flip_j, (wrapperTex->flipped())?1:0);
	
	//	restore the original GL context
	jit_gl_set_context(ctx);
	
	//	publish the texture
	t_max_jit_gl_vvisf		*mws = (t_max_jit_gl_vvisf*)TI->maxWrapperStruct;
	if (TI->outputTexObj!=NULL && mws!=NULL && mws->texout!=NULL)	{
		t_atom			tmpAtom;
		atom_setsym(&tmpAtom, jit_attr_getsym(TI->outputTexObj, gensym("name")));
		outlet_anything(mws->texout, ps_jit_gl_texture_j, 1, &tmpAtom);
	}
	
	
	return JIT_ERR_NONE;
}
		
#pragma mark -
#pragma mark Attributes

// attributes

t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf* targetInstance, void* attr, long argc, t_atom* argv) {
	//post("%s",__func__);
	//t_symbol			*srvname;

	if (targetInstance != NULL && argc && argv) {
		t_symbol *fsym = jit_atom_getsym(argv);
		if (fsym && fsym != _jit_sym_nothing) {
			static t_symbol *ps_VDVX_COLORBARS = NULL;
			if(!ps_VDVX_COLORBARS) ps_VDVX_COLORBARS = gensym("VDVX:COLORBARS");
			
			char conformpath[MAX_PATH_CHARS];
			//bool				foundTheFile = false;
			//	we don't know if the passed symbol is a filename or a path- assume a filename at first
			std::string				inStr((char*)fsym->s_name);
#if defined(VVGL_SDK_MAC)
			ISFFileManager_Mac* fm = (ISFFileManager_Mac *)max_jit_gl_vvisf_getisffilemanager();
#elif defined(VVGL_SDK_WIN)
			ISFFileManager_Win* fm = (ISFFileManager_Win *)max_jit_gl_vvisf_getisffilemanager();
#endif
			ISFFile				fileEntry = fm->fileEntryForName(inStr);

			if (fileEntry.isValid()) {
				if(fileEntry._path == std::string("VDVX:COLORBARS")) {
					TI->file = ps_VDVX_COLORBARS;
				}
				else {
					path_nameconform(fileEntry.path().c_str(), conformpath, PATH_STYLE_SLASH, PATH_TYPE_ABSOLUTE);
					TI->file = gensym(conformpath);
				}
			}
			else {
				char pathfile[MAX_PATH_CHARS];
				char pathname[MAX_PATH_CHARS];
				t_fourcc filetype = 0;
				short volume = 0;
				// make a copy of the filename for locatefile
				strcpy(pathfile, fsym->s_name);
				// locate the file
				if (locatefile_extended(pathfile, &volume, &filetype, NULL, 0))  {
					TI->pending_file_read = 0;
					jit_object_error((t_object *)targetInstance, (char*)"jit.gl.isf: can't find file %s", fsym->s_name);
					return JIT_ERR_GENERIC;
				}
				path_topathname(volume, pathfile, pathname);
				TI->file = gensym(pathname);
			}
		}
		else {
			//	update the file symbol
			TI->file = _jit_sym_nothing;
		}
		if (!jit_gl_vvisf_do_set_file(TI)) {
			TI->pending_file_read = 1;
		}
	}
	else {
		post("jit.gl.isf: ERR: target instance NULL in %s", __func__);
		return JIT_ERR_INVALID_PTR;
	}

	return JIT_ERR_NONE;
}
t_bool jit_gl_vvisf_do_set_file(t_jit_gl_vvisf* targetInstance) {
	t_bool success = true;
	char conformpath[MAX_PATH_CHARS];
	if(std::string(TI->file->s_name) != std::string("VDVX:COLORBARS")) {
#ifdef MAC_VERSION
		path_nameconform(TI->file->s_name, conformpath, PATH_STYLE_SLASH, PATH_TYPE_BOOT);
#else
		path_nameconform(TI->file->s_name, conformpath, PATH_STYLE_NATIVE_WIN, PATH_TYPE_ABSOLUTE);
#endif
	}
	else {
		strcpy(conformpath, TI->file->s_name);
	}

	//	get the host context, we'll need to restore it later
#if defined(VVGL_SDK_WIN)
	HGLRC				origGLCtx = wglGetCurrentContext();
	HDC					origDevCtx = wglGetCurrentDC();
#elif defined(VVGL_SDK_MAC)
	CGLContextObj		origCglCtx = CGLGetCurrentContext();
#endif

	//	load the file (or load a nil file if we weren't passed any args)
	if (TI->isfRenderer == nullptr) {
		post("jit.gl.isf: ERR: isfRenderer NULL in %s", __func__);
		success = false;
	}
	else	{
		if (TI->file == _jit_sym_nothing)
			TI->isfRenderer->loadFile();
		else	{
			std::string		curPath;
			bool reloadOnFail = false;
			if(TI->isfRenderer->isFileLoaded()) {
				reloadOnFail = true;
				curPath= TI->isfRenderer->loadedISFDoc()->path();
			}
			std::string		tmpStr = std::string(conformpath);
			TI->isfRenderer->loadFile(&tmpStr);
			if (!TI->isfRenderer->isFileLoaded())	{
				//post("jit.gl.isf: ERR- shader could not be compiled, sorry! %s",tmpStr.c_str());
				//jit_object_error((t_object *)targetInstance,(char*)"jit.gl.isf: ERR: shader would not compile! (%s)",tmpStr.c_str());
				if(reloadOnFail)
					TI->isfRenderer->loadFile(&curPath);
				success = false;
			}
		}
		
		if (success) {
			//	run through the input name to texture map, unregistering for notification on all of the textures in it
			auto			iter = TI->inputToHostTexNameMap->begin();
			while (iter != TI->inputToHostTexNameMap->end())	{
				t_symbol		*textureSym = gensym((char*)iter->second.c_str());
				if (textureSym != NULL)	{
					jit_object_detach(textureSym, TI);
				}
				iter = TI->inputToHostTexNameMap->erase(iter);
			}

			//	fake an input call- this sends information describing the inputs of the loaded file from the appropriate outlet
			max_jit_gl_vvisf_getparamlist((t_max_jit_gl_vvisf*)TI->maxWrapperStruct);
		}

		//	restore the original GL context
#if defined(VVGL_SDK_WIN)
		if (origDevCtx != NULL && origGLCtx != NULL) {
			wglMakeCurrent(origDevCtx, origGLCtx);
		}
#elif defined(VVGL_SDK_MAC)
		if (origCglCtx != NULL) {
			CGLSetCurrentContext(origCglCtx);
		}
#endif
	}
	return success;
}


t_jit_err jit_gl_vvisf_setattr_out_name(t_jit_gl_vvisf *targetInstance, void *attr, long ac, t_atom *av)	{
	object_attr_setvalueof(TI->outputTexObj, _jit_sym_name, ac, av);
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_getattr_out_name(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
	object_attr_getvalueof(TI->outputTexObj, _jit_sym_name, ac, av);
	return JIT_ERR_NONE;
}											  


t_jit_err jit_gl_vvisf_getattr_adapt(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
	if ((*ac) && (*av))	{
		//	memory passed in, use it
	}
	else	{
		//	otherwise allocate memory
		*ac = 1;
		if (!(*av = (atom*)jit_getbytes(sizeof(t_atom)*(*ac)))) {
			*ac = 0;
			return JIT_ERR_OUT_OF_MEM;
		}
	}
	
	if (*ac >= 1)
		jit_atom_setlong(*av, TI->adapt);
	
	return JIT_ERR_NONE;
}
t_jit_err jit_gl_vvisf_setattr_adapt(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	long			i;
	long			v;
	
	if (targetInstance)	{
		for(i = 0; i < JIT_MATH_MIN(argc, 1); i++)	{
			v = jit_atom_getlong(argv+i);
			if (TI->adapt != JIT_MATH_MIN(v,1))	{
				TI->adapt = v;
			}
		}
		
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}
t_jit_err jit_gl_vvisf_getattr_dim(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
	if ((*ac) && (*av))	{
		//	memory passed in, use it
	}
	else	{
		//	otherwise allocate memory
		*ac = 2;
		if (!(*av = (atom*)jit_getbytes(sizeof(t_atom)*(*ac)))) {
			*ac = 0;
			return JIT_ERR_OUT_OF_MEM;
		}
	}
	
	if (*ac >= 1)
		jit_atom_setlong(*av, TI->dim[0]);
	if (*ac >= 2)
		jit_atom_setlong(*av+1, TI->dim[1]);
	
	return JIT_ERR_NONE;
}
t_jit_err jit_gl_vvisf_setattr_dim(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	//post("%s",__func__);
	//std::cout << __PRETTY_FUNCTION__ << std::endl;
	long			i;
	long			v;
	
	if (targetInstance)	{
		for(i = 0; i < JIT_MATH_MIN(argc, 2); i++)	{
			v = jit_atom_getlong(argv+i);
			if (TI->dim[i] != JIT_MATH_MIN(v,1))	{
				TI->dim[i] = v;
				TI->lastAdaptDims[i] = v;
			}
		}
		
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}



ISFRenderer * jit_gl_vvisf_get_renderer(t_jit_gl_vvisf *targetInstance)	{
	if (targetInstance == NULL)
		return NULL;
	return TI->isfRenderer;
}




MyBufferRef jit_gl_vvisf_apply_jit_tex_for_input_key(t_jit_gl_vvisf *targetInstance, t_symbol *inJitGLTexNameSym, const std::string & inInputName) {
	if (TI->isfRenderer == nullptr)
		return nullptr;

	if (inJitGLTexNameSym != NULL) {
		//	retrieve the actual jitter texture for the passed texture name, query its basic properties
		void				*jitTexture = jit_object_findregistered(static_cast<t_symbol*>(inJitGLTexNameSym));
		if (jitTexture == NULL) {
			jit_object_error((t_object*)targetInstance, (char*)"cant find jitter object registered for %s", static_cast<t_symbol*>(inJitGLTexNameSym)->s_name);
		}
		else {
			//GLuint width = jit_attr_getlong(texture,ps_width);
			//GLuint height = jit_attr_getlong(texture,ps_height);
			//GLuint texTarget = jit_attr_getlong(texture, ps_gltarget);
			//t_jit_gl_context			ctx = jit_gl_get_context();
			//if (ctx == NULL)
			//	post("ERR: couldnt retrieve ctx in %s",__func__);
			//else
			//	jit_ob3d_set_context(_parentJitterObject);
			//t_symbol			*tmpClassName = jit_object_classname(jitTexture);
			//post("texture is %p, class name check is %s",jitTexture,tmpClassName->s_name);
			
			// ensure jitter-texture is properly initialized and submitted
			if(!jit_gl_vvisf_setup_jitter_texture(targetInstance, inJitGLTexNameSym)) {
				jit_object_error((t_object*)targetInstance, (char*)"failed to setup texture %s", static_cast<t_symbol*>(inJitGLTexNameSym)->s_name);
				return nullptr;
			}

			uint32_t			texName = jit_attr_getlong(jitTexture, ps_glid_j);
			if(!texName) {
				jit_object_error((t_object*)targetInstance, (char*)"cant bind texture %s", static_cast<t_symbol*>(inJitGLTexNameSym)->s_name);
				return nullptr;
			}
			
			//VVGL::Size			tmpSize = VVGL::Size(jitObj->dim[0], jitObj->dim[1]);
			VVGL::Size			tmpSize;
			tmpSize.width = (double)jit_attr_getlong(jitTexture, ps_width_j);
			tmpSize.height = (double)jit_attr_getlong(jitTexture, ps_height_j);
			//post("tex name is %d, dims are %f x %f",texName,tmpSize.width,tmpSize.height);
			VVGL::Rect			tmpRect = VVGL::Rect(0, 0, tmpSize.width, tmpSize.height);
			bool				tmpFlipped = (jit_attr_getlong(jitTexture, ps_flip_j) > 0) ? false : true;
			//	create a 'MyBuffer' for the jitter texture, pass it to the renderer with the given input name
			MyBufferRef			returnMe = CreateBufferFromExistingTex(
				texName,
				jit_attr_getlong(jitTexture, ps_gltarget_j),
				tmpSize,
				tmpFlipped,
				tmpRect,
				TI->isfRenderer);

			TI->isfRenderer->setBufferForInputKey(returnMe, inInputName);

			return returnMe;
		}
	}
	return nullptr;
}


