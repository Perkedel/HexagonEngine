tool
extends Label

# fonts by https://www.keshikan.net/fonts-e.html, OpenFont SIL 1.1
# built the Label for Godot by JOELwindows7, GNU GPL v3
const fellbackChooseMode:String = "7Seg"
const fellbackChooseForm:String = "Classic"
const fellbackFont:DynamicFont = preload("res://fonts/kashikan-DSEG/kashikan-DSEG.tres")

export(float) var size = 16.0
onready var fonto:DynamicFont = get_font("font")
export(String,"7Seg","14Seg","Weather") var chooseMode = fellbackChooseMode setget set_choose_mode
export(String,"Classic","Modern","Egg") var chooseForm = fellbackChooseForm setget set_choose_form
export(bool) var miniForm = false setget set_mini_form
export(String,"Regular","Italic","Bold","BoldItalic", "Light", "LightItalic") var fontWeight = "Regular" setget set_font_weight
export(Color) var fontColor = Color.white setget set_font_color
export(Dictionary) var Fonts = _defaultFont setget set_fonts_dictionary

const fellBackClassic:DynamicFontData = preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Regular.ttf")
const fellBackModern:DynamicFontData = preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Regular.ttf")
onready var fellBackClassic7:DynamicFontData = preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Regular.ttf")
const fellBackModern7:DynamicFontData = preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Regular.ttf")
const fellBackWeather:DynamicFontData = preload("res://font/fonts-DSEG/DSEGWeather/DSEGWeather.ttf")
export(bool) var justUseFellBackCustomInstead = false
export(DynamicFontData) var fellBackPleaseAssignCustom = load("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Regular.ttf")

const _defaultFont:Dictionary = {
	"7Seg":{
		"Classic":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-LightItalic.ttf")
			}
		},
		"Modern":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-LightItalic.ttf")
			}
		},
		"Egg":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-7SEGG-CHAN/DSEG7SEGGCHAN-Regular.ttf"),
#				"Italic":{},
#				"Bold":{},
#				"BoldItalic":{},
#				"Light":{},
#				"LightItalic":{}
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-7SEGG-CHAN/DSEG7SEGGCHANMINI-Regular.ttf"),
#				"Italic":{},
#				"Bold":{},
#				"BoldItalic":{},
#				"Light":{},
#				"LightItalic":{}
			}
		}
	},
	"14Seg":{
		"Classic":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-LightItalic.ttf")
			}
		},
		"Modern":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-BoldItalic.ttf"),
				"Light":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Light.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-LightItalic.ttf")
			}
		},
	},
	"Weather":{
		"Classic":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEGWeather/DSEGWeather.ttf")
			}
		}
	}
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _updateFont():
	# safety check! without this, it could error invalid set index base Nil.
	if fonto == null:
		return
	
	fonto.chooseMode = chooseMode
#	fonto.set_deferred("chooseMode", chooseMode)
#	fonto.get_script().chooseMode = chooseMode
	fonto.chooseForm = chooseForm
	fonto.miniForm = miniForm
	fonto.fontWeight = fontWeight
	fonto.size = size
	if not justUseFellBackCustomInstead:
		if _defaultFont:
			fonto.font_data = _defaultFont[chooseMode][chooseForm if chooseMode != "Weather" else "Classic"]["mini" if miniForm && chooseMode != "Weather" else "beeg"][fontWeight if chooseMode != "Weather" else "Regular"]
			#fonto.font_data = _defaultFont[chooseMode][chooseForm]["beeg"][fontWeight]
		else:
			#fonto.font_data = fellBackClassic
			match(chooseMode):
				"7Seg":
					fonto.font_data = fellBackModern7
					pass
				"14Seg":
					fonto.font_data = fellBackModern
					pass
				"Weather":
					fonto.font_data = fellBackWeather
					pass
		pass
	else:
		fonto.font_data = fellBackPleaseAssignCustom

func replaceColor(value:Color=fontColor):
	if value:
		fontColor = value
	add_color_override("font_color",fontColor)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	replaceColor()
	_updateFont()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	_updateFont()
	pass

func set_font_size(value):
	# https://godotengine.org/qa/42430/changing-font-size-of-theme-or-control-at-runtime?show=42430#q42430
	#fonto.size = value
	pass

func set_font_color(whichColor:Color):
	fontColor = whichColor
	_updateFont()

func set_choose_mode(whichIs:String = fellbackChooseMode):
	chooseMode = whichIs
	_updateFont()

func set_choose_form(whichIs:String = fellbackChooseForm):
	chooseForm = whichIs
	_updateFont()

func set_mini_form(with:bool = false):
	miniForm = with
	_updateFont()

func set_font_weight(howThicc:String = "Regular"):
	fontWeight = howThicc
	_updateFont()

func set_fonts_dictionary(with:Dictionary = _defaultFont):
	Fonts = with
	_updateFont()
