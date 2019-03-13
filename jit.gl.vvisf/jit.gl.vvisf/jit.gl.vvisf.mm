
#include "jit.gl.vvisf.h"

#import <Cocoa/Cocoa.h>

#include "max.jit.gl.vvisf.h"




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
t_symbol			*ps_needsRedraw_j;
t_symbol			*ps_willfree_j;
t_symbol			*ps_free_j;




//
// Function implementations
//
#pragma mark -
#pragma mark Init, New, Cleanup, Context changes




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
	ps_needsRedraw_j = gensym("needsRedraw");
	ps_willfree_j = gensym("willfree");
	ps_free_j = gensym("free");
	
	// setup our OB3D flags to indicate our capabilities.
	long			ob3d_flags = JIT_OB3D_NO_MATRIXOUTPUT; // no matrix output
	ob3d_flags |= JIT_OB3D_NO_ROTATION_SCALE;
	ob3d_flags |= JIT_OB3D_NO_POLY_VARS;
	ob3d_flags |= JIT_OB3D_NO_FOG;
	ob3d_flags |= JIT_OB3D_NO_MATRIXOUTPUT;
	ob3d_flags |= JIT_OB3D_NO_LIGHTING_MATERIAL;
	ob3d_flags |= JIT_OB3D_NO_DEPTH;
	ob3d_flags |= JIT_OB3D_NO_COLOR;
	
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
	
	//	this method is how you pass input values to the isf object
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_setInputValue, "setInputValue", A_GIMME, 0L );
	
	// add attributes
	long				attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_USURP_LOW;

	t_jit_object		*attr;
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset_array,
		"size",
		_jit_sym_long,
		2,
		attrflags,
		(method)jit_gl_vvisf_getattr_size,
		(method)jit_gl_vvisf_setattr_size,
		0/*fix*/,
		calcoffset(t_jit_gl_vvisf,dim));
	jit_class_addattr(_jit_gl_vvisf_class, attr);	
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"file",
		_jit_sym_symbol,
		attrflags,
		(method)0L,
		jit_gl_vvisf_setattr_file,
		calcoffset(t_jit_gl_vvisf, file)); 
	jit_class_addattr(_jit_gl_vvisf_class, attr);
	
	attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_OPAQUE_USER | JIT_ATTR_GET_OPAQUE_USER;
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"out_tex_sym",
		_jit_sym_symbol,
		attrflags,
		(method)jit_gl_vvisf_getattr_out_tex_sym,
		(method)0L,
		0);	
	jit_class_addattr(_jit_gl_vvisf_class,attr);
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"needsRedraw",
		_jit_sym_long,
		attrflags,
		jit_gl_vvisf_getattr_needsRedraw,
		jit_gl_vvisf_setattr_needsRedraw,
		calcoffset(t_jit_gl_vvisf, needsRedraw));
	jit_class_addattr(_jit_gl_vvisf_class, attr);
	
	jit_class_register(_jit_gl_vvisf_class);

	return JIT_ERR_NONE;
}

t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name)	{
	//post("%s",__func__);
	t_jit_gl_vvisf			*targetInstance;
	
	// make jit object
	if ((targetInstance = (t_jit_gl_vvisf *)jit_object_alloc(_jit_gl_vvisf_class)))	{
		targetInstance->isfRenderer = new ISFRenderer(/*targetInstance*/);
		
		//	allocate the input texture map
		targetInstance->inputTextureMap = new std::map<std::string,std::string>();
		
		targetInstance->sizeNeedsToBePushed = false;
		
		// TODO : is this right ? 
		// set up attributes
		jit_attr_setsym(targetInstance->file, _jit_sym_name, ps_file_j);
		
		jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
		
		// instantiate a single internal jit.gl.texture should we need it.
		targetInstance->outputTexObj = (t_jit_object*)jit_object_new(ps_jit_gl_texture,dest_name);
		if (targetInstance->outputTexObj != NULL)	{
			// set texture attributes.
			jit_attr_setsym(targetInstance->outputTexObj, _jit_sym_name, jit_symbol_unique());
			jit_attr_setsym(targetInstance->outputTexObj, gensym("defaultimage"), gensym("white"));
			jit_attr_setlong(targetInstance->outputTexObj, gensym("rectangle"), 1);
			jit_attr_setlong(targetInstance->outputTexObj, ps_flip_j, 0);
			
			targetInstance->dim[0] = 640;
			targetInstance->dim[1] = 480;
			jit_attr_setlong_array(targetInstance->outputTexObj, _jit_sym_dim, 2, targetInstance->dim);
		}
		else	{
			post("error creating internal texture object");
			jit_object_error((t_object *)targetInstance,(char*)"jit.gl.syphonserver: could not create texture");
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
	
	//if (targetInstance->syClient != NULL)	{
	//	[targetInstance->syClient release];
	//	targetInstance->syClient = nil;
	//}
	
	//[pool drain];
	
	if (targetInstance->isfRenderer != NULL)	{
		delete targetInstance->isfRenderer;
		targetInstance->isfRenderer = NULL;
	}
	
	if (targetInstance->inputTextureMap != nullptr)	{
		delete targetInstance->inputTextureMap;
		targetInstance->inputTextureMap = nullptr;
	}

	// free our ob3d data 
	if(targetInstance)
		jit_ob3d_free(targetInstance);
	
	// free our internal texture
	if(targetInstance->outputTexObj)
		jit_object_free(targetInstance->outputTexObj);
}


#pragma mark -
#pragma mark misc funcs


/*
void jit_gl_vvisf_loadFile(t_jit_gl_vvisf *targetInstance, const string & inFilePath)	{
	post("%s ... %s",__func__,inFilePath.c_str());
}
*/
void jit_gl_vvisf_setInputValue(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	
	using namespace std;
	//post("%s, argc is %d",__func__,argc);
	
	/*
	{
		t_atom			*aptr = argv;
		long			i = 0;
		for (i=0; i<argc; i++)	{
			switch (atom_gettype(aptr))	{
			case A_NOTHING:
				post("\targ %d is null", i);
				break;
			case A_LONG:
			case A_DEFLONG:
				post("\targ %d is %d", i, (int)aptr->a_w.w_long);
				break;
			case A_FLOAT:
			case A_DEFFLOAT:
				post("\targ %d is %f", i, aptr->a_w.w_float);
				break;
			case A_SYM:
			case A_DEFSYM:
				post("\targ %d is %s", i, aptr->a_w.w_sym->s_name);
				break;
			case A_OBJ:
				post("\targ %d is an object", i);
				break;
			case A_GIMME:
			case A_CANT:
			case A_SEMI:
			case A_COMMA:
			case A_DOLLAR:
			case A_DOLLSYM:
			case A_GIMMEBACK:
			case A_DEFER:
			case A_USURP:
			case A_DEFER_LOW:
			case A_USURP_LOW:
				post("\targ %d is some other type",argc);
				break;
			}
			++aptr;
		}
	}
	*/
	if (argv == NULL)
		return;
	
	//post("%s, inlet is %d",__func__,proxy_getinlet(&targetInstance->ob));
	//int				rxInlet = proxy_getinlet(&targetInstance->ob);
	//int				rxInlet = proxy_getinlet((t_object*)targetInstance);
	//post("\trxInlet is %d",rxInlet);
	//	bail if this method is called on anything but the second inlet
	//if (rxInlet != 1)	{
	//	post("ERR: bailing, wrong inlet (not 1)");
	//	return;
	//}
	
	//	get the jitter object
	//t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	//	get the renderer from the jitter object
	ISFRenderer			*renderer = targetInstance->isfRenderer;
	//	get the ISFDoc that is currently being used
	ISFDocRef			doc = (renderer==nullptr) ? nullptr : renderer->loadedISFDoc();
	if (doc == nullptr)	{
		//post("ERR: bailing, no ISF file loaded yet, %s",__func__);
		return;
	}
	//	's' would ordinarily be the message/method name, but in this case it's the name of the input
	t_atom				*inputNameAtom = argv;
	string				inputName = string( (char*)jit_atom_getsym(inputNameAtom)->s_name );
	t_atom				*argAtoms = argv + 1;
	//	get the ISFAttr from the ISFDoc that corresponds to the input name the user supplied
	ISFAttrRef			attr = doc->input(inputName);
	if (attr == nullptr)	{
		post("err: unrecognized input \"%s\"",inputName.c_str());
		return;
	}
	//	based on the type of the attribute, assemble a value from the input values, showing a warning if we can't
	switch (attr->type())	{
	case ISFValType_None:	//	unrecognized value type, do nothing
		break;
	case ISFValType_Event:	//	event-type ISF attribute
		attr->setCurrentVal(ISFEventVal(true));
		break;
	case ISFValType_Bool:	//	bool-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			attr->setCurrentVal( (jit_atom_getlong(argAtoms)>0) ? ISFBoolVal(true) : ISFBoolVal(false) );
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			attr->setCurrentVal( (jit_atom_getlong(argAtoms)>0.0) ? ISFBoolVal(true) : ISFBoolVal(false) );
			break;
		default:
			post("ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Long:	//	long-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			attr->setCurrentVal( ISFLongVal(jit_atom_getlong(argAtoms)) );
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			attr->setCurrentVal( ISFLongVal(jit_atom_getlong(argAtoms)) );
			break;
		case A_SYM:
		case A_DEFSYM:
			{
				string			tmpStr = std::string( (char*)jit_atom_getsym(argAtoms)->s_name );
				vector<string>		&labels = attr->labelArray();
				vector<int32_t>		&vals = attr->valArray();
				int					tmpIndex = 0;
				int					foundIndex = -1;
				if (labels.size() < 1)
					post("ERR: arg is wrong type, attr %s is a long",s->s_name);
				else	{
					for (const string & label : labels)	{
						if (label == tmpStr)	{
							if (tmpIndex>=0 && tmpIndex<vals.size())	{
								attr->setCurrentVal( ISFLongVal(vals[tmpIndex]) );
							}
							else	{
								post("ERR: label is valid, but doesn't have matching value");
							}
							foundIndex = tmpIndex;
							break;
						}
						++tmpIndex;
					}
					if (foundIndex < 0)	{
						post("ERR: arg is wrong type, attr %s is a long",s->s_name);
					}
				}
			}
			break;
		default:
			post("ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Float:	//	float-type ISF attribute
		switch (atom_gettype(argAtoms))	{
		case A_LONG:
		case A_DEFLONG:
			attr->setCurrentVal( ISFFloatVal(jit_atom_getfloat(argAtoms)) );
			break;
		case A_FLOAT:
		case A_DEFFLOAT:
			attr->setCurrentVal( ISFFloatVal(jit_atom_getfloat(argAtoms)) );
			break;
		default:
			post("ERR: arg is wrong type, attr %s is a bool",s->s_name);
			break;
		}
		break;
	case ISFValType_Point2D:	//	point-type ISF attribute
		{
			if (argc == 3)	{
				t_atom		*firstAtom = argAtoms;
				t_atom		*secondAtom = argAtoms + 1;
				ISFVal		tmpPointVal = ISFPoint2DVal(jit_atom_getfloat(firstAtom), jit_atom_getfloat(secondAtom));
				attr->setCurrentVal(tmpPointVal);
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
				attr->setCurrentVal(tmpColorVal);
			}
		}
		break;
	case ISFValType_Cube:	//	cube-type ISF attribute: unhandled
		break;
	case ISFValType_Image:	//	image-type ISF attribute
		{
			t_atom		*firstAtom = argAtoms;
			t_atom		*secondAtom = firstAtom + 1;
			//post("argc is %d",argc);
			long		firstType = atom_gettype(firstAtom);
			//long		secondType = atom_gettype(secondAtom);
			if ( (argc == 3) && (firstType == A_SYM || firstType == A_DEFSYM) )	{
				//std::string			msgSymString = std::string( (char*)av->a_w.w_sym->s_name );
				t_symbol			*firstMsgSym = jit_atom_getsym(firstAtom);
				t_symbol			*secondMsgSym = jit_atom_getsym(secondAtom);
				if (firstMsgSym != NULL && secondMsgSym != NULL && firstMsgSym == ps_jit_gl_texture)	{
					//post("should be okay so far, second type is %d",secondType);
					void				*jitTexture = jit_object_findregistered(secondMsgSym);
					if (jitTexture == NULL)
						post("ERR: unable to create jitTexture from sym");
					else	{
						
						//	first use the attr name to look up and detach from any jit.gl.texture objects we're attached to under this input name
						try	{
							string				&oldJitTexName = targetInstance->inputTextureMap->at(inputName);
							t_symbol			*oldJitTexNameSym = gensym((char*)oldJitTexName.c_str());
							targetInstance->inputTextureMap->erase(inputName);
							if (oldJitTexNameSym != NULL)	{
								jit_object_detach(oldJitTexNameSym, targetInstance);
							}
						}
						catch(...)	{
						}
						
						//	now attach to the jitter texture we were passed, and store a record of this attachment in our map
						if (jit_object_attach(secondMsgSym, targetInstance) == NULL)
							post("ERR: unable to attach the jitter object to the input texture, %s",__func__);
						else	{
							targetInstance->inputTextureMap->emplace( std::make_pair(inputName, std::string((char*)secondMsgSym->s_name)) );
							//targetInstance->inputTextureMap->insert({inputName, std::string((char*)secondMsgSym->s_name)});
							
							//	finally, pass the jitter texture object to the ISFRenderer, which will "wrap" it with a GLBufferRef from the appropriate pool/GL version to render
							renderer->applyJitGLTexToInputKey(secondMsgSym, inputName);
						}
					}
				}
				else
					post("ERR: arg is wrong type, attr %s is an image and requires a GL texture for input",s->s_name);
			}
			else
				post("ERR: arg is wrong type, attr %s is an image and requires a GL texture for input",s->s_name);
		}
		break;
	case ISFValType_Audio:	//	audio-type ISF attribute
		break;
	case ISFValType_AudioFFT:	//	audio-FFT-type ISF attribute
		break;
	}
}

t_jit_err jit_gl_vvisf_jit_gl_texture(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	//post("%s",__func__);
	t_atom			*firstAtom = argv;
	t_symbol		*firstMsgSym = jit_atom_getsym(firstAtom);
	
	//	get the renderer from the jitter object, try to pass the texture to it as an input image
	ISFRenderer			*renderer = jit_gl_vvisf_get_renderer(targetInstance);
	if (renderer != NULL && renderer->hasInputImageKey())
		targetInstance->isfRenderer->applyJitGLTexToInputKey(firstMsgSym, string("inputImage"));
	
	return JIT_ERR_NONE;
}

void jit_gl_vvisf_notify(t_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *ob, void *data)	{
	//post("%s ... %s %s",__func__,msg->s_name,s->s_name);
	
	if (msg == ps_willfree_j || msg == ps_free_j)	{
		//	get the jitter object
		t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(x);
		//	get the renderer from the jitter object
		ISFRenderer			*renderer = jit_gl_vvisf_get_renderer(jitObj);
		//	get the ISFDoc that is currently being used by the renderer
		//ISFDocRef			doc = (renderer==nullptr) ? nullptr : renderer->loadedISFDoc();
		
		//	get the name of the jitter texture being freed as a std::string
		string			jitTextureName = std::string((char*)s->s_name);
		//	run through the map of input names/jitter texture names
		auto			iter = x->inputTextureMap->begin();
		while (iter != x->inputTextureMap->end())	{
			//	if this item in the map matches the texture being freed...
			if (iter->second == jitTextureName)	{
				//	detach from the jitter object, we no longer want to be notified as to its changes (is this safe to do now, in a notify callback?)
				jit_object_detach(s, x);
				//	tell the ISF renderer to clear out the texture for this attribute 
				renderer->applyJitGLTexToInputKey(NULL, iter->first);
				//	delete the item from the map (this automatically increments the iterator)
				iter = x->inputTextureMap->erase(iter);
			}
			//	else this item in the map doesn't match the texture being freed- increment the iterator and check the next...
			else
				++iter;
		}
	}
	
}


#pragma mark -
#pragma mark ctx change


t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance)	{
	//post("%s ... %p",__func__,CGLGetCurrentContext());
	
	//	get the current GL context on this thread- if there isn't one, bail
	CGLContextObj				hostCtx = CGLGetCurrentContext();
	if (hostCtx == NULL)	{
		post("ERR: no host GL ctx");
		return JIT_ERR_INVALID_PTR;
	}
	
	//	get the cache item for the current context- the cache item contains buffer pools and shared contexts (GL2 + GL4) used to create the renderer's contexts
	VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(hostCtx);
	//	if there's no cached context item, something has gone horribly wrong- bail
	if (cacheItem == nullptr)	{
		post("ERR: couldnt find cache ctx");
		return JIT_ERR_INVALID_PTR;
	}
	
	//	tell the renderer to update using the cache item- this will create all the contexts and reload the file if necessary
	targetInstance->isfRenderer->configureWithCache(cacheItem);
	
	//	get the jit.gl.texture object we render into for output
	if (targetInstance->outputTexObj != NULL)	{
		t_symbol			*context = jit_attr_getsym(targetInstance, ps_drawto_j);
		if (context == NULL)	{
			post("ERR: context NULL in %s",__func__);
		}
		else	{
			jit_attr_setsym(targetInstance->outputTexObj, ps_drawto_j, context);
			
			// our texture has to be bound in the new context before we can use it
			// http://cycling74.com/forums/topic.php?id=29197
			t_jit_gl_drawinfo			drawInfo;
			t_symbol			*texName = jit_attr_getsym(targetInstance->outputTexObj, gensym("name"));
			if (texName == NULL)	{
				post("ERR: texName NULL in %s",__func__);
			}
			else	{
				jit_gl_drawinfo_setup(targetInstance, &drawInfo);
				jit_gl_bindtexture(&drawInfo, texName, 0);
				jit_gl_unbindtexture(&drawInfo, texName, 0);
			}
			
		}
	}
	else
		post("ERR: outputTexObj null in %s",__func__);
	
	//	flag the needsRedraw attribute so i know i need to render a new frame
	jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
	
	//	don't forget to return the cache item to the pool!
	ReturnCacheItemToPool(cacheItem);
	
	return JIT_ERR_NONE;
}

#pragma mark -
#pragma mark Draw

t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	//post("%s",__func__);
	object_attr_setvalueof(targetInstance->outputTexObj, s, argc, argv);	
	jit_ob3d_dest_name_set((t_jit_object *)targetInstance, NULL, argc, argv);
	
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance)	{
	//post("%s",__func__);
	if (!targetInstance)
		return JIT_ERR_INVALID_PTR;
	
	if (jit_attr_getlong(targetInstance, ps_needsRedraw_j))	{
		//post("\trendering a frame...");
		
		//	if our size has been changed, we need to apply that change to our internal jit.gl.texture object now
		if (targetInstance->sizeNeedsToBePushed && targetInstance->outputTexObj != NULL)	{
			//	first update the texture's size attr
			jit_attr_setlong_array(targetInstance->outputTexObj, _jit_sym_dim, 2, targetInstance->dim);
			targetInstance->sizeNeedsToBePushed = false;
			
			// our texture has to be bound in the new context before we can use it
			// http://cycling74.com/forums/topic.php?id=29197
			t_jit_gl_drawinfo			drawInfo;
			t_symbol			*texName = jit_attr_getsym(targetInstance->outputTexObj, gensym("name"));
			if (texName == NULL)
				post("ERR: texName NULL in %s",__func__);
			else	{
				jit_gl_drawinfo_setup(targetInstance, &drawInfo);
				jit_gl_bindtexture(&drawInfo, texName, 0);
				jit_gl_unbindtexture(&drawInfo, texName, 0);
			}
		}
		
		//t_symbol		*tmpClassName = object_classname((t_object*)&targetInstance->ob);
		//post("class name of jit objects ob is %s",tmpClassName->s_name);
		
		//	get the host context, use that to retrieve the cache item which holds the shared contexts, buffer pools, and buffer copiers
		CGLContextObj		origCglCtx = CGLGetCurrentContext();
		VVGLContextCacheItemRef		cacheItem = GetCacheItemForContext(origCglCtx);
		if (cacheItem != nullptr)	{
			targetInstance->isfRenderer->configureWithCache(cacheItem);
			ReturnCacheItemToPool(cacheItem);
		}
		
		//	get the buffer pool that corresponds to the currently-loaded ISF file (we need the appropriate- gl2/gl4- pool)
		GLBufferPoolRef		tmpPool =  targetInstance->isfRenderer->loadedBufferPool();
		//	if there's no buffer pool then something is wrong with the renderer
		if (tmpPool == nullptr)	{
			//post("err: no pool in %s, file presumably not loaded yet",__func__);
			return JIT_ERR_NONE;
		}
		
		//	create a GLBufferRef that "wraps" the jitter texture
		uint32_t			texName = jit_attr_getlong(targetInstance->outputTexObj, ps_glid_j);
		VVGL::Size			tmpSize = VVGL::Size(targetInstance->dim[0], targetInstance->dim[1]);
		VVGL::Rect			tmpRect = VVGL::Rect(0, 0, tmpSize.width, tmpSize.height);
		GLBufferRef			wrapperTex = CreateFromExistingGLTexture(
			texName,	//	inTexName The name of the OpenGL texture that will be used to populate the GLBuffer.
			GLBuffer::Target_Rect,	//	inTexTarget The texture target of the OpenGL texture (GLBuffer::Target)
			GLBuffer::IF_RGBA8,	//	inTexIntFmt The internal format of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
			GLBuffer::PF_BGRA,	//	inTexPxlFmt The pixel format of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
			GLBuffer::PT_UInt_8888_Rev,	//	inTexPxlType The pixel type of the OpenGL texture.  Not as important to get right, used primarily for creating the texture.
			tmpSize,	//	inTexSize The Size of the OpenGL texture, in pixels.
			false,	//	inTexFlipped Whether or not the image in the OpenGL texture is flipped.
			tmpRect,	//	inImgRectInTex The region of the texture (bottom-left origin, in pixels) that contains the image.
			nullptr,	//	inReleaseCallbackContext An arbitrary pointer stored (weakly) with the GLBuffer- this pointer is passed to the release callback.  If you want to store a pointer from another SDK, this is the appropriate place to do so.
			nullptr,	//	inReleaseCallback A callback function or lambda that will be executed when the GLBuffer is deallocated.  If the GLBuffer needs to release any other resources when it's freed, this is the appropriate place to do so.
			tmpPool	//	inPoolRef The pool that the GLBuffer should be created with.  When the GLBuffer is freed, its underlying GL resources will be returned to this pool (where they will be either freed or recycled).
		);
		//post("\twrapperTex is %s",wrapperTex->getDescriptionString().c_str());
		
		//	tell the renderer to render into the wrapper GLBufferRef we made around the jit.gl.texture object we own
		targetInstance->isfRenderer->render(wrapperTex, VVGL::Size(targetInstance->dim[0], targetInstance->dim[1]));
		
		jit_attr_setlong(targetInstance, ps_needsRedraw_j, 0);
		
		if (origCglCtx != NULL)	{
			CGLSetCurrentContext(origCglCtx);
		}
	}
	
	return JIT_ERR_NONE;
}
		
#pragma mark -
#pragma mark Attributes

// attributes

t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	//post("%s",__func__);
	//t_symbol			*srvname;

	if(targetInstance != NULL)	{
		if (argc && argv)	{
			targetInstance->file = jit_atom_getsym(argv);
			string		tmpStr = string(targetInstance->file->s_name);
			//post("\tfile is %s",tmpStr.c_str());
			if (targetInstance->isfRenderer == nullptr)
				post("ERR: isfRenderer NULL in %s",__func__);
			else	{
				targetInstance->isfRenderer->loadFile(&tmpStr);
				max_jit_gl_vvisf_inputs((t_max_jit_gl_vvisf*)targetInstance->maxWrapperStruct);
			}
		} 
		else	{
			// no args, set to zero
			targetInstance->file = _jit_sym_nothing;
			targetInstance->isfRenderer->loadFile();
		}
		// if we have a server release it, 
		// make a new one, with our new UUID.
		//NSAutoreleasePool			*pool = [[NSAutoreleasePool alloc] init];
		//[targetInstance->syClient setName:[NSString stringWithCString:targetInstance->file->s_name
		//																	encoding:NSASCIIStringEncoding]];
		jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
		
		//[pool drain];
	}
	else	{
		post("ERR: target instance NULL in %s",__func__);
		return JIT_ERR_INVALID_PTR;
	}
	return JIT_ERR_NONE;
}


t_jit_err jit_gl_vvisf_getattr_needsRedraw(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
	//	if there was memory passed in, use it
	if ((*ac) && (*av))	{
	}
	//	else allocate memory
	else	{
		*ac = 1;
		if (!(*av == (atom*)jit_getbytes(sizeof(t_atom)*(*ac))))	{
			*ac = 0;
			return JIT_ERR_OUT_OF_MEM;
		}
	}
	
	//	populate the memory with the return value
	jit_atom_setlong(*av, targetInstance->needsRedraw);
	
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_setattr_needsRedraw(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	if (targetInstance)	{
		targetInstance->needsRedraw = jit_atom_getlong(argv);
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}

											  
t_jit_err jit_gl_vvisf_getattr_out_tex_sym(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
	//post("%s",__func__);
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
	
	jit_atom_setsym(*av, jit_attr_getsym(targetInstance->outputTexObj, _jit_sym_name));
	
	return JIT_ERR_NONE;
}											  

t_jit_err jit_gl_vvisf_getattr_size(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
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
	
	//jit_atom_setsym(*av, jit_attr_getsym(targetInstance->outputTexObj, _jit_sym_name));
	if (*ac >= 1)
		jit_atom_setfloat(*av, targetInstance->dim[0]);
	if (*ac >= 2)
		jit_atom_setfloat(*av+1, targetInstance->dim[1]);
	
	return JIT_ERR_NONE;
}
t_jit_err jit_gl_vvisf_setattr_size(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	//post("%s",__func__);
	long			i;
	long			v;
	
	if (targetInstance)	{
		jit_attr_setlong(targetInstance, ps_needsRedraw_j, 1);
		
		for(i = 0; i < JIT_MATH_MIN(argc, 2); i++)	{
			v = jit_atom_getlong(argv+i);
			if (targetInstance->dim[i] != JIT_MATH_MIN(v,1))	{
				targetInstance->dim[i] = v;
			}
		}
		
		//post("size updated to %d targetInstance %d",targetInstance->dim[0],targetInstance->dim[1]);
		
		targetInstance->sizeNeedsToBePushed = true;
		/*
		// update our internal texture as well.
		jit_attr_setlong_array(targetInstance->outputTexObj, _jit_sym_dim, 2, targetInstance->dim);
		*/
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}



ISFRenderer * jit_gl_vvisf_get_renderer(t_jit_gl_vvisf *targetInstance)	{
	if (targetInstance == NULL)
		return NULL;
	return targetInstance->isfRenderer;
}

