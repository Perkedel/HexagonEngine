extends Button

@export (int) var WhatNumberAmI = 0
@export (bool) var SingleUse = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal IamPressed(WhatNumberAreYou)
# Avoid "Enesis" in Chance Enesis, as clipping "Enesis" forms "Enes"
# PM JOELwindows7 why should the theft be not honored.
# Replaced this into "Anezic" 

func SetPrussieNumber(number:int):
	WhatNumberAmI = number
	text = String(number+1) + " Chance Anezic"
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PrussieButtonChanceEnesis_pressed():
	emit_signal("IamPressed", WhatNumberAmI)
	if SingleUse:
		disabled = true
		pass
	pass # Replace with function body.
