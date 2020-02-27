extends Node

func _ready():
	$Stopwatch.reset()

func _process(delta):
	_update_ui()

func _on_Start_pressed():
	$Stopwatch.start()
	$CanvasLayer/AnimationPlayer.play("Default")

func _on_Stop_pressed():
	$Stopwatch.stop()
	$CanvasLayer/AnimationPlayer.play("Default")

func _on_PauseResume_pressed():
	if $Stopwatch.paused:
		$Stopwatch.resume()
		$CanvasLayer/AnimationPlayer.play("Default")
	else:
		$Stopwatch.pause()
		$CanvasLayer/AnimationPlayer.play("Blink")

func _on_Reset_pressed():
	$Stopwatch.reset()
	$CanvasLayer/AnimationPlayer.play("Default")

func _on_Stopwatch_started():
	print("Stopwatch has been started.")

func _on_Stopwatch_stopped():
	print("Stopwatch has been stopped.")

func _on_Stopwatch_paused():
	print("Stopwatch has been paused.")

func _on_Stopwatch_resumed():
	print("Stopwatch has been resumed.")

func _on_Stopwatch_reset():
	print("Stopwatch has been reset.")
	$CanvasLayer/VBoxContainer/Label.text = $Stopwatch.get_formatted_elapsed_time()

func _on_Stopwatch_ticked():
	$CanvasLayer/VBoxContainer/Label.text = $Stopwatch.get_formatted_elapsed_time()

func _update_ui():
	if $Stopwatch.started:
		$CanvasLayer/VBoxContainer/HBoxContainer/Start.disabled = true
		$CanvasLayer/VBoxContainer/HBoxContainer/Stop.disabled = false
		$CanvasLayer/VBoxContainer/HBoxContainer/PauseResume.disabled = false
		$CanvasLayer/VBoxContainer/HBoxContainer/Reset.disabled = true
	else:
		$CanvasLayer/VBoxContainer/HBoxContainer/Start.disabled = false
		$CanvasLayer/VBoxContainer/HBoxContainer/Stop.disabled = true
		$CanvasLayer/VBoxContainer/HBoxContainer/PauseResume.disabled = true
		$CanvasLayer/VBoxContainer/HBoxContainer/Reset.disabled = false
	
	if $Stopwatch.paused:
		$CanvasLayer/VBoxContainer/HBoxContainer/PauseResume.text = "Resume"
	else:
		$CanvasLayer/VBoxContainer/HBoxContainer/PauseResume.text = "Pause"
