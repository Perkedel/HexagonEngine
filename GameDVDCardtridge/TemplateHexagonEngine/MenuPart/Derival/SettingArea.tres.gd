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

func StopTesting():
	$HBoxContainer/ScrollContainer/SeriouslyContainer/AudioCategoryArea.StopTesting()
	$HBoxContainer/ScrollContainer/SeriouslyContainer/InheritableCategoryArea/TestoidMusicPlayer.DeToggle()
	pass

func FocusFirstCategoryButtonNow():
	#$HBoxContainer/CategoryScrolling/CategorySelection/InheritableCategoryButton.grab_focus()
	$HBoxContainer/CategoryScrolling/CategorySelection/AudioSection.grab_focus()
	pass

func _on_CategoryScrolling_gui_input(event):
	# https://godotforums.org/discussion/20206/swipe-function-with-scroll
	# Oops, it's no longer required becaue Internal Godot Touch Screen can scroll the ScrollCOntainer with Drag finger!
#	if (event is InputEventMouseButton):
#		if (event.button_index == BUTTON_LEFT):
#			mouse_button_down = event.pressed
#			pass
#		pass
#	# Scroll with the mouse
#	if (event is InputEventMouseMotion and mouse_button_down == true):
#		ScrollCategory.scroll_vertical += event.speed.y * ScrollSensitive
#		pass
#	# Scroll with touch
#	if (event is InputEventScreenDrag):
#		ScrollCategory.scroll_vertical += event.relative.y
#		pass
	
	
	pass # Replace with function body.

func HideAllSettingContent():
	var SeriouslyCount = $HBoxContainer/ScrollContainer/SeriouslyContainer.get_child_count()
	for i in range(1, SeriouslyCount+1):
		var TargetSectionButton = $HBoxContainer/ScrollContainer/SeriouslyContainer.get_child(i).get_tree()
		TargetSectionButton.hide()
		TargetSectionButton.UnPressSectionButton()
		pass
	pass

func _on_ScrollContainer_gui_input(event):
	# Wrong Signal
	pass # Replace with function body.

func _on_InheritableCategoryButton_LoadThisCategoryPlease(CategoryScenePath):
	#HideAllSettingContent()
	#$HBoxContainer/ScrollContainer/SeriouslyContainer/InheritableCategoryArea.show()
	pass # Replace with function body.


func _on_AudioSection_LoadThisCategoryPlease(CategoryScenePath):
	#HideAllSettingContent()
	#$HBoxContainer/ScrollContainer/SeriouslyContainer/AudioCategoryArea.show()
	pass # Replace with function body.


func _on_InheritableCategoryButton_StatusPressed(value):
	if value:
		$HBoxContainer/ScrollContainer/SeriouslyContainer/InheritableCategoryArea.show()
		pass
	else:
		$HBoxContainer/ScrollContainer/SeriouslyContainer/InheritableCategoryArea.hide()
		pass
	pass # Replace with function body.


func _on_AudioSection_StatusPressed(value):
	if value:
		$HBoxContainer/ScrollContainer/SeriouslyContainer/AudioCategoryArea.show()
		pass
	else:
		$HBoxContainer/ScrollContainer/SeriouslyContainer/AudioCategoryArea.hide()
		pass
	pass # Replace with function body.
