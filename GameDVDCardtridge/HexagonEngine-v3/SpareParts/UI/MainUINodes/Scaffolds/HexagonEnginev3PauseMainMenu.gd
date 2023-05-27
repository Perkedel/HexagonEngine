extends Control

@onready var tween = $aTween
@onready var titler = $KonMenu/TitleHeader
@onready var navigator = $KonMenu/MenuNavigation
@export var howLong: float = .5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal doChangeDVD
signal doShutdown
@onready var PortraitMode = false

func preAnimate():
	var NavpositionBefore = navigator.position
	tween.interpolate_property(titler, "position", Vector2(0,-titler.size.y),Vector2.ZERO, howLong, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(navigator, "position", Vector2(0,navigator.position.y+navigator.size.y),NavpositionBefore, howLong, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	tween.start()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	preAnimate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
