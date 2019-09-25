{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 1,
			"revision" : 0,
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
					"id" : "obj-56",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 535.3863525390625, 428.782379150390625, 277.0, 20.0 ],
					"text" : "Use these built-in videos to preview the transition",
					"textcolor" : [ 0.545098039215686, 0.545098039215686, 0.545098039215686, 1.0 ]
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
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 323.462120056152344, 618.535858154296875, 133.0, 22.0 ],
					"text" : "param endImage $1 $2"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-49",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 323.462120056152344, 594.535858154296875, 70.0, 22.0 ],
					"text" : "jit.gl.texture"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 29.464630126953125,
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
					"patching_rect" : [ 535.3863525390625, 549.1419677734375, 294.0, 91.393890380859375 ]
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
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 323.462120056152344, 520.17626953125, 136.0, 22.0 ],
					"text" : "param startImage $1 $2"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-32",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 323.462120056152344, 496.17626953125, 70.0, 22.0 ],
					"text" : "jit.gl.texture"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 29.464630126953125,
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
									"srcrect" : [ 0, 0, 1, 1 ],
									"looppoints" : [ 0, 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"usedstrect" : [ 0 ],
									"adapt" : [ 1 ],
									"texture_name" : [ "u737003752" ],
									"time_ms" : [ 0 ],
									"interp" : [ 0 ],
									"usesrcrect" : [ 0 ],
									"framereport" : [ 0 ],
									"position" : [ 0.0 ],
									"colormode" : [ "argb" ],
									"autostart" : [ 1 ],
									"drawto" : [ "" ],
									"loopreport" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"vol" : [ 1.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"time_secs" : [ 0.0 ],
									"engine" : [ "avf" ],
									"moviefile" : [ "" ],
									"loopstart" : [ 0 ],
									"output_texture" : [ 0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"automatic" : [ 0 ],
									"rate" : [ 1.0 ],
									"time" : [ 0 ]
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
					"patching_rect" : [ 535.3863525390625, 450.782379150390625, 294.0, 91.393890380859375 ]
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
					"id" : "obj-8",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 682.181884765625, 1.5, 150.9090576171875, 33.0 ],
					"text" : "Parameters (optional, not generated by jit.gl.isf)",
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"bgmode" : 1,
					"border" : 1,
					"clickthrough" : 0,
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
					"patching_rect" : [ 531.181884765625, 36.5, 301.9090576171875, 137.40911865234375 ],
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
					"patching_rect" : [ 531.181884765625, 187.5, 134.0, 22.0 ],
					"text" : "s msgsToISFInlet_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 531.181884765625, 1.5, 150.0, 22.0 ],
					"text" : "r msgsFromINPUTS_trans"
				}

			}
, 			{
				"box" : 				{
					"frozen_object_attributes" : 					{
						"rect" : [ 800, 45, 1440, 525 ]
					}
,
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "bang", "" ],
					"patching_rect" : [ 44.371124267578125, 618.535858154296875, 168.0, 22.0 ],
					"text" : "jit.world isftransctx @enable 1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 143.037790934244811, 570.535858154296875, 133.0, 22.0 ],
					"text" : "s msgsFromFiles_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 93.704457600911468, 594.535858154296875, 152.0, 22.0 ],
					"text" : "s msgsFromINPUTS_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 44.371124267578125, 457.43212890625, 132.0, 22.0 ],
					"text" : "r msgsToISFInlet_trans"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-17",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "jit_gl_texture", "", "", "" ],
					"patching_rect" : [ 44.371124267578125, 510.43212890625, 167.0, 22.0 ],
					"text" : "jit.gl.isf @file \"Window Blinds\""
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
					"angle" : 270.0,
					"background" : 1,
					"bgcolor" : [ 0.996078431372549, 0.572549019607843, 0.572549019607843, 1.0 ],
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-28",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 35.371124267578125, 501.61151123046875, 184.0, 38.82061767578125 ],
					"proportion" : 0.5
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
					"bgcolor" : [ 0.811764705882353, 0.811764705882353, 0.811764705882353, 1.0 ],
					"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
					"id" : "obj-37",
					"maxclass" : "panel",
					"mode" : 0,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 531.181884765625, 424.438018798828125, 301.018878936767578, 221.147369384765625 ],
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
					"destination" : [ "obj-5", 0 ],
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
					"destination" : [ "obj-17", 0 ],
					"midpoints" : [ 332.962120056152344, 552.17626953125, 302.416622161865234, 552.17626953125, 302.416622161865234, 499.43212890625, 53.871124267578125, 499.43212890625 ],
					"source" : [ "obj-27", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 0 ],
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"midpoints" : [ 544.8863525390625, 552.17626953125, 476.924236297607422, 552.17626953125, 476.924236297607422, 485.17626953125, 332.962120056152344, 485.17626953125 ],
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
					"destination" : [ "obj-17", 0 ],
					"midpoints" : [ 332.962120056152344, 650.535858154296875, 294.416622161865234, 650.535858154296875, 294.416622161865234, 499.43212890625, 53.871124267578125, 499.43212890625 ],
					"source" : [ "obj-47", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-49", 0 ]
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
					"destination" : [ "obj-49", 0 ],
					"midpoints" : [ 544.8863525390625, 650.535858154296875, 484.924236297607422, 650.535858154296875, 484.924236297607422, 583.535858154296875, 332.962120056152344, 583.535858154296875 ],
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
 ],
		"parameters" : 		{
			"obj-10::obj-4::obj-4" : [ "progress", "progress", 0 ],
			"parameterbanks" : 			{

			}
,
			"parameter_overrides" : 			{
				"obj-10::obj-4::obj-4" : 				{
					"parameter_longname" : "progress",
					"parameter_shortname" : "progress"
				}

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
				"name" : "ISF_UI_stack.maxpat",
				"bootpath" : "~/dev/cycling/jit.gl.isf/jit.gl.isf/Packages/ISF/patchers",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "jit_gl_isf_ui_controller.js",
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
