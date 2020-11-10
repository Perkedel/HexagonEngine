extends Node

# Heartbeat emulator
# https://github.com/Perkedel/HeartbeatOpenScript-Unity/blob/master/Assets/HeartbeatOpenScript.cs
# No more Unity! Yeet Proprietarism, Expensivism, and Partialism!
# Help sound ogg loops!!! 
#https://github.com/godotengine/godot/issues/15895#issuecomment-359185065
# BBcode Godot 
# https://docs.godotengine.org/en/stable/tutorials/gui/bbcode_in_richtextlabel.html

# TODO skip hearbeat button. this resets your heartbeat stator
# TODO in function of those systole and diastoles the heart.


export(PoolStringArray) var SystoleSounds
export(PoolStringArray) var DiastoleSounds

export(float) var HeartRate = 70
onready var Hertz = HeartRate / 60
onready var PeriodT = 1/Hertz
onready var remainPeriod = PeriodT
onready var remainPeriodMillisec = remainPeriod * 1000
export(float) var returnTime = .25
onready var startReturnTime = returnTime
onready var startReturnTimeMillisec = startReturnTime * 1000

var GlobalTimer = [0,0]
var CatchGlobalTimer = [0,0]
var Lub:bool = false
var stateIndex:int = 0
var isBeating = true
onready var EnableSound = true

onready var debugToggle = $CanvasLayer/UIsoWe/Listoid/ToggleDebugButton
onready var ToggleSays = "Heartbeat"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

enum SureToDo {Quit = 0, ChangeDVD = 1}
var ToWhat = "Quit"
onready var SelectedLeave = SureToDo.Quit

export var useAsync:bool = true #make heartbeat asyncronouse. after a lub, heartbeat can lub again without need of dubb first.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func DecideReturnTime(var forWhathowMuch):
	if forWhathowMuch <= 0:
		ToggleSays = "Eik Serkat!"
		returnTime = 0
		pass
	elif forWhathowMuch >= 1 and forWhathowMuch < 20:
		ToggleSays = "..."
		returnTime = .75
		pass
	elif forWhathowMuch >= 20 and forWhathowMuch < 50:
		ToggleSays = "Looooooooww... heeeaarrt raaaaaate..."
		returnTime = .5
		pass
	elif forWhathowMuch >= 50 and forWhathowMuch < 70:
		if forWhathowMuch == 69:
			ToggleSays = "nice"
		else:
			ToggleSays = "Sleepie"
		returnTime = .3
		pass
	elif forWhathowMuch >= 70 and forWhathowMuch < 90:
		ToggleSays = "Heartbeat"
		returnTime = .25
		pass
	elif forWhathowMuch >= 90 and forWhathowMuch < 100:
		ToggleSays = "Accelerated"
		returnTime = .20
		pass
	elif forWhathowMuch >= 100 and forWhathowMuch < 150:
		ToggleSays = "FASS"
		returnTime = .15
		pass
	elif forWhathowMuch >= 150 and forWhathowMuch < 200:
		ToggleSays = "VERY FASS"
		returnTime = .1
		pass
	elif forWhathowMuch >= 200 and forWhathowMuch < 300:
		ToggleSays = "TOO FASS"
		returnTime = .05
		pass
	elif forWhathowMuch >= 300 and forWhathowMuch < 400:
		ToggleSays = "EXTREMELY FASS"
		returnTime = .025
		pass
	elif forWhathowMuch >= 400:
		ToggleSays = "OH PECK!!! FIBRILATION GOING ON!!! OH NO!!!"
		returnTime = .001
		pass
	debugToggle.text = ToggleSays
	pass

func SetHeartRate(var value):
	HeartRate = value
	if HeartRate >= 1:
		isBeating = true
		
	elif HeartRate <= 0:
		print("Stop The Heartbeat")
		isBeating = false
		HeartRate = 1
		pass
	DecideReturnTime(value)
	print("Set Heart Rate to ", value ," BPM")
	Hertz = HeartRate / 60 if HeartRate > 0 else 1
	PeriodT = 1 / Hertz if Hertz > 0 else 1
	pass

func SystoleCodeProcess(var delta):
	remainPeriod -= delta
	remainPeriodMillisec = remainPeriod * 1000
	startReturnTime = returnTime
	startReturnTimeMillisec = startReturnTime * 1000
	pass

func DiastoleBeatCodeProcess(var delta):
	remainPeriod = PeriodT
	remainPeriodMillisec = remainPeriod * 1000
	startReturnTime -= delta
	startReturnTimeMillisec = startReturnTime * 1000
	pass

func NewHeartbeatMode(var delta):
	remainPeriod -= delta
	remainPeriodMillisec = remainPeriod * 1000
	if(remainPeriodMillisec <= 0):
		stateIndex = 1
		if(debugToggle):
			debugToggle.pressed = true
			pass
		#Play Sounds Systole
		print("Lub")
		remainPeriod = PeriodT
		remainPeriodMillisec = remainPeriod * 1000
		if EnableSound:
			$Systole.play()
		Lub = true
		pass
	else:
		$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.max_value = PeriodT
		$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.value = PeriodT-remainPeriod
		pass
	
	if Lub:
		startReturnTime -= delta
		startReturnTimeMillisec = startReturnTime * 1000
		if startReturnTimeMillisec <= 0:
			$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.max_value = returnTime
			$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.value = 0
			stateIndex = 0
			if(debugToggle):
				debugToggle.pressed = false
				pass
			# Play Sounds Diastole
			print("Dubb")
			startReturnTime = returnTime
			startReturnTimeMillisec = startReturnTime * 1000
			Lub = false
			if EnableSound:
				$Diastole.play()
			
			pass
		else:
			$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.max_value = returnTime
			$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.value = startReturnTime
		pass
	else:
#		$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.max_value = PeriodT
#		$CanvasLayer/UIsoWe/Listoid/Settings/LeftSetting/HeartProgress.value = PeriodT-remainPeriod
		pass
	pass

func OldHeartbeatMode(var delta):
	if not Lub:
		SystoleCodeProcess(delta)
		if(remainPeriodMillisec <= 0):
			stateIndex = 1
			if(debugToggle):
				debugToggle.pressed = true
				pass
			#Play Sounds Systole
			print("Lub")
			Lub = true
			pass
		pass
	else:
		DiastoleBeatCodeProcess(delta)
		if startReturnTimeMillisec <= 0:
			stateIndex = 0
			if(debugToggle):
				debugToggle.pressed = false
				pass
			# Play Sounds Diastole
			print("Dubb")
			Lub = false
			pass
		pass
	pass

func NoHeartbeatEikSerkat(var delta):
	remainPeriod = PeriodT
	remainPeriodMillisec = remainPeriod * 1000
	startReturnTime = returnTime
	startReturnTimeMillisec = startReturnTime * 1000
	
	# Last hearbeat if in Systole
	if Lub:
		startReturnTime -= delta
		startReturnTimeMillisec = startReturnTime * 1000
		if startReturnTimeMillisec <= 0:
			stateIndex = 0
			if(debugToggle):
				debugToggle.pressed = false
				pass
			# Play Sounds Diastole
			print("Dubb")
			startReturnTime = returnTime
			startReturnTimeMillisec = startReturnTime * 1000
			Lub = false
			if EnableSound:
				$Diastole.play()
			pass
		pass
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if isBeating:
		match useAsync:
			true:
				NewHeartbeatMode(delta)
				pass
			false:
				OldHeartbeatMode(delta)
				pass
		pass
	else:
		NoHeartbeatEikSerkat(delta)
	pass

func AreYouSureToDo(var whatThis):
	SelectedLeave = whatThis
	match whatThis:
		SureToDo.ChangeDVD:
			ToWhat = "Change DVD"
			pass
		SureToDo.Quit:
			ToWhat = "Quit"
			pass
		_:
			pass
	$CanvasLayer/UIsoWe/AreYouSureTo.dialog_text = "Are you sure to " + ToWhat
	$CanvasLayer/UIsoWe/AreYouSureTo.popup()
	pass

func ConfirmAreYouSure(var whatThis):
	
	match whatThis:
		SureToDo.ChangeDVD:
			emit_signal("ChangeDVD_Exec")
			pass
		SureToDo.Quit:
			emit_signal("Shutdown_Exec")
			pass
		_:
			pass
	pass


func _on_BPMSpinBox_value_changed(value):
	SetHeartRate(value)
	pass # Replace with function body.


func _on_Shutdown_pressed():
	#emit_signal("Shutdown_Exec")
	AreYouSureToDo(SureToDo.Quit)
	pass # Replace with function body.


func _on_ChangeDVD_pressed():
	#emit_signal("ChangeDVD_Exec")
	AreYouSureToDo(SureToDo.ChangeDVD)
	pass # Replace with function body.


func _on_AreYouSureTo_confirmed():
	ConfirmAreYouSure(SelectedLeave)
	pass # Replace with function body.


func _on_CheckButton_toggled(button_pressed):
	EnableSound = button_pressed
	pass # Replace with function body.


func _on_DescriptionTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.
