extends Button

@export var contextInputMapName: PackedStringArray:PackedStringArray = ["ui_cancel"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ControllerType{KeyboardMouse,Keyboard,Mouse,Gamepad, Touchscreen}
enum ControllerBrand{Sony, Microsoft, Nintendo, Oculus, OpenVR}
enum DirectionArrow{Cross,Horizonal,Vertical,Diagonal,Rotate,Half_Rotate,Quarter_Rotate,One_Way}
var lastControllerType = ControllerType.KeyboardMouse
var lastControllerBetween = ControllerType.KeyboardMouse
var isInGamePad = false
var isAMouse = false # is the context being observed a mouse?
var isGamepadButton = false # is the gamepad context being a button?
var actionList:Array
@onready var filteredActionList:Dictionary = {
	counts = {
		type_InputEventKey = 0,
		type_InputEventJoypadButton = 0,
		type_InputEventJoypadMotion = 0,
		type_InputEventMouseButton = 0
	},
	Listing = {
		type_InputEventKey = {},
		type_InputEventJoypadButton = {},
		type_InputEventJoypadMotion = {},
		type_InputEventMouseButton = {}
	}
}
@onready var filter_InputEventKey:Array
@onready var filter_InputEventJoypadButton:Array
@onready var filter_InputEventJoypadMotion:Array
@onready var filter_InputEventMouseButton:Array
@onready var texture_InputEventKey:Array
@onready var texture_InputEventMouseButton:Array
@onready var texture_InputEventKeyboardMouse:Array
@onready var texture_InputEventJoypad:Array
@onready var texture_InputEventJoypadButton:Array
@onready var texture_InputEventJoypadMotion:Array
@onready var texture_InputEventNeither:Array
@onready var counter_InputEventKey:int = 0
@onready var counter_InputEventMouseButton:int = 0
@onready var counter_InputEventKeyboardMouse:int = 0
@onready var counter_InputEventJoypadButton:int = 0
@onready var counter_InputEventJoypadMotion:int = 0
@onready var counter_InputEventJoypad:int = 0
var theActionEventOfIt # is dynamic, supposedly any InputEvent based such as InputEventKey, InputEventJoypadButton, etc. etc.
var gamepadName:String
var gamepadGuid:String
var isDirection:bool = false
var contains_InputEventKey:bool = false
var contains_InputEventMouseButton:bool = false
var contains_InputEventJoypadButton:bool = false
var contains_InputEventJoypadMotion:bool = false

@onready var overTopImager = $OverTop

@export var whichGamepad: int = 0
@export var tempThemePathment: String = "res://assets/ExtraImport/Xelu_Free_Controller&Key_Prompts/"

@export var tempGamepadImage: Texture2D = load(tempThemePathment + "PS5/PS5_Circle.png")
@export var tempGamepadButtonImage: Texture2D = load(tempThemePathment + "PS5/PS5_Circle.png")
@export var tempGamepadMotionImage: Texture2D = load(tempThemePathment + "PS5/PS5_Left_Stick.png")
@export var tempOverTopImage: Texture2D
@export var tempKeyboardMouseImage: Texture2D = load(tempThemePathment + "Keyboard & Mouse/Light3D/Esc_Key_Light.png")
@export var tempKeyboardImage: Texture2D = load(tempThemePathment + "Keyboard & Mouse/Light3D/Esc_Key_Light.png")
@export var tempMouseImage: Texture2D = load(tempThemePathment + "Keyboard & Mouse/Light3D/Mouse_Simple_Key_Light.png")
@export var tempTouchscreenImage: Texture2D = load("res://Sprites/KembaliButton.png")
@export var tempNeitherImage: Texture2D = load("res://Sprites/MavrickleIcon.png")
@export var _debug_printNow: bool:bool = false

func _returnJoyPadButton(button_index:int)->String:
	# TODO: wrap by different brand of console
	match(button_index):
		JOY_SONY_TRIANGLE:
			return tempThemePathment + "PS5/PS5_Triangle.png"
			pass
		JOY_SONY_CIRCLE:
			return tempThemePathment + "PS5/PS5_Circle.png"
			pass
		JOY_SONY_X:
			return tempThemePathment + "PS5/PS5_Cross.png"
			pass
		JOY_SONY_SQUARE:
			return tempThemePathment + "PS5/PS5_Square.png"
			pass
		_:
			pass
	
	return "res://Sprites/MavrickleIcon.png"
	pass

func _checkJoyPadButton(button_index:int) -> Texture2D:
	if _debug_printNow:
		print("Joypad Button of " + String(button_index)) 
	tempGamepadImage = load(_returnJoyPadButton(button_index))
	return tempGamepadImage
	pass

func _returnJoypadAxis(axis_index:int)->String:
	match(axis_index):
		JOY_ANALOG_LX: #L horizontal
			_checkDirection(DirectionArrow.Horizonal)
			return tempThemePathment + "PS5/PS5_Left_Stick.png"
			pass
		JOY_ANALOG_LY: #L Vertical
			_checkDirection(DirectionArrow.Vertical)
			return tempThemePathment + "PS5/PS5_Left_Stick.png"
			pass
		JOY_ANALOG_RX: #R Horizonal
			_checkDirection(DirectionArrow.Horizonal)
			return tempThemePathment + "PS5/PS5_Right_Stick.png"
			pass
		JOY_ANALOG_RY: #R Vertical
			_checkDirection(DirectionArrow.Vertical)
			return tempThemePathment + "PS5/PS5_Right_Stick.png"
			pass
		JOY_ANALOG_L2:
			return tempThemePathment + "PS5/PS5_L2.png"
			pass
		JOY_ANALOG_R2:
			return tempThemePathment + "PS5/PS5_R2.png"
			pass
		_:
			pass
	
	return "res://Sprites/MavrickleIcon.png"
	pass

func _checkJoyPadAxis(axis_index:int) -> Texture2D:
	if _debug_printNow:
		print("Joypad Axis of " + String(axis_index)) 
	tempGamepadImage = load(_returnJoypadAxis(axis_index))
	tempGamepadMotionImage = load(_returnJoypadAxis(axis_index))
	isDirection = true
	return tempGamepadMotionImage
	pass

func _returnDirection(chooseEnum)->String:
	match(chooseEnum):
		DirectionArrow.Cross:
			return tempThemePathment + "Others/Arrows/Directional_Arrow_Cross.png"
			pass
		DirectionArrow.Horizonal:
			return tempThemePathment + "Others/Arrows/Directional_Arrow_Horizontal.png"
			pass
		DirectionArrow.Vertical:
			return tempThemePathment + "Others/Arrows/Directional_Arrow_Vertical.png"
			pass
		_:
			pass
	
	return "res://Sprites/MavrickleIcon.png"

func _checkDirection(chooseEnum):
	overTopImager.texture = load(_returnDirection(chooseEnum))
	overTopImager.visible = true
	pass

func _calculateFunctionKey(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light3D/F" + String((button_index - KEY_F1) + 1) + "_Key_Light.png"

func _calculateAlphabeticKey(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light3D/"+ char(button_index) +"_Key_Light.png"

func _calculateNumericRow(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light3D/"+ String(button_index - KEY_0) +"_Key_Light.png"

func _calculateNumpad(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light3D/"+ String(button_index - KEY_KP_0) +"_Key_Light.png"

func _returnKeyboardButton(button_index:int)->String:
	if button_index >= KEY_A and button_index <= KEY_Z:
		return _calculateAlphabeticKey(button_index)
	
	if button_index >= KEY_0 and button_index <= KEY_9:
		return _calculateNumericRow(button_index)
	
	if button_index >= KEY_KP_0 and button_index <= KEY_KP_9:
		return _calculateNumpad(button_index)
	
	match(button_index):
		KEY_ESCAPE:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Esc_Key_Light.png"
			pass
		KEY_ENTER:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Enter_Alt_Key_Light.png"
			pass
		KEY_KP_ENTER:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Enter_Tall_Key_Light.png"
		KEY_SPACE:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Space_Key_Light.png"
		_:
			pass
	
	if button_index >= KEY_F1 and button_index <= KEY_F12:
		return _calculateFunctionKey(button_index)
		pass
	
	return "res://Sprites/MavrickleIcon.png"
	pass

func _checkKeyboardButton(button_index:int) -> Texture2D:
	overTopImager.visible = false
	if _debug_printNow:
		print("Keyboard Scancode of " + String(button_index))
	tempKeyboardMouseImage = load(_returnKeyboardButton(button_index))
	tempKeyboardImage = load(_returnKeyboardButton(button_index))
	return tempKeyboardImage
	pass

func _returnMouseButton(button_index:int)->String:
	match(button_index):
		0:
			pass
		1:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Mouse_Left_Key_Light.png"
		2:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Mouse_Right_Key_Light.png"
		3:
			return tempThemePathment + "Keyboard & Mouse/Light3D/Mouse_Middle_Key_Light.png"
		_:
			pass
	return "res://Sprites/MavrickleIcon.png"

func _checkMouseButton(button_index:int) -> Texture2D:
	if _debug_printNow:
		print("Mouse Index of " + String(button_index))
	tempKeyboardMouseImage = load(_returnMouseButton(button_index))
	tempMouseImage = load(_returnMouseButton(button_index))
	return tempMouseImage
	pass

func _checkKeyboardMouseButton():
	pass

func _retrieveActionContext():
	#TODO reset contains
	
	isDirection = false # reset the flag first
	actionList = InputMap.action_get_events(contextInputMapName[0])
	if _debug_printNow:
		print(String(actionList))
	# TODO: watch for copy of InputEvent as there may be one another with same datatype. e.g. ui_accept has ENTER & SPACE, both are InputEventKey. it indexes last scanned of them.
	for things in actionList:
#		if _debug_printNow:
#			print(""+String(things))
		if things is InputEventKey:
			filteredActionList["Listing"]["type_InputEventKey"][things.keycode] = things
			filter_InputEventKey.append(things)
			texture_InputEventKey.append(_checkKeyboardButton(things.keycode))
			texture_InputEventKeyboardMouse.append(_checkKeyboardButton(things.keycode))
			isAMouse = false
			contains_InputEventKey = true
			pass
		elif things is InputEventJoypadButton:
			filteredActionList["Listing"]["type_InputEventJoypadButton"][things.button_index] = things
			filter_InputEventJoypadButton.append(things)
			texture_InputEventJoypadButton.append(_checkJoyPadButton(things.button_index))
			texture_InputEventJoypad.append(_checkJoyPadButton(things.button_index))
			isGamepadButton = true
			contains_InputEventJoypadButton = true
			pass
		elif things is InputEventJoypadMotion:
			filteredActionList["Listing"]["type_InputEventJoypadButton"][things.axis] = things
			filter_InputEventJoypadMotion.append(things)
			texture_InputEventJoypadMotion.append(_checkJoyPadAxis(things.axis))
			texture_InputEventJoypad.append(_checkJoyPadAxis(things.axis))
			isGamepadButton = false
			contains_InputEventJoypadMotion = true
			pass
		elif things is InputEventMouseButton:
			filteredActionList["Listing"]["type_InputEventMouseButton"][things.button_index] = things
			filter_InputEventMouseButton.append(things)
			texture_InputEventMouseButton.append(_checkMouseButton(things.button_index))
			texture_InputEventKeyboardMouse.append(_checkMouseButton(things.button_index))
			isAMouse = true
			contains_InputEventJoypadMotion = true
			pass
		
		# wtf, using switch case doesn't work?!??!??!
		match(things):
			InputEventKey:
				pass
			InputEventMouse:
				pass
			InputEventMouseButton:
				pass
			InputEventMouseMotion:
				pass
			InputEventJoypadButton:
				_checkJoyPadButton(things.button_index)
				pass
			InputEventJoypadMotion:
				pass
			InputEventMIDI:
				pass
			InputEventScreenTouch:
				pass
			InputEventMagnifyGesture:
				pass
			InputEventMultiScreenDrag:
				pass
			InputEventPanGesture:
				pass
			InputEventScreenPinch:
				pass
			InputEventScreenTwist:
				pass
			InputEvent:
				pass
			_:
				pass
		pass

func _retrieveGamePadName(which:int = 0):
	# Yoink from Godot Demo named "Joypads"
	gamepadName = Input.get_joy_name(which) if which>=0 else "Empty"
	gamepadGuid = Input.get_joy_guid(which) if which>=0 else "GUIDnull"
	if _debug_printNow:
		print("Gamepad Name = " + gamepadName + "\nGamepad GUID = " + gamepadGuid)
	pass

func _cycleImages():
	if not texture_InputEventKey.is_empty():
	#	var theKeyboardThing:int = filteredActionList["Listing"]["type_InputEventKey"].values()[ int(filteredActionList["counts"]["type_InputEventKey"])]
		if _debug_printNow:
			print(String(counter_InputEventKey) + " indexd")
#		var theniq:Array 
#		theniq.resize(10)
#		theniq.append_array(filter_InputEventKey)
#		theniq.invert()
#		print(String(theniq))
#		var thonig:InputEventKey = theniq[counter_InputEventKey]
#		var theKeyboardThing:int = thonig.scancode
#		var theKeyboardThing:int = filter_InputEventKey[counter_InputEventKey].scancode
		if _debug_printNow:
#			print(String(filter_InputEventKey[counter_InputEventKey].scancode))
			print(String(counter_InputEventKey))
#			print("Cycle " + String(theKeyboardThing))
			pass
#		_checkKeyboardButton(theKeyboardThing)
		tempKeyboardImage = texture_InputEventKey[counter_InputEventKey]
		counter_InputEventKey += 1
		if counter_InputEventKey > texture_InputEventKey.size()-1:
			counter_InputEventKey = 0
	else:
		tempKeyboardImage = tempNeitherImage
	
	if not texture_InputEventMouseButton.is_empty():
		tempMouseImage = texture_InputEventMouseButton[counter_InputEventMouseButton]
		counter_InputEventMouseButton += 1
		if counter_InputEventMouseButton > texture_InputEventMouseButton.size()-1:
			counter_InputEventMouseButton = 0
		pass
	else:
		tempMouseImage = tempNeitherImage
	
	if not texture_InputEventKeyboardMouse.is_empty():
		tempKeyboardMouseImage = texture_InputEventKeyboardMouse[counter_InputEventKeyboardMouse]
		counter_InputEventKeyboardMouse += 1
		if counter_InputEventKeyboardMouse > texture_InputEventKeyboardMouse.size()-1:
			counter_InputEventKeyboardMouse = 0
		pass
	else:
		tempKeyboardMouseImage = tempNeitherImage
	
	if not texture_InputEventJoypadButton.is_empty():
		tempGamepadButtonImage = texture_InputEventJoypadButton[counter_InputEventJoypadButton]
		counter_InputEventJoypadButton += 1
		if counter_InputEventJoypadButton > texture_InputEventJoypadButton.size()-1:
			counter_InputEventJoypadButton = 0
		pass
	else:
		tempGamepadButtonImage = tempNeitherImage
	
	if not texture_InputEventJoypadMotion.is_empty():
		tempGamepadMotionImage = texture_InputEventJoypadMotion[counter_InputEventJoypadMotion]
		counter_InputEventJoypadMotion += 1
		if counter_InputEventJoypadMotion > texture_InputEventJoypadMotion.size()-1:
			counter_InputEventJoypadMotion = 0
		pass
	else:
		tempGamepadMotionImage = tempNeitherImage
	
	if not texture_InputEventJoypad.is_empty():
		tempGamepadImage = texture_InputEventJoypad[counter_InputEventJoypad]
		counter_InputEventJoypad += 1
		if counter_InputEventJoypad > texture_InputEventJoypad.size()-1:
			counter_InputEventJoypad = 0
		pass
	else:
		tempGamepadImage = tempNeitherImage
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# from Godot demo "Joypads", connect signals
	Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))
	# then get name & the context
	_retrieveGamePadName(whichGamepad)
	_retrieveActionContext()
	_cycleImages()
	pass # Replace with function body.

func _input(event):
	theActionEventOfIt = event
	if event.device == whichGamepad:
		# wtf, using switch case doesn't work?!??!??!
		match(event):
			InputEventKey:
				pass
			InputEventMouse:
				pass
			InputEventMouseButton:
				pass
			InputEventMouseMotion:
				pass
			InputEventJoypadButton:
				pass
			InputEventJoypadMotion:
				pass
			InputEventMIDI:
				pass
			InputEventScreenTouch:
				pass
			InputEventMagnifyGesture:
				pass
			InputEventMultiScreenDrag:
				pass
			InputEventPanGesture:
				pass
			InputEventScreenPinch:
				pass
			InputEventScreenTwist:
				pass
			InputEvent:
				pass
			_:
				pass
		
		if event is InputEventKey or event is InputEventMouse:
			overTopImager.visible = false
			lastControllerType = ControllerType.Keyboard
			lastControllerBetween = ControllerType.KeyboardMouse
			isInGamePad = false
			pass
		elif event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
			overTopImager.visible = false
			lastControllerType = ControllerType.Mouse
			lastControllerBetween = ControllerType.KeyboardMouse
			isInGamePad = false
			pass
		elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
			lastControllerType = ControllerType.Gamepad
			lastControllerBetween = ControllerType.Gamepad
			overTopImager.visible = isDirection
			isInGamePad = true
			pass
		elif event is InputEventScreenTouch or event is InputEventScreenDrag or event is InputEventScreenPinch or event is InputEventScreenTwist:
			lastControllerType = ControllerType.Touchscreen
			lastControllerBetween = ControllerType.Touchscreen
			isInGamePad = true
			pass
		
#		match(lastControllerType):
#			ControllerType.Keyboard:
#				icon = tempKeyboardImage if contains_InputEventKey and not contains_InputEventMouseButton else tempKeyboardMouseImage if not contains_InputEventKey and contains_InputEventMouseButton else tempKeyboardMouseImage if contains_InputEventKey and contains_InputEventMouseButton else tempNeitherImage
##				icon = tempKeyboardImage
#				pass
#			ControllerType.Mouse:
##				icon = tempMouseImage if not contains_InputEventKey and contains_InputEventMouseButton else tempKeyboardImage if contains_InputEventKey and not contains_InputEventMouseButton else tempKeyboardMouseImage if contains_InputEventKey and contains_InputEventMouseButton else tempNeitherImage
#				icon = tempMouseImage
#				pass
#			ControllerType.KeyboardMouse:
#				icon = tempKeyboardImage if contains_InputEventKey and contains_InputEventMouseButton else tempMouseImage if not contains_InputEventKey and contains_InputEventMouseButton else tempKeyboardImage if contains_InputEventKey and not contains_InputEventMouseButton else tempNeitherImage
#				pass
#			ControllerType.Gamepad:
#				icon = tempGamepadButtonImage if not contains_InputEventJoypadMotion and contains_InputEventJoypadButton else tempGamepadMotionImage if contains_InputEventJoypadMotion and not contains_InputEventJoypadButton else tempGamepadImage if contains_InputEventJoypadMotion and contains_InputEventJoypadButton else tempNeitherImage
#				pass
#			ControllerType.Touchscreen:
#				icon = tempTouchscreenImage
#				pass
#			_:
#				pass
			
		# switch case lastControllerBetween in _physics_process
#		if _debug_printNow:
#			print("ararararar " + String(lastControllerBetween))
		
		if event.is_action_pressed(contextInputMapName[0]):
			flat = false
			pass
		elif event.is_action_released(contextInputMapName[0]):
			flat = true
			pass
		pass
	pass

func _physics_process(delta):
	match(lastControllerBetween):
			ControllerType.KeyboardMouse:
#				icon = tempKeyboardImage if contains_InputEventKey and not contains_InputEventMouseButton else tempMouseImage if not contains_InputEventKey and contains_InputEventMouseButton else tempKeyboardMouseImage if contains_InputEventKey and contains_InputEventMouseButton else tempNeitherImage
#				if contains_InputEventKey and !contains_InputEventMouseButton:
#					print("a1")
#					icon = tempKeyboardImage
#				elif !contains_InputEventKey and contains_InputEventMouseButton:
#					print("a2")
#					icon = tempMouseImage
#				elif contains_InputEventKey and contains_InputEventMouseButton:
#					print("a3")
#					icon = tempKeyboardMouseImage
#				else:
#					print("a1")
#					icon = tempNeitherImage
				icon = tempKeyboardMouseImage
				pass
			ControllerType.Gamepad:
#				icon = tempGamepadButtonImage if not contains_InputEventJoypadMotion and contains_InputEventJoypadButton else tempGamepadMotionImage if contains_InputEventJoypadMotion and not contains_InputEventJoypadButton else tempGamepadImage if contains_InputEventJoypadMotion and contains_InputEventJoypadButton else tempNeitherImage
#				if contains_InputEventJoypadMotion and !contains_InputEventJoypadButton:
#					icon = tempGamepadMotionImage
#				elif !contains_InputEventJoypadMotion and contains_InputEventJoypadButton:
#					icon = tempGamepadButtonImage
#				elif contains_InputEventJoypadMotion and contains_InputEventJoypadButton:
#					icon = tempGamepadImage
#				else:
#					icon = tempNeitherImage
				icon = tempGamepadImage
				pass
			ControllerType.Touchscreen:
				icon = tempTouchscreenImage
				pass
			_:
				pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	yield(get_tree().create_timer(5),"timeout")
#	_cycleImages()
	pass

# copy from Godot's demo "Joypads"
# Called whenever a joypad has been connected or disconnected.
func _on_joy_connection_changed(device_id, connected):
	if device_id == whichGamepad:
		if connected:
			_retrieveGamePadName(whichGamepad)
		else:
			_retrieveGamePadName(-1)
	if _debug_printNow:
		print("Change of Gamepad connection No." + device_id + ": \nName = " + gamepadName + "\nGUID = " + gamepadGuid)

func _on_Timer_timeout():
	_cycleImages()
	pass # Replace with function body.
