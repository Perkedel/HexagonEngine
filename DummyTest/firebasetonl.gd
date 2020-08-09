extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var aDatabasa
var aDokumente = {
	Ald = "a",
	an = "a",
	tand = "12.4a",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#aDatabasa = Firebase.Database.get_database_reference("Sandbox", aDokumente)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	
	pass # Replace with function body.


func _on_FireBaseAuth_loggedInAuthed(theAuth):
	pass # Replace with function body.
