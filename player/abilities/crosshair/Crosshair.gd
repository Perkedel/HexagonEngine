extends RayCast3D

var speed = 0.1
var base_position = 53.5
var end_position = 81.5

var wide_crosshair = false

@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var reload_tween = get_tree().get_root().find_child("ReloadTween", true, false)
@onready var grab  = get_tree().get_root().find_child("Grab", true, false)
@onready var shoot  = get_tree().get_root().find_child("Shoot", true, false)

func _ready():
	$Marker2D/Lines/Line1.position.x = -base_position
	$Marker2D/Lines/Line2.position.y = -base_position
	$Marker2D/Lines/Line3.position.x = base_position
	$Marker2D/Lines/Line4.position.y = base_position

func _process(delta):
	$Marker2D.position = get_viewport().size / 2
	
	$Marker2D.show()
	
	if not player.is_on_floor() or player.speed_multiplier == 2:
		$Marker2D.hide()
	
	if shoot: # If the node Shoot is in the scene, hide when reloading and aiming
		if reload_tween.is_active():
			$Marker2D.hide()
	
		if shoot.accuracy == 1:
			$Marker2D/Lines.show()
			$Marker2D/CenterDot.hide()
		else:
			$Marker2D/Lines.hide()
			$Marker2D/CenterDot.show()
	
	if grab: # If the node Grab is in the scene, hide when grabbing
		if grab.object_grabbed:
			$Marker2D.hide()
	
	# Change color to red when pointing on an enemy
	if is_colliding() and get_collider().is_in_group("Enemy"):
		red()
	else:
		white()
	
	# If we move the crosshair becomes wider
	if player.direction != Vector3():
		if not wide_crosshair:
			animate(wide_crosshair)
	else:
		if wide_crosshair:
			animate(wide_crosshair)
	
func animate(wide):
	if not wide:
		# if false make wider
		$Tween.interpolate_property($Marker2D/Lines/Line1, "position:x", $Marker2D/Lines/Line1.position.x, -end_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line2, "position:y", $Marker2D/Lines/Line2.position.y, -end_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line3, "position:x", $Marker2D/Lines/Line3.position.x, end_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line4, "position:y", $Marker2D/Lines/Line4.position.y, end_position, speed, 0, 2, 0)
		$Tween.start()
		wide_crosshair = true
	else:
		# if true make closer
		$Tween.interpolate_property($Marker2D/Lines/Line1, "position:x", $Marker2D/Lines/Line1.position.x, -base_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line2, "position:y", $Marker2D/Lines/Line2.position.y, -base_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line3, "position:x", $Marker2D/Lines/Line3.position.x, base_position, speed, 0, 2, 0)
		$Tween.interpolate_property($Marker2D/Lines/Line4, "position:y", $Marker2D/Lines/Line4.position.y, base_position, speed, 0, 2, 0)
		$Tween.start()
		wide_crosshair = false

func white():
	$Marker2D/Lines/Line1.white()
	$Marker2D/Lines/Line2.white()
	$Marker2D/Lines/Line3.white()
	$Marker2D/Lines/Line4.white()
	$Marker2D/CenterDot.white()

func red():
	$Marker2D/Lines/Line1.red()
	$Marker2D/Lines/Line2.red()
	$Marker2D/Lines/Line3.red()
	$Marker2D/Lines/Line4.red()
	$Marker2D/CenterDot.red()
