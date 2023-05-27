extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isDrawerOpen = false
var DebugKeyMode = false
var doMenuDrawerOpen = false
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"
enum PositionsMenu {Init,Close,Open = 0}
var PrevPosition
var NowPosition
@onready var y_size_init = size.y
var y_pos_prev
@onready var y_pos_init = position.y
@onready var y_compensate_close_drawer = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	y_pos_init = position.y
	pass # Replace with function body.

func SetExitLabel(name:String):
	$MoreMenu/BoxMenuContainings/ExitButton.ButtonLabelName = name
	pass

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

func _input(event):
	if event is InputEventKey:
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
	#$MoreMenu/BoxMenuContainings/SettingButton/Button.grab_focus()
	$MoreMenu/BoxMenuContainings/SettingButton.FocusMeThisButton()
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

func ResetMoreMenuButtonAnimatione():
	for Morebuttoner in $MoreMenu/BoxMenuContainings.get_children():
		Morebuttoner.ResetAnimatione()
		pass
	pass

func OpenMenuDrawer():
	if not isDrawerOpen:
		y_pos_prev = position.y
		$MenuButtonTweens.interpolate_property(self,"position",Vector2(0,y_pos_prev),Vector2(0,get_parent_control().size.y-size.y),.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$MenuButtonTweens.start()
		#yield($MenuButtonTweens,"tween_completed")
		#$MenuButtonAnimations.play("OpenMenu")
		isDrawerOpen = true
	pass

func CloseMenuDrawer():
	if isDrawerOpen:
		y_pos_prev = position.y
		$MenuButtonTweens.interpolate_property(self,"position",Vector2(0,y_pos_prev),Vector2(0,get_parent().size.y-($FocusArea.size.y+y_compensate_close_drawer)),.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$MenuButtonTweens.start()
		#yield($MenuButtonTweens,"tween_completed")
		#$MenuButtonAnimations.play("CloseMenu")
		ResetMoreMenuButtonAnimatione()
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


func _on_SettingButton_Button_Hoverated():
	$MoreMenu/BoxMenuContainings/SettingButton.FocusMeThisButton()
	pass # Replace with function body.


func _on_UnknownButton_Button_Hoverated():
	$MoreMenu/BoxMenuContainings/UnknownButton.FocusMeThisButton()
	pass # Replace with function body.


func _on_ExtrasButton_Button_Hoverated():
	$MoreMenu/BoxMenuContainings/ExtrasButton.FocusMeThisButton()
	pass # Replace with function body.


func _on_ChangeDVDButton_Button_Hoverated():
	$MoreMenu/BoxMenuContainings/ChangeDVDButton.FocusMeThisButton()
	pass # Replace with function body.


func _on_ExitButton_Button_Hoverated():
	$MoreMenu/BoxMenuContainings/ExitButton.FocusMeThisButton()
	pass # Replace with function body.
