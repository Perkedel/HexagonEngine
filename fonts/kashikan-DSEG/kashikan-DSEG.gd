extends FontFile

@export var chooseMode = "7Seg" # (String,"7Seg","14Seg","Weather")
@export var chooseForm = "Classic" # (String,"Classic","Modern","Egg")
@export var miniForm: bool = false
@export var fontWeight = "Regular" # (String,"Regular","Italic","Bold","BoldItalic", "Light3D", "LightItalic")
@onready var _defaultFont:Dictionary = {
	"7Seg":{
		"Classic":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Classic/DSEG7Classic-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Classic-MINI/DSEG7ClassicMini-LightItalic.ttf")
			}
		},
		"Modern":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG7-Modern/DSEG7Modern-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG7-Modern-MINI/DSEG7ModernMini-Light3D.ttf"),
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
				"Light3D":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Classic/DSEG14Classic-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Classic-MINI/DSEG14ClassicMini-LightItalic.ttf")
			}
		},
		"Modern":{
			"beeg":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-Light3D.ttf"),
				"LightItalic":preload("res://font/fonts-DSEG/DSEG14-Modern/DSEG14Modern-LightItalic.ttf")
			},
			"mini":{
				"Regular":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Regular.ttf"),
				"Italic":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Italic.ttf"),
				"Bold":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Bold.ttf"),
				"BoldItalic":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-BoldItalic.ttf"),
				"Light3D":preload("res://font/fonts-DSEG/DSEG14-Modern-MINI/DSEG14ModernMini-Light3D.ttf"),
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
@export var Fonts: Dictionary = _defaultFont
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#font_data = _defaultFont[chooseMode][chooseForm if chooseMode != "Weather" else "Classic"]["mini" if miniForm && chooseMode != "Weather" else "beeg"][fontWeight if chooseMode != "Weather" else "Regular"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#font_data = _defaultFont[chooseMode][chooseForm if chooseMode != "Weather" else "Classic"]["mini" if miniForm && chooseMode != "Weather" else "beeg"][fontWeight if chooseMode != "Weather" else "Regular"]
	pass
