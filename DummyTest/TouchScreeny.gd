extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# https://docs.godotengine.org/en/3.1/classes/class_touchscreenbutton.html

# TouchScreen Only
func _on_TouchScreenButton_pressed():
	print("TouchScreen Press")
	pass # Replace with function body.


func _on_TouchScreenButton_released():
	print("TouchScreen Release")
	pass # Replace with function body.

#Mouse & emulate mouse only
func _on_Button_pressed():
	print("Button Press")
	pass # Replace with function body.


func _on_Button_button_up():
	print("Button Release")
	pass # Replace with function body.


func _on_Button_button_down():
	print("Button Down")
	pass # Replace with function body.
