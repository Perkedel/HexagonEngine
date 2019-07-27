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
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DebugKeyMode:
		if Input.is_key_pressed(KEY_1):
			#OpenMenuDrawer()
			pass
		if Input.is_key_pressed(KEY_2):
			#CloseMenuDrawer()
			pass
		pass
		
	if Input.is_action_just_pressed("ui_down"):
		#doMenuDrawerOpen = true
		pass
	if Input.is_action_just_pressed("ui_up"):
		#doMenuDrawerOpen = false
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

func ReplayButtoningAnimations():
	doMenuDrawerOpen = false;
	CloseMenuDrawer()
	$MenuButtonAnimations.play("InitMenu")
	$FocusArea/SamPlayArea.FocusPlayButtonNow()
	pass

func FocusPlayButtonNow():
	$FocusArea/SamPlayArea.FocusPlayButtonNow()
	#letsCloseMenuDrawer()
	pass

func FocusFirstMoreMenuButton():
	$MoreMenu/BoxMenuContainings/SettingButton/Button.grab_focus()
	pass


func _on_SamPlayArea_Hover_MoreMenu_Button():
	#letsOpenMenuDrawer()
	BecauseOpenMenuDrawer()
	pass # Replace with function body.

func _on_SamPlayArea_Hover_Play_Button():
	#letsCloseMenuDrawer()
	BecauseCloseMenuDrawer()
	pass # Replace with function body.

func letsOpenMenuDrawer():
	doMenuDrawerOpen = true
	pass

func letsCloseMenuDrawer():
	doMenuDrawerOpen = false
	pass

func BecauseOpenMenuDrawer():
	letsOpenMenuDrawer()
	FocusFirstMoreMenuButton()
	pass

func BecauseCloseMenuDrawer():
	letsCloseMenuDrawer()
	FocusPlayButtonNow()
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

signal PressPlayButton()
func _on_SamPlayArea_Press_Play_Button():
	#$AnimationPlayer.play("CloseMenu")
	emit_signal("PressPlayButton")
	pass # Replace with function body.

signal PressSettingButton()
func _on_SettingButton_Button_Pressingated():
	emit_signal("PressSettingButton")
	pass # Replace with function body.

signal PressUnknownButton()
func _on_UnknownButton_Button_Pressingated():
	emit_signal("PressUnknownButton")
	pass # Replace with function body.

signal PressExtrasButton()
func _on_ExtrasButton_Button_Pressingated():
	emit_signal("PressExtrasButton")
	pass # Replace with function body.

signal PressChangeDVDButton()
func _on_ChangeDVDButton_Button_Pressingated():
	emit_signal("PressChangeDVDButton")
	pass # Replace with function body.

signal PressExitButton()
func _on_ExitButton_Button_Pressingated():
	emit_signal("PressExitButton")
	pass # Replace with function body.
