extends Viewport

# https://youtu.be/07euJhZbeSc
# https://youtu.be/IijlGjDh8lk
# use Plugin of VR by Bastiaan Olij
# New https://github.com/GodotVR/godot_openxr OpenXR

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ownWorldItself = preload("res://Scenes/Zetrix/ZetrixWorld.tres")
var rootViewport

func ReceiveRootViewport(getIt:Viewport):
	rootViewport = getIt
	$PortScreen.ReceiveRootViewport(rootViewport)

func UninstallOwnWorld():
	own_world = false
	world = null
	$PortScreen.hide()

func ReinstallOwnWorld():
	world = ownWorldItself
	own_world = true
	$PortScreen.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
