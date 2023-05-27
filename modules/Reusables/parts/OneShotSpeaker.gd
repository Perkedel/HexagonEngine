class_name OneShotSpeaker
extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var destroyOnFinish: bool = true
#class_name OneShotSpeaker
#class OneShotSpeaker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playThis(anSound:AudioStream, volume:float = 0, pitch:float = 1, mix:int = MIX_TARGET_STEREO, busTo = "SoundEffect", destroyAfter:bool = true):
	stream = anSound
	volume_db = volume
	pitch_scale = pitch
	mix_target = mix
	bus = busTo
	destroyOnFinish = destroyAfter
	play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OneShotSpeaker_finished():
	if destroyOnFinish:
		queue_free()
	pass # Replace with function body.
