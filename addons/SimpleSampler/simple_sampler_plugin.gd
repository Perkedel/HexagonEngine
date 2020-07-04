tool
extends EditorPlugin

func _enter_tree():
  add_custom_type(
	"NoteSample",
	"Resource",
	load("sample_resource.gd"),
	load("sample_icon.png")
  )
  add_autoload_singleton("NoteValue", "res://addons/SimpleSampler/note_value.gd")
  add_custom_type(
	"Sampler",
	"AudioStreamPlayer",
	load("sampler.gd"),
	load("sampler_icon.png")
  )
  add_custom_type(
	"Multisampler",
	"AudioStreamPlayer",
	load("multisampler.gd"),
	load("multisampler_icon.png")
  )
  

func _exit_tree():
  remove_custom_type("NoteSample")
  remove_custom_type("Sampler")
  remove_custom_type("Multisampler")
  remove_autoload_singleton("NoteValue")
