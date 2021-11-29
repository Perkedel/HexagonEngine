tool
extends ConfirmationDialog
class_name OptionsDialog

var current_path : String = ""
var newInstanceDocker
var SelectScene

func _on_btnChangePath_pressed():
	# var SelectScene = preload("res://addons/GhodBase.RunInstance/SelectScene.tscn").instance()
	SelectScene.OptionsDialog = self
	SelectScene.newInstanceDocker = newInstanceDocker
	SelectScene.current_dir = ProjectSettings.globalize_path("res://")
	get_tree().root.add_child(SelectScene)
	SelectScene.popup()

func _on_OptionsDialog_confirmed():
	var pidContainerInstance = preload("res://addons/GhodBase.RunInstance/PidContainer.tscn").instance()
	var options = ["--path", $VBoxContainer/Container/txtPath.text]
	
	if $VBoxContainer/chkDebugCollision.pressed:
		options.append("--debug-collisions")
	if $VBoxContainer/chkDebugNavigation.pressed:
		options.append("--debug-navigation")
	if $VBoxContainer/chkCommandLineDebug.pressed:
		options.append("--debug")
	if $VBoxContainer/chkOnTop.pressed:
		options.append("--always-on-top")
	
	options.append(current_path)
	var pid : int = OS.execute(OS.get_executable_path(), options, false)
	pidContainerInstance.pidId = pid
	pidContainerInstance.sceneName = current_path.get_file()
	pidContainerInstance.options = options
	pidContainerInstance.get_node("lblPid").text = current_path.get_file()+" "+String(pid)
	pidContainerInstance.newInstanceDocker = newInstanceDocker
	pidContainerInstance.id = randi() % 2000000000
	
	# add this configured instance to the GUI list
	newInstanceDocker.add_child(pidContainerInstance)
	newInstanceDocker.addKnownScene(options, current_path.get_file(), pidContainerInstance.id)

