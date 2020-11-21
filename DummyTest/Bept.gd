extends Control

# https://godotengine.org/qa/8893/special-characters-in-labels
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#string
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_format_string.html#doc-gdscript-printf
# https://docs.godotengine.org/en/stable/classes/class_string.html
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	print("Bept the \a \uf071")
	pass # Replace with function body.
