extends Button

export(String) var contextInputMapName = "ui_cancel"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ControllerType{KeyboardMouse,Gamepad, Touchscreen}
enum ControllerBrand{Sony, Microsoft, Nintendo, Oculus, OpenVR}
var lastControllerType = ControllerType.KeyboardMouse
var actionList:Array
var theActionEventOfIt # is dynamic, supposedly any InputEvent based such as InputEventKey, InputEventJoypadButton, etc. etc.

export(String) var tempThemePathment = "res://assets/ExtraImport/Xelu_Free_Controller&Key_Prompts/"

export(Texture) var tempGamepadImage = load(tempThemePathment + "PS5/PS5_Circle.png")
export(Texture) var tempKeyboardMouseImage = load(tempThemePathment + "Keyboard & Mouse/Light/Esc_Key_Light.png")
export(Texture) var tempTouchscreenImage = load("res://Sprites/KembaliButton.png")

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

func _checkJoyPadButton(button_index:int):
	print("Joypad Button of " + String(button_index)) 
	tempGamepadImage = load(_returnJoyPadButton(button_index))
	pass

func _calculateFunctionKey(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light/F" + String((button_index - KEY_F1) + 1) + "_Key_Light.png"

func _calculateAlphabeticKey(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light/"+ char(button_index) +"_Key_Light.png"

func _calculateNumericRow(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light/"+ String(button_index - KEY_0) +"_Key_Light.png"

func _calculateNumpad(button_index:int)->String:
	return tempThemePathment + "Keyboard & Mouse/Light/"+ String(button_index - KEY_KP_0) +"_Key_Light.png"

func _returnKeyboardButton(button_index:int)->String:
	if button_index >= KEY_A and button_index <= KEY_Z:
		return _calculateAlphabeticKey(button_index)
	
	if button_index >= KEY_0 and button_index <= KEY_9:
		return _calculateNumericRow(button_index)
	
	if button_index >= KEY_KP_0 and button_index <= KEY_KP_9:
		return _calculateNumpad(button_index)
	
	match(button_index):
		KEY_ESCAPE:
			return tempThemePathment + "Keyboard & Mouse/Light/Esc_Key_Light.png"
			pass
		KEY_ENTER:
			return tempThemePathment + "Keyboard & Mouse/Light/Enter_Alt_Key_Light.png"
			pass
		KEY_KP_ENTER:
			tempThemePathment + "Keyboard & Mouse/Light/Enter_Tall_Key_Light.png"
		KEY_SPACE:
			return tempThemePathment + "Keyboard & Mouse/Light/Space_Key_Light.png"
		_:
			pass
	
	if button_index >= KEY_F1 and button_index <= KEY_F12:
		return _calculateFunctionKey(button_index)
		pass
	
	return "res://Sprites/MavrickleIcon.png"
	pass

func _checkKeyboardButton(button_index:int):
	print("Keyboard Scancode of " + String(button_index))
	tempKeyboardMouseImage = load(_returnKeyboardButton(button_index))
	pass

func _returnMouseButton(button_index:int)->String:
	match(button_index):
		0:
			pass
		1:
			return tempThemePathment + "Keyboard & Mouse/Light/Mouse_Left_Key_Light.png"
		2:
			return tempThemePathment + "Keyboard & Mouse/Light/Mouse_Right_Key_Light.png"
		3:
			return tempThemePathment + "Keyboard & Mouse/Light/Mouse_Middle_Key_Light.png"
		_:
			pass
	return "res://Sprites/MavrickleIcon.png"

func _checkMouseButton(button_index:int):
	print("Mouse Index of " + String(button_index))
	tempKeyboardMouseImage = load(_returnMouseButton(button_index))
	pass

func _retrieveActionContext():
	actionList = InputMap.get_action_list(contextInputMapName)
	print(String(actionList))
	# TODO: watch for copy of InputEvent as there may be one another with same datatype. e.g. ui_accept has ENTER & SPACE, both are InputEventKey. it indexes last scanned of them.
	for things in actionList:
		if things is InputEventKey:
			_checkKeyboardButton(things.scancode)
			pass
		elif things is InputEventJoypadButton:
			_checkJoyPadButton(things.button_index)
			pass
		elif things is InputEventMouseButton:
			_checkMouseButton(things.button_index)
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

# Called when the node enters the scene tree for the first time.
func _ready():
	_retrieveActionContext()
	pass # Replace with function body.

func _input(event):
	theActionEventOfIt = event
	
	
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
	
	if event is InputEventKey or event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		lastControllerType = ControllerType.KeyboardMouse
		pass
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		lastControllerType = ControllerType.Gamepad
		pass
	elif event is InputEventScreenTouch or event is InputEventScreenDrag or event is InputEventScreenPinch or event is InputEventScreenTwist:
		lastControllerType = ControllerType.Touchscreen
		pass
	
	match(lastControllerType):
		ControllerType.KeyboardMouse:
			icon = tempKeyboardMouseImage
			pass
		ControllerType.Gamepad:
			icon = tempGamepadImage
			pass
		ControllerType.Touchscreen:
			icon = tempTouchscreenImage
			pass
		_:
			pass
	
	if event.is_action_pressed(contextInputMapName):
		flat = false
		pass
	elif event.is_action_released(contextInputMapName):
		flat = true
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
