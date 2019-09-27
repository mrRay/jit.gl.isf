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
		"rect" : [ 34.0, 79.0, 838.0, 684.0 ],
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
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 931.0, 488.717620849609375, 29.5, 22.0 ],
					"text" : "1"
				}

			}
, 			{
				"box" : 				{
					"hidden" : 1,
					"id" : "obj-1",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 931.0, 462.717620849609375, 67.0, 22.0 ],
					"text" : "delay 1000"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-44",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 521.3863525390625, 409.717620849609375, 284.0, 20.0 ],
					"text" : "Use one of these built-in videos to preview the filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-97",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 521.3863525390625, 611.92974853515625, 130.0, 22.0 ],
					"text" : "s msgsToISFInlet_filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-27",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 521.3863525390625, 587.92974853515625, 139.0, 22.0 ],
					"text" : "param inputImage $1 $2"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-32",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 521.3863525390625, 560.92974853515625, 70.0, 22.0 ],
					"text" : "jit.gl.texture"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 38.653920491536461,
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
									"dstrect" : [ 0, 0, 1, 1 ],
									"framereport" : [ 0 ],
									"automatic" : [ 0 ],
									"interp" : [ 0 ],
									"adapt" : [ 1 ],
									"usedstrect" : [ 0 ],
									"position" : [ 0.0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"colormode" : [ "argb" ],
									"texture_name" : [ "u737003752" ],
									"vol" : [ 1.0 ],
									"rate" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"moviefile" : [ "" ],
									"autostart" : [ 1 ],
									"output_texture" : [ 0 ],
									"time_ms" : [ 0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time" : [ 0 ],
									"engine" : [ "avf" ],
									"loopreport" : [ 0 ],
									"drawto" : [ "" ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"loopstart" : [ 0 ]
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
									"dstrect" : [ 0, 0, 1, 1 ],
									"framereport" : [ 0 ],
									"automatic" : [ 0 ],
									"interp" : [ 0 ],
									"adapt" : [ 1 ],
									"usedstrect" : [ 0 ],
									"position" : [ 0.0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"colormode" : [ "argb" ],
									"texture_name" : [ "u737003752" ],
									"vol" : [ 1.0 ],
									"rate" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"moviefile" : [ "" ],
									"autostart" : [ 1 ],
									"output_texture" : [ 0 ],
									"time_ms" : [ 0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time" : [ 0 ],
									"engine" : [ "avf" ],
									"loopreport" : [ 0 ],
									"drawto" : [ "" ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"loopstart" : [ 0 ]
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
									"dstrect" : [ 0, 0, 1, 1 ],
									"framereport" : [ 0 ],
									"automatic" : [ 0 ],
									"interp" : [ 0 ],
									"adapt" : [ 1 ],
									"usedstrect" : [ 0 ],
									"position" : [ 0.0 ],
									"looppoints_secs" : [ 0.0, 0.0 ],
									"looppoints_ms" : [ 0, 0 ],
									"colormode" : [ "argb" ],
									"texture_name" : [ "u737003752" ],
									"vol" : [ 1.0 ],
									"rate" : [ 1.0 ],
									"time_secs" : [ 0.0 ],
									"moviefile" : [ "" ],
									"autostart" : [ 1 ],
									"output_texture" : [ 0 ],
									"time_ms" : [ 0 ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time" : [ 0 ],
									"engine" : [ "avf" ],
									"loopreport" : [ 0 ],
									"drawto" : [ "" ],
									"usesrcrect" : [ 0 ],
									"loopend" : [ 0 ],
									"unique" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"loopstart" : [ 0 ]
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
					"patching_rect" : [ 521.3863525390625, 432.217620849609375, 294.0, 118.961761474609375 ]
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 9.0,
					"id" : "obj-22",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 509.462120056152344, 657.8443603515625, 309.628822326660156, 17.0 ],
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
					"text" : "Image Filter example",
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
					"hidden" : 1,
					"id" : "obj-33",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 861.0, 449.61151123046875, 58.0, 22.0 ],
					"text" : "loadbang"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-8",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 668.181884765625, 1.5, 150.9090576171875, 33.0 ],
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
					"patching_rect" : [ 517.181884765625, 36.5, 301.9090576171875, 332.40911865234375 ],
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
					"patching_rect" : [ 517.181884765625, 379.5, 130.0, 22.0 ],
					"text" : "s msgsToISFInlet_filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 517.181884765625, 1.5, 146.0, 22.0 ],
					"text" : "r msgsFromINPUTS_filter"
				}

			}
, 			{
				"box" : 				{
					"frozen_object_attributes" : 					{
						"erase_color" : [ 0.0, 0.0, 0.0, 1.0 ],
						"rect" : [ 815, 45, 1455, 525 ]
					}
,
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "bang", "" ],
					"patching_rect" : [ 123.371124267578125, 564.215240478515625, 167.0, 22.0 ],
					"text" : "jit.world isffilterctx @enable 1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 202.037790934244811, 516.306121826171875, 129.0, 22.0 ],
					"text" : "s msgsFromFiles_filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 162.704457600911468, 540.215240478515625, 148.0, 22.0 ],
					"text" : "s msgsFromINPUTS_filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 123.371124267578125, 409.717620849609375, 128.0, 22.0 ],
					"text" : "r msgsToISFInlet_filter"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-17",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "jit_gl_texture", "", "", "" ],
					"patching_rect" : [ 123.371124267578125, 462.717620849609375, 137.0, 22.0 ],
					"text" : "jit.gl.isf @file \"ASCII Art\""
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
					"patching_rect" : [ -11.833343505859375, -33.0, 91.0, 22.0 ],
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
					"patching_rect" : [ 861.0, 576.0, 93.0, 22.0 ],
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
					"patching_rect" : [ 861.0, 542.0, 75.0, 22.0 ],
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
					"patching_rect" : [ 861.0, 490.0, 64.0, 22.0 ],
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
					"patching_rect" : [ 861.0, 516.0, 99.0, 22.0 ],
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
					"patching_rect" : [ 114.371124267578125, 454.09088134765625, 153.0, 37.626739501953125 ],
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
					"patching_rect" : [ 517.181884765625, 405.873260498046875, 301.9090576171875, 150.147369384765625 ],
					"proportion" : 0.5
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-4", 0 ],
					"hidden" : 1,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
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
					"destination" : [ "obj-97", 0 ],
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
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"order" : 0,
					"source" : [ "obj-33", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-50", 0 ],
					"hidden" : 1,
					"order" : 1,
					"source" : [ "obj-33", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-35", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-35", 0 ],
					"hidden" : 1,
					"source" : [ "obj-4", 0 ]
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
 ],
		"parameters" : 		{
			"obj-10::obj-11::obj-4" : [ "tintColor", "tintColor", 0 ],
			"obj-10::obj-13::obj-4" : [ "alphaMode", "alphaMode", 0 ],
			"obj-10::obj-9::obj-4" : [ "tint", "tint", 0 ],
			"obj-10::obj-6::obj-4" : [ "gamma", "gamma", 0 ],
			"obj-10::obj-4::obj-4" : [ "size", "size", 0 ],
			"parameterbanks" : 			{

			}
,
			"parameter_overrides" : 			{
				"obj-10::obj-11::obj-4" : 				{
					"parameter_longname" : "tintColor",
					"parameter_shortname" : "tintColor"
				}
,
				"obj-10::obj-13::obj-4" : 				{
					"parameter_longname" : "alphaMode",
					"parameter_shortname" : "alphaMode"
				}
,
				"obj-10::obj-9::obj-4" : 				{
					"parameter_longname" : "tint",
					"parameter_shortname" : "tint"
				}
,
				"obj-10::obj-6::obj-4" : 				{
					"parameter_longname" : "gamma",
					"parameter_shortname" : "gamma"
				}
,
				"obj-10::obj-4::obj-4" : 				{
					"parameter_longname" : "size",
					"parameter_shortname" : "size"
				}

			}

		}
,
		"dependency_cache" : [ 			{
				"name" : "reltoabspath.js",
				"bootpath" : "~/Documents/Max 8/Packages/ISF/javascript",
				"patcherrelativepath" : "../../../../../Max 8/Packages/ISF/javascript",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "ISF_UI_stack.maxpat",
				"bootpath" : "~/Documents/jit.gl.isf/jit.gl.isf/Packages/ISF/patchers",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "jit_gl_isf_ui_controller.js",
				"bootpath" : "~/Documents/Max 8/Packages/ISF/javascript",
				"patcherrelativepath" : "../../../../../Max 8/Packages/ISF/javascript",
				"type" : "TEXT",
				"implicit" : 1
			}
, 			{
				"name" : "jit_gl_isf_controller.js",
				"bootpath" : "~/Documents/Max 8/Packages/ISF/javascript",
				"patcherrelativepath" : "../../../../../Max 8/Packages/ISF/javascript",
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
