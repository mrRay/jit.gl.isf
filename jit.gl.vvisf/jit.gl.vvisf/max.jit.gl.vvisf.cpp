#include "jit.common.h"
#include "jit.gl.h"




typedef struct _max_jit_gl_vvisf	{
	t_object		ob;
	void			*obex;
	
	// output texture outlet
	void			*texout;
	void			*dumpout;
	
} t_max_jit_gl_vvisf;

t_jit_err jit_gl_vvisf_init(void); 

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv);
void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x);

// custom draw
void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *x);
void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv);




t_class				*max_jit_gl_vvisf_class;

t_symbol			*ps_jit_gl_texture;
t_symbol			*ps_draw;
t_symbol			*ps_out_name;
t_symbol			*ps_file;
t_symbol			*ps_clear;




int C74_EXPORT main(void)
{
	ps_jit_gl_texture = gensym("jit_gl_texture");
	ps_draw = gensym("draw");
	ps_out_name = gensym("out_name");
	ps_file = gensym("file");
	ps_clear = gensym("clear");
	
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
	
	// specify a byte offset to keep additional information about our object
	classex = max_jit_classex_setup(calcoffset(t_max_jit_gl_vvisf, obex));
	
	// look up our Jitter class in the class registry
	jitclass = jit_class_findbyname(gensym("jit_gl_vvisf"));	
		
	// wrap our Jitter class with the standard methods for Jitter objects
	max_jit_classex_standard_wrap(classex, jitclass, 0);	
	
	// custom draw handler so we can output our texture.
	// override default ob3d bang/draw methods
	addbang((method)max_jit_gl_vvisf_bang);
	max_addmethod_defer_low((method)max_jit_gl_vvisf_draw, "draw");	 
	
	// use standard ob3d assist method
	addmess((method)max_jit_ob3d_assist, "assist", A_CANT,0);  
	
	// add methods for 3d drawing
	max_ob3d_setup();
	
}

void max_jit_gl_vvisf_free(t_max_jit_gl_vvisf *x)	{
	max_jit_ob3d_detach(x);

	// lookup our internal Jitter object instance and free
	if (max_jit_obex_jitob_get(x))	{
		jit_object_free(max_jit_obex_jitob_get(x));
	}
	
	// free resources associated with our obex entry
	max_jit_obex_free(x);
}

void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *x)	{
//	typedmess((t_object *)x,ps_draw,0,NULL);
	max_jit_gl_vvisf_draw(x, ps_draw, 0, NULL);

}

void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv)	{
	t_atom				a;
	// get the jitter object
	t_jit_object			*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	
	// call the jitter object's draw method
	jit_object_method(jitob,s,s,argc,argv);
	
	// query the texture name and send out the texture output 
	jit_atom_setsym(&a,jit_attr_getsym(jitob,ps_out_name));
	outlet_anything(x->texout,ps_jit_gl_texture,1,&a);
}

void * max_jit_gl_vvisf_new(t_symbol *s, long argc, t_atom *argv)	{
	t_max_jit_gl_vvisf			*x;
	void			*jit_ob;
	long			attrstart;
	t_symbol		*dest_name_sym = _jit_sym_nothing;
	
	if ((x = (t_max_jit_gl_vvisf *) max_jit_obex_new(max_jit_gl_vvisf_class, gensym("jit_gl_vvisf"))))	{
		// get first normal arg, the destination name
		attrstart = max_jit_attr_args_offset(argc,argv);
		if (attrstart&&argv) 	{
			jit_atom_arg_getsym(&dest_name_sym, 0, attrstart, argv);
		}
		
		// instantiate Jitter object with dest_name arg
		if ((jit_ob = jit_object_new(gensym("jit_gl_vvisf"), dest_name_sym)))	{
			// set internal jitter object instance
			max_jit_obex_jitob_set(x, jit_ob);
			
			// process attribute arguments 
			max_jit_attr_args(x, argc, argv);		
			

			// add a general purpose outlet (rightmost)
			x->dumpout = outlet_new(x,NULL);
			max_jit_obex_dumpout_set(x, x->dumpout);

			// this outlet is used to shit out textures! yay!
			x->texout = outlet_new(x, "jit_gl_texture");
		} 
		else 	{
			error("jit.gl.syphon_server: could not allocate object");
			freeobject((t_object *)x);
			x = NULL;
		}
	}
	return (x);
}



