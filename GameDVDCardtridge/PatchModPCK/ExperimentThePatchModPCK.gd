extends Node
# https://docs.godotengine.org/en/stable/getting_started/workflow/export/exporting_pcks.html

var loadingbarIncase
var loadingbarInstance
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func _loadTheModPCK(path:String,replaces:bool):
	print("Load the Mod PCK \n", path)
	print("\nReplace is ", String(replaces))
	var succession = ProjectSettings.load_resource_pack(path,replaces)
	print("Load the PCK is success ? ", String(succession))
	pass

func _loadingBarNow():
	$Control/OpenPCKbutton.hide()
	$Control/PutLoadingBarHereButton.hide()
	loadingbarIncase = load("res://GenLoad.tscn")
	loadingbarInstance = loadingbarIncase.instantiate()
	$LoadingBay.add_child(loadingbarInstance)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OpenPCKbutton_pressed():
	$Control/SelectFileLoadingMode.popup_centered()
	pass # Replace with function body.


func _on_SelectFileLoadingMode_FileAccessModeSelected(Which):
	$Control/FileDialog.access = Which
	$Control/FileDialog.popup_centered()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	_loadTheModPCK(path,false)
	pass # Replace with function body.


func _on_ChangeDVDButton_pressed():
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	pass # Replace with function body.


func _on_PutLoadingBarHereButton_pressed():
	_loadingBarNow()
	pass # Replace with function body.
