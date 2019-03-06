/*
	jit.gl.syphonclient.m
	jit.gl.syphonclient
	
	Copyright 2010 bangnoise (Tom Butterworth) & vade (Anton Marini).
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.

	* Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "jit.common.h"
#include "jit.gl.h"
#include "jit.gl.ob3d.h"
#include "ext_obex.h"

#import <Cocoa/Cocoa.h>
//#import <Syphon/Syphon.h>
//#import "SyphonNameboundClient.h"

t_jit_err jit_ob3d_dest_name_set(t_jit_object *x, void *attr, long argc, t_atom *argv);

typedef struct _jit_gl_vvisf 
{
	// Max object
	t_object			ob;			
	// 3d object extension.	 This is what all objects in the GL group have in common.
	void				*ob3d;
		
	// attributes
	t_symbol			*texturename;	
	t_symbol			*servername;
	t_symbol			*appname;
		
	// Need our syphon instance here.
	//SyphonNameboundClient* syClient;

	NSRect latestBounds;
	t_atom_long dim[2];			// output dim
	BOOL needsRedraw;

	// internal jit.gl.texture object
	t_jit_object *output;
	
} t_jit_gl_vvisf;

void *_jit_gl_vvisf_class;

//
// Function Declarations
//

// init/constructor/free
t_jit_err jit_gl_vvisf_init(void);
t_jit_gl_vvisf *jit_gl_vvisf_new(t_symbol * dest_name);
void jit_gl_vvisf_free(t_jit_gl_vvisf *jit_gl_vvisf_instance);

// handle context changes - need to rebuild IOSurface + textures here.
t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *jit_gl_vvisf_instance);
t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *jit_gl_vvisf_instance);

// draw;
t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *jit_gl_vvisf_instance);
t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *x, t_symbol *s, int argc, t_atom *argv);

//attributes
// serveruuid, for server human readable name
t_jit_err jit_gl_vvisf_servername(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv);
t_jit_err jit_gl_vvisf_appname(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv);

// @texturename to read a named texture.
t_jit_err jit_gl_vvisf_texturename(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv);

// @out_name for output...
t_jit_err jit_gl_vvisf_getattr_out_name(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long *ac, t_atom **av);

// dim
t_jit_err jit_gl_vvisf_setattr_dim(t_jit_gl_vvisf *x, void *attr, long argc, t_atom *argv);

// symbols
t_symbol *ps_servername;
t_symbol *ps_appname;
t_symbol *ps_texture;
t_symbol *ps_width;
t_symbol *ps_height;
t_symbol *ps_glid;
t_symbol *ps_flip;
t_symbol *ps_automatic;
t_symbol *ps_drawto;
t_symbol *ps_draw;

// for our internal texture
extern t_symbol *ps_jit_gl_texture;

//
// Function implementations
//

#pragma mark -
#pragma mark Init, New, Cleanup, Context changes

t_jit_err jit_gl_vvisf_init(void) 
{
	// setup our OB3D flags to indicate our capabilities.
	long ob3d_flags = JIT_OB3D_NO_MATRIXOUTPUT; // no matrix output
	ob3d_flags |= JIT_OB3D_NO_ROTATION_SCALE;
	ob3d_flags |= JIT_OB3D_NO_POLY_VARS;
	ob3d_flags |= JIT_OB3D_NO_FOG;
	ob3d_flags |= JIT_OB3D_NO_MATRIXOUTPUT;
	ob3d_flags |= JIT_OB3D_NO_LIGHTING_MATERIAL;
	ob3d_flags |= JIT_OB3D_NO_DEPTH;
	ob3d_flags |= JIT_OB3D_NO_COLOR;
	
	_jit_gl_vvisf_class = jit_class_new("jit_gl_vvisf", 
										 (method)jit_gl_vvisf_new, (method)jit_gl_vvisf_free,
										 sizeof(t_jit_gl_vvisf),A_DEFSYM,0L);
	
	// set up object extension for 3d object, customized with flags
	
	void *ob3d;
	ob3d = jit_ob3d_setup(_jit_gl_vvisf_class, 
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
	jit_class_addmethod(_jit_gl_vvisf_class, 
						(method)jit_gl_vvisf_dest_closing, "dest_closing", A_CANT, 0L);
	jit_class_addmethod(_jit_gl_vvisf_class, 
						(method)jit_gl_vvisf_dest_changed, "dest_changed", A_CANT, 0L);
	jit_class_addmethod(_jit_gl_vvisf_class, 
						(method)jit_gl_vvisf_draw, "ob3d_draw", A_CANT, 0L);
	
	// must register for ob3d use
	jit_class_addmethod(_jit_gl_vvisf_class, 
						(method)jit_object_register, "register", A_CANT, 0L);
	
	// add attributes
	long attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_USURP_LOW;

	t_jit_object *attr;
	
	attr = jit_object_new(_jit_sym_jit_attr_offset_array,"dim",_jit_sym_long,2,attrflags,
						  (method)0L,(method)jit_gl_vvisf_setattr_dim,0/*fix*/,calcoffset(t_jit_gl_vvisf,dim));
	jit_class_addattr(_jit_gl_vvisf_class,attr);	

	attr = jit_object_new(_jit_sym_jit_attr_offset,"servername",_jit_sym_symbol,attrflags,
						  (method)0L, jit_gl_vvisf_servername, calcoffset(t_jit_gl_vvisf, servername)); 
	jit_class_addattr(_jit_gl_vvisf_class,attr);	

	attr = jit_object_new(_jit_sym_jit_attr_offset,"appname",_jit_sym_symbol,attrflags,
						  (method)0L, jit_gl_vvisf_appname, calcoffset(t_jit_gl_vvisf, appname));	
	jit_class_addattr(_jit_gl_vvisf_class,attr);	
	
	attr = jit_object_new(_jit_sym_jit_attr_offset,"texturename",_jit_sym_symbol,attrflags,
						  (method)0L,(method)jit_gl_vvisf_texturename,calcoffset(t_jit_gl_vvisf, texturename));		
	jit_class_addattr(_jit_gl_vvisf_class,attr);	
	
	attrflags = JIT_ATTR_GET_DEFER_LOW | JIT_ATTR_SET_OPAQUE_USER;
	attr = jit_object_new(_jit_sym_jit_attr_offset,"out_name",_jit_sym_symbol, attrflags,
						  (method)jit_gl_vvisf_getattr_out_name,(method)0L,0);	
	jit_class_addattr(_jit_gl_vvisf_class,attr);

	//symbols
	ps_servername = gensym("servername");
	ps_appname = gensym("appname");
	ps_texture = gensym("texture");
	ps_width = gensym("width");
	ps_height = gensym("height");
	ps_glid = gensym("glid");
	ps_flip = gensym("flip");
	ps_automatic = gensym("automatic");
	ps_drawto = gensym("drawto");
	ps_draw = gensym("draw");
	
	jit_class_register(_jit_gl_vvisf_class);

	return JIT_ERR_NONE;
}

t_jit_gl_vvisf *jit_gl_vvisf_new(t_symbol * dest_name)
{
	post("%s",__func__);
	t_jit_gl_vvisf *jit_gl_vvisf_instance;
	
	// make jit object
	if ((jit_gl_vvisf_instance = (t_jit_gl_vvisf *)jit_object_alloc(_jit_gl_vvisf_class)))
	{
		// TODO : is this right ? 
		// set up attributes
		jit_attr_setsym(jit_gl_vvisf_instance->servername, _jit_sym_name, gensym("servername"));
		jit_attr_setsym(jit_gl_vvisf_instance->appname, _jit_sym_name, gensym("appname"));
		
		jit_gl_vvisf_instance->needsRedraw = YES;
		
		// instantiate a single internal jit.gl.texture should we need it.
		jit_gl_vvisf_instance->output = jit_object_new(ps_jit_gl_texture,dest_name);

		jit_gl_vvisf_instance->latestBounds = NSMakeRect(0, 0, 640, 480);
		
		if (jit_gl_vvisf_instance->output)
		{
			jit_gl_vvisf_instance->texturename = jit_symbol_unique();		

			// set texture attributes.
			jit_attr_setsym(jit_gl_vvisf_instance->output,_jit_sym_name, jit_gl_vvisf_instance->texturename);
			jit_attr_setsym(jit_gl_vvisf_instance->output,gensym("defaultimage"),gensym("black"));
			jit_attr_setlong(jit_gl_vvisf_instance->output,gensym("rectangle"), 1);
			jit_attr_setlong(jit_gl_vvisf_instance->output, gensym("flip"), 0);
			
			jit_gl_vvisf_instance->dim[0] = 640;
			jit_gl_vvisf_instance->dim[1] = 480;
			jit_attr_setlong_array(jit_gl_vvisf_instance->output, _jit_sym_dim, 2, jit_gl_vvisf_instance->dim);
		} 
		else
		{
			post("error creating internal texture object");
			jit_object_error((t_object *)jit_gl_vvisf_instance,"jit.gl.syphonserver: could not create texture");
			jit_gl_vvisf_instance->texturename = _jit_sym_nothing;		
		}
		
		// create and attach ob3d
		jit_ob3d_new(jit_gl_vvisf_instance, dest_name);
		post("about to make new ctx");
		if (CGLGetCurrentContext() == NULL) {
			post("ERR: current context NULL in %s",__func__);
			//jit_gl_vvisf_instance->syClient = NULL;
		}
		else	{
			post("should be good to go!");
			//jit_gl_vvisf_instance->syClient = [[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
		}
		
		//jit_gl_vvisf_instance->syClient = [[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
	} 
	else 
	{
		jit_gl_vvisf_instance = NULL;
	}

	return jit_gl_vvisf_instance;
}

void jit_gl_vvisf_free(t_jit_gl_vvisf *jit_gl_vvisf_instance)
{
	post("%s",__func__);
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//if (jit_gl_vvisf_instance->syClient != NULL)	{
	//	[jit_gl_vvisf_instance->syClient release];
	//	jit_gl_vvisf_instance->syClient = nil;
	//}
	
	[pool drain];

	// free our ob3d data 
	if(jit_gl_vvisf_instance)
		jit_ob3d_free(jit_gl_vvisf_instance);
	
	// free our internal texture
	if(jit_gl_vvisf_instance->output)
		jit_object_free(jit_gl_vvisf_instance->output);
}

t_jit_err jit_gl_vvisf_dest_closing(t_jit_gl_vvisf *jit_gl_vvisf_instance)
{
	post("%s",__func__);
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_dest_changed(t_jit_gl_vvisf *jit_gl_vvisf_instance)
{
	post("%s ... %p",__func__,CGLGetCurrentContext());
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//if (jit_gl_vvisf_instance->syClient != NULL)	{
	//	[jit_gl_vvisf_instance->syClient release];
	//	jit_gl_vvisf_instance->syClient = NULL;
	//}
	CGLContextObj		cc = CGLGetCurrentContext();
	//if (cc != NULL)
	//	jit_gl_vvisf_instance->syClient = [[SyphonNameboundClient alloc] initWithContext:cc];
	
	if (jit_gl_vvisf_instance->output)
	{
		t_symbol *context = jit_attr_getsym(jit_gl_vvisf_instance,ps_drawto);
		jit_attr_setsym(jit_gl_vvisf_instance->output,ps_drawto,context);
		
		// our texture has to be bound in the new context before we can use it
		// http://cycling74.com/forums/topic.php?id=29197
		t_jit_gl_drawinfo drawInfo;
		t_symbol *texName = jit_attr_getsym(jit_gl_vvisf_instance->output, gensym("name"));
		jit_gl_drawinfo_setup(jit_gl_vvisf_instance, &drawInfo);
		jit_gl_bindtexture(&drawInfo, texName, 0);
		jit_gl_unbindtexture(&drawInfo, texName, 0);
	}
	else
		post("ERR: output texture null in %s",__func__);
	
	jit_gl_vvisf_instance->needsRedraw = YES;
	
	[pool release];
	pool = nil;
	
	return JIT_ERR_NONE;
}

#pragma mark -
#pragma mark Draw

t_jit_err jit_gl_vvisf_drawto(t_jit_gl_vvisf *jit_gl_vvisf_instance, t_symbol *s, int argc, t_atom *argv)
{
	object_attr_setvalueof(jit_gl_vvisf_instance->output,s,argc,argv);	
	jit_ob3d_dest_name_set((t_jit_object *)jit_gl_vvisf_instance, NULL, argc, argv);
	
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_draw(t_jit_gl_vvisf *jit_gl_vvisf_instance)
{
	if (!jit_gl_vvisf_instance)
		return JIT_ERR_INVALID_PTR;
	//if (!jit_gl_vvisf_instance->syClient)
	//	return JIT_ERR_GENERIC;
	/*
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// if we have a client and a frame, render to our internal texture.
	[jit_gl_vvisf_instance->syClient lockClient];
	
	SyphonClient *client = [jit_gl_vvisf_instance->syClient client];
	if((client != nil) && ([client hasNewFrame] || jit_gl_vvisf_instance->needsRedraw))
	{
		// our syphon clients texture is only valid for the duration of the bind/unbind.
		// this means we need to render into our internal texture, via an FBO.
		// for now, we are going to do this all inline, in place.
		
		SyphonImage *frame = [client newFrameImage];
		
		// clearly we need our texture for this...
		if(jit_gl_vvisf_instance->output && frame)
		{
			jit_gl_vvisf_instance->needsRedraw = NO;

			// cache/restore context in case in capture mode
			// TODO: necessary ? JKC says no unless context changed above? should be set during draw for you. 
			t_jit_gl_context ctx = jit_gl_get_context();
			jit_ob3d_set_context(jit_gl_vvisf_instance);
			
			// add texture to OB3D list.
			jit_attr_setsym(jit_gl_vvisf_instance,ps_texture, jit_attr_getsym(jit_gl_vvisf_instance->output, gensym("name")));
			
			// Bind the Syphon Texture early, so we can base the viewport on the framesize and update our internal texture
			// ahead of rendering.
			
			jit_gl_vvisf_instance->latestBounds.size = [frame textureSize];
			
			// we need to update our internal texture to the latest known size of our syphonservers image.
			t_atom_long newdim[2];			// output dim

			newdim[0] = jit_gl_vvisf_instance->latestBounds.size.width;
			newdim[1] = jit_gl_vvisf_instance->latestBounds.size.height;

			// update our internal attribute so attr messages work
			jit_attr_setlong_array(jit_gl_vvisf_instance, _jit_sym_dim, 2, newdim);

			// save some state
			GLint previousFBO;	// make sure we pop out to the right FBO
			GLint previousReadFBO;
			GLint previousDrawFBO;
			GLint previousMatrixMode;
			
			glGetIntegerv(GL_FRAMEBUFFER_BINDING_EXT, &previousFBO);
			glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING_EXT, &previousReadFBO);
			glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING_EXT, &previousDrawFBO);
			glGetIntegerv(GL_MATRIX_MODE, &previousMatrixMode);
			
			// save texture state, client state, etc.
			glPushAttrib(GL_ALL_ATTRIB_BITS);
			glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS);

			// We are going to bind our FBO to our internal jit.gl.texture as COLOR_0 attachment
			// We need the ID, width/height.
			
			GLuint texname = jit_attr_getlong(jit_gl_vvisf_instance->output,ps_glid);
			GLuint width = jit_attr_getlong(jit_gl_vvisf_instance->output,ps_width);
			GLuint height = jit_attr_getlong(jit_gl_vvisf_instance->output,ps_height);

			//post("texture id is %u width %u height %u", texname, width, height);
			
			// FBO generation/attachment to texture
			GLuint tempFBO;
			glGenFramebuffers(1, &tempFBO);
			glBindFramebuffer(GL_FRAMEBUFFER, tempFBO);
			
			// TODO: check texture target and sset appropriately, dont assume rect
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_RECTANGLE_ARB, texname, 0);
			
			// it work?
			GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
			if(status == GL_FRAMEBUFFER_COMPLETE)
			{
				//post("jit.gl.syphonclient	 FBO complete");

				// Using replace blend mode, no need to clear?
				//glClearColor(0.0, 0.0, 0.0, 0.0);
				//glClear(GL_COLOR_BUFFER_BIT);				
				
				glMatrixMode(GL_TEXTURE);
				glPushMatrix();
				glLoadIdentity();
				
				glViewport(0, 0,  width, height);
				glMatrixMode(GL_PROJECTION);
				glPushMatrix();
				glLoadIdentity();
				
				glOrtho(0.0, width,	 0.0,  height, -1, 1);		
				
				glMatrixMode(GL_MODELVIEW);
				glPushMatrix();
				glLoadIdentity();
				
				// render our syphon texture to our jit.gl.texture's texture.
				glColor4f(1.0, 1.0, 1.0, 1.0);
								
				// Moved above.
				//if ([client bindFrameTexture:cgl_ctx] != 0);
				{
					// Moved above
					
					// our frame size is only valid when we have a bound texture. 
					// We hope our frame size does not change every frame, since we are effectively a frame behind.
					//jit_gl_vvisf_instance->latestBounds.size = [client frameSize];
					
					// do not need blending if we use black border for alpha and replace env mode, saves a buffer wipe
					// we can do this since our image draws over the complete surface of the FBO, no pixel goes untouched.
					glActiveTexture(GL_TEXTURE0);
					glClientActiveTexture(GL_TEXTURE0);
					glEnable(GL_TEXTURE_RECTANGLE_EXT);
					glBindTexture(GL_TEXTURE_RECTANGLE_EXT, [frame textureName]);
					
					glDisable(GL_BLEND);
					glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE); 
					
					// move to VA for rendering
					GLfloat tex_coords[] = 
					{
						width,height,
						0.0,height,
						0.0,0.0,
						width,0.0
					};
					
					GLfloat verts[] = 
					{
						width,height,
						0.0,height,
						0.0,0.0,
						width,0.0
					};
					
					glEnableClientState( GL_TEXTURE_COORD_ARRAY );
					glTexCoordPointer(2, GL_FLOAT, 0, tex_coords );
					glEnableClientState(GL_VERTEX_ARRAY);		
					glVertexPointer(2, GL_FLOAT, 0, verts );
					glDrawArrays( GL_TRIANGLE_FAN, 0, 4 );
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_TEXTURE_COORD_ARRAY);
				}
				
				glMatrixMode(GL_MODELVIEW);
				glPopMatrix();
				glMatrixMode(GL_PROJECTION);
				glPopMatrix();

				glMatrixMode(GL_TEXTURE);
				glPopMatrix();

				glMatrixMode(previousMatrixMode);
				
				// Is this needed? 
				//glFlushRenderAPPLE(); 
			}
			else 
			{
				post("jit.gl.syphonclient could not attach to FBO");
			}
			
			// clean up after ourselves
			glDeleteFramebuffers(1, &tempFBO);
			tempFBO = 0;
			
			glPopAttrib();
			glPopClientAttrib();			
			
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, previousFBO);	
			glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, previousReadFBO);
			glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, previousDrawFBO);			
			
			jit_gl_set_context(ctx);
		}
		
		[frame release];
	}
	[jit_gl_vvisf_instance->syClient unlockClient];
	[pool drain];
	*/
	return JIT_ERR_NONE;
}
		
#pragma mark -
#pragma mark Attributes

// attributes
// @serveruuid
t_jit_err jit_gl_vvisf_servername(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv)
{
	post("%s",__func__);
	t_symbol *srvname;

	if(jit_gl_vvisf_instance)
	{	
		if (argc && argv)
		{
			srvname = jit_atom_getsym(argv);
			post("\tsrvname is %s",srvname);

			jit_gl_vvisf_instance->servername = srvname;
		} 
		else
		{
			// no args, set to zero
			jit_gl_vvisf_instance->servername = _jit_sym_nothing;
		}
		// if we have a server release it, 
		// make a new one, with our new UUID.
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		//[jit_gl_vvisf_instance->syClient setName:[NSString stringWithCString:jit_gl_vvisf_instance->servername->s_name
		//																	encoding:NSASCIIStringEncoding]];
		jit_gl_vvisf_instance->needsRedraw = YES;
		
		[pool drain];
	}
	return JIT_ERR_NONE;
}

t_jit_err jit_gl_vvisf_appname(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv)
{
	post("%s",__func__);
	t_symbol *appname;
	
	if(jit_gl_vvisf_instance)
	{	
		if (argc && argv)
		{
			appname = jit_atom_getsym(argv);
			post("\tappname is %s",appname);
			
			jit_gl_vvisf_instance->appname = appname;
		} 
		else
		{
			// no args, set to zero
			jit_gl_vvisf_instance->appname = _jit_sym_nothing;
		}
		// if we have a server release it, 
		// make a new one, with our new UUID.
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		//[jit_gl_vvisf_instance->syClient setAppName:[NSString stringWithCString:jit_gl_vvisf_instance->appname->s_name
		//																		encoding:NSASCIIStringEncoding]];
		jit_gl_vvisf_instance->needsRedraw = YES;
		
		[pool drain];
	}
	return JIT_ERR_NONE;
}

// #texturename
t_jit_err jit_gl_vvisf_texturename(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv)
{
	t_symbol *s=jit_atom_getsym(argv);
	
	jit_gl_vvisf_instance->texturename = s;
	if (jit_gl_vvisf_instance->output)
		jit_attr_setsym(jit_gl_vvisf_instance->output,_jit_sym_name,s);
	jit_attr_setsym(jit_gl_vvisf_instance,ps_texture,s);
	
	return JIT_ERR_NONE;
}
											  
t_jit_err jit_gl_vvisf_getattr_out_name(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long *ac, t_atom **av)
{
	if ((*ac)&&(*av)) {
		//memory passed in, use it
	} else {
		//otherwise allocate memory
		*ac = 1;
		if (!(*av = jit_getbytes(sizeof(t_atom)*(*ac)))) {
			*ac = 0;
			return JIT_ERR_OUT_OF_MEM;
		}
	}
	
	jit_atom_setsym(*av,jit_attr_getsym(jit_gl_vvisf_instance->output,_jit_sym_name));
	// jit_object_post((t_object *)x,"jit.gl.imageunit: sending output: %s", JIT_SYM_SAFECSTR(jit_attr_getsym(x->output,_jit_sym_name)));
	
	return JIT_ERR_NONE;
}											  
											  
t_jit_err jit_gl_vvisf_setattr_dim(t_jit_gl_vvisf *jit_gl_vvisf_instance, void *attr, long argc, t_atom *argv)
{
	long i;
	long v;
	
	if (jit_gl_vvisf_instance)
	{
		jit_gl_vvisf_instance->needsRedraw = YES;
		
		for(i = 0; i < JIT_MATH_MIN(argc, 2); i++)
		{
			v = jit_atom_getlong(argv+i);
			if (jit_gl_vvisf_instance->dim[i] != JIT_MATH_MIN(v,1))
			{
				jit_gl_vvisf_instance->dim[i] = v;
			}
		}
		
		// update our internal texture as well.
		jit_attr_setlong_array(jit_gl_vvisf_instance->output, _jit_sym_dim, 2, jit_gl_vvisf_instance->dim);
		
		return JIT_ERR_NONE;
	}
	return JIT_ERR_INVALID_PTR;
}
