tool
extends Spatial
class_name healthbar3D, "res://modules/ExtraImport/night-glider\HealthBar3D/class_icon.png"


export(float, 0, 1) var value = 1 setget value_set
export(Color) var full_color = Color.green setget full_set
export(Color) var empty_color = Color.red setget empty_set
export(Color) var outline_color = Color.black setget outline_color_set
export(Vector3) var size = Vector3(2,1,0.5) setget size_set
export(float) var outline_size = 0.1 setget outline_size_set
export(int,"enabled","y-fixed", "disabled") var billboard_mode = 2 setget billboard_set
export(bool) var unshaded = true setget unshaded_set

var progress:MeshInstance
var under:MeshInstance
var origin:Spatial
var progress_origin:Spatial

func _init():
	progress = MeshInstance.new()
	under = MeshInstance.new()
	origin = Spatial.new()
	progress_origin = Spatial.new()
	add_child(origin)
	origin.add_child(under)
	origin.add_child(progress_origin)
	progress_origin.add_child(progress)
	progress.mesh = CubeMesh.new()
	under.mesh = CubeMesh.new()
	progress.material_override = SpatialMaterial.new()
	under.material_override = SpatialMaterial.new()
	progress.material_override.params_billboard_keep_scale = true
	under.material_override.params_billboard_keep_scale = true
	
	outline_color_set(outline_color)
	size_set(size)
	value_set(value)
	billboard_set(billboard_mode)
	unshaded_set(unshaded)

func value_set(val):
	value = val
	progress_origin.scale.x = value
	progress.material_override.albedo_color = empty_color.linear_interpolate(full_color, value)


func full_set(val):
	full_color = val
	value_set(value)

func empty_set(val):
	empty_color = val
	value_set(value)

func outline_color_set(val):
	outline_color = val
	under.material_override.albedo_color = outline_color

func size_set(val):
	size = val
	progress.mesh.size = size
	under.mesh.size.y = size.y + outline_size
	under.mesh.size.z = size.z * 0.9
	under.mesh.size.x = size.x + outline_size

func outline_size_set(val):
	outline_size = val
	size_set(size)

func billboard_set(val):
	billboard_mode = val
	match billboard_mode:
		0:
			progress.material_override.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
		1:
			progress.material_override.params_billboard_mode = SpatialMaterial.BILLBOARD_FIXED_Y
		2:
			progress.material_override.params_billboard_mode = SpatialMaterial.BILLBOARD_DISABLED
	under.material_override.params_billboard_mode = progress.material_override.params_billboard_mode

func unshaded_set(val):
	unshaded = val
	progress.material_override.flags_unshaded = unshaded
	under.material_override.flags_unshaded = unshaded
