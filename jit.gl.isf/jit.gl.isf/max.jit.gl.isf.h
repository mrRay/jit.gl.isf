#ifndef max_jit_gl_vvisf_h
#define max_jit_gl_vvisf_h



/*
#include "VVGL.hpp"
*/

#include "jit.common.h"
#include "jit.gl.h"

//#include "ext.h"							// standard Max include, always required
//#include "ext_obex.h"						// required for new style Max object

#include <map>
#include <string>




typedef struct _max_jit_gl_vvisf	{
	t_object		ob;
	void			*obex;
	
	//	outlets
	void			*texout;
	void			*inputsout;
	void			*filesout;
	void			*dumpout;
	
} t_max_jit_gl_vvisf;

t_jit_err jit_gl_vvisf_init(void); 

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv);
void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x);

void max_jit_gl_vvisf_assist(t_max_jit_gl_vvisf *x, void *b, long m, long a, char *s);

//	misc methods
//void max_jit_gl_vvisf_anything(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv);
void max_jit_gl_vvisf_read(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, long argc, t_atom *argv);
void max_jit_gl_vvisf_getparamlist(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_getparam(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, long argc, t_atom *argv);

void max_jit_gl_vvisf_all_filenames(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_source_filenames(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_filter_filenames(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_transition_filenames(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_all_categories(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_category_filenames(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, long argc, t_atom *argv);

void max_jit_gl_vvisf_description(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_credit(t_max_jit_gl_vvisf *targetInstance);
void max_jit_gl_vvisf_vsn(t_max_jit_gl_vvisf *targetInstance);

// custom draw
void max_jit_gl_vvisf_float(t_max_jit_gl_vvisf *x, double n);
void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv);

//	send the passed atoms out the dumpout


#endif /* max_jit_gl_vvisf_h */
