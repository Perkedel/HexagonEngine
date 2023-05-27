extends ColorRect
# https://generalistprogrammer.com/godot/godot-infinite-scrolling-background-how-to/

@export var Selector=0 # (float,0,1)
@export var prevBG: Texture2D:Texture2D
@export var nextBG: Texture2D:Texture2D
@onready var tween = $Tweenek
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func transitionInto(thisImage:Texture2D):
	prevBG = nextBG
	nextBG = thisImage
	
	tween.interpolate_property(self,"Selector",0.0,1.0,.5)
	tween.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("tex_frg_15",prevBG)
	material.set_shader_parameter("tex_frg_16",nextBG)
	
	material.set_shader_parameter("PrevBgDrop",Color.WHITE * abs(clamp(-Selector,-1,0)+1))
	material.set_shader_parameter("NextBgDrop",Color.WHITE * clamp(Selector,0,1))
	pass
