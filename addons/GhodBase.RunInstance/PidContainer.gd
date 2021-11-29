tool
extends HBoxContainer
class_name PidContainer

var pidId : int = -1
var sceneName : String = ""
var output : Array = []
var options : Array = []
var id : int = -1
var newInstanceDocker

func _on_btnKill_pressed():
	if pidId > 0:
		OS.kill(pidId)
		$lblPid.text = sceneName


func _on_btnViewOutput_pressed():
	var outputDialogInstance = preload("res://addons/GhodBase.RunInstance/OutputDialog.tscn").instance()
	outputDialogInstance.get_node("lblOutput").text = String(output)
	get_tree().root.add_child(outputDialogInstance)
	outputDialogInstance.show()


func _on_btnReRun_pressed():
	restartProcess(true)

func restartProcess(force : bool = false):
	if force or ($chkRestart as CheckBox).pressed:
		if pidId > 0:
			OS.kill(pidId)
		var pid = OS.execute(OS.get_executable_path(), options, false, output)
		pidId = pid
		$lblPid.text = sceneName+" "+String(pid)

func _on_btnRemove_pressed():
	if pidId > 0:
		OS.kill(pidId)
	newInstanceDocker.removeKnownScene(id)
	queue_free()
