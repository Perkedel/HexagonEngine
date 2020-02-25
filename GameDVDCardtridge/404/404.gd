extends Node

# https://docs.godotengine.org/en/3.2/classes/class_tween.html

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

# Articles
# https://docs.godotengine.org/en/3.2/classes/class_videoplayer.html
# https://docs.godotengine.org/en/3.2/classes/class_tween.html#enum-tween-easetype

export (AudioStream) var SelectMusicFile = load("res://GameDVDCardtridge/404/audacity/swfchan 404/The Other Side - Pendulum [HQ]-cut.ogg")
export (PoolStringArray) var VideoFilePaths = ["res://GameDVDCardtridge/404/videos/Sonne_Zeitraffer_-_Sun_Time_Lapse_3840x2160p_24FPS_CC_(Royalty_Free)_(Kostenlos)_10bit.webm"]
export (int) var IndexVideoFIle = 0
onready var LoadTheVideoNow = load(VideoFilePaths[IndexVideoFIle])
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"404ui/Control404/404Contains/Panel404/UpTween".interpolate_property($"404ui/Control404/404Contains/Panel404", "rect_position", Vector2(0,-100), Vector2(0,0),1,Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$"404ui/Control404/404Contains/Panel404/UpTween".start()
	
	var y_pos_downMenu = $"404ui/Control404/404Contains/Menu404".rect_position.y
	$"404ui/Control404/404Contains/Menu404/DownTween".interpolate_property($"404ui/Control404/404Contains/Menu404", "rect_position", Vector2(0,y_pos_downMenu+100), Vector2(0,y_pos_downMenu),1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$"404ui/Control404/404Contains/Menu404/DownTween".start()
	
	$VideoCanvas/VideoPlayer.stream = LoadTheVideoNow
	$VideoCanvas/VideoPlayer.play()
	
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
	$VideoCanvas/VideoPlayer.stop()
	IndexVideoFIle += 1
	if IndexVideoFIle > VideoFilePaths.size():
		IndexVideoFIle = 0
		pass
	LoadTheVideoNow = load(VideoFilePaths[IndexVideoFIle])
	$VideoCanvas/VideoPlayer.stream = LoadTheVideoNow
	$VideoCanvas/VideoPlayer.play()
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	pass # Replace with function body.
