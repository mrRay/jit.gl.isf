#include "jit.common.h"
#include "jit.gl.h"
#include "jit.gl.ob3d.h"
#include "ext_obex.h"

#import <Cocoa/Cocoa.h>



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
	
	//	ivars (not to be confused with attributes!)
	BOOL				needsRedraw;
	
	// internal jit.gl.texture object
	t_jit_object		*outputTexObj;
	
} t_jit_gl_vvisf;

void			*_jit_gl_vvisf_class;

//	init/constructor/free
t_jit_err jit_gl_vvisf_init(void);
t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name);
void jit_gl_vvisf_free(t_jit_gl_vvisf *targetInstance);

//	handle context changes - need to rebuild IOSurface + textures here.
t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance);
t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance);

//	draw;
t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance);
t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);

//attributes
t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

// @out_tex_sym for output...
t_jit_err jit_gl_vvisf_getattr_out_tex_sym(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);

// dim
t_jit_err jit_gl_vvisf_setattr_size(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

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

// for our internal texture
extern t_symbol			*ps_jit_gl_texture;




//
// Function implementations
//
#pragma mark -
#pragma mark Init, New, Cleanup, Context changes




t_jit_err jit_gl_vvisf_init(void)	{
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
	jit_class_addattr(_jit_gl_vvisf_class,attr);	

	attr = (t_jit_object*)jit_object_new(
		_jit_sym_jit_attr_offset,
		"file",
		_jit_sym_symbol,
		attrflags,
		(method)0L,
		jit_gl_vvisf_setattr_file,
		calcoffset(t_jit_gl_vvisf, file)); 
	jit_class_addattr(_jit_gl_vvisf_class,attr);
	
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
	
	
	jit_class_register(_jit_gl_vvisf_class);

	return JIT_ERR_NONE;
}

t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name)	{
	post("%s",__func__);
	t_jit_gl_vvisf			*targetInstance;
	
	// make jit object
	if ((targetInstance = (t_jit_gl_vvisf *)jit_object_alloc(_jit_gl_vvisf_class)))	{
		// TODO : is this right ? 
		// set up attributes
		jit_attr_setsym(targetInstance->file, _jit_sym_name, ps_file_j);
		
		targetInstance->needsRedraw = YES;
		
		// instantiate a single internal jit.gl.texture should we need it.
		targetInstance->outputTexObj = (t_jit_object*)jit_object_new(ps_jit_gl_texture,dest_name);
		
		if (targetInstance->outputTexObj)	{
			// set texture attributes.
			jit_attr_setsym(targetInstance->outputTexObj, _jit_sym_name, jit_symbol_unique());
			jit_attr_setsym(targetInstance->outputTexObj, gensym("defaultimage"), gensym("black"));
			jit_attr_setlong(targetInstance->outputTexObj, gensym("rectangle"), 1);
			jit_attr_setlong(targetInstance->outputTexObj, ps_flip_j, 0);
			
			targetInstance->dim[0] = 640;
			targetInstance->dim[1] = 480;
			jit_attr_setlong_array(targetInstance->outputTexObj, _jit_sym_dim, 2, targetInstance->dim);
		} 
		else	{
			post("error creating internal texture object");
			jit_object_error((t_object *)targetInstance,"jit.gl.syphonserver: could not create texture");
		}
		
		// create and attach ob3d
		jit_ob3d_new(targetInstance, dest_name);
		post("about to make new ctx");
		if (CGLGetCurrentContext() == NULL) {
			post("ERR: current context NULL in %s",__func__);
			//targetInstance->syClient = NULL;
		}
		else	{
			post("should be good to go!");
			//targetInstance->syClient = [[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
		}
		
		//targetInstance->syClient = [[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
	} 
	else 	{
		targetInstance = NULL;
	}

	return targetInstance;
}

void jit_gl_vvisf_free(t_jit_gl_vvisf *targetInstance)	{
	post("%s",__func__);
	NSAutoreleasePool			*pool = [[NSAutoreleasePool alloc] init];
	
	//if (targetInstance->syClient != NULL)	{
	//	[targetInstance->syClient release];
	//	targetInstance->syClient = nil;
	//}
	
	[pool drain];

	// free our ob3d data 
	if(targetInstance)
		jit_ob3d_free(targetInstance);
	
	// free our internal texture
	if(targetInstance->outputTexObj)
		jit_object_free(targetInstance->outputTexObj);
}

t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance)	{
	post("%s",__func__);
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance)	{
	post("%s ... %p",__func__,CGLGetCurrentContext());
	
	NSAutoreleasePool			*pool = [[NSAutoreleasePool alloc] init];
	
	//if (targetInstance->syClient != NULL)	{
	//	[targetInstance->syClient release];
	//	targetInstance->syClient = NULL;
	//}
	//CGLContextObj		cc = CGLGetCurrentContext();
	//if (cc != NULL)
	//	targetInstance->syClient = [[SyphonNameboundClient alloc] initWithContext:cc];
	
	if (targetInstance->outputTexObj)	{
		t_symbol			*context = jit_attr_getsym(targetInstance, ps_drawto_j);
		jit_attr_setsym(targetInstance->outputTexObj, ps_drawto_j,context);
		
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
	
	targetInstance->needsRedraw = YES;
	
	[pool release];
	pool = nil;
	
	return JIT_ERR_NONE;
}

#pragma mark -
#pragma mark Draw

t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	object_attr_setvalueof(targetInstance->outputTexObj, s, argc, argv);	
	jit_ob3d_dest_name_set((t_jit_object *)targetInstance, NULL, argc, argv);
	
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance)	{
	if (!targetInstance)
		return JIT_ERR_INVALID_PTR;
	return JIT_ERR_NONE;
}
		
#pragma mark -
#pragma mark Attributes

// attributes
t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv)	{
	post("%s",__func__);
	t_symbol			*srvname;

	if(targetInstance)	{
		if (argc && argv)	{
			srvname = jit_atom_getsym(argv);
			post("\tsrvname is %s",srvname);

			targetInstance->file = srvname;
		} 
		else	{
			// no args, set to zero
			targetInstance->file = _jit_sym_nothing;
		}
		// if we have a server release it, 
		// make a new one, with our new UUID.
		NSAutoreleasePool			*pool = [[NSAutoreleasePool alloc] init];
		//[targetInstance->syClient setName:[NSString stringWithCString:targetInstance->file->s_name
		//																	encoding:NSASCIIStringEncoding]];
		targetInstance->needsRedraw = YES;
		
		[pool drain];
	}
	return JIT_ERR_NONE;
}
											  
t_jit_err jit_gl_vvisf_getattr_out_tex_sym(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av)	{
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
	long			i;
	long			v;
	
	if (targetInstance)	{
		targetInstance->needsRedraw = YES;
		
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
