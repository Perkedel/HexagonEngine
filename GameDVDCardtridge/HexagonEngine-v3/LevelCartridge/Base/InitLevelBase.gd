extends Node3D

class_name HexagonLevel
var whereMenuAreWe:String
var whereMenuAreWePrev:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recheckMenu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	super._process(delta)
	
	pass

func recheckMenu() -> String:
	whereMenuAreWe = Singletoner.currentMenu
	whereMenuAreWePrev = Singletoner.prevMenu
	return Singletoner.currentMenu
