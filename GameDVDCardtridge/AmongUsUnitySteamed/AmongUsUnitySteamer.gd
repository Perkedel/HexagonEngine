extends Node

# Emergency Meeting
# https://godotengine.org/qa/27987/run-external-application-with-arguments
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	# I saw Unity has just vented.
	# he had just scronched one of our crewmate, Godette-chan
	# luckily I was also next to her and Unity still had cooldown
	# hence I managed to reach her body and report Eik serkat
	OS.shell_open("steam://rungameid/945360")
	await get_tree().create_timer(1).timeout
	emit_signal("ChangeDVD_Exec")
	
	# Vote Unity guys. that's the Impostor!
	# What do you guys think?
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
