extends Area2D

@export (float) var setTimer = .2
@export (bool) var isStarted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func StartScronch():
	$ScronchTimer.start()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScronchTimer.wait_time = setTimer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isStarted = !$ScronchTimer.is_stopped()
	pass


func _on_ScronchTimer_timeout():
	if $ScronchTimer.is_stopped():
		pass
	else:
		
		pass
	pass # Replace with function body.


func _on_InitScronch_body_entered(body):
	if $ScronchTimer.is_stopped():
		pass
	elif !$ScronchTimer.is_stopped():
		print("Init Scronched " + body.name)
		body.free()
		pass
	pass # Replace with function body.


func _on_InitScronch_body_shape_entered(body_id, body, body_shape, area_shape):
	if $ScronchTimer.is_stopped():
		pass
	elif !$ScronchTimer.is_stopped():
		print("Init Scronched " + body.name)
		body.free()
		pass
	pass # Replace with function body.
