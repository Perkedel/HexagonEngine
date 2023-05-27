extends Marker3D

@export (PackedScene) var debris

func _ready():
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 0, 0)
	material.metallic = 1
	material.emission = Color(0.92, 0.91, 0.90)
	material.emission_energy = 10
	material.emission_enabled = true
	$Bullet.set_surface_override_material(0, material)
	$Bullet.scale = Vector3(2, 2, 2)
	
	$ColorTween.interpolate_property(material, "emission", Color(0.93, 0.9, 0.89), Color(0.88, 0.55, 0.45), 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$ColorTween.interpolate_property(material, "emission", Color(0.88, 0.55, 0.45), Color(0, 0, 0), 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	$ColorTween.interpolate_property(material, "emission_energy", 10, 0, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$ColorTween.interpolate_property($Bullet, "scale", Vector3(2, 2, 2), Vector3(1, 1, 1), 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$ColorTween.start()
	await get_tree().idle_frame
	for i in 3:
		spawn_debris(randf_range(1, 5))
	
func hide_bullet():
	await get_tree().create_timer(0.1).timeout
	$Bullet.hide()

func spawn_debris(throw_force):
	var debris_instance = debris.instantiate()
	get_tree().get_root().add_child(debris_instance)
	debris_instance.global_transform = $DebrisPosition3D.global_transform
	debris_instance.linear_velocity = global_transform.basis.z * throw_force
