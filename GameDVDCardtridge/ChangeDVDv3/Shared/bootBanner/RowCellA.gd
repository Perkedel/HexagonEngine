@tool
extends HBoxContainer

# Rimborn please add "Made with -Unity- Godot" here
@export var imageFile: Texture2D = load("res://Sprites/HexagonEngineLogo.png")

@export var startAppearTime: float = .3
@export var startInflateTime: float = 3
@export var plusDisappearIn: float = 1
@export var stopAppearTime: float = 1

@onready var tween = $Tween
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ImDone()


# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property($Splash,"modulate",Color(1,1,1,0),Color(1,1,1,1),startAppearTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.interpolate_property($Splash,"scale",Vector2(.75,.75),Vector2(1,1),startInflateTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.interpolate_property($Splash,"modulate",Color(1,1,1,1),Color(1,1,1,0),stopAppearTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, startAppearTime+plusDisappearIn)
	
	tween.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Splash.texture = imageFile
	pass

func justSkipAlready():
	print("\n\nOkay I'm skip!\n\n")
	tween.stop_all()
	emit_signal("ImDone")
	pass


func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.

func startNow():
	tween.start()
	pass

func _on_Tween_tween_all_completed():
	emit_signal("ImDone")
	pass # Replace with function body.
