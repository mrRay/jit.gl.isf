#include "max.jit.gl.vvisf.h"

#include "jit.gl.vvisf.h"
#include "ISFRenderer.hpp"




t_class				*max_jit_gl_vvisf_class;

t_symbol			*ps_jit_gl_texture;
t_symbol			*ps_draw;
t_symbol			*ps_out_tex_sym;
t_symbol			*ps_file;
t_symbol			*ps_clear;
t_symbol			*ps_glid;




int C74_EXPORT main(void)
{
	ps_jit_gl_texture = gensym("jit_gl_texture");
	ps_draw = gensym("draw");
	ps_out_tex_sym = gensym("out_tex_sym");
	ps_file = gensym("file");
	ps_clear = gensym("clear");
	ps_glid = gensym("glid");
	
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
	addbang((method)max_jit_gl_vvisf_bang);
	max_addmethod_defer_low((method)max_jit_gl_vvisf_draw, (char*)"draw");
	
	// use standard ob3d assist method
	addmess((method)max_jit_ob3d_assist, (char*)"assist", A_CANT,0);
	
	//addmess( (method)max_jit_gl_vvisf_anything, (char*)"anything", A_GIMME, 0L );
	
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
		
		newObjPtr->_proxyInlet = proxy_new(newObjPtr, 1, &newObjPtr->_proxyInletVal);
		
		//	allocate the input texture map
		//newObjPtr->inputTextureMap = new std::map<std::string,std::string>();
		
		// instantiate Jitter object with dest_name arg
		if ((jit_ob = jit_object_new(gensym("jit_gl_vvisf"), dest_name_sym)))	{
			// set internal jitter object instance
			max_jit_obex_jitob_set(newObjPtr, jit_ob);
			
			// process attribute arguments 
			max_jit_attr_args(newObjPtr, argc, argv);		
			
			// add a general purpose outlet (rightmost)
			newObjPtr->dumpout = outlet_new(newObjPtr, NULL);
			max_jit_obex_dumpout_set(newObjPtr, newObjPtr->dumpout);

			// this outlet is used to send textures
			newObjPtr->texout = outlet_new(newObjPtr, "jit_gl_texture");
			
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
	
	//if (x->inputTextureMap != nullptr)	{
	//	delete x->inputTextureMap;
	//	x->inputTextureMap = nullptr;
	//}
	
	if (x->_proxyInlet != NULL)	{
		freeobject((t_object *)x->_proxyInlet);
		x->_proxyInlet = NULL;
	}
	
	// free resources associated with our obex entry
	max_jit_obex_free(x);
}
/*
void max_jit_gl_vvisf_anything(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	post("%s, argc is %d",__func__,argc);
}
*/

void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *x)	{
	//post("%s",__func__);
	
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	jit_attr_setlong(jitob, gensym("needsRedraw"), 1);
	
	max_jit_gl_vvisf_draw(x, ps_draw, 0, NULL);
	
}

void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv)	{
	//post("%s",__func__);
	
	/*
	//	run through the entries in 'inputTextureMap', creating GLBufferRefs that wrap the various jitter textures and pushing them to the renderer
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(x);
	ISFRenderer			*renderer = jit_gl_vvisf_get_renderer(jitObj);
	auto				iter = x->inputTextureMap->begin();
	while (iter != x->inputTextureMap->end())	{
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



