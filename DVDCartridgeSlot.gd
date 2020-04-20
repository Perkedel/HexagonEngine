extends Node

var InstanceDVD
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	CheckDVD()
	ConnectCartridge()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func CheckDVD():
	InstanceDVD = get_child(0)
	pass

func ConnectCartridge():
	# Connect important signals of basically every DVD Cartridge
	print("Connect Cartridge") #cartride connecc say
	get_child(0).connect("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec")
	get_child(0).connect("Shutdown_Exec", self, "_on_Shutdown_Exec")
	pass

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	CheckDVD()
	if InstanceDVD:
		InstanceDVD.queue_free()
		pass
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass

signal DVDTryLoad
func PlayDVD(LoadDVD):
	emit_signal("DVDTryLoad")
	InstanceDVD = LoadDVD.instance()
	add_child(InstanceDVD)
	ConnectCartridge()
	pass

func _exit_tree():
	CheckDVD()
	if InstanceDVD:
		InstanceDVD.queue_free()
		pass
	pass

func _on_ChangeDVD_Exec():
	ExecuteChangeDVD()
	pass # Replace with function body.


func _on_Shutdown_Exec():
	ExecuteShutdown()
	pass # Replace with function body.


func _on_TemplateHexagonEngine_Shutdown_Exec():
	pass # Replace with function body.
