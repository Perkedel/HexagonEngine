extends Node2D

#Hud Position and Size
var Selected = false
var ScreenWidth = ProjectSettings.get("display/window/size/viewport_width")
var ScreenHeight = ProjectSettings.get("display/window/size/viewport_height")
var ConHUDView = true
@export var HudScale: float = 1

#Hide Hud Vars
@export var HideHudCommand: String
@export var HideControllerListPrint: bool = true
var InputMaps = InputMap.get_actions()
@onready var Searchinput = InputMaps.find(HideHudCommand,0)

#Console Vars
@export var ConsoleList = ["Xbox","PlayStation","Nintendo"]
var SelectedConsole
var ConsoleListIndex = 0



func _ready():
#Inicial position
	self.position = Vector2(ScreenWidth/2, ScreenHeight/2)
	#if HideControllerListPrint == true:
		#print("Joypads Connected:",Input.get_connected_joypads().size())

func _process(delta):
#Analog Input
	var L3Horizontal = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
	var L3Vertical = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	
	var R3Horizontal = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
	var R3Vertical = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	
	var AnalogLimit = 60
	
#Mouse vars
	var ScaleX = self.scale.x
	var ScaleY = self.scale.y
	
#Get window's dimension
	ScreenWidth = ProjectSettings.get("display/window/size/viewport_width")
	ScreenHeight = ProjectSettings.get("display/window/size/viewport_height")
	
#Self Hud Dimension
	self.scale = lerp(scale, Vector2(HudScale,HudScale), 25 * delta)
	
#Mouse controller function
	if Selected:
		followMouse(delta)
	else:
		if position.x < (ScaleX / 2) + (HudScale*280):
			self.position.x = lerp(self.position.x, (ScaleX / 2) + (HudScale*280), 45 * delta)
		if position.x > ScreenWidth - (HudScale*280) :
			self.position.x = lerp(self.position.x, (ScaleX / 2) + (ScreenWidth - (HudScale*280)), 45 * delta)
		if position.y < (ScaleY / 2) + (HudScale*280):
			self.position.y = lerp(self.position.y, (ScaleY / 2) + (HudScale*280), 45 * delta)
		if position.y > ScreenHeight - (HudScale*280):
			self.position.y = lerp(self.position.y, (ScaleY / 2) + (ScreenHeight - (HudScale*280)), 45 * delta)
	
#Set Triggers Value
	$Buttons/LeftTrigger.text = str("%.2f" % (Input.get_joy_axis(0,JOY_AXIS_TRIGGER_LEFT)))
	$Buttons/RightTrigger.text = str("%.2f" % (Input.get_joy_axis(0,JOY_AXIS_TRIGGER_RIGHT)))
	
#Set Buttons
	SelectedConsole = ConsoleList[ConsoleListIndex]
	
	if Input.is_joy_button_pressed(0,JOY_BUTTON_A):
		if ConsoleListIndex == 1:
			$Buttons/XAButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/XAButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/XAButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/XAButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/XAButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/XAButton.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_X):
		if ConsoleListIndex == 1:
			$Buttons/SquareXButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/SquareXButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/SquareXButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/SquareXButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/SquareXButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/SquareXButton.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_B):
		if ConsoleListIndex == 1:
			$Buttons/CircleBButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/CircleBButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/CircleBButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/CircleBButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/CircleBButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/CircleBButton.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_Y):
		if ConsoleListIndex == 1:
			$Buttons/TriangleYButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/TriangleYButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/TriangleYButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/TriangleYButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/TriangleYButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/TriangleYButton.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_LEFT_SHOULDER):
		if ConsoleListIndex == 1:
			$Buttons/L1LBButton.frame = 1
			$Buttons/L1LBButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/L1LBButton.frame = 3
			$Buttons/L1LBButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/L1LBButton.frame = 5
			$Buttons/L1LBButton.scale = Vector2(0.233,0.233)
	else:
		if ConsoleListIndex == 1:
			$Buttons/L1LBButton.frame = 0
			$Buttons/L1LBButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/L1LBButton.frame = 2
			$Buttons/L1LBButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/L1LBButton.frame = 4
			$Buttons/L1LBButton.scale = Vector2(0.233,0.233)
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_RIGHT_SHOULDER):
		if ConsoleListIndex == 1:
			$Buttons/R1RBButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/R1RBButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/R1RBButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/R1RBButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/R1RBButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/R1RBButton.frame = 4
			
	if Input.get_joy_axis(0,JOY_AXIS_TRIGGER_LEFT) > 0:
		if ConsoleListIndex == 1:
			$Buttons/L2LTButton.frame = 1
			$Buttons/L2LTButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/L2LTButton.frame = 3
			$Buttons/L2LTButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/L2LTButton.frame = 5
			$Buttons/L2LTButton.scale = Vector2(0.233,0.233)
	else:
		if ConsoleListIndex == 1:
			$Buttons/L2LTButton.frame = 0
			$Buttons/L2LTButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/L2LTButton.frame = 2
			$Buttons/L2LTButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/L2LTButton.frame = 4
			$Buttons/L2LTButton.scale = Vector2(0.233,0.233)
			
	if Input.get_joy_axis(0,JOY_AXIS_TRIGGER_RIGHT) > 0:
		if ConsoleListIndex == 1:
			$Buttons/R2RTButton.frame = 1
			$Buttons/R2RTButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/R2RTButton.frame = 3
			$Buttons/R2RTButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/R2RTButton.frame = 5
			$Buttons/R2RTButton.scale = Vector2(0.233,0.233)
	else:
		if ConsoleListIndex == 1:
			$Buttons/R2RTButton.frame = 0
			$Buttons/R2RTButton.scale = Vector2(1,1)
		elif ConsoleListIndex == 0:
			$Buttons/R2RTButton.frame = 2
			$Buttons/R2RTButton.scale = Vector2(0.233,0.233)
		elif ConsoleListIndex == 2:
			$Buttons/R2RTButton.frame = 4
			$Buttons/R2RTButton.scale = Vector2(0.233,0.233)
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_START):
		if ConsoleListIndex == 1:
			$Buttons/StartButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/StartButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/StartButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/StartButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/StartButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/StartButton.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_BACK):
		if ConsoleListIndex == 1:
			$Buttons/SelectButton.frame = 1
		elif ConsoleListIndex == 0:
			$Buttons/SelectButton.frame = 3
		elif ConsoleListIndex == 2:
			$Buttons/SelectButton.frame = 5
	else:
		if ConsoleListIndex == 1:
			$Buttons/SelectButton.frame = 0
		elif ConsoleListIndex == 0:
			$Buttons/SelectButton.frame = 2
		elif ConsoleListIndex == 2:
			$Buttons/SelectButton.frame = 4

#D-pad
	if ConsoleListIndex == 1:
		$Buttons/Dpad/Base.frame = 0
		$Buttons/Dpad/Up.frame = 0
		$Buttons/Dpad/Down.frame = 0
		$Buttons/Dpad/Left.frame = 0
		$Buttons/Dpad/Right.frame = 0
	elif ConsoleListIndex == 0:
		$Buttons/Dpad/Base.frame = 1
		$Buttons/Dpad/Up.frame = 1
		$Buttons/Dpad/Down.frame = 1
		$Buttons/Dpad/Left.frame = 1
		$Buttons/Dpad/Right.frame = 1
	elif ConsoleListIndex == 2:
		$Buttons/Dpad/Base.frame = 2
		$Buttons/Dpad/Up.frame = 2
		$Buttons/Dpad/Down.frame = 2
		$Buttons/Dpad/Left.frame = 2
		$Buttons/Dpad/Right.frame = 2
		
	if Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_UP):
		$Buttons/Dpad/Up.visible = true
	else:
		$Buttons/Dpad/Up.visible = false
		
	if Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_DOWN):
		$Buttons/Dpad/Down.visible = true
	else:
		$Buttons/Dpad/Down.visible = false
		
	if Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_LEFT):
		$Buttons/Dpad/Left.visible = true
	else:
		$Buttons/Dpad/Left.visible = false
		
	if Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_RIGHT):
		$Buttons/Dpad/Right.visible = true
	else:
		$Buttons/Dpad/Right.visible = false
		
#Analogs Input
	if Input.is_joy_button_pressed(0,JOY_BUTTON_LEFT_STICK):
		if ConsoleListIndex == 1:
			$LAnalog/Thumb.frame = 1
		elif ConsoleListIndex == 0:
			$LAnalog/Thumb.frame = 3
		elif ConsoleListIndex == 2:
			$LAnalog/Thumb.frame = 5
	else:
		if ConsoleListIndex == 1:
			$LAnalog/Thumb.frame = 0
		elif ConsoleListIndex == 0:
			$LAnalog/Thumb.frame = 2
		elif ConsoleListIndex == 2:
			$LAnalog/Thumb.frame = 4
			
	if Input.is_joy_button_pressed(0,JOY_BUTTON_RIGHT_STICK):
		if ConsoleListIndex == 1:
			$RAnalog/Thumb.frame = 1
		elif ConsoleListIndex == 0:
			$RAnalog/Thumb.frame = 3
		elif ConsoleListIndex == 2:
			$RAnalog/Thumb.frame = 5
	else:
		if ConsoleListIndex == 1:
			$RAnalog/Thumb.frame = 0
		elif ConsoleListIndex == 0:
			$RAnalog/Thumb.frame = 2
		elif ConsoleListIndex == 2:
			$RAnalog/Thumb.frame = 4
		
#Analog Position
	$LAnalog/Thumb.position.x = AnalogLimit * L3Horizontal
	$LAnalog/Thumb.position.y = AnalogLimit * L3Vertical
	$RAnalog/Thumb.position.x = AnalogLimit * R3Horizontal
	$RAnalog/Thumb.position.y = AnalogLimit * R3Vertical
	
#Set console label
	$Buttons/ConsoleButton.text = SelectedConsole
	
func followMouse(delta):
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _on_area_2d_input_event(viewport, event, shape_idx):
#Drag and drop controller
	var mouseInput
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouseInput = true
	else:
		mouseInput = false
		
	if event is InputEventMouseButton and mouseInput == true:
			Selected = true
	elif event is InputEventMouseButton and mouseInput == false:
			Selected = false

func _on_console_button_pressed():
#Change game console
	ConsoleListIndex += 1
	if ConsoleListIndex > ConsoleList.size() - 1:
		ConsoleListIndex = 0

func _on_vibration_pressed():
	Input.start_joy_vibration(0,1,1,1)
