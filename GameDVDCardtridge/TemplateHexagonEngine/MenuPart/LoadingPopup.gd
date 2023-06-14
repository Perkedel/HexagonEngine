extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var ProgressMeterValue:float = 0 # (float, 0, 100)
@export var ProgressWording: String
var Dots:String = "......."
@export var LoadingCompleted: bool = false
@export var IncompleteLoadingColor: Color
@export var CompleteLoadingColor: Color
@export var HourglassRotateDegree: float # (float,0,360)

# Called when the node enters the scene tree for the first time.
func _ready():
	ProgressMeterValue = 98
	#$DotFramePerSec.start(.5)
	pass # Replace with function body.

func SpawnLoading():
	#popup()
	show()
	DeCompleteTheLoadingNow()
	pass

func DespawnLoading():
	hide()
	pass

func ManageLoading(ProgressValuei:float = 0, WordingHint = "Loaden", isComplete = false):
	ProgressMeterValue = ProgressValuei
	if not isComplete:
		ProgressWording = WordingHint
		pass
	elif isComplete:
		if not LoadingCompleted:
			CompleteTheLoadingNow()
			pass
		pass
	pass

func DeCompleteTheLoadingNow():
	set_exclusive(false)
	LoadingCompleted = false
	#$LoadingAnimates.play("GravityHourGlassRotate")
	$Timerout.stop()
#	$HBoxContainer/SpaceContain/GravityHourGlass.ignore_rotation =true # reversed "rotating" for Camera2D
	#$DotFramePerSec.start()
	#$HourglassFramesPerSec.start()
	#ProgressWording = "Now Loading!"
	pass

func CompleteTheLoadingNow():
	set_exclusive(false)
	LoadingCompleted = true
	#$LoadingAnimates.play("GravityHourGlassStonp")
	$Timerout.start()
#	$HBoxContainer/SpaceContain/GravityHourGlass.ignore_rotation =true # reversed "rotating" for Camera2D
	$DotFramePerSec.stop()
	$HourglassFramesPerSec.stop()
	ProgressWording = "Loading Completed!"
	pass

func UpdateDots():
	Dots += "."
	if Dots == "........":
		Dots = ""
		pass
	pass

func RotateHourglass():
	HourglassRotateDegree += 2
	if HourglassRotateDegree >= 360:
		HourglassRotateDegree = HourglassRotateDegree - 360
		pass    
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer/VBoxContainer/ProgressBar.set_value(ProgressMeterValue)
	$HBoxContainer/VBoxContainer/LoadingHintWord.text = ProgressWording + Dots
	
	if Input.is_key_pressed(KEY_5):
		#SpawnLoading()
		pass
	
	if Input.is_key_pressed(KEY_4):
		#CompleteTheLoadingNow()
		pass
	
	if LoadingCompleted:
		$HBoxContainer/VBoxContainer/ProgressBar.self_modulate = CompleteLoadingColor
		
		pass
	else:
		$HBoxContainer/VBoxContainer/ProgressBar.self_modulate = IncompleteLoadingColor
		pass
	
	#$HBoxContainer/SpaceContain/GravityHourGlass.set_rotation_degrees(HourglassRotateDegree)
	pass


func _on_Timerout_timeout():
	#$LoadingAnimates.stop()
	hide()
	pass # Replace with function body.


func _on_DotFramePerSec_timeout():
	UpdateDots()
	pass # Replace with function body.


func _on_HourglassFramesPerSec_timeout():
	RotateHourglass()
	pass # Replace with function body.
