@tool
extends Node2D

#InputMaps
@export var HideHUD: bool = true
@export var HideHudCommand: String
@export var HideControllerListPrint: bool = true
var InputMaps = InputMap.get_actions()
@onready var Searchinput = InputMaps.find(HideHudCommand,0)

#ScaleInputs
@export var UpScallerHUD: String
@export var DownScallerHUD: String
@export var HUDScale: float = 1
@onready var SearchInputUp = InputMaps.find(UpScallerHUD, 0)
@onready var SearchInputDown = InputMaps.find(DownScallerHUD, 0)

var ViewerScene : PackedScene = preload("res://addons/ControllerInputViewer/ControllerHud/ControllerInputViewer.tscn")

func _ready():
	if !Engine.is_editor_hint():
		var SceneInt = ViewerScene.instantiate()
			
		add_child(SceneInt)
		SceneInt.set_owner(get_tree().get_edited_scene_root())
		
	if HideControllerListPrint == true:
		print("Joypads Connected:",Input.get_connected_joypads().size())

func _process(delta):
	if !Engine.is_editor_hint():
#Hide and Show preset
		var HUDHideVar = get_node("ControllerHud").get("ConHUDView")
		
		HUDHideVar = HideHUD
		
#Hide and Show Controller HUD Input
		if Searchinput >= 0:
			if Input.is_action_just_pressed(HideHudCommand):
				HideHUD =! HideHUD
			
			get_node("ControllerHud").visible = HideHUD
			
#HUD Scaller
		var HUDScaller = get_node("ControllerHud").scale
		var ChildExist = false
		
		get_node("ControllerHud").scale = lerp(get_node("ControllerHud").scale,Vector2(HUDScale,HUDScale), 25 * delta)
		
		if SearchInputUp >= 0:
			if Input.is_action_just_pressed(UpScallerHUD):
				if HUDScale <= 4:
					HUDScale = HUDScale + 0.3
				
		if SearchInputDown >= 0:
			if Input.is_action_just_pressed(DownScallerHUD):
				if HUDScale >= 0.3:
					HUDScale = HUDScale - 0.3
	
func _enter_tree():
	pass
		
