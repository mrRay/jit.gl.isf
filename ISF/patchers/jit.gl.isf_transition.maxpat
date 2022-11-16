{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 1,
			"revision" : 1,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 34.0, 79.0, 836.0, 677.0 ],
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
					"hidden" : 1,
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 964.0, 23.295440673828125, 54.0, 22.0 ],
					"text" : "onecopy"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-69",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 540.181884765625, 17.795440673828125, 169.0, 33.0 ],
					"text" : "The progress param changes the amount of the transition "
				}

			}
, 			{
				"box" : 				{
					"fontface" : 2,
					"id" : "obj-67",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 570.0, 576.0, 164.0, 33.0 ],
					"text" : "Note that startImage and endImage use a capital \"I\" "
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-58",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 606.905353546142578, 371.748244577148171, 58.0, 20.0 ],
					"text" : "Source B"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-53",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 449.181884765625, 371.748244577148171, 57.0, 20.0 ],
					"text" : "Source A"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-46",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 449.181884765625, 567.533736079101118, 82.0, 22.0 ],
					"text" : "s ToISF_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-1",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 9.166656494140625, 280.861877882812678, 368.0, 47.0 ],
					"text" : "Transitions take two separate input sources and output a mix of the two sources uses the progress parameter. A progress value of 0. will be all source A and a value of 1. will fully transition to source B."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-21",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 9.166656494140625, 236.861877882812678, 363.0, 33.0 ],
					"text" : "Get a list of all currently installed transition type ISF files, then populate a umenu with the file names for easy navigation."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-42",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 618.462120056152344, 501.660996807617721, 150.0, 33.0 ],
					"text" : "The param endImage is used to define source B"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-41",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 461.181884765625, 501.660996807617721, 150.0, 33.0 ],
					"text" : "The param startImage is used to define source A"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-23",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 237.041656494140625, 507.160996807617721, 82.0, 22.0 ],
					"text" : "s ToISF_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-26",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 237.041656494140625, 477.172501713867632, 49.0, 22.0 ],
					"text" : "read $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-28",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 187.166656494140625, 420.270874244140714, 54.0, 22.0 ],
					"text" : "sel done"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-30",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 242.166656494140625, 420.270874244140714, 70.0, 22.0 ],
					"text" : "append $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-31",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "" ],
					"patching_rect" : [ 187.166656494140625, 391.712128126953303, 129.0, 22.0 ],
					"text" : "route filenames name"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-57",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 21.166656494140625, 420.361877882812678, 62.0, 22.0 ],
					"text" : "loadbang"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-33",
					"items" : [ "Angular", ",", "Bounce", ",", "Bow Tie Horizontal", ",", "Bow Tie Vertical", ",", "Burn", ",", "Butterfly Wave Scrawler", ",", "Cannabis Leaf", ",", "Circle", ",", "Circle Crop", ",", "Circle Open", ",", "Color Phase", ",", "Colour Distance", ",", "Crazy Parametric Fun", ",", "CrossZoom", ",", "Crosshatch", ",", "Crosswarp", ",", "Directional", ",", "Directional Warp", ",", "Directional Wipe", ",", "Displacement", ",", "Doom Screen Transition", ",", "Doorway", ",", "Dreamy", ",", "Dreamy Zoom", ",", "Fade", ",", "Fade Color", ",", "Fade Gray Scale", ",", "Film Burn", ",", "Fly Eye", ",", "Glitch Displace", ",", "Glitch Memories", ",", "Grid Flip", ",", "Heart Transition", ",", "Hexagonalize", ",", "Inverted Page Curl", ",", "Kaleidoscope Transition", ",", "Linear Blur", ",", "Luma Transition", ",", "Luminance Melt", ",", "Morph", ",", "Mosaic", ",", "Multiply Blend", ",", "Perlin Transition", ",", "Pinwheel", ",", "Pixelize", ",", "Polar Function", ",", "Polka Dots Curtain", ",", "Radial", ",", "Random Squares", ",", "Ripple Transition", ",", "Rotate Scale Fade", ",", "Simple Zoom Transition", ",", "Squares Wire", ",", "Squeeze", ",", "Stereo Viewer", ",", "Swap Transition", ",", "Swirl", ",", "TV Static", ",", "Undulating Burn Out", ",", "Water Drop", ",", "Wind", ",", "Window Blinds", ",", "Window Slice", ",", "Wipe Down", ",", "Wipe Left", ",", "Wipe Right", ",", "Wipe Up", ",", "Zoom In Circles", ",", "cube" ],
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 187.166656494140625, 448.613755596680221, 118.749999999999972, 22.0 ],
					"style" : "redness"
				}

			}
, 			{
				"box" : 				{
					"frozen_object_attributes" : 					{
						"rect" : [ 905, 45, 1545, 525 ]
					}
,
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "bang", "" ],
					"patching_rect" : [ 21.166656494140625, 612.058868408203125, 168.0, 22.0 ],
					"text" : "jit.world isftransctx @enable 1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 62.166656494140625, 587.539749145507812, 91.0, 22.0 ],
					"text" : "s params_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 9.166656494140625, 477.172501713867632, 80.0, 22.0 ],
					"text" : "r ToISF_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-17",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "jit_gl_texture", "", "", "" ],
					"patching_rect" : [ 21.166656494140625, 515.43212890625, 142.0, 22.0 ],
					"text" : "jit.gl.isf @file Mosaic"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 21.166656494140625, 448.613755596680221, 115.0, 22.0 ],
					"text" : "transition_filenames"
				}

			}
, 			{
				"box" : 				{
					"bgcolor" : [ 0.0, 0.0, 0.0, 0.0 ],
					"fontsize" : 16.0,
					"id" : "obj-56",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 449.181884765625, 348.730727045897993, 367.0, 24.0 ],
					"text" : "Use these built-in videos to preview the transition",
					"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-55",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 964.0, 50.0, 58.0, 22.0 ],
					"text" : "loadbang"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-54",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1192.5, 150.90911865234375, 29.5, 22.0 ],
					"text" : "2"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-47",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 606.905353546142578, 540.062636225585493, 147.0, 22.0 ],
					"text" : "prepend param endImage"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 28.464630126953125,
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
								}

							}
 ]
					}
,
					"id" : "obj-52",
					"maxclass" : "jit.playlist",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "jit_matrix", "", "dictionary" ],
					"output_texture" : 1,
					"patching_rect" : [ 606.905353546142578, 390.668745844726118, 144.185588836669922, 88.393890380859375 ]
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-38",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 1161.0, 124.90911865234375, 67.0, 22.0 ],
					"text" : "delay 1000"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-39",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1161.0, 150.90911865234375, 29.5, 22.0 ],
					"text" : "1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-27",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 449.181884765625, 540.062636225585493, 150.0, 22.0 ],
					"text" : "prepend param startImage"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 28.464630126953125,
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
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
									"rate" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"looppoints_ms" : [ 0, 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"time_ms" : [ 0 ],
									"autostart" : [ 1 ],
									"usedstrect" : [ 0 ],
									"drawto" : [ "" ],
									"time" : [ 0 ],
									"output_texture" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"texture_name" : [ "u737003752" ],
									"engine" : [ "avf" ],
									"interp" : [ 0 ],
									"colormode" : [ "argb" ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"position" : [ 0.0 ],
									"time_secs" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"adapt" : [ 1 ],
									"vol" : [ 1.0 ],
									"automatic" : [ 0 ],
									"loopstart" : [ 0 ],
									"moviefile" : [ "" ],
									"cache_size" : [ 0.100000001490116 ],
									"fps" : [ 0.0 ],
									"timescale" : [ 600 ],
									"framecount" : [ 0 ],
									"duration" : [ 0 ]
								}

							}
 ]
					}
,
					"id" : "obj-35",
					"maxclass" : "jit.playlist",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "jit_matrix", "", "dictionary" ],
					"output_texture" : 1,
					"patching_rect" : [ 449.181884765625, 390.668745844726118, 144.185588836669922, 88.393890380859375 ]
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 9.0,
					"id" : "obj-22",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 523.462120056152344, 657.8443603515625, 309.628822326660156, 17.0 ],
					"text" : "ISF is open source under the MIT License, copyright VIDVOX, LLC 2019",
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-19",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 2.166656494140625, 209.5, 383.0, 20.0 ],
					"text" : "Transition example",
					"textjustification" : 1
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontname" : "Arial",
					"fontsize" : 48.0,
					"id" : "obj-36",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 2.166656494140625, 147.5, 383.0, 60.0 ],
					"text" : "jit.gl.isf",
					"textjustification" : 1
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 1,
					"border" : 1,
					"clickthrough" : 0,
					"embed" : 1,
					"enablehscroll" : 0,
					"enablevscroll" : 1,
					"id" : "obj-10",
					"lockeddragscroll" : 0,
					"maxclass" : "bpatcher",
					"name" : "ISF_UI_stack.maxpat",
					"numinlets" : 1,
					"numoutlets" : 1,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 8,
							"minor" : 1,
							"revision" : 1,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 34.0, 79.0, 640.0, 480.0 ],
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
						"boxes" : [ 							{
								"box" : 								{
									"hidden" : 1,
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 416.0, 24.373260498046875, 54.0, 22.0 ],
									"text" : "deferlow"
								}

							}
, 							{
								"box" : 								{
									"hidden" : 1,
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 416.0, 0.373260498046875, 79.0, 22.0 ],
									"text" : "loadmess init"
								}

							}
, 							{
								"box" : 								{
									"comment" : "to jit.gl.isf object",
									"hidden" : 1,
									"id" : "obj-2",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 379.0, 0.373260498046875, 30.0, 30.0 ],
									"varname" : "OUTLET"
								}

							}
, 							{
								"box" : 								{
									"comment" : "from params outlet of jit.gl.isf",
									"hidden" : 1,
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ -1.0, 0.373260498046875, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"hidden" : 1,
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 31.0, 0.373260498046875, 131.0, 22.0 ],
									"saved_object_attributes" : 									{
										"filename" : "jit_gl_isf_controller.js",
										"parameter_enable" : 0
									}
,
									"text" : "js jit_gl_isf_controller.js",
									"varname" : "jit_gl_isf_controller"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"hidden" : 1,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"hidden" : 1,
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"hidden" : 1,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"hidden" : 1,
									"source" : [ "obj-7", 0 ]
								}

							}
 ],
						"bgcolor" : [ 0.694117647058824, 0.694117647058824, 0.694117647058824, 1.0 ]
					}
,
					"patching_rect" : [ 449.181884765625, 52.295440673828125, 311.9090576171875, 250.40911865234375 ],
					"varname" : "mybpatcher",
					"viewvisibility" : 1
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 449.181884765625, 315.157318556640803, 82.0, 22.0 ],
					"text" : "s ToISF_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 449.181884765625, 23.295440673828125, 89.0, 22.0 ],
					"text" : "r params_trans"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-12",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 2.166656494140625, -33.0, 91.0, 22.0 ],
					"text" : "r BGImagePath"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-11",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 952.0, 203.0, 93.0, 22.0 ],
					"text" : "s BGImagePath"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-51",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 952.0, 169.0, 75.0, 22.0 ],
					"text" : "prepend pict"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-50",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 952.0, 117.0, 64.0, 22.0 ],
					"text" : "../icon.png"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-43",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 952.0, 143.0, 99.0, 22.0 ],
					"saved_object_attributes" : 					{
						"filename" : "reltoabspath.js",
						"parameter_enable" : 0
					}
,
					"text" : "js reltoabspath.js"
				}

			}
, 			{
				"box" : 				{
					"alpha" : 0.05,
					"autofit" : 1,
					"background" : 1,
					"forceaspect" : 1,
					"id" : "obj-6",
					"ignoreclick" : 1,
					"maxclass" : "fpic",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "jit_matrix" ],
					"patching_rect" : [ 2.166656494140625, 1.5, 382.0, 382.0 ],
					"pic" : "icon.png"
				}

			}
, 			{
				"box" : 				{
					"angle" : 270.0,
					"background" : 1,
					"bgcolor" : [ 0.996078431372549, 0.572549019607843, 0.572549019607843, 1.0 ],
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-34",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 12.166656494140625, 507.118759155273438, 159.0, 37.313369750976562 ],
					"proportion" : 0.5
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"source" : [ "obj-10", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"hidden" : 1,
					"source" : [ "obj-12", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-10", 0 ],
					"source" : [ "obj-13", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-17", 0 ],
					"source" : [ "obj-16", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"source" : [ "obj-17", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-31", 0 ],
					"midpoints" : [ 112.666656494140625, 553.43212890625, 177.666656494140625, 553.43212890625, 177.666656494140625, 380.712128126953303, 196.666656494140625, 380.712128126953303 ],
					"source" : [ "obj-17", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"source" : [ "obj-17", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-23", 0 ],
					"source" : [ "obj-26", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-46", 0 ],
					"source" : [ "obj-27", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-28", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-17", 0 ],
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-30", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-31", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"source" : [ "obj-31", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 0 ],
					"source" : [ "obj-33", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 0 ],
					"source" : [ "obj-35", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-39", 0 ],
					"hidden" : 1,
					"order" : 1,
					"source" : [ "obj-38", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-54", 0 ],
					"hidden" : 1,
					"order" : 0,
					"source" : [ "obj-38", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-35", 0 ],
					"hidden" : 1,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"hidden" : 1,
					"source" : [ "obj-43", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-46", 0 ],
					"source" : [ "obj-47", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 0 ],
					"hidden" : 1,
					"source" : [ "obj-50", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-11", 0 ],
					"hidden" : 1,
					"source" : [ "obj-51", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-52", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-52", 0 ],
					"hidden" : 1,
					"source" : [ "obj-54", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-38", 0 ],
					"hidden" : 1,
					"order" : 0,
					"source" : [ "obj-55", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-50", 0 ],
					"hidden" : 1,
					"order" : 1,
					"source" : [ "obj-55", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-57", 0 ]
				}

			}
 ],
		"parameters" : 		{
			"parameterbanks" : 			{

			}

		}
,
		"dependency_cache" : [ 			{
				"name" : "icon.png",
				"bootpath" : "~/dev/cycling/jit.gl.isf/jit.gl.isf/Packages/ISF",
				"patcherrelativepath" : "..",
				"type" : "PNG",
				"implicit" : 1
			}
, 			{
				"name" : "reltoabspath.js",
				"bootpath" : "~/dev/cycling/jit.gl.isf/jit.gl.isf/Packages/ISF/javascript",
				"patcherrelativepath" : "../javascript",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "jit_gl_isf_controller.js",
				"bootpath" : "~/dev/cycling/jit.gl.isf/jit.gl.isf/Packages/ISF/javascript",
				"patcherrelativepath" : "../javascript",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
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
				"name" : "jit.gl.isf.mxo",
				"type" : "iLaX"
			}
 ],
		"autosave" : 0
	}

}
