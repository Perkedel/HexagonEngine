extends Control

signal animation_finished

func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")


func _process(delta):
	if scene_manager.loading_scene_path:
		var progress = scene_manager.get_progress()
		if progress >= 0 : 
			$Control/ProgressBar.value = progress * 100
			
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)
