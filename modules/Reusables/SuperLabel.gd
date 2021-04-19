tool
extends Label

#onready var superLabelFont:DynamicFont = preload("res://modules/Reusables/SuperLabelDynamicFont.tres")
export(DynamicFontData) var fontFile = load("res://font/ubuntu-font-family-0.83/Ubuntu-R.ttf")
onready var fonto = get_font("font")
export(float) var size = 24.0
export(Color) var fontColor = Color.white # to rechange again, use add color overide directly. if it is in process, it lags!
export(float) var outlineSize = 1.0
export(Color) var OutlineColor = Color.black
export(bool) var useMipmaps = false
export(bool) var useFilter = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _updateFont():
	#add_font_override("font",superLabelFont)
	#add_color_override("font_color",fontColor)
	fonto.font_data = fontFile
	fonto.size = size
	
	fonto.outline_size = outlineSize
	fonto.outline_color = OutlineColor
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#fonto = get_font("font")
	#add_font_override("font",superLabelFont)
	add_color_override("font_color",fontColor)
	_updateFont()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_updateFont()
	pass
