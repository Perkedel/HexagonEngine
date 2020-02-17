extends Control

export (float, 0, 100) var HPlevel = 100
export (Texture) var ScoreIcon
export (float) var ScoreNumber = 2000
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

signal PressPauseButton()
func _on_PauseButton_pressed():
	print("Press Pause Button")
	emit_signal("PressPauseButton")
	pass # Replace with function body.
