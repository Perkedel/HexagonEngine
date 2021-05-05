extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()
# TODO remove signal requirement connection. use Singletoner.ChangeDVD or Shutdown to execute commands of it. makes it easier should it be!

# https://youtu.be/nFcBSuzxFdM how to yield a tween
# yield the tween node object and wait for "tween_completed" signal from it.

onready var anTween:Tween = $Tween
onready var anButton1:NodePath = "./UIixef/BaseOf/Scene1/Button1"
onready var anButton2:NodePath = "./UIixef/BaseOf/Scene2/Button2"
onready var buttonNo:int = 1
onready var onGoing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Panel.hide()
	$UIixef/BaseOf/Scene2.hide()
	$UIixef/BaseOf/Scene1/Button1.grab_focus()
	#$UIMeta/QuitButtons/TheyContains/ChangeDVD.focus_neighbour_top = anButton1
	#$UIMeta/QuitButtons/TheyContains/Shutdown.focus_neighbour_top = anButton1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func TransitionNext():
	if !onGoing:
		onGoing = true
		$CanvasLayer/Panel.show()
		$CanvasLayer/Panel.self_modulate = Color(0,0,0, 0)
		anTween.interpolate_property($CanvasLayer/Panel,"self_modulate", Color(0,0,0,0), Color(0,0,0,1), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		anTween.start()
		yield(anTween, "tween_completed")
		$UIixef/BaseOf/Scene1.hide()
		$UIixef/BaseOf/Scene2.show()
		anTween.interpolate_property($CanvasLayer/Panel,"self_modulate", Color(0,0,0,1), Color(0,0,0,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		anTween.start()
		yield(anTween, "tween_completed")
		$UIixef/BaseOf/Scene2/Button2.grab_focus()
		#$UIMeta/QuitButtons/TheyContains/ChangeDVD.set_focus_neighbour(MARGIN_TOP,anButton2)
		#$UIMeta/QuitButtons/TheyContains/Shutdown.set_focus_neighbour(MARGIN_TOP,anButton2)
		buttonNo = 2
		$CanvasLayer/Panel.hide()
		onGoing = false
	pass

func TransitionPlsGoBack():
	if !onGoing:
		onGoing = true
		$CanvasLayer/Panel.show()
		$CanvasLayer/Panel.self_modulate = Color(0,0,0, 0)
		anTween.interpolate_property($CanvasLayer/Panel,"self_modulate", Color(0,0,0,0), Color(0,0,0,1), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		anTween.start()
		yield(anTween, "tween_completed")
		$UIixef/BaseOf/Scene1.show()
		$UIixef/BaseOf/Scene2.hide()
		anTween.interpolate_property($CanvasLayer/Panel,"self_modulate", Color(0,0,0,1), Color(0,0,0,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		anTween.start()
		yield(anTween, "tween_completed")
		$UIixef/BaseOf/Scene1/Button1.grab_focus()
		#$UIMeta/QuitButtons/TheyContains/ChangeDVD.set_focus_neighbour(MARGIN_TOP,anButton1)
		#$UIMeta/QuitButtons/TheyContains/Shutdown.set_focus_neighbour(MARGIN_TOP,anButton1)
		buttonNo = 1
		$CanvasLayer/Panel.hide()
		onGoing = false
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		match buttonNo:
			1:
				$UIixef/BaseOf/Scene1/Button1.grab_focus()
				pass
			2:
				$UIixef/BaseOf/Scene2/Button2.grab_focus()
				pass
			_:
				pass
		pass
	pass


func _on_Button1_pressed():
	TransitionNext()
	pass # Replace with function body.


func _on_Button2_pressed():
	TransitionPlsGoBack()
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	pass # Replace with function body.


func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.


func _on_Shutdown_pressed():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.


func _on_ChangeDVD_pressed():
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.
