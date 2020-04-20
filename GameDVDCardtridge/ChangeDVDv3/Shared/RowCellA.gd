extends HBoxContainer

export(Texture) var imageFile = load("res://Sprites/HexagonEngineLogo.png")

export(float) var startAppearTime = .3
export(float) var startInflateTime = 5
export(float) var plusDisappearIn = 2
export(float) var stopAppearTime = 1

onready var tween = $Tween
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property($Splash,"modulate",Color(1,1,1,0),Color(1,1,1,1),startAppearTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.interpolate_property($Splash,"rect_scale",Vector2(.75,.75),Vector2(1,1),startInflateTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.interpolate_property($Splash,"modulate",Color(1,1,1,1),Color(1,1,1,0),stopAppearTime,Tween.TRANS_LINEAR,Tween.EASE_OUT, startAppearTime+plusDisappearIn)
	
	tween.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.
