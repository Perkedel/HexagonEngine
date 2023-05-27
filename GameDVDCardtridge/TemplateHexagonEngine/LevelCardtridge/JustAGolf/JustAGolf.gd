extends Node3D

@export (float) var scorePar = 0
@export (float) var limitStroke = 6
@onready var isPullingPutt = false
@onready var puttPower = 0.0
@onready var pullRelativeScreenPos = Vector2.ZERO
@onready var isItWalking = false

# https://www.reddit.com/r/godot/comments/bd2q87/how_to_make_a_camera_follow_the_player/
# https://docs.godotengine.org/en/latest/tutorials/inputs/input_examples.html#mouse-events
# https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html
# https://godotengine.org/

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal reportHP(level)
signal reportScore(number)
signal reportNextLevel(cardWhich)
signal BackMenuButton
signal ResetButton
signal NextLevelButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singletoner.isGamePaused:
		if$"MINI-UI".visible:
			 $"CanvasUI/MINI-UI".hide()
		pass
	else:
		if!$"CanvasUI/MINI-UI".visible:
			 $"CanvasUI/MINI-UI".show()
		pass
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !isPullingPutt and event.pressed:
			pullRelativeScreenPos = event.position
			$"CanvasUI/MINI-UI/DotRectAwal".position = event.position
			$"CanvasUI/MINI-UI/PowerProgress".position = event.position
			$Player/BolaGolf1.setYLaunch($CamStickPole.rotation.y)
			if !isItWalking:
				$"CanvasUI/MINI-UI/PowerProgress".show()
			isPullingPutt = true
			pass
		if isPullingPutt and !event.pressed:
			$"CanvasUI/MINI-UI/DotRectAkhir".position = event.position
			$"CanvasUI/MINI-UI/PowerProgress".hide()
			isPullingPutt = false
			pass
		pass
		
	if event is InputEventMouseMotion:
		if isPullingPutt:
			puttPower = (event.position.y - pullRelativeScreenPos.y) / 10
			puttPower = clamp(puttPower, 0, 10)
			$"CanvasUI/MINI-UI/PowerProgress".value = puttPower
			pass
		pass
		pass
	pass

func updateScoreAndHP():
	scorePar += 1.0
	emit_signal("reportScore", scorePar)
	emit_signal("reportHP", ( (limitStroke-scorePar) / limitStroke) * 100)
	pass


func _on_HoleSensor_body_entered(body):
	if body == $Player/BolaGolf1:
		$SpeakerYay.play()
		$"CanvasUI/MINI-UI/YayComplete".PopThisDialogWith("Congrats you finish Golf")
	pass # Replace with function body.


func _on_BolaGolf1_entered_goal():
	pass # Replace with function body.


func _on_BolaGolf1_noLongerWalking():
	print("Bola stop walking HUEUEUEUEUEUEUEEUUUUUUEEEEE")
	$SpeakerStopWalk.play()
	isItWalking = false
	if isPullingPutt:
		$"CanvasUI/MINI-UI/PowerProgress".show()
		pass
	pass # Replace with function body.


func _on_BolaGolf1_stroked():
	
	isItWalking = true
	updateScoreAndHP()
	pass # Replace with function body.


func _on_BolaGolf1_body_entered(body):
	if body == $TheLoadedCourse/CumanGolfCoursing/HoleSensor:
		print("Yep! ", body.name, " is indeed the hole sensor")
		pass
	pass # Replace with function body.


func _on_YayComplete_BackMenuButton():
	emit_signal("BackMenuButton")
	pass # Replace with function body.


func _on_YayComplete_NextLevelButton():
	emit_signal("NextLevelButton")
	pass # Replace with function body.


func _on_YayComplete_ResetButton():
	emit_signal("ResetButton")
	pass # Replace with function body.
