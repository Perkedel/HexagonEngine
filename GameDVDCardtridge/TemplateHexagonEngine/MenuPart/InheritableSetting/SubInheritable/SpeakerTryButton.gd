extends Button

@export var playThisPls: AudioStream
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$individualSpeaker.stream = playThisPls
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpeakerTryButton_pressed():
#	if not $individualSpeaker.playing:
#		$individualSpeaker.play()
#	else:
#		$individualSpeaker.stop()
	pass # Replace with function body.


func _on_SpeakerTryButton_toggled(button_pressed):
	$individualSpeaker.playing = button_pressed
	pass # Replace with function body.


func _on_individualSpeaker_finished():
	$individualSpeaker.stop()
	pass # Replace with function body.
