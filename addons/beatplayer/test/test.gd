extends Control

signal playback_changed(playback, beat)
signal beatplayer_changed(beatplayer)

func _ready():
	emit_signal("beatplayer_changed", $BeatPlayer)

func _on_play_btn_pressed():
	$BeatPlayer.play(0)

func _on_play_absolute_btn_pressed():
	$BeatPlayer.play_absolute(0)


func _process(delta):
	# if $BeatPlayer.playing:
	emit_signal("playback_changed", $BeatPlayer.playback_position, $BeatPlayer.beat)

func _on_bpm_edit_text_entered(new_text):
	var new_bpm = float(new_text)
	if new_bpm != null:
		$BeatPlayer.bpm = new_bpm
		emit_signal("beatplayer_changed", $BeatPlayer)


func _on_stop_pressed():
	$BeatPlayer.stop()
