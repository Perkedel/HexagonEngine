extends Node

# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_exports.html
enum OpenModes {shellOpen,OSExecute}
@export var open_mode: OpenModes
@export var target: String = "https://cointr.ee/joelwindows7"
@export var appArgs :PackedStringArray
@export var doBlocking :bool = false
@export var readStdErr :bool = false
#export var requiredEggselents:PoolStringArray
var pid_error_code
var output = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	match open_mode:
		OpenModes.shellOpen:
			print("\n\nOpen Shell url now! ", target)
			OS.shell_open(target)
			pass
		OpenModes.OSExecute:
			print("\n\nExecute app now! ", target)
			pid_error_code = OS.execute(target, appArgs, doBlocking, output, readStdErr)
			print("\n\npid or error code ", pid_error_code)
			pass
	
	await get_tree().create_timer(1).timeout
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
