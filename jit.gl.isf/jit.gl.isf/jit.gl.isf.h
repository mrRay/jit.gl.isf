#ifndef jit_gl_vvisf_h
#define jit_gl_vvisf_h



#include "ISFRenderer.hpp"

#include "jit.common.h"
#include "jit.gl.h"
//#include "jit.gl.ob3d.h"
#include "ext_obex.h"

#include <map>
#include <string>
#include "MyBuffer.hpp"




typedef struct _jit_gl_vvisf	{
	// Max object
	t_object			ob;			
	// 3d object extension.	 This is what all objects in the GL group have in common.
	void				*ob3d;
	
	//	attributes (automatically recognized by max)
	t_symbol			*file;	//	
	long				adapt;	//	if 1, render resolution is the resolution of the incoming texture.  if 0, render resolution is 'dim' attribute.
	uint32_t			lastAdaptDims[2];	//	'adapt' means we need to render at the res of the input image.  this is the res of the last-received input image.
	long				dim[2];	//	render size must be explicitly set
	double				renderTimeOverride;	//	-1 by default.  if not -1, the scene will be rendered at this time value (instead of calculating the appropriate time internally).
	long				optimize;

	//	ivars (not to be confused with attributes!)
	ISFRenderer			*isfRenderer;	//	this owns the GL scenes and does all the rendering
	
	//	key is string of attribute name, value is string of the jitter object name of the gl texture (turn this into a t_symbol and use it to find the registered object to locate the jitter object) owned by the host.  THE HOST- NOT SELF- OWNS ALL OF THE JIT_GL_TEXTURE OBJECTS REFERENCED BY NAME IN THIS MAP!
	std::map<std::string,std::string>		*inputToHostTexNameMap;
	
	//	key is string of attribute name, value is a ptr to the jit_gl_texture object allocated and owned by this object.  THIS OBJECT ALLOCATES AND OWNS AND MUST DELETE ALL OF THE JIT_GL_TEXTURE OBJECTS OWNED BY THIS MAP!
	std::map<std::string,t_jit_object*>		*inputToClientGLTexPtrMap;
	
	// internal jit.gl.texture object
	t_jit_object		*outputTexObj;
	
	void				*maxWrapperStruct;	//	weak ptr to t_max_jit_gl_vvisf struct that "wraps" my jitter object
	
	t_bool				pending_file_read;
	t_hashtab			*pending_tex_params;
	t_hashtab			*pending_params;
} t_jit_gl_vvisf;

//	init/constructor/free
t_jit_err jit_gl_vvisf_init(void);
t_jit_gl_vvisf * jit_gl_vvisf_new(t_symbol * dest_name);
void jit_gl_vvisf_free(t_jit_gl_vvisf *targetInstance);

//void jit_gl_vvisf_loadFile(t_jit_gl_vvisf *targetInstance, const string & inFilePath);
void jit_gl_vvisf_setParamValue(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);
t_jit_err jit_gl_vvisf_jit_matrix(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);
t_jit_err jit_gl_vvisf_jit_gl_texture(t_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);

//	notify
void jit_gl_vvisf_notify(t_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *ob, void *data);

//	handle context changes - need to rebuild IOSurface + textures here.
t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *targetInstance);
t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *targetInstance);

//	draw;
t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *targetInstance);

//attributes
t_jit_err jit_gl_vvisf_setattr_file(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

// @out_name for output...
t_jit_err jit_gl_vvisf_setattr_out_name(t_jit_gl_vvisf *targetInstance, void *attr, long ac, t_atom *av);
t_jit_err jit_gl_vvisf_getattr_out_name(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);

// dim
t_jit_err jit_gl_vvisf_getattr_adapt(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);
t_jit_err jit_gl_vvisf_setattr_adapt(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);
t_jit_err jit_gl_vvisf_getattr_dim(t_jit_gl_vvisf *targetInstance, void *attr, long *ac, t_atom **av);
t_jit_err jit_gl_vvisf_setattr_dim(t_jit_gl_vvisf *targetInstance, void *attr, long argc, t_atom *argv);

//	getters
ISFRenderer * jit_gl_vvisf_get_renderer(t_jit_gl_vvisf *targetInstance);

//	misc
MyBufferRef jit_gl_vvisf_apply_jit_tex_for_input_key(t_jit_gl_vvisf *targetInstance, t_symbol *inJitGLTexNameSym, const std::string & inInputName);
t_bool jit_gl_vvisf_do_set_file(t_jit_gl_vvisf* targetInstance);

// for our internal texture
extern t_symbol			*ps_jit_gl_texture;
extern t_symbol			*ps_jit_matrix;

void* max_jit_gl_vvisf_getisffilemanager();

#endif /* jit_gl_vvisf_h */
