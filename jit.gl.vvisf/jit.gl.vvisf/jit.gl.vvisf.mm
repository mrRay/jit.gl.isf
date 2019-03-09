#include "jit.common.h"
#include "jit.gl.h"
#include "jit.gl.ob3d.h"
#include "ext_obex.h"

#import <Cocoa/Cocoa.h>

#include "VVGL.hpp"
#include "VVISF.hpp"
#include "ISFRenderer.hpp"

#include <map>
#include <string>



BEGIN_USING_C_LINKAGE
t_jit_err jit_ob3d_dest_name_set(t_jit_object *targetInstance, void *attr, long argc, t_atom *argv);
END_USING_C_LINKAGE



typedef struct _jit_gl_vvisf	{
	// Max object
	t_object			ob;			
	// 3d object extension.	 This is what all objects in the GL group have in common.
	void				*ob3d;
		
	//	attributes (automatically recognized by max)
	t_symbol			*file;	//	
	t_atom_long			dim[2];	//	render size must be explicitly set
	t_atom_long			needsRedraw;
	
	//	ivars (not to be confused with attributes!)
	ISFRenderer			*isfRenderer;	//	this owns the GL scenes and does all the rendering
	std::map<std::string,std::string>		*inputTextureMap;	//	key is string of the jitter object name of the gl texture, value is a string describing the name of the input
	
	// internal jit.gl.texture object
	t_jit_object		*outputTexObj;
	
} t_jit_gl_vvisf;

void			*_jit_gl_vvisf_class;

//	init/constructor/free
t_jit_err jit_gl_vvisf_init(void);
t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name);
void jit_gl_vvisf_free(t_jit_gl_vvisf *targetInstance);

//void jit_gl_vvisf_loadFile(t_jit_gl_vvisf *targetInstance, const string & inFilePath);
void jit_gl_vvisf_setInputValue(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);

//	handle context changes - need to rebuild IOSurface + textures here.
t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance);
t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance);

//	draw;
t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance);
t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);

//attributes
t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);
t_jit_err jit_gl_vvisf_getattr_needsRedraw(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);
t_jit_err jit_gl_vvisf_setattr_needsRedraw(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

// @out_tex_sym for output...
t_jit_err jit_gl_vvisf_getattr_out_tex_sym(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);

// dim
t_jit_err jit_gl_vvisf_setattr_size(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

//	getters
//ISFRenderer * jit_gl_vvisf_get_renderer(t_jit_gl_vvisf *targetInstance);

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

// for our internal texture
extern t_symbol			*ps_jit_gl_texture;




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
	
	// define our OB3D draw method.  called in automatic mode by
	// jit.gl.render or otherwise through ob3d when banged. this
	// method is A_CANT because our draw setup needs to happen
	// in the ob3d beforehand to initialize OpenGL state
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_draw, "ob3d_draw", A_CANT, 0L );
	
	// must register for ob3d use
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_object_register, "register", A_CANT, 0L );
	
	// add attributes
	long				attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_USURP_LOW;

	t_jit_object		*attr;
	
	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset_array,
		"size",
		_jit_sym_long,
		2,
		attrflags,
		(method)0L,
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
	
	attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_OPAQUE_USER;
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
	
	jit_class_addmethod( _jit_gl_vvisf_class, (method)jit_gl_vvisf_setInputValue, "setInputValue", A_GIMME, 0L );
	
	jit_class_register(_jit_gl_vvisf_class);

	return JIT_ERR_NONE;
}

t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name)	{
	//post("%s",__func__);
	t_jit_gl_vvisf			*targetInstance;
	
	// make jit object
	if ((targetInstance = (t_jit_gl_vvisf *)jit_object_alloc(_jit_gl_vvisf_class)))	{
		targetInstance->isfRenderer = new ISFRenderer();
		
		//	allocate the input texture map
		targetInstance->inputTextureMap = new std::map<std::string,std::string>();
		
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
	post("%s",__func__);
	if (argv == NULL)
		return;
	
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
		jit_attr_setsym(targetInstance->outputTexObj, ps_drawto_j, context);
		
		// our texture has to be bound in the new context before we can use it
		// http://cycling74.com/forums/topic.php?id=29197
		t_jit_gl_drawinfo			drawInfo;
		t_symbol			*texName = jit_attr_getsym(targetInstance->outputTexObj, gensym("name"));
		jit_gl_drawinfo_setup(targetInstance, &drawInfo);
		jit_gl_bindtexture(&drawInfo, texName, 0);
		jit_gl_unbindtexture(&drawInfo, texName, 0);
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
			//srvname = jit_atom_getsym(argv);
			//post("\tsrvname is %s",srvname);
			//targetInstance->file = srvname;
			targetInstance->file = jit_atom_getsym(argv);
			string		tmpStr = string(targetInstance->file->s_name);
			//post("\tfile is %s",tmpStr.c_str());
			if (targetInstance->isfRenderer == nullptr)
				post("ERR: isfRenderer NULL in %s",__func__);
			else
				targetInstance->isfRenderer->loadFile(&tmpStr);
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
	// jit_object_post((t_object *)targetInstance,"jit.gl.imageunit: sending output: %s", JIT_SYM_SAFECSTR(jit_attr_getsym(targetInstance->outputTexObj,_jit_sym_name)));
	
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
		
		post("size updated to %d targetInstance %d",targetInstance->dim[0],targetInstance->dim[1]);
		
		// update our internal texture as well.
		jit_attr_setlong_array(targetInstance->outputTexObj, _jit_sym_dim, 2, targetInstance->dim);
		
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}


/*
ISFRenderer * jit_gl_vvisf_get_renderer(t_jit_gl_vvisf *targetInstance)	{
	if (targetInstance == NULL)
		return NULL;
	return targetInstance->isfRenderer;
}
*/
