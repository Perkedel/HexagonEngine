extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isDrawerOpen = false
var DebugKeyMode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	pass


func _on_SamPlayArea_Hover_MoreMenu_Button():
	OpenMenuDrawer()
	pass # Replace with function body.


func _on_SamPlayArea_Press_Play_Button():
	#$AnimationPlayer.play("CloseMenu")
	pass # Replace with function body.


func _on_SamPlayArea_Hover_Play_Button():
	CloseMenuDrawer()
	
	pass # Replace with function body.

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
