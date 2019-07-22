extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isDrawerOpen = false
var DebugKeyMode = false
var doMenuDrawerOpen = false
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for buttonings in $MoreMenu/BoxMenuContainings.get_children():
		buttonings.connect("Button_Pressingated", self, "_on_MoreButton_Pressed", [buttonings.callTheFunction])
		pass
	pass # Replace with function body.

func _on_MoreButton_Pressed(callFunction):
	if callFunction == "GoToNextMenuOf":
		GoToNextMenuOf(PassMenuScene)
		pass
	pass

func GoToNextMenuOf(NameOfScene):
	#get_tree().change_scene(NameOfScene) #dont use change scene! it will replace entire node
	var currMenu = get_node("../../")
	remove_child(currMenu)
	currMenu.call_deferred("free")
	var NextMenu = load(PassMenuScene)
	var GoNextMenu = NextMenu.instance()
	get_node("../../").add_child(GoNextMenu)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DebugKeyMode:
		if Input.is_key_pressed(KEY_1):
			OpenMenuDrawer()
			pass
		if Input.is_key_pressed(KEY_2):
			CloseMenuDrawer()
			pass
		pass
		
	if Input.is_action_just_pressed("ui_down"):
		doMenuDrawerOpen = true
		pass
	if Input.is_action_just_pressed("ui_up"):
		doMenuDrawerOpen = false
		pass
	
	if doMenuDrawerOpen:
		if not isDrawerOpen:
			OpenMenuDrawer()
			pass
		pass
	else:
		if isDrawerOpen:
			CloseMenuDrawer()
			pass
		pass
	pass


func _on_SamPlayArea_Hover_MoreMenu_Button():
	letsOpenMenuDrawer()
	pass # Replace with function body.


func _on_SamPlayArea_Press_Play_Button():
	#$AnimationPlayer.play("CloseMenu")
	pass # Replace with function body.


func _on_SamPlayArea_Hover_Play_Button():
	letsCloseMenuDrawer()
	pass # Replace with function body.

func letsOpenMenuDrawer():
	doMenuDrawerOpen = true
	pass

func letsCloseMenuDrawer():
	doMenuDrawerOpen = false
	pass



func OpenMenuDrawer():
	if not isDrawerOpen:
		$MenuButtonAnimations.play("OpenMenu")
		isDrawerOpen = true
	pass

func CloseMenuDrawer():
	if isDrawerOpen:
		$MenuButtonAnimations.play("CloseMenu")
		isDrawerOpen = false
	pass


func _on_SettingButton_focus_entered():
	pass # Replace with function body.


func _on_SettingButton_Button_Pressingated():
	
	pass # Replace with function body.


func _on_UnknownButton_Button_Pressingated():
	pass # Replace with function body.


func _on_ExtrasButton_Button_Pressingated():
	pass # Replace with function body.


func _on_ChangeDVDButton_Button_Pressingated():
	pass # Replace with function body.


func _on_ExitButton_Button_Pressingated():
	pass # Replace with function body.
