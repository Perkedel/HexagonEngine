extends Node

export (bool) var isPlayingGameNow
export (bool) var isGamePaused
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Singleton. Ahlinya Intinya inti, Core of the core. 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Nonaktifkan_Sistem():
	Kixlonzing.SaveKixlonz()
	print("Quit Game!")
	#get_tree().queue_delete(get_tree())
	#get_tree().queue_free()
	get_tree().quit()
	pass

func _exit_tree():
	pass

func PauseGameNow():
	get_tree().paused = true
	isGamePaused = true
	pass

func ResumeGameNow():
	get_tree().paused = false
	isGamePaused = false
	pass
