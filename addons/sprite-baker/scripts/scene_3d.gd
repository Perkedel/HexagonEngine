tool
extends Spatial

const Tools: Script = preload("tools.gd")
const AABB_EXTRA_FACTOR: float = 1.05

export(bool) var post_process: bool = false setget set_post_process, get_post_process
export(ShaderMaterial) var post_process_material: ShaderMaterial

onready var remote_xform: RemoteTransform = $RemoteTransform
onready var camera: Camera = $Base/Camera
onready var bone: BoneAttachment = $Bone

var model: Spatial setget set_model, get_model
var meshes: Array
var aabb: AABB
var anim_player: AnimationPlayer
var skeleton: Skeleton
var rest_xforms: Array = []
var cam_pos: Vector3


func set_post_process(value: bool) -> void:
	post_process = value
	if post_process:
		$Base/Camera/PostProcess.show()
	else:
		$Base/Camera/PostProcess.hide()


func get_post_process() -> bool:
	return post_process


func set_model(model_: Spatial) -> void:
	if bone.get_parent() != self:
		bone.get_parent().remove_child(bone)
		add_child(bone)
	if remote_xform.get_parent() != self:
		remote_xform.get_parent().remove_child(remote_xform)
		add_child(remote_xform)
	if model != null:
		remove_child(model)
		model.queue_free()
	if model_:
		model = model_.duplicate()
		add_child(model)
		meshes = Tools.find_nodes_by_type("MeshInstance", model)
		anim_player = Tools.find_single_node_by_type("AnimationPlayer", model)
		if anim_player:
			anim_player.playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
		skeleton = Tools.find_single_node_by_type("Skeleton", model)
		rest_xforms = []
		if skeleton:
			for ibone in range(skeleton.get_bone_count()):
				rest_xforms.append(skeleton.get_bone_global_pose(ibone))
			remove_child(bone)
			skeleton.add_child(bone)
		get_meshes_aabb()
	else:
		meshes = []
		anim_player = null
		skeleton = null
		rest_xforms = []
		model = null


func get_model() -> Spatial:
	return model


func get_meshes_aabb() -> void:
	if meshes.size() == 0:
		aabb = AABB(Vector3.ZERO, Vector3.ONE)
		return
	aabb = meshes[0].get_transformed_aabb()
	for iMesh in range(1, meshes.size()):
		aabb = aabb.merge(meshes[iMesh].get_transformed_aabb())


func adjust_camera() -> void:
	var posx: float = aabb.position.x + aabb.size.x * 0.5
	var posy: float = aabb.position.y + aabb.size.y * 0.5
	cam_pos = Vector3(posx, posy, 10.0)
	camera.translation = cam_pos
	fit_to_viewport()


func fit_to_viewport() -> void:
	var model_ratio: float = aabb.size.x / aabb.size.y
	var vp_size: Vector2 = get_parent().size
	var vp_ratio: float = vp_size.x / vp_size.y
	if vp_ratio > model_ratio:
		camera.size = aabb.size.y * AABB_EXTRA_FACTOR
	else:
		camera.size = aabb.size.y * AABB_EXTRA_FACTOR * model_ratio / vp_ratio


func rotate_model(rotx: float, roty: float) -> void:
	var model_scale = model.scale
	model.transform.basis = Basis() # reset rotation
	model.rotate_object_local(Vector3(0, 1, 0), rotx) # first rotate in Y
	model.rotate_object_local(Vector3(1, 0, 0), roty) # then rotate in X
	var basis: Basis = model.transform.basis
	var aabb_center: Vector3 = Vector3(aabb.position.x + aabb.size.x * 0.5,
										aabb.position.y + aabb.size.y * 0.5,
										aabb.position.z + aabb.size.z * 0.5)
	var center: Vector3 = basis.x * aabb_center.x + basis.y * aabb_center.y + basis.z * aabb_center.z
	model.transform.origin = aabb_center - center
	model.scale = model_scale


func update_surface_material(mesh_path: NodePath, surf_index: int, mat: Material) -> void: # SpriteBaker.Materials group function
	if model:
		var mesh_inst: MeshInstance = model.get_node(mesh_path)
		mesh_inst.set_surface_material(surf_index, mat)


func set_loop(aname: String, loop: bool) -> void: # SpriteBaker.Animation group function
	anim_player.get_animation(aname).loop = loop


func play(anim_name: String) -> void: # SpriteBaker.Animation group function
	if anim_player.current_animation == anim_name:
		if anim_player.is_playing():
			anim_player.stop(false)
		else:
			anim_player.play()
	else:
		anim_player.play(anim_name)
		anim_player.seek(0.0, true)


func stop() -> void: # SpriteBaker.Animation group function
	anim_player.stop(true)
	for ibone in range(skeleton.get_bone_count()):
		skeleton.set_bone_global_pose(ibone, rest_xforms[ibone])


func set_anim_time(time: float) -> void: # SpriteBaker.Animation group function
	anim_player.seek(time, true)


func set_key_frames(_fps: float) -> void: # SpriteBaker.Animation group function
	pass


func set_root_motion_track(root_path: String, id: int) -> void:
	var root: Spatial = model.get_node(root_path)
	remote_xform.get_parent().remove_child(remote_xform)
	if id == -1:
		root.add_child(remote_xform)
	else:
		bone.add_child(remote_xform)
		bone.bone_name = skeleton.get_bone_name(id)
	remote_xform.transform = Transform()
	camera.translation = cam_pos - remote_xform.global_transform.origin
	remote_xform.remote_path = $Base.get_path()


func clear_root_motion_track() -> void:
	remote_xform.get_parent().remove_child(remote_xform)
	add_child(remote_xform)
	remote_xform.transform = Transform()
	remote_xform.remote_path = $Base.get_path()
	$Base.transform = Transform()
	camera.translation = cam_pos


func set_outline_color(color: Color) -> void:
	if post_process:
		post_process_material.set_shader_param("outline_color", color)


func set_pp_depth_cutoff(value: float) -> void:
	post_process_material.set_shader_param("depth_cutoff", value)


func set_pp_use_depth(value: bool) -> void:
	post_process_material.set_shader_param("use_depth", value)


func set_pp_blend(value: bool) -> void:
	post_process_material.set_shader_param("blend", value)


func set_pp_pixel_size(px: float, py: float) -> void:
	post_process_material.set_shader_param("px_x", px)
	post_process_material.set_shader_param("px_y", py)


