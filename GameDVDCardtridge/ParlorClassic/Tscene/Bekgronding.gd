extends ParallaxBackground

export (float) var speedWay = -2
export (float) var currentXoffset = 0
export (bool) var EnableSpeed = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Paralak.position = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if EnableSpeed:
		currentXoffset += speedWay
		pass
	if currentXoffset <= float(-1920):
		currentXoffset = 0
		pass
#	if currentXoffset >= float(0):
#		currentXoffset = -1920
#		pass
	$Paralak.motion_offset = Vector2(currentXoffset,0)
	#$Paralak.motion_offset+=Vector2(speedWay,0)
	pass
