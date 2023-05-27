extends Popup

enum FileAccessModes {Resourcer = 0, Userer = 1, FileSystemer = 2, Canceler = -1}
@export (FileAccessModes) var SelectAccessMode
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal FileAccessModeSelected(Which)
func _on_Resourcer_pressed():
	emit_signal("FileAccessModeSelected",FileAccessModes.Resourcer)
	SelectAccessMode = FileAccessModes.Resourcer
	hide()
	pass # Replace with function body.


func _on_FileSystemer_pressed():
	emit_signal("FileAccessModeSelected",FileAccessModes.FileSystemer)
	SelectAccessMode = FileAccessModes.FileSystemer
	hide()
	pass # Replace with function body.


func _on_Userer_pressed():
	emit_signal("FileAccessModeSelected",FileAccessModes.Userer)
	SelectAccessMode = FileAccessModes.Userer
	hide()
	pass # Replace with function body.


func _on_Canceler_pressed():
	emit_signal("FileAccessModeSelected",FileAccessModes.Canceler)
	SelectAccessMode = FileAccessModes.Canceler
	hide()
	pass # Replace with function body.
