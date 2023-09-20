extends HBoxContainer

@export var VariableName:String = "Test Music"
@export var SongFile:AudioStream
@export var isItPlaying:bool = false
@export var PressToPlayName:String = "Press to Play"
@export var PressToStopName:String = "Press to Stop"
@export var PlayButtonLabelRightNow:String
@export var PlayIcon:Texture2D
@export var StopIcon:Texture2D
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
	$HBoxContainer/PlayButton.button_pressed = false
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
	$HBoxContainer/PlayButton.text = "SONG PLAY= " + 'true' if isItPlaying else 'false' + ", " + PlayButtonLabelRightNow
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
