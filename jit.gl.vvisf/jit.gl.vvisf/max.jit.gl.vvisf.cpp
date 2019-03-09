#include "max.jit.gl.vvisf.h"

#include "jit.gl.vvisf.h"
#include "ISFRenderer.hpp"




t_class				*max_jit_gl_vvisf_class;

t_symbol			*ps_jit_gl_texture;
t_symbol			*ps_draw;
t_symbol			*ps_out_tex_sym;
t_symbol			*ps_file;
t_symbol			*ps_clear;




int C74_EXPORT main(void)
{
	ps_jit_gl_texture = gensym("jit_gl_texture");
	ps_draw = gensym("draw");
	ps_out_tex_sym = gensym("out_tex_sym");
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
	
	//	we need notify messages to get information about jitter textures we've received
	addmess((method)max_jit_gl_vvisf_notify, (char*)"notify", A_CANT, 0);
	
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
	
	addmess( (method)max_jit_gl_vvisf_anything, (char*)"anything", A_GIMME, 0L );
	
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
void max_jit_gl_vvisf_file(t_max_jit_gl_vvisf *x, t_symbol *s)	{
	post("%s ... %s",__func__,s);
	//t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	//jit_attr_setsym(jitob, ps_file, s);
}
*/
void max_jit_gl_vvisf_anything(t_max_jit_gl_vvisf *targetInstance, t_symbol *s, int argc, t_atom *argv)	{
	post("%s",__func__);
	
	using namespace std;
	
	if (argv == NULL)
		return;
	
	//post("%s, inlet is %d",__func__,proxy_getinlet(&targetInstance->ob));
	int				rxInlet = proxy_getinlet(&targetInstance->ob);
	post("\trxInlet is %d",rxInlet);
	//	bail if this method is called on anything but the second inlet
	if (rxInlet != 1)	{
		return;
	}
	
	//	get the jitter object
	t_jit_gl_vvisf		*jitObj = (t_jit_gl_vvisf *)max_jit_obex_jitob_get(targetInstance);
	//	get the renderer from the jitter object
	ISFRenderer			*renderer = jit_gl_vvisf_get_renderer(jitObj);
	//	get the ISFDoc that is currently being used
	ISFDocRef			doc = (renderer==nullptr) ? nullptr : renderer->loadedISFDoc();
	if (doc == nullptr)	{
		return;
	}
	//	's' would ordinarily be the message/method name, but in this case it's the name of the input
	string				inputName = string(s->s_name);
	//	get the ISFAttr from the ISFDoc that corresponds to the input name the user supplied
	ISFAttrRef			attr = doc->input(inputName);
	if (attr == nullptr)	{
		post("err: unrecognized input \"%s\"",inputName.c_str());
		return;
	}
	//	based on the type of the attribute, assemble a value from the input values, showing a warning if we can't
	
	
	/*
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
	*/
}
void max_jit_gl_vvisf_notify(t_max_jit_gl_vvisf *x, t_symbol *s, t_symbol *msg, void *ob, void *data)	{
	post("%s",__func__);
	/*
	if (s == <matrix name>)	{
		if (msg == _jit_sym_modified)	{
			post("\tmodified a matrix we're watching!");
		}
		else if (msg == _jit_sym_free)	{
			post("\tfreeing a matrix we're watching!");
		}
	}
	*/
}

void max_jit_gl_vvisf_bang(t_max_jit_gl_vvisf *x)	{
	//post("%s",__func__);
	
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	jit_attr_setlong(jitob, gensym("needsRedraw"), 1);
	
	max_jit_gl_vvisf_draw(x, ps_draw, 0, NULL);
	
}

void max_jit_gl_vvisf_draw(t_max_jit_gl_vvisf *x, t_symbol *s, long argc, t_atom *argv)	{
	//post("%s",__func__);
	t_atom				a;
	// get the jitter object
	t_jit_object		*jitob = (t_jit_object*)max_jit_obex_jitob_get(x);
	
	// call the jitter object's draw method
	jit_object_method(jitob, s, s, argc, argv);
	
	// query the texture name and send out the texture output 
	jit_atom_setsym(&a, jit_attr_getsym(jitob, ps_out_tex_sym));
	outlet_anything(x->texout, ps_jit_gl_texture, 1, &a);
}



