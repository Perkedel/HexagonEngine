extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectCartridge()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ConnectCartridge():
	connect("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec")
	connect("Shutdown_Exec", self, "_on_Shutdown_Exec")
	pass

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass


func _on_ChangeDVD_Exec():
	pass # Replace with function body.


func _on_Shutdown_Exec():
	pass # Replace with function body.
