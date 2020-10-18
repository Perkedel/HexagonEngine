extends Node

export var bootJsonPatho : String = "res://GameDVDCardtridge/ExtAppOpener/boot.json"
var bootFile : File
enum OpenModes {shellOpen,OSExecute}
var open_mode
var output = []
var pid_error_code
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	bootFile = File.new()
	var tryeCode = bootFile.open(bootJsonPatho,File.READ)
	if tryeCode == OK:
		var jsonContent = parse_json(bootFile.get_as_text())
		if jsonContent["args"][0] == "shellOpen":
			print("\n\nOpen Shell url now!")
			open_mode = OpenModes.shellOpen
			OS.shell_open(jsonContent["args"][1])
			pass
		elif jsonContent["args"][0] == "OSExecute":
			print("\n\nExecute app now!")
			open_mode = OpenModes.OSExecute
			print("\n\nRun ", jsonContent["args"][1], "\n args ", String(jsonContent["appArgs"]))
			pid_error_code = OS.execute(jsonContent["args"][1], jsonContent["appArgs"], jsonContent["doBlocking"], output, jsonContent["readStdErr"])
			print("\n\npid or error code ", pid_error_code)
			pass
		else:
			pass
	else:
		printerr("Fatal error! boot.json cannot open!!! Code ", tryeCode)
	bootFile.close()
	yield(get_tree().create_timer(1),"timeout")
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
