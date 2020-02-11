extends HBoxContainer

export (String) var VariableName = "Test Music"
export (AudioStream) var SongFile
export (bool) var isItPlaying = false
export (String) var PressToPlayName = "Press to Play"
export (String) var PressToStopName = "Press to Stop"
export (String) var PlayButtonLabelRightNow
export (Texture) var PlayIcon
export (Texture) var StopIcon
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://www.youtube.com/audiolibrary
# Search "Floaters" artist is "Jimmy Fontanez"
# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.stream = SongFile
	PlayButtonLabelRightNow = PressToPlayName
	pass # Replace with function body.

func DeToggle(): #Stop Testing
	$HBoxContainer/PlayButton.pressed = false
	pass

func PlaySong():
	$MusicPlayer.play()
	pass

func StopSong():
	$MusicPlayer.stop()
	pass

func PauseSong():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isItPlaying = $MusicPlayer.is_playing()
	$Label.text = VariableName
	$HBoxContainer/PlayButton.text = "SONG PLAY= " + String(isItPlaying) + ", " + PlayButtonLabelRightNow
	if isItPlaying:
		$HBoxContainer/PlayIcon.texture = StopIcon
		pass
	else:
		$HBoxContainer/PlayIcon.texture = PlayIcon
		pass
	pass


func _on_MusicPlayer_finished():
	DeToggle()
	#print("Music Finished")
	pass # Replace with function body.

signal isPlaying(value)
func _on_Button_toggled(button_pressed):
	emit_signal("isPlaying", button_pressed)
	
	if button_pressed:
		PlaySong()
		PlayButtonLabelRightNow = PressToStopName
		pass
	else:
		StopSong()
		PlayButtonLabelRightNow = PressToPlayName
		
		pass
	pass # Replace with function body.
