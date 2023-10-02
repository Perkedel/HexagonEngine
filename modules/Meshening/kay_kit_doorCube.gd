extends Node3D

@onready var animP = $AnimationPlayer
@onready var meshening = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playAnimation(name: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	animP.play(name,custom_blend,custom_speed,from_end)
	pass

func playAnimationBackwards(name: StringName = "", custom_blend: float = -1):
	animP.play_backwards(name,custom_blend)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
