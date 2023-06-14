extends Node

# Videos
# https://www.videvo.net/stock-video-footage/time-lapse/
# https://www.videvo.net/video/san-bartolomeo-milky-way/2661/
# https://www.videvo.net/video/corporate-building-and-clouds-time-lapse/3348/
# https://commons.wikimedia.org/wiki/File:Sonne_Zeitraffer_-_Sun_Time_Lapse_3840x2160p_24FPS_CC_(Royalty_Free)_(Kostenlos)_10bit.webm

# Music
# Pendulum - The Other Side [100%] Warner Music (swfchan 404 flash inspired)
# Jimmy Fontanez - Floaters [<100%] Audio Library

# Music link
# https://www.youtube.com/watch?v=z0hwFJ1rbbU
# https://www.youtube.com/watch?v=rgwmnCMpGKw
# https://www.youtube.com/audiolibrary (search "Floaters")
# https://youtu.be/9mimcQruoNE (DJ Emkei Burung Gagak - Grass Skirt Remix SPongebob)
# https://www.youtube.com/watch?v=y78SkQK6weM TikToked Grass Skirt

# Articles
# https://docs.godotengine.org/en/3.2/classes/class_videoplayer.html
# https://docs.godotengine.org/en/3.2/classes/class_tween.html#enum-tween-easetype
# https://docs.godotengine.org/en/3.2/classes/class_tween.html
# https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number

@export var MusicSelections: Array = ["res://GameDVDCardtridge/404/audacity/swfchan 404/The Other Side - Pendulum [HQ]-cut.ogg", "res://GameDVDCardtridge/404/audio/Spongebob Gagak (DJ Emkei).wav"]
@export var UseRandomMusicInstead: bool = true
@export var SelectFavouriteNumber: int = 0
@export var SelectMusicFile:AudioStream = load("res://GameDVDCardtridge/404/audacity/swfchan 404/The Other Side - Pendulum [HQ]-cut.ogg")
@export var VideoFilePaths:Array = ["res://GameDVDCardtridge/404/videos/Sonne_Zeitraffer_-_Sun_Time_Lapse_3840x2160p_24FPS_CC_(Royalty_Free)_(Kostenlos)_10bit.webm"]
@export var IndexVideoFIle:int = 0

@onready var upTween = get_tree().create_tween()
@onready var downTween = get_tree().create_tween()
@onready var messTween = get_tree().create_tween()
@onready var LoadTheVideoNow = load(VideoFilePaths[IndexVideoFIle])
@onready var werrorTitle = $"404ui/Control404/404Contains/Panel404/LEDscrolling/HBoxContainer/Label"
@onready var werrorMessage = $"404ui/Control404/404Contains/DebugMessage/RichTextLabel"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func customMessage(writeTitle:String, writeMessage:String):
	werrorTitle.text = writeTitle
	werrorMessage.text = writeMessage
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$"404ui/Control404/404Contains/Panel404".position = Vector2(0,-100)
	upTween.tween_property($"404ui/Control404/404Contains/Panel404", "position", Vector2(0,0),1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	upTween.play()
	
	var y_pos_downMenu = $"404ui/Control404/404Contains/Menu404".position.y
	$"404ui/Control404/404Contains/Menu404".position = Vector2(0,y_pos_downMenu+100)
	downTween.tween_property($"404ui/Control404/404Contains/Menu404", "position", Vector2(0,y_pos_downMenu),1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	downTween.play()
	
	$"404ui/Control404/404Contains/DebugMessage".modulate =  Color.TRANSPARENT
	messTween.tween_property($"404ui/Control404/404Contains/DebugMessage", "modulate", Color.WHITE, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
#	messTween.start()
	
#	$VideoCanvas/VideoPlayer.stream = LoadTheVideoNow
#	$VideoCanvas/VideoPlayer.play()
	
	if UseRandomMusicInstead:
		for i in 3:
			#SelectFavouriteNumber = randi()%MusicSelections.size()
			SelectFavouriteNumber = range(0,MusicSelections.size())[randi()%range(0,MusicSelections.size()).size()]
			# Bug in Godot about random integer
			pass
		var customLoading
		if MusicSelections[SelectFavouriteNumber].ends_with(".wav"):
			pass
		elif MusicSelections[SelectFavouriteNumber].ends_with(".ogg"):
			pass
		else:
			pass
		
		SelectMusicFile = load(MusicSelections[SelectFavouriteNumber])
		pass
	$AudioStreamPlayer.stream = SelectMusicFile
	$AudioStreamPlayer.play()
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


func _on_VideoPlayer_finished():
	$VideoCanvas/VideoStreamPlayer.stop()
	IndexVideoFIle += 1
	if IndexVideoFIle > VideoFilePaths.size()-1:
		IndexVideoFIle = 0
		pass
	LoadTheVideoNow = load(VideoFilePaths[IndexVideoFIle])
	$VideoCanvas/VideoStreamPlayer.stream = LoadTheVideoNow
	$VideoCanvas/VideoStreamPlayer.play()
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	pass # Replace with function body.
