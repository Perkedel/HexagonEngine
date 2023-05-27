extends RigidBody3D

@export (PackedScene) var grenade
var material = StandardMaterial3D.new()

func _ready():
	material.albedo_color = Color(1, 1, 1)
	material.emission = Color(1, 0, 0)
	material.emission_energy = 0.1
	material.emission_enabled = true
	$MeshInstance3D.set_surface_override_material(0, material)

func _on_LifetimeTimer_timeout():
	var grenade_instance = grenade.instantiate()
	grenade_instance.global_transform = global_transform
	
	get_tree().get_root().add_child(grenade_instance)
	queue_free()

func _on_LightTimer_timeout():
	$BlinkingLight.visible = !$BlinkingLight.visible
	if $BlinkingLight.visible == true:
		material.emission_energy = 1
	else:
		material.emission_energy = 0.1
	$LightTimer.start()
