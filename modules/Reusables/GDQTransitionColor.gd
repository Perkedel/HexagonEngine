tool
# https://youtu.be/K9FBpJ2Ypb4
# https://github.com/GDQuest/godot-demos/tree/master/2018/09-20-shaders/shaders/masks
# https://github.com/GDQuest/godot-demos
# https://godotengine.org/qa/1401/how-to-name-a-class
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html
extends ColorRect
class_name GDQTransitionColor, "res://modules/ShadeMask/GDQuestShadeMask/shards.png"

export(float,0,1) var cutoff = 0.0
export(float,0,1) var smooth_size = .005
export(Texture) var mask
export(Color) var warna
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_param("cutoff",cutoff)
	material.set_shader_param("smooth_size",smooth_size)
	material.set_shader_param("mask",mask)
	material.set_shader_param("color",warna)
	pass
