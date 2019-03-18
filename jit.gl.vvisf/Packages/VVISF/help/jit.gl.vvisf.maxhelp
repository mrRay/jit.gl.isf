{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 0,
			"revision" : 3,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 518.0, 79.0, 1104.0, 962.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_matrix", "" ],
					"patching_rect" : [ 741.0909423828125, 655.86822509765625, 53.0, 22.0 ],
					"text" : "jit.matrix"
				}

			}
, 			{
				"box" : 				{
					"format" : 6,
					"id" : "obj-7",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 216.257598876953125, 572.0, 50.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-4",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 995.0, 203.0, 35.0, 22.0 ],
					"text" : "clear"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-50",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 185.257598876953125, 692.77972412109375, 184.0, 20.0 ],
					"text" : "<-- (this does all the rendering)"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-44",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 485.8443603515625, 258.0, 20.0 ],
					"text" : "second video stream for testing image filters!"
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-42",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 120.0, 225.0, 33.0 ],
					"text" : "5. Play!"
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-41",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 409.0909423828125, 378.296630859375, 319.0, 33.0 ],
					"text" : "4. Load an installed ISF."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-40",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.166656494140625, 229.0, 260.0, 20.0 ],
					"text" : "https://XXXXXX"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-38",
					"linecount" : 4,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.166656494140625, 165.5, 318.0, 60.0 ],
					"text" : "ISF is an open format that emphasizes making it as easy as possible to create and share useful generators and filters.  Here are a couple hundred free filters and a free cross-platform ISF Editor to get you started:"
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-26",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.166656494140625, 120.0, 326.0, 33.0 ],
					"text" : "1.  Get some free ISF files."
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-23",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 404.0909423828125, 120.0, 310.0, 60.0 ],
					"text" : "3. Browse installed ISFs- by function or category."
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-21",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.166656494140625, 302.0, 237.0, 33.0 ],
					"text" : "2.  Start Rendering."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-19",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.272735595703125, 68.0, 260.0, 20.0 ],
					"text" : "Load and render ISF files to jitter GL textures."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 29.166656494140625, 341.0, 54.0, 54.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "bang", "erase", "bang" ],
					"patching_rect" : [ 115.166656494140625, 442.3443603515625, 65.0, 22.0 ],
					"text" : "t b erase b"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-24",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 115.166656494140625, 472.3443603515625, 115.0, 22.0 ],
					"text" : "jit.gl.render preview"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-8",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_matrix", "" ],
					"patching_rect" : [ 29.166656494140625, 500.0, 245.0, 22.0 ],
					"text" : "jit.gl.videoplane preview @transform_reset 2"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"linecount" : 2,
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "bang", "" ],
					"patching_rect" : [ 29.166656494140625, 402.0, 191.0, 35.0 ],
					"text" : "jit.world clientcontext @enable 1 @shared 1 @output_texture 1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-29",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 185.257598876953125, 442.3443603515625, 81.0, 22.0 ],
					"text" : "s renderBang"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-22",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 635.5909423828125, 921.0, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-20",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 635.5909423828125, 864.6556396484375, 58.0, 22.0 ],
					"text" : "loadbang"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-10",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 635.5909423828125, 892.6556396484375, 83.0, 22.0 ],
					"text" : "all_categories"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-101",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 341.0, 136.0, 33.0 ],
					"text" : "basic information about UI items"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-99",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 466.5909423828125, 622.3443603515625, 199.0, 33.0 ],
					"text" : "backend, populates UI item list and gates the 'inputImage' stream"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-97",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 822.21258544921875, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-96",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 481.5909423828125, 811.21258544921875, 81.0, 22.0 ],
					"text" : "s inUIItemList"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-94",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 382.0, 79.0, 22.0 ],
					"text" : "r inUIItemList"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-93",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 522.5909423828125, 757.86822509765625, 81.0, 22.0 ],
					"text" : "s inUIItemList"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-92",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 554.5909423828125, 734.86822509765625, 103.0, 22.0 ],
					"text" : "s inputImageGate"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-90",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 766.21258544921875, 101.0, 22.0 ],
					"text" : "r inputImageGate"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-77",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 466.5909423828125, 889.86822509765625, 103.0, 22.0 ],
					"text" : "s inputImageGate"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-69",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 466.5909423828125, 865.86822509765625, 22.0, 22.0 ],
					"text" : "t 1"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-63",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 466.5909423828125, 841.86822509765625, 99.0, 22.0 ],
					"text" : "route inputImage"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-62",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 794.86822509765625, 52.0, 22.0 ],
					"text" : "gate 1 0"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-14",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 306.296630859375, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 795.0909423828125, 165.5, 150.0, 33.0 ],
					"text" : "Change the size at which ISFs are rendered:"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-87",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 466.5909423828125, 509.8443603515625, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-88",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 466.5909423828125, 485.8443603515625, 49.0, 22.0 ],
					"text" : "read $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-89",
					"items" : [ "3d Rotate", ",", "AAAMotionTestISF", ",", "ASCII Art", ",", "Amatorka", ",", "Apply Alpha", ",", "Auto Color Tone", ",", "Auto Colors Histogram", ",", "Auto Levels", ",", "Bad TV", ",", "Bloom", ",", "Boxinator", ",", "Bright", ",", "Bump Distortion", ",", "CGA ColorSpace", ",", "CMYK Halftone", ",", "CMYK Halftone-Lookaround", ",", "Channel Slide", ",", "Chroma Desaturation Mask", ",", "Chroma Mask", ",", "Chroma Zoom", ",", "Circle Splash Distortion", ",", "Circle Warp", ",", "Circle Wrap Distortion", ",", "Circular Feedback Mask", ",", "Circular Screen", ",", "City Lights", ",", "Collage", ",", "Color Blowout", ",", "Color Controls", ",", "Color Invert", ",", "Color Levels", ",", "Color Monochrome", ",", "Color Posterize", ",", "Color Relookup", ",", "Color Replacement", ",", "Convergence", ",", "Corner Color Tint", ",", "Cubic Warp", ",", "Deinterlace", ",", "Diagonal Blur", ",", "Diagonalize", ",", "Dilate", ",", "Dilate-Fast", ",", "Dirty Lens", ",", "Displace", ",", "Dither-Bayer", ",", "Dot Screen", ",", "Double Vision", ",", "Dual Side Scroller And Flip", ",", "Duotone", ",", "Echo Trace", ",", "Edge Blowout", ",", "Edge Blur", ",", "Edge Distort", ",", "Edge Trace", ",", "Edges", ",", "Emboss", ",", "Erode", ",", "Erode-Fast", ",", "Exposure Adjust", ",", "FakeMotionBlur", ",", "False Color", ",", "Fast Blur", ",", "FastMosh", ",", "Flip H", ",", "Flip V", ",", "Flipbook", ",", "Frosted Glass", ",", "Gamma Correction", ",", "Ghosting", ",", "Glitch Shifter", ",", "Gloom", ",", "Glow", ",", "Glow-Fast", ",", "God Rays", ",", "HSVtoRGB", ",", "Hatch Blur", ",", "HorizVertHold", ",", "Hyperspace", ",", "Interlace", ",", "Interlace Mirror", ",", "Kaleidoscope", ",", "Kaleidoscope Tile", ",", "Key Frame Artifacts", ",", "Layer Mask", ",", "Layer Position", ",", "Lens Flare", ",", "Line Screen", ",", "Luminance Posterize", ",", "Maximum Component", ",", "Median", ",", "Meta Image", ",", "Micro Buffer", ",", "Micro Buffer RGB", ",", "Minimum Component", ",", "Mirror", ",", "Mirror Edge", ",", "MissEtikate", ",", "Monochrome", ",", "Motion Heat Map", ",", "Motion Mask", ",", "Multi Hue Shift", ",", "Multi Pass Gaussian Blur", ",", "Multi-Pixellate", ",", "MultiFrame 2x2", ",", "MultiFrame 3x3", ",", "Neon", ",", "Night Vision", ",", "Noise Adapt", ",", "Noise Displace", ",", "Noise Pixellate", ",", "Optical Flow Distort", ",", "Optical Flow Generator", ",", "Pixel Shifter", ",", "Pixellate", ",", "Poly Glitch", ",", "Posterize", ",", "Power Warp", ",", "Quad Mask", ",", "Quad Tile", ",", "RGB EQ", ",", "RGB Halftone", ",", "RGB Halftone-lookaround", ",", "RGB Invert", ",", "RGB Strobe", ",", "RGB Trails 3.0", ",", "RGBA Swap", ",", "RGBtoHSV", ",", "Radial Replicate", ",", "Random Freeze", ",", "Random Squares Mask", ",", "Replicate", ",", "Replicate Random", ",", "Resize Glitch", ",", "Ripples", ",", "Rotate", ",", "Sepia Tone", ",", "Set Alpha", ",", "Shake", ",", "Shape Mask", ",", "Shape Morph Feedback Mask", ",", "Shape Morph Wrap", ",", "Sharpen Luminance", ",", "Sharpen RGB", ",", "Shockwave", ",", "Shockwave Pulse", ",", "Show Alpha", ",", "Side Scroller And Flip", ",", "Sine Warp Tile", ",", "Sketch", ",", "Sliding Strips", ",", "Slit Scan", ",", "Smoke Screen", ",", "Soft Blur", ",", "Soft Flip", ",", "Solarize", ",", "Sphere Map", ",", "Strobe", ",", "Thermal Camera", ",", "Time Glitch RGB", ",", "Toon", ",", "Trail Mask", ",", "Trapezoid Distortion", ",", "Triangle Warp", ",", "Triangles", ",", "Trio Tone", ",", "Triple Rotate", ",", "Twirl", ",", "Unsharp Mask", ",", "VHS Glitch", ",", "VVMotionBlur 3.0", ",", "Vertex Manipulator", ",", "Vertical Tearing", ",", "Vibrance", ",", "Waveform Displace", ",", "White Point Adjust", ",", "XYZoom", ",", "Zoom", ",", "Zooming Feedback", ",", "[NV15]_Space_Curvature_llj3Rz-asFX", ",", "calvin", ",", "notebook_drawings_XtVGD1", ",", "oil_paint_brush_MtKcDG", ",", "v002 Bleach Bypass", ",", "v002 Crosshatch", ",", "v002 Dilate", ",", "v002 Erode", ",", "v002 Light Leak", ",", "v002 Technicolor", ",", "v002 Vignette", ",", "v002-CRT-Displacement", ",", "v002-CRT-Mask" ],
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 409.0909423828125, 462.8443603515625, 134.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-83",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 91.0, 98.0, 22.0 ],
					"text" : "r msgsFromFiles"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-84",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 139.0, 65.0, 22.0 ],
					"text" : "append $1"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-85",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "clear" ],
					"patching_rect" : [ 479.0909423828125, 139.0, 41.0, 22.0 ],
					"text" : "t clear"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"hidden" : 1,
					"id" : "obj-86",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "" ],
					"patching_rect" : [ 404.0909423828125, 115.0, 166.0, 22.0 ],
					"text" : "route filename filename_clear"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-82",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 409.0909423828125, 438.5, 75.0, 22.0 ],
					"text" : "r inFilesPUB"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-81",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 404.0909423828125, 171.0, 77.0, 22.0 ],
					"text" : "s inFilesPUB"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-78",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 635.5909423828125, 295.52398681640625, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-79",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 635.5909423828125, 271.21270751953125, 129.0, 22.0 ],
					"text" : "category_filenames $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-80",
					"items" : [ "PIXELSPIRIT", ",", "Automatically Converted", ",", "Shadertoy", ",", "Geometry Adjustment", ",", "XXX", ",", "Stylize", ",", "Retro", ",", "MIX", ",", "Transition", ",", "Film", ",", "raymarching", ",", "motionblur", ",", "antialiasing", ",", "screw", ",", "bolt", ",", "nut", ",", "procedural", ",", "3d", ",", "distancefield", ",", "Color Adjustment", ",", "Color Effect", ",", "Glitch", ",", "Generator", ",", "Blur", ",", "Duotone", ",", "Distortion Effect", ",", "Halftone Effect", ",", "Masking", ",", "Toneburst", ",", "Feedback", ",", "Colors", ",", "Color", ",", "Zoom", ",", "Vidvox", ",", "Clock", ",", "Wipe", ",", "Utility", ",", "Special", ",", "Morph", ",", "Distortion", ",", "Tile Effect", ",", "icalvin102", ",", "Sharpen", ",", "Audio Reactive", ",", "ic102_filter", ",", "GLSLSandbox", ",", "v002" ],
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 578.0909423828125, 247.21270751953125, 134.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-73",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 578.0909423828125, 91.0, 98.0, 22.0 ],
					"text" : "r msgsFromFiles"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-74",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 578.0909423828125, 139.0, 65.0, 22.0 ],
					"text" : "append $1"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-75",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "clear" ],
					"patching_rect" : [ 652.0909423828125, 139.0, 41.0, 22.0 ],
					"text" : "t clear"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"hidden" : 1,
					"id" : "obj-76",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "" ],
					"patching_rect" : [ 578.0909423828125, 115.0, 167.0, 22.0 ],
					"text" : "route category category_clear"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-68",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 578.0909423828125, 220.52398681640625, 75.0, 22.0 ],
					"text" : "r inCatsPUB"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-67",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 578.0909423828125, 171.0, 77.0, 22.0 ],
					"text" : "s inCatsPUB"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-66",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 409.0909423828125, 417.0, 218.0, 20.0 ],
					"text" : "Load one of the file types from above:"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-65",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 578.0909423828125, 198.0, 150.0, 20.0 ],
					"text" : "Browse files by category:"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-64",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 404.0909423828125, 198.0, 150.0, 20.0 ],
					"text" : "Browse files by function:"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-54",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 296.0, 115.0, 22.0 ],
					"text" : "transition_filenames"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-53",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 272.0, 89.0, 22.0 ],
					"text" : "filter_filenames"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-52",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 248.0, 103.0, 22.0 ],
					"text" : "source_filenames"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-51",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 604.0909423828125, 332.0, 101.0, 22.0 ],
					"text" : "s msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-49",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 466.5909423828125, 658.86822509765625, 116.0, 22.0 ],
					"text" : "r msgsFromINPUTS"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-48",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 132.590927124023438, 726.71258544921875, 100.0, 22.0 ],
					"text" : "s msgsFromFiles"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-47",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 110.924270629882812, 753.05694580078125, 119.0, 22.0 ],
					"text" : "s msgsFromINPUTS"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-46",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 99.42425537109375, 652.77972412109375, 99.0, 22.0 ],
					"text" : "r msgsToISFInlet"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-37",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 481.5909423828125, 788.21258544921875, 133.0, 22.0 ],
					"text" : "sprintf append %s (%s)"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-32",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 404.0909423828125, 224.0, 79.0, 22.0 ],
					"text" : "all_filenames"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-35",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "clear", "int" ],
					"patching_rect" : [ 522.5909423828125, 711.86822509765625, 51.0, 22.0 ],
					"text" : "t clear 0"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"hidden" : 1,
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "" ],
					"patching_rect" : [ 466.5909423828125, 688.86822509765625, 131.0, 22.0 ],
					"text" : "route inputDetails clear"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-27",
					"items" : [ "inputImage", "(image)", ",", "size", "(float)", ",", "gamma", "(float)", ",", "tint", "(float)", ",", "tintColor", "(color)", ",", "alphaMode", "(bool)" ],
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 795.0909423828125, 411.3443603515625, 134.0, 22.0 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-30",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 280.32061767578125, 75.0, 22.0 ],
					"text" : "prepend dim"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-28",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 828.0909423828125, 739.86822509765625, 177.0, 22.0 ],
					"text" : "setInputValue inputImage $1 $2"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-16",
					"linecount" : 3,
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_matrix", "" ],
					"patching_rect" : [ 892.181884765625, 688.86822509765625, 188.0, 49.0 ],
					"text" : "jit.gl.videoplane clientcontext @blend_enable 1 @color 1 1 1 1 @transform_reset 2 @layer 2"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-18",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 884.5909423828125, 655.86822509765625, 70.0, 22.0 ],
					"text" : "jit.gl.texture"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 33.666666666666664,
					"data" : 					{
						"clips" : [ 							{
								"absolutepath" : "chickens.mp4",
								"filename" : "chickens.mp4",
								"filekind" : "moviefile",
								"loop" : 1,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u139003754" ],
									"dim" : [ 1, 1 ],
									"position" : [ 0.0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"output_texture" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"vol" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"rate" : [ 1.0 ],
									"drawto" : [ "" ],
									"adapt" : [ 1 ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"framereport" : [ 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time" : [ 0 ],
									"interp" : [ 0 ],
									"automatic" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"unique" : [ 0 ],
									"loopreport" : [ 0 ],
									"colormode" : [ "argb" ],
									"engine" : [ "avf" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ]
								}

							}
, 							{
								"absolutepath" : "dust.mp4",
								"filename" : "dust.mp4",
								"filekind" : "moviefile",
								"loop" : 1,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u139003754" ],
									"dim" : [ 1, 1 ],
									"position" : [ 0.0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"output_texture" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"vol" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"rate" : [ 1.0 ],
									"drawto" : [ "" ],
									"adapt" : [ 1 ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"framereport" : [ 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time" : [ 0 ],
									"interp" : [ 0 ],
									"automatic" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"unique" : [ 0 ],
									"loopreport" : [ 0 ],
									"colormode" : [ "argb" ],
									"engine" : [ "avf" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ]
								}

							}
, 							{
								"absolutepath" : "sunflower.mp4",
								"filename" : "sunflower.mp4",
								"filekind" : "moviefile",
								"loop" : 1,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u139003754" ],
									"dim" : [ 1, 1 ],
									"position" : [ 0.0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"output_texture" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"vol" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"rate" : [ 1.0 ],
									"drawto" : [ "" ],
									"adapt" : [ 1 ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"framereport" : [ 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time" : [ 0 ],
									"interp" : [ 0 ],
									"automatic" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"unique" : [ 0 ],
									"loopreport" : [ 0 ],
									"colormode" : [ "argb" ],
									"engine" : [ "avf" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ]
								}

							}
 ]
					}
,
					"id" : "obj-17",
					"maxclass" : "jit.playlist",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "jit_matrix", "", "dictionary" ],
					"output_texture" : 1,
					"patching_rect" : [ 795.0909423828125, 512.8443603515625, 293.0, 104.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-11",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 203.0, 65.0, 22.0 ],
					"text" : "1920 1080"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-1",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 227.0, 52.0, 22.0 ],
					"text" : "640 480"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 795.0909423828125, 252.0885009765625, 52.0, 22.0 ],
					"text" : "320 240"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-33",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "jit_gl_texture", "", "", "" ],
					"patching_rect" : [ 89.257598876953125, 692.77972412109375, 84.0, 22.0 ],
					"text" : "jit.gl.vvisf"
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"id" : "obj-36",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 29.272735595703125, 28.90911865234375, 255.0, 33.0 ],
					"text" : "jit.gl.isf"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-12",
					"linecount" : 2,
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_matrix", "" ],
					"patching_rect" : [ 89.257598876953125, 781.71258544921875, 273.0, 35.0 ],
					"text" : "jit.gl.videoplane clientcontext @blend_enable 1 @color 1 1 1 1 @transform_reset 2 @layer 1"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"hidden" : 1,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-22", 0 ],
					"hidden" : 1,
					"source" : [ "obj-10", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"hidden" : 1,
					"source" : [ "obj-11", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-18", 0 ],
					"order" : 0,
					"source" : [ "obj-17", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"order" : 1,
					"source" : [ "obj-17", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-16", 0 ],
					"hidden" : 1,
					"source" : [ "obj-18", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-2", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-10", 0 ],
					"hidden" : 1,
					"source" : [ "obj-20", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-35", 0 ],
					"hidden" : 1,
					"source" : [ "obj-25", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-37", 0 ],
					"hidden" : 1,
					"order" : 0,
					"source" : [ "obj-25", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-63", 0 ],
					"hidden" : 1,
					"order" : 1,
					"source" : [ "obj-25", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 1 ],
					"hidden" : 1,
					"source" : [ "obj-28", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-14", 0 ],
					"hidden" : 1,
					"source" : [ "obj-30", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"hidden" : 1,
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-12", 0 ],
					"source" : [ "obj-33", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-33", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-33", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-92", 0 ],
					"hidden" : 1,
					"source" : [ "obj-35", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-93", 0 ],
					"hidden" : 1,
					"source" : [ "obj-35", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-96", 0 ],
					"hidden" : 1,
					"source" : [ "obj-37", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 0 ],
					"hidden" : 1,
					"order" : 0,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-80", 0 ],
					"hidden" : 1,
					"order" : 1,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-89", 0 ],
					"hidden" : 1,
					"order" : 2,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-46", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"hidden" : 1,
					"source" : [ "obj-49", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"hidden" : 1,
					"source" : [ "obj-5", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"hidden" : 1,
					"source" : [ "obj-52", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"hidden" : 1,
					"source" : [ "obj-53", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"hidden" : 1,
					"source" : [ "obj-54", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 0 ],
					"source" : [ "obj-6", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"source" : [ "obj-6", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-97", 0 ],
					"hidden" : 1,
					"source" : [ "obj-62", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-69", 0 ],
					"hidden" : 1,
					"source" : [ "obj-63", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-80", 0 ],
					"hidden" : 1,
					"source" : [ "obj-68", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-77", 0 ],
					"hidden" : 1,
					"source" : [ "obj-69", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-7", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-76", 0 ],
					"hidden" : 1,
					"source" : [ "obj-73", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-67", 0 ],
					"hidden" : 1,
					"source" : [ "obj-74", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-67", 0 ],
					"hidden" : 1,
					"source" : [ "obj-75", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-74", 0 ],
					"hidden" : 1,
					"source" : [ "obj-76", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-75", 0 ],
					"hidden" : 1,
					"source" : [ "obj-76", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-78", 0 ],
					"hidden" : 1,
					"source" : [ "obj-79", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-79", 0 ],
					"hidden" : 1,
					"source" : [ "obj-80", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-89", 0 ],
					"hidden" : 1,
					"source" : [ "obj-82", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-86", 0 ],
					"hidden" : 1,
					"source" : [ "obj-83", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-81", 0 ],
					"hidden" : 1,
					"source" : [ "obj-84", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-81", 0 ],
					"hidden" : 1,
					"source" : [ "obj-85", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-84", 0 ],
					"hidden" : 1,
					"source" : [ "obj-86", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-85", 0 ],
					"hidden" : 1,
					"source" : [ "obj-86", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-87", 0 ],
					"hidden" : 1,
					"source" : [ "obj-88", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-88", 0 ],
					"hidden" : 1,
					"source" : [ "obj-89", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"source" : [ "obj-9", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-29", 0 ],
					"source" : [ "obj-9", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 0 ],
					"hidden" : 1,
					"source" : [ "obj-90", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 0 ],
					"hidden" : 1,
					"source" : [ "obj-94", 0 ]
				}

			}
 ],
		"dependency_cache" : [ 			{
				"name" : "chickens.mp4",
				"bootpath" : "C74:/media/jitter",
				"type" : "mpg4",
				"implicit" : 1
			}
, 			{
				"name" : "dust.mp4",
				"bootpath" : "C74:/media/jitter",
				"type" : "mpg4",
				"implicit" : 1
			}
, 			{
				"name" : "sunflower.mp4",
				"bootpath" : "C74:/media/jitter",
				"type" : "mpg4",
				"implicit" : 1
			}
, 			{
				"name" : "jit.gl.vvisf.mxo",
				"type" : "iLaX"
			}
 ],
		"autosave" : 0,
		"bgcolor" : [ 0.996078431372549, 0.996078431372549, 0.996078431372549, 1.0 ]
	}

}
