extends Control

@export_range(0,100) var HPlevel:float = 100
@export var ScoreIcon:Texture2D
@export var ScoreNumber:float = 2000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Gameplay UI controls Character, HP, gameplay values

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TotalVBoxContainer/BottomVBoxContainer/MeserckanStatus/CoineCounter.CoineCountNumber = ScoreNumber
	$TotalVBoxContainer/BottomVBoxContainer/MeserckanStatus/CoineCounter.CoineIcon = ScoreIcon
	$TotalVBoxContainer/BottomVBoxContainer/HPbar.HPvalue = HPlevel
	pass

func pressThePause():
	print("Press Pause Button")
	emit_signal("PressPauseButton")
	Singletoner.pressAMenuButton('Pause')
	pass

signal PressPauseButton()
func _on_PauseButton_pressed():
	if visible:
		pressThePause()
		pass
	pass # Replace with function body.


func _on_pause_button_button_up() -> void:
	
	pass # Replace with function body.
