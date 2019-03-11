#ifndef max_jit_gl_vvisf_h
#define max_jit_gl_vvisf_h




#include "jit.common.h"
#include "jit.gl.h"

#include <map>
#include <string>




typedef struct _max_jit_gl_vvisf	{
	t_object		ob;
	void			*obex;
	long			_proxyInletVal;
	
	//	proxy inlets?
	void			*_proxyInlet;
	
	//	outlets
	void			*texout;
	void			*dumpout;
	
	//	ivars
	//std::map<std::string,std::string>		*inputTextureMap;	//	key is string of attribute name, value is string of the jitter object name of the gl texture (turn this into a t_symbol and use it to find the registered object to locate the jitter object)
	
} t_max_jit_gl_vvisf;

t_jit_err jit_gl_vvisf_init(void); 

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv);
void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x);

//	misc methods
//void max_jit_gl_vvisf_anything(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);

// custom draw
void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv);




#endif /* max_jit_gl_vvisf_h */
