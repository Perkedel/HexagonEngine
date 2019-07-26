extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ScrollCategory = $HBoxContainer/CategoryScrolling
onready var ScrollContainings = $HBoxContainer/ScrollContainer
const ScrollSensitive = 2
var mouse_button_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func FocusFirstCategoryButtonNow():
	$HBoxContainer/CategoryScrolling/CategorySelection/InheritableCategoryButton.grab_focus()
	pass

func _on_CategoryScrolling_gui_input(event):
	# https://godotforums.org/discussion/20206/swipe-function-with-scroll
	if (event is InputEventMouseButton):
		if (event.button_index == BUTTON_LEFT):
			mouse_button_down = event.pressed
			pass
		pass
	# Scroll with the mouse
	if (event is InputEventMouseMotion and mouse_button_down == true):
		ScrollCategory.scroll_vertical += event.speed.y * ScrollSensitive
	# Scroll with touch
	if (event is InputEventScreenDrag):
		ScrollCategory.scroll_vertical += event.relative.y
	pass # Replace with function body.


func _on_ScrollContainer_gui_input(event):
	pass # Replace with function body.

