@tool
# https://youtu.be/K9FBpJ2Ypb4
# https://github.com/GDQuest/godot-demos/tree/master/2018/09-20-shaders/shaders/masks
# https://github.com/GDQuest/godot-demos
# https://godotengine.org/qa/1401/how-to-name-a-class
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html
extends ColorRect
class_name GDQTransitionColor, "res://modules/ShadeMask/GDQuestShadeMask/shards.png"

@export var cutoff = 0.0: set = set_cutoff
@export var smooth_size = .005: set = set_smooth_size
@export var mask: Texture2D: set = set_mask
@export var warna: Color: set = set_warna
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_cutoff(howMuch:float = 0):
	cutoff = howMuch
	_syncParams()

func set_smooth_size(howBig:float = .005):
	smooth_size = howBig
	_syncParams()

func set_mask(withImage:Texture2D):
	mask = withImage
	_syncParams()

func set_warna(with:Color):
	warna = with
	_syncParams()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _syncParams():
	material.set_shader_parameter("cutoff",cutoff)
	material.set_shader_parameter("smooth_size",smooth_size)
	material.set_shader_parameter("mask",mask)
	material.set_shader_parameter("color",warna)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
