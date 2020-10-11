extends Node

# MIDI player testoid
# Soundfont
# https://musescore.org/en/node/109371
# https://www.mediafire.com/file/2as606szvw1pbw8/OmegaGMGS2.sf2/file
# http://www.synthfont.com/links_to_soundfonts.html
# http://www.synthfont.com/soundfonts.html
# https://osdn.net/projects/sfnet_androidframe/downloads/soundfonts/SGM-V2.01.sf2/
# 

# Plugin itself
# https://godotengine.org/asset-library/asset/240
# https://bitbucket.org/arlez80/godot-midi-player

# How to work
# Check Load all voices from sf2, and check No Reload sf2
# Any Soundfont, any MIDI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	$GodotMIDIPlayer.send_reset()
	$GodotMIDIPlayer.play(0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeDVDButton_pressed():
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.
