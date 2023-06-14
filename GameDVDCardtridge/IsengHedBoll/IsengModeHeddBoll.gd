extends Node

# Prosotipe Kardus
# https://www.headball2.com/
# inspired
# we would like to make it basket instead

# Link Inspire
# https://github.com/AiTechEye/physics-object-picking-up
# https://www.youtube.com/watch?v=olyvemX6XjA

# Bonus
# https://github.com/godotengine/godot/issues/9939 (contains linkre zbrush sculpted girl)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
#	$Admob.load_banner()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_Hoop_BasketMasuk(apaNode):
	print("Hoop 1 " + apaNode.name)
	pass # Replace with function body.


func _on_Hoop2_BasketMasuk(apaNode):
	print("Hoop 2 " + apaNode.name)
	pass # Replace with function body.


func _on_ChangeDVD_pressed():
	emit_signal("ChangeDVD_Exec")
#	$Admob.hide_banner()
	pass # Replace with function body.


func _on_ShutdownHexagon_pressed():
	emit_signal("Shutdown_Exec")
#	$Admob.hide_banner()
	pass # Replace with function body.


func _on_Admob_banner_loaded():
	Kixlonzing.AdRewardUserNow(5)
	pass # Replace with function body.
