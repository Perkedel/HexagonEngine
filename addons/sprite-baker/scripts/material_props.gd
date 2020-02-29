tool
extends Control

signal material_copied(mat)
signal paste_material(slot, unique)

const MAT_EXTS: = PoolStringArray([
	"*.material; Material", "*.tres; Text Resource", "*.res; Resource"
	])
const TEXTURE_EXTS: = PoolStringArray([
	"*.bmp, BMP", "*.jpeg; JPEG", "*.jpg; JPG", "*.png; PNG", "*.res; RES",
	"*.tres; TRES", "*.tex; TEX", "*.tga; TGA", "*.webp; WEBP"
	])
const VisibleIcon: Texture = preload("res://addons/sprite-baker/resources/icons/visible.svg")
const HiddenIcon: Texture = preload("res://addons/sprite-baker/resources/icons/hidden.svg")
const XrayIcon: Texture = preload("res://addons/sprite-baker/resources/icons/xray.svg")

const ShadedIcon: Texture = preload("res://addons/sprite-baker/resources/icons/shaded.svg")
const UnshadedIcon: Texture = preload("res://addons/sprite-baker/resources/icons/unshaded.svg")
const PlainColorIcon: Texture = preload("res://addons/sprite-baker/resources/icons/plain_color.svg")

const Tools: Script = preload("tools.gd")

enum VisibilityState {VISIBLE, HIDDEN, XRAY}
enum ShadeState {SHADED, UNSHADED, PLAIN}
enum MenuOpt {ADVANCED_OPTIONS, SP1, LOAD, SAVE, SAVEAS, SP2,
	RESTORE_ORIGINAL, RESTORE_ACTIVE, SP3, COPY, PASTE, PASTE_UNIQUE}

export(Material) var hidden_material: Material
export(Material) var hidden_xray_material: Material
export(SpatialMaterial) var plain_color_material: SpatialMaterial
export(NodePath) var surface_name_path: NodePath
export(NodePath) var material_name_path: NodePath
export(NodePath) var hide_path: NodePath
export(NodePath) var unshaded_path: NodePath
export(NodePath) var color_path: NodePath
export(NodePath) var albedo_texture_path: NodePath
export(NodePath) var roughness_texture_path: NodePath
export(NodePath) var roughness_color_path: NodePath
export(NodePath) var metallic_texture_path: NodePath
export(NodePath) var metallic_color_path: NodePath
export(NodePath) var normal_texture_path: NodePath
export(NodePath) var roughness_options_path: NodePath
export(NodePath) var roughness_spin_path: NodePath
export(NodePath) var roughness_slider_path: NodePath
export(NodePath) var roughness_texture_opt_path: NodePath
export(NodePath) var roughness_channel_path: NodePath
export(NodePath) var metallic_options_path: NodePath
export(NodePath) var metallic_check_path: NodePath
export(NodePath) var metallic_texture_opt_path: NodePath
export(NodePath) var metallic_channel_path: NodePath
export(NodePath) var specular_spin_path: NodePath
export(NodePath) var specular_slider_path: NodePath
export(NodePath) var normal_options_path: NodePath
export(NodePath) var normal_spin_path: NodePath
export(NodePath) var normal_slider_path: NodePath
export(NodePath) var normal_texture_opt_path: NodePath
export(NodePath) var ao_enabled_path: NodePath
export(NodePath) var ao_box_path: NodePath
export(NodePath) var ao_spin_path: NodePath
export(NodePath) var ao_slider_path: NodePath
export(NodePath) var ao_texture_path: NodePath
export(NodePath) var ao_texture_opt_path: NodePath
export(NodePath) var ao_options_path: NodePath
export(NodePath) var ao_channel_path: NodePath
export(NodePath) var ao_uv2_path: NodePath
export(NodePath) var more_options_path: NodePath
export(NodePath) var advanced_dialog_path: NodePath

onready var material_name: Button = get_node(material_name_path)
onready var hide: Button = get_node(hide_path)
onready var unshaded: Button = get_node(unshaded_path)
onready var albedo_color: ColorPicker = get_node(color_path)
onready var albedo_texture: TextureRect = get_node(albedo_texture_path)
onready var roughness_texture: TextureRect = get_node(roughness_texture_path)
onready var roughness_color: ColorRect = get_node(roughness_color_path)
onready var metallic_texture: TextureRect = get_node(metallic_texture_path)
onready var metallic_color: ColorRect = get_node(metallic_color_path)
onready var normal_texture: TextureRect = get_node(normal_texture_path)
onready var roughness_options: PopupPanel = get_node(roughness_options_path)
onready var roughness_spin: SpinBox = get_node(roughness_spin_path)
onready var roughness_slider: Slider = get_node(roughness_slider_path)
onready var roughness_texture_opt: TextureRect = get_node(roughness_texture_opt_path)
onready var roughness_channel: OptionButton = get_node(roughness_channel_path)
onready var metallic_options: PopupPanel = get_node(metallic_options_path)
onready var metallic_check: CheckBox = get_node(metallic_check_path)
onready var metallic_texture_opt: TextureRect = get_node(metallic_texture_opt_path)
onready var metallic_channel: OptionButton = get_node(metallic_channel_path)
onready var specular_spin: SpinBox = get_node(specular_spin_path)
onready var specular_slider: Slider = get_node(specular_slider_path)
onready var normal_options: PopupPanel = get_node(normal_options_path)
onready var normal_spin: SpinBox = get_node(normal_spin_path)
onready var normal_slider: Slider = get_node(normal_slider_path)
onready var normal_texture_opt: TextureRect = get_node(normal_texture_opt_path)
onready var ao_enabled: CheckBox = get_node(ao_enabled_path)
onready var ao_box: BoxContainer = get_node(ao_box_path)
onready var ao_spin: SpinBox = get_node(ao_spin_path)
onready var ao_slider: Slider = get_node(ao_slider_path)
onready var ao_texture: TextureRect = get_node(ao_texture_path)
onready var ao_texture_opt: TextureRect = get_node(ao_texture_opt_path)
onready var ao_options: PopupPanel = get_node(ao_options_path)
onready var ao_channel: OptionButton = get_node(ao_channel_path)
onready var ao_uv2: CheckBox = get_node(ao_uv2_path)
onready var more_options: MenuButton = get_node(more_options_path)
onready var advanced_dialog: PopupPanel = get_node(advanced_dialog_path)
onready var more_options_menu: PopupMenu = more_options.get_popup()

onready var plain_mat: SpatialMaterial = plain_color_material.duplicate()

var original_path: String
var active_material_path: String
var active_material: Material
var surf_name: String
var surf_index: int
var mesh_nodepath: String
var visibility_state: int = VisibilityState.VISIBLE
var shade_state: int = ShadeState.SHADED
var file_dialog_path: String
var dialog: FileDialog


func _ready() -> void:
	if Tools.is_node_being_edited(self):
		return
	for node in get_tree().get_nodes_in_group("SpriteBaker.FileDialog"):
		if node is FileDialog:
			dialog = node
			break
	if active_material:
		get_node(surface_name_path).text = surf_name
		update_material(active_material)
		set_material_name(active_material_path)
	assert(more_options_menu.connect("id_pressed", self, "_on_MoreOptions_id_pressed") == OK)


func init(sn: String, mp: String, si: int, op: String, am: Material) -> void:
	surf_name = sn
	mesh_nodepath = mp
	surf_index = si
	original_path = op
	active_material = am
	active_material_path = op


func set_plain_color(color: Color) -> void:
	plain_mat.albedo_color = color


func update_material(mat: Material) -> void:
	if mat is SpatialMaterial:
		update_spatial_material(mat as SpatialMaterial)
	else:
		printerr("Material of class " + mat.get_class() + " not supported")
		return
	for node in get_tree().get_nodes_in_group("SpriteBaker.Materials"):
		node.update_surface_material(mesh_nodepath, surf_index, mat)


func update_spatial_material(mat: SpatialMaterial) -> void:
	# Albedo
	albedo_color.color = mat.albedo_color
	set_texture_rect(mat.albedo_texture, albedo_texture)

	# Roughness
	var rval: float = mat.roughness
	roughness_slider.value = rval
	roughness_color.color = Color(rval, rval, rval)
	set_texture_rect(mat.roughness_texture, roughness_texture)
	set_texture_rect(mat.roughness_texture, roughness_texture_opt)
	if mat.roughness_texture:
		roughness_color.hide()
		roughness_channel.select(mat.roughness_texture_channel)
	else:
		roughness_texture.hide()
		roughness_channel.select(1)
		mat.roughness_texture_channel = 1

	# Metallic
	var mval: float = 0.0 if mat.metallic < 0.6 else 1.0
	mat.metallic = mval
	metallic_check.pressed = true if mval == 1.0 else false
	metallic_color.color = Color(mval, mval, mval)
	set_texture_rect(mat.metallic_texture, metallic_texture)
	set_texture_rect(mat.metallic_texture, metallic_texture_opt)
	if mat.metallic_texture:
		metallic_color.hide()
		metallic_channel.select(mat.metallic_texture_channel)
	else:
		metallic_texture.hide()
		metallic_channel.select(2)
		mat.metallic_texture_channel = 2
	specular_slider.value = mat.metallic_specular

	### Advanced options

	# Normal
	set_texture_rect(mat.normal_texture, normal_texture)
	set_texture_rect(mat.normal_texture, normal_texture_opt)
	normal_slider.value = mat.normal_scale

	# AO
	ao_enabled.pressed = mat.ao_enabled
	enable_ao(mat.ao_enabled)
	ao_slider.value = mat.ao_light_affect
	set_texture_rect(mat.ao_texture, ao_texture)
	set_texture_rect(mat.ao_texture, ao_texture_opt)
	if mat.ao_texture:
		ao_channel.select(mat.ao_texture_channel)
	else:
		ao_channel.select(0)
		mat.ao_texture_channel = 0
	ao_uv2.pressed = mat.ao_on_uv2


func disable_buttons(group: String, disabled: bool) -> void:
	for node in get_tree().get_nodes_in_group(group):
		if is_a_parent_of(node):
			node.disabled = disabled


func set_material_name(path: String) -> void:
	material_name.text = path.get_file()
	material_name.hint_tooltip = path


func set_texture_rect(texture: Texture, node: TextureRect) -> void:
	node.texture = texture
	var clear_button: Button = node.get_node("Clear")
	if texture:
		clear_button.disabled = false
		clear_button.show()
	else:
		clear_button.disabled = true
		clear_button.hide()


func popup_texture_dialog(tex_rect: TextureRect, method: String) -> void:
	file_dialog_path = dialog.current_dir
	if tex_rect.texture:
		var texture_path: String  = tex_rect.texture.resource_path.get_base_dir()
		dialog.current_dir = texture_path
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.filters = TEXTURE_EXTS
	dialog.set_meta("on_texture_selected", method)
	dialog.popup_centered(Vector2(500, 500))
	if not dialog.is_connected("file_selected", self, "_on_texture_file_selected"):
		assert(dialog.connect("file_selected", self, "_on_texture_file_selected") == OK)


func popup_material_dialog() -> void:
	file_dialog_path = dialog.current_dir

	dialog.current_dir = active_material_path.get_base_dir()
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.filters = MAT_EXTS
	dialog.popup_centered(Vector2(500, 500))
	if not dialog.is_connected("file_selected", self, "_on_material_file_selected"):
		assert(dialog.connect("file_selected", self, "_on_material_file_selected") == OK)


func set_albedo_texture(texture: Texture) -> void:
	set_texture_rect(texture, albedo_texture)
	active_material.albedo_texture = texture


func set_roughness(value: float) -> void:
	roughness_color.color = Color(value, value, value)
	active_material.roughness = value


func set_roughness_texture(texture: Texture) -> void:
	set_texture_rect(texture, roughness_texture)
	set_texture_rect(texture, roughness_texture_opt)
	active_material.roughness_texture = texture
	roughness_color.hide()
	roughness_texture.show()


func set_metallic_texture(texture: Texture) -> void:
	set_texture_rect(texture, metallic_texture)
	set_texture_rect(texture, metallic_texture_opt)
	active_material.metallic_texture = texture
	metallic_color.hide()
	metallic_texture.show()


func set_normal_texture(texture: Texture) -> void:
	set_texture_rect(texture, normal_texture)
	set_texture_rect(texture, normal_texture_opt)
	active_material.normal_texture = texture
	active_material.normal_enabled = true


func set_ao_texture(texture: Texture) -> void:
	set_texture_rect(texture, ao_texture)
	set_texture_rect(texture, ao_texture_opt)
	active_material.ao_texture = texture


func enable_ao(enabled: bool) -> void:
	active_material.ao_enabled = enabled
	for i in range(1, ao_box.get_child_count()):
		if enabled:
			ao_box.get_child(i).show()
		else:
			ao_box.get_child(i).hide()
	ao_options.rect_size = Vector2(0,0)


func saveas() -> void:
	file_dialog_path = dialog.current_dir
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.filters = MAT_EXTS
	dialog.popup_centered(Vector2(500, 500))
	if not dialog.is_connected("file_selected", self, "_on_saveas_file_selected"):
		assert(dialog.connect("file_selected", self, "_on_saveas_file_selected") == OK)


func copied_material_available() -> void:
	more_options_menu.set_item_disabled(MenuOpt.PASTE, false)
	more_options_menu.set_item_disabled(MenuOpt.PASTE_UNIQUE, false)


func paste_material(mat: Material, unique: bool) -> void:
	if unique:
		update_material(mat.duplicate())
	else:
		update_material(mat)


func _on_saveas_file_selected(file: String) -> void:
	assert(ResourceSaver.save(file, active_material,
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS + ResourceSaver.FLAG_CHANGE_PATH) == OK)


func _on_Hide_pressed() -> void:
	visibility_state = (visibility_state + 1) % 3
	var mat: Material
	if visibility_state == VisibilityState.VISIBLE:
		hide.icon = VisibleIcon
		mat = plain_mat if shade_state == ShadeState.PLAIN else active_material
		disable_buttons("SpriteBaker.MaterialProps.Hide", false)
		if shade_state == ShadeState.PLAIN:
			mat = plain_mat
			set_material_name(plain_color_material.resource_path)
			disable_buttons("SpriteBaker.MaterialProps.PlainColor", true)
			more_options_menu.set_item_disabled(MenuOpt.ADVANCED_OPTIONS, true)
		else:
			mat = active_material
			set_material_name(active_material_path)
			more_options_menu.set_item_disabled(MenuOpt.ADVANCED_OPTIONS, false)
		hide.hint_tooltip = "Toggle visibility: visible"
	elif visibility_state == VisibilityState.HIDDEN:
		hide.icon = HiddenIcon
		mat = hidden_material
		hide.hint_tooltip = "Toggle visibility: hidden"
		set_material_name(hidden_material.resource_path)
		disable_buttons("SpriteBaker.MaterialProps.Hide", true)
		more_options_menu.set_item_disabled(MenuOpt.ADVANCED_OPTIONS, true)
	elif visibility_state == VisibilityState.XRAY:
		hide.icon = XrayIcon
		mat = hidden_xray_material
		hide.hint_tooltip = "Toggle visibility: X-Ray"
		set_material_name(hidden_xray_material.resource_path)
		disable_buttons("SpriteBaker.MaterialProps.Hide", true)
		more_options_menu.set_item_disabled(MenuOpt.ADVANCED_OPTIONS, true)
	update_material(mat)


func _on_Unshaded_pressed() -> void:
	shade_state = (shade_state + 1) % 3
	var mat: Material
	var disable_buttons: bool = false
	var mat_path: String
	if shade_state == ShadeState.SHADED:
		unshaded.icon = ShadedIcon
		active_material.flags_unshaded = false
		unshaded.hint_tooltip = "Toggle shading: shaded"
		mat = active_material
		albedo_color.color = active_material.albedo_color
		mat_path = active_material_path
	elif shade_state == ShadeState.UNSHADED:
		unshaded.icon = UnshadedIcon
		active_material.flags_unshaded = true
		mat = active_material
		unshaded.hint_tooltip = "Toggle shading: unshaded"
		albedo_color.color = active_material.albedo_color
		mat_path = active_material_path
	elif shade_state == ShadeState.PLAIN:
		unshaded.icon = PlainColorIcon
		unshaded.hint_tooltip = "Toggle shading: plain color"
		mat = plain_mat
		albedo_color.color = plain_mat.albedo_color
		disable_buttons = true
		mat_path = plain_color_material.resource_path
	if visibility_state == VisibilityState.VISIBLE:
		disable_buttons("SpriteBaker.MaterialProps.PlainColor", disable_buttons)
		more_options_menu.set_item_disabled(MenuOpt.ADVANCED_OPTIONS, disable_buttons)
		update_material(mat)
		set_material_name(mat_path)


func _on_texture_file_selected(path: String) -> void:
	dialog.disconnect("file_selected", self, "_on_texture_file_selected")
	dialog.current_dir = file_dialog_path

	var texture: Texture = load(path)
	var method: String = dialog.get_meta("on_texture_selected")
	dialog.remove_meta("on_texture_selected")
	call(method, texture)


func _on_material_file_selected(path: String) -> void:
	dialog.disconnect("file_selected", self, "_on_material_file_selected")
	dialog.current_dir = file_dialog_path

	var mat: Material = load(path)
	if mat is SpatialMaterial:
		update_material(mat)
		active_material_path = path
		active_material = mat
		material_name.text = path.get_file()
		if active_material_path != original_path:
			more_options_menu.set_item_disabled(MenuOpt.RESTORE_ACTIVE, false)


func _on_Color_color_changed(color: Color) -> void:
	var mat: SpatialMaterial = plain_mat if shade_state == ShadeState.PLAIN else active_material
	mat.albedo_color = color


func _on_Clear_albedo_pressed() -> void:
	set_texture_rect(null, albedo_texture)
	active_material.albedo_texture = null


func _on_AlbedoTexture_pressed() -> void:
	popup_texture_dialog(albedo_texture, "set_albedo_texture")


func _on_Roughness_pressed() -> void:
	var rect:  = Rect2(roughness_texture.rect_global_position, Vector2.ONE)
	rect.position.y += roughness_texture.rect_size.y
	roughness_options.popup(rect)


func _on_RoughnessSlider_value_changed(value: float) -> void:
	roughness_spin.value = value
	set_roughness(value)


func _on_RoughnessSpin_value_changed(value: float) -> void:
	roughness_slider.value = value
	set_roughness(value)


func _on_RoughnessTexture_pressed() -> void:
	popup_texture_dialog(roughness_texture, "set_roughness_texture")


func _on_Clear_roughness_pressed() -> void:
	set_texture_rect(null, roughness_texture)
	set_texture_rect(null, roughness_texture_opt)
	active_material.roughness_texture = null
	roughness_texture.hide()
	roughness_color.show()


func _on_RoughnessChOpt_item_selected(id: int) -> void:
	active_material.roughness_texture_channel = id


func _on_Metallic_pressed() -> void:
	var rect:  = Rect2(metallic_texture.rect_global_position, Vector2.ONE)
	rect.position.y += metallic_texture.rect_size.y
	metallic_options.popup(rect)


func _on_MetallicCheck_toggled(button_pressed: bool) -> void:
	var val: float = 1.0 if button_pressed else 0.0
	metallic_color.color = Color(val, val, val)
	active_material.metallic = val


func _on_MetallicTexture_pressed() -> void:
	popup_texture_dialog(metallic_texture, "set_metallic_texture")


func _on_Clear_metallic_pressed() -> void:
	set_texture_rect(null, metallic_texture)
	set_texture_rect(null, metallic_texture_opt)
	active_material.metallic_texture = null
	metallic_texture.hide()
	metallic_color.show()


func _on_MetallicChOpt_item_selected(id: int) -> void:
	active_material.metallic_texture_channel = id


func _on_SpecularSlider_value_changed(value: float) -> void:
	specular_spin.value = value
	active_material.metallic_specular = value


func _on_SpecularSpin_value_changed(value: float) -> void:
	specular_slider.value = value
	active_material.metallic_specular = value


func _on_Normal_pressed() -> void:
	var rect:  = Rect2(normal_texture.rect_global_position, Vector2.ONE)
	rect.position.y += normal_texture.rect_size.y
	normal_options.popup(rect)


func _on_NormalSlider_value_changed(value: float) -> void:
	normal_spin.value = value
	active_material.normal_scale = value


func _on_NormalSpin_value_changed(value: float) -> void:
	normal_slider.value = value
	active_material.normal_scale = value


func _on_NormalTexture_pressed() -> void:
	popup_texture_dialog(normal_texture, "set_normal_texture")


func _on_Clear_normal_pressed() -> void:
	set_texture_rect(null, normal_texture)
	set_texture_rect(null, normal_texture_opt)
	active_material.normal_enabled = false
	active_material.normal_texture = null


func _on_MaterialName_pressed() -> void:
	popup_material_dialog()


func _on_MoreOptions_id_pressed(id: int) -> void:
	match id:
		MenuOpt.ADVANCED_OPTIONS:
			var pos: = Vector2(more_options.rect_global_position.x,
				more_options.rect_global_position.y + more_options.rect_size.y)
			var rect: = Rect2(pos, Vector2.ONE)
			advanced_dialog.popup(rect)
		MenuOpt.LOAD:
			popup_material_dialog()
		MenuOpt.SAVE:
			assert(ResourceSaver.save(active_material_path,
				active_material, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS) == OK)
		MenuOpt.SAVEAS:
			saveas()
		MenuOpt.RESTORE_ORIGINAL:
			var mat: Material = load(original_path)
			update_material(mat.duplicate())
			more_options_menu.set_item_disabled(MenuOpt.RESTORE_ACTIVE, true)
		MenuOpt.RESTORE_ACTIVE:
			var mat: Material = load(active_material_path)
			update_material(mat.duplicate())
		MenuOpt.COPY:
			emit_signal("material_copied", active_material)
		MenuOpt.PASTE:
			emit_signal("paste_material", self, false)
		MenuOpt.PASTE_UNIQUE:
			emit_signal("paste_material", self, true)


func _on_AOSlider_value_changed(value: float) -> void:
	ao_spin.value = value
	active_material.ao_light_affect = value


func _on_AOSpin_value_changed(value: float) -> void:
	ao_slider.value = value
	active_material.ao_light_affect = value


func _on_AOEnabled_toggled(button_pressed: bool) -> void:
	enable_ao(button_pressed)


func _on_AOTexture_pressed() -> void:
	popup_texture_dialog(normal_texture, "set_ao_texture")


func _on_AO_pressed() -> void:
	var rect:  = Rect2(ao_texture.rect_global_position, Vector2.ONE)
	rect.position.y += ao_texture.rect_size.y
	ao_options.popup(rect)


func _on_Clear_ao_pressed() -> void:
	set_texture_rect(null, ao_texture)
	set_texture_rect(null, ao_texture_opt)
	active_material.ao_texture = null


func _on_AOChOpt_item_selected(id: int) -> void:
	active_material.ao_texture_channel = id


func _on_AOUv2_toggled(button_pressed: bool) -> void:
	active_material.ao_on_uv2 = button_pressed
