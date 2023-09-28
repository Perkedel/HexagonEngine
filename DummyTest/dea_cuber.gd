extends Node3D

@onready var animP:=$AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playAnimation('spawn')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	animP.stop(false)
	animP.play(named,custom_blend,custom_speed,from_end)
	pass

signal animation_finished(anim_name:StringName)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("animation_finished",anim_name)
	pass # Replace with function body.
