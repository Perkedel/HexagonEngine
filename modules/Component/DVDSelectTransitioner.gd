extends ColorRect
# https://generalistprogrammer.com/godot/godot-infinite-scrolling-background-how-to/

export(float,0,1) var Selector=0
export(Texture) var prevBG:Texture
export(Texture) var nextBG:Texture
onready var tween = $Tweenek
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func transitionInto(thisImage:Texture):
	prevBG = nextBG
	nextBG = thisImage
	
	tween.interpolate_property(self,"Selector",0.0,1.0,.5)
	tween.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_param("tex_frg_15",prevBG)
	material.set_shader_param("tex_frg_16",nextBG)
	
	material.set_shader_param("PrevBgDrop",Color.white * abs(clamp(-Selector,-1,0)+1))
	material.set_shader_param("NextBgDrop",Color.white * clamp(Selector,0,1))
	pass
