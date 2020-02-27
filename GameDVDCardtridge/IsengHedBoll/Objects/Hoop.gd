extends Spatial

export (bool) var inBasket1 = false
export (bool) var anBasket2 = false
# https://godotengine.org/article/importing-3d-assets-blender-gamedevtv
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal BasketMasuk(apaNode)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SensorBasket_body_entered(body):
	emit_signal("BasketMasuk", body)
	inBasket1 = true
	pass # Replace with function body.


func _on_SensorBasket2_body_entered(body):
	if inBasket1:
		
		pass
	pass # Replace with function body.
