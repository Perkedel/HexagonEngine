extends AudioStreamPlayer

var FLMmusic = FLMusicLib.new()
#var ArlezMIDI = MidiPlayer.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# https://godotforums.org/discussion/22756/button-sound

# Called when the node enters the scene tree for the first time.
func _ready():
	set_bus("SoundEffect")
	
	# https://github.com/MightyPrinny/godot-FLMusicLib/blob/demo/global.gd
	add_child(FLMmusic)
	FLMmusic.set_gme_buffer_size(2048*5)
	
	# https://godotengine.org/asset-library/asset/240
#	add_child(ArlezMIDI)
#	ArlezMIDI.set_max_polyphony(12)
#	ArlezMIDI.soundfont = load("res://DummyTest/dataArlez80/Aspirin-Stereo.sf2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
