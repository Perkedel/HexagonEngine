extends RigidBody2D

export (AudioStream) var WeponTembakSound = load("res://GameDVDCardtridge/ParlorClassic/Audio/450854__kyles__gun-lee-enfield-303-rifle-fire-shot.wav")
export (PackedScene) var EmitThisSoundSpeaker = load("res://GameDVDCardtridge/ParlorClassic/Tscene/WeponNembakNoise.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$PistolTembak.stream = WeponTembakSound
	#$PistolTembak.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MissTimer_timeout():
	$".".queue_free()
	
	if $"../../../.." && $"../../../..".isPlayingGameNow:
		$"../../../..".BekgronWasHit()
		pass
	pass # Replace with function body.


func _on_Peluru_body_entered(body):
	$MissTimer.stop()
	$".".queue_free()
	pass # Replace with function body.
