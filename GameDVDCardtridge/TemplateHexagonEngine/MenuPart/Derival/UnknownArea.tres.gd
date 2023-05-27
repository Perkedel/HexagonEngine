extends Control

@export (String) var pathToSave = "user://Unknown.txt"
var Filer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func Save():
	Filer = File.new()
	Filer.open(pathToSave,File.WRITE)
	Filer.store_string($VBoxContainer/EditMe.text)
	Filer.close()
	pass

func Load():
	Filer = File.new()
	if Filer.open(pathToSave,File.READ) == OK:
		$VBoxContainer/EditMe.text = Filer.get_as_text()
		Filer.close()
		pass
	else:
		Save()
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Load()
	pass # Replace with function body.

func FocusWhatDoYouWantNow():
	$VBoxContainer/EditMe.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			LeaveTheEditorNow()
			pass
		pass
	pass

signal LeaveAndBackToMenu
func LeaveTheEditorNow():
	emit_signal("LeaveAndBackToMenu")
	pass


func _on_SaveKey_pressed():
	#Todo: save this file
	Save()
	pass # Replace with function body.
