extends ARVROrigin

# from OpenXR plugin Bastiaan Olij GodotVR
var interface : ARVRInterface
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func initialize() -> bool:
	var interface = ARVRServer.find_interface("OpenXR")
	if interface and interface.initialize():
		print("OpenXR Interface initialized")
		
		return true
	else:
		return false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#var interface = ARVRServer.find_interface("OpenXR")
	print("GO the VR now: " + String(initialize()))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
