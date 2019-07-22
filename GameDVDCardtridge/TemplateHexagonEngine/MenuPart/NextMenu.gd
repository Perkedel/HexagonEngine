extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var TitleBarName = "NextMenu Title Bar!"
export(Image) var TitleIcon
export(PackedScene) var MainMenuBack
export(PackedScene) var GameplayArea
export(PackedScene) var SettingArea
export(PackedScene) var UnknownArea #area51
export(PackedScene) var ExtrasArea
export(NodePath) var PrevNode
export(NodePath) var NextNode

enum SelectMenuList {Setting=0,Unknown=1,Extras=2, Gameplay = 3}
export(SelectMenuList) var SelectYourMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	#LetsChangeScene
	SoftLetsChangeScene()
	pass # Replace with function body.

func ChangeMenuSpace(CurrentFrom, IntoNewSpace):
	# https://godotengine.org/qa/24773/how-to-load-and-change-scenes
	# Remove the current level
	var level = CurrentFrom
	remove_child(level)
	level.call_deferred("free")
	
	# Add the next level
	var next_level_resource = IntoNewSpace
	var next_level = next_level_resource.instance()
	$VBoxContainer/MenuSpaceArea.add_child(next_level)
	pass

func SoftChangeMenuSpace(CurrentFrom, IntoNewSpace):
	CurrentFrom.hide()
	IntoNewSpace.show()
	
	pass

func LetsChangeScene():
	var CurrentMenuSpace = $VBoxContainer/MenuSpaceArea.get_child(0)
	if SelectYourMenu == SelectMenuList.Setting:
		# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position 
		# https://godotengine.org/qa/24773/how-to-load-and-change-scenes
		ChangeMenuSpace(CurrentMenuSpace, SettingArea)
		$VBoxContainer/MenuSpaceArea/SettingArea/HBoxContainer/CategoryScrolling/CategorySelection/AudioCategory.grab_focus()
		pass
	elif SelectYourMenu == SelectMenuList.Unkown:
		pass
	elif SelectYourMenu == SelectMenuList.Extras:
		pass
	elif SelectYourMenu == SelectMenuList.Gameplay:
		pass
	
	pass

func SoftLetsChangeScene():
	PrevNode = $VBoxContainer/MenuSpaceArea.get_child(0)
	if SelectYourMenu == SelectMenuList.Setting:
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/SettingArea)
		
		$VBoxContainer/MenuSpaceArea/SettingArea/HBoxContainer/CategoryScrolling/CategorySelection/AudioCategory.grab_focus()
		pass
	elif SelectYourMenu == SelectMenuList.Unkown:
		pass
	elif SelectYourMenu == SelectMenuList.Extras:
		pass
	elif SelectYourMenu == SelectMenuList.Gameplay:
		pass
	pass

func EnterWhichMenu(WhichOne):
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_9):
		LetsChangeScene()
		pass
	$VBoxContainer/HeadingBar/TitleBarArea/Label.text = TitleBarName
	$VBoxContainer/HeadingBar/IconArea/TextureRect.texture = TitleIcon
	pass


func _on_BackButton_pressed():
	ReturnToMainMenu()
	pass # Replace with function body.


func _on_BackButton_mouse_entered():
	pass # Replace with function body.


func _on_BackButton_focus_entered():
	pass # Replace with function body.

func ReturnToMainMenu():
	
	pass
