tool
extends EditorPlugin

const beatplayer_name = "BeatPlayer"

func _enter_tree():
    add_custom_type(beatplayer_name, "AudioStreamPlayer", preload("beatplayer.gd"), preload("beatplayer_icon.png"))

func _exit_tree():
    remove_custom_type(beatplayer_name)