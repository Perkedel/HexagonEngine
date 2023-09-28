extends Node3D

@onready var animP:=$AnimationPlayer
@onready var mainMesh:=$PlaceBean
@onready var tweene = get_tree().create_tween()
var scaleWas = Vector3.ONE

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

func squish(byWha:Vector3,forHowLong:float=.25):
	if tweene:
		tweene.kill()
	tweene = create_tween()
#	var scaleWas:Vector3=mainMesh.scale
#	mainMesh.scale_object_local(-byWha)
	mainMesh.scale -= byWha
	tweene.tween_property(mainMesh,'scale',scaleWas,forHowLong)
	pass

signal animation_finished(anim_name:StringName)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("animation_finished",anim_name)
	pass # Replace with function body.
