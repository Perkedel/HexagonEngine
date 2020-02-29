tool
extends Tree

signal selected_animations(selected)

const Tools: Script = preload("tools.gd")

const PlayIcon: Texture = preload("res://addons/sprite-baker/resources/icons/play.svg")
const StopIcon: Texture = preload("res://addons/sprite-baker/resources/icons/stop.svg")
const PauseIcon: Texture = preload("res://addons/sprite-baker/resources/icons/pause.svg")
const LoopIcon: Texture = preload("res://addons/sprite-baker/resources/icons/loop.svg")
const LoopActiveIcon: Texture = preload("res://addons/sprite-baker/resources/icons/loop_active.svg")

enum Column {PLAY, STOP, NAME, CHECK, LOOP, FPS, LENGTH, FRAMES, EDIT}
enum PlayState {STOPPED, PLAYING, PAUSED}

var anim_player: AnimationPlayer
var frame_rate: float = 15.0
var selected: bool = false
var item_playing: TreeItem
var play_state: int = PlayState.STOPPED
var nanim: int = 0


func _ready() -> void:
	set_column_titles_visible(true)
	set_column_expand(Column.PLAY, false)
	set_column_min_width(Column.PLAY, 30)
	set_column_expand(Column.STOP, false)
	set_column_min_width(Column.STOP, 30)
	set_column_title(Column.NAME, "Name")
	set_column_min_width(Column.NAME, 60)
	set_column_expand(Column.CHECK, false)
	set_column_min_width(Column.CHECK, 30)
	set_column_expand(Column.LOOP, false)
	set_column_min_width(Column.LOOP, 30)
	set_column_title(Column.FPS, "Fps")
	set_column_expand(Column.FPS, false)
	set_column_min_width(Column.FPS, 60)
	set_column_title(Column.LENGTH, "Length")
	set_column_min_width(Column.LENGTH, 60)
	set_column_expand(Column.LENGTH, false)
	set_column_title(Column.FRAMES, "Frames")
	set_column_min_width(Column.FRAMES, 60)
	set_column_expand(Column.FRAMES, false)
	set_column_min_width(Column.EDIT, 60)
	set_column_expand(Column.EDIT, false)


func update_model(model: Spatial) -> void: # SpriteBaker.Model group function
	clear()
	anim_player = Tools.find_single_node_by_type("AnimationPlayer", model)
	populate_anim_tree()
	emit_signal("selected_animations", true)
	selected = true


func clear_model() -> void: # SpriteBaker.Model group function
	clear()
	anim_player = null
	emit_signal("selected_animations", false)
	selected = false
	nanim = 0
	set_info()


func populate_anim_tree() -> void:
	if not anim_player:
		return
	var anim_list: PoolStringArray = anim_player.get_animation_list()
	if anim_list.size() == 0:
		return
	set_column_titles_visible(true)

	var root: TreeItem = create_item()
	for aname in anim_list:
		var item: TreeItem = create_item(root)

		# Play/Stop buttons
		item.add_button(Column.PLAY, PlayIcon, 0)
		item.add_button(Column.STOP, StopIcon, 0, true)

		var anim: Animation = anim_player.get_animation(aname)
		var is_loop: bool = anim.loop

		# Animation name
		var anim_name: String = aname
		if anim_name.find("|") != -1:
			anim_name = aname.right(anim_name.find_last("|")).strip_edges()
		if anim_name.ends_with("-loop"):
			anim_name = anim_name.left(anim_name.length() - 5)
			is_loop = true
		item.set_text(Column.NAME, anim_name)
		item.set_metadata(Column.NAME, aname)

		# Select checkbox
		item.set_cell_mode(Column.CHECK, TreeItem.CELL_MODE_CHECK)
		item.set_checked(Column.CHECK, true)
		item.set_editable(Column.CHECK, true)
		item.set_tooltip(Column.CHECK, "Selected animations will be considered for sprite sheet generation")

		# Loop
		if is_loop:
			item.add_button(Column.LOOP, LoopActiveIcon, 0)
		else:
			item.add_button(Column.LOOP, LoopIcon, 0)
		item.set_metadata(Column.LOOP, is_loop)
		item.set_tooltip(Column.LOOP, "Animation Looping")

		# FPS
		item.set_cell_mode(Column.FPS, TreeItem.CELL_MODE_RANGE)
		item.set_range_config(Column.FPS, 1, 60, 1)
		item.set_range(Column.FPS, frame_rate)
		item.set_editable(Column.FPS, true)
		item.set_tooltip(Column.FPS, "Frames per second")

		# Animation lenght
		item.set_text(Column.LENGTH, "%.2f" % anim.length)
		item.set_text_align(Column.LENGTH, TreeItem.ALIGN_CENTER)
		item.set_tooltip(Column.LENGTH, "Animation lenght (in seconds)")

		# Number of frames
		set_item_frames(item, frame_rate)
		item.set_text_align(Column.FRAMES, TreeItem.ALIGN_CENTER)
		item.set_tooltip(Column.FRAMES, "Number of frames")

	nanim = anim_list.size()
	set_info()


func get_selected_data() -> Dictionary:
	var data: Dictionary = {}
	var item: TreeItem = get_root().get_children()
	while item:
		if item.is_checked(Column.CHECK):
			var aname: String = item.get_metadata(Column.NAME)
			data[aname] = get_frame_keys(item)
		item = item.get_next()
	return data


func set_loop(anim_name: String, loop: bool) -> void: # SpriteBaker.Animation group function
	var anim: Animation = anim_player.get_animation(anim_name)
	anim.loop = loop
	var item: TreeItem = get_root().get_children()
	while item:
		if item.get_metadata(Column.NAME) == anim_name:
			break
		item = item.get_next()
	if item:
		var icon: Texture = LoopActiveIcon if loop else LoopIcon
		item.set_button(Column.LOOP, 0, icon)
		set_item_frames(item, item.get_range(Column.FPS))


func get_frame_keys(item: TreeItem) -> Array:
	var keys: Array = []
	var fps: float = item.get_range(Column.FPS)
	var anim: Animation = anim_player.get_animation(item.get_metadata(Column.NAME))
	var nframes: int = int(round(anim.length * fps))
	for i in range(nframes):
		keys.append(i * anim.length / float(nframes))
	if not anim.loop:
		keys.append(anim.length)
	return keys


func check_anim_changed(anim_name: String) -> void:
	if item_playing and item_playing.get_metadata(Column.NAME) != anim_name:
		item_playing.set_button_disabled(Column.STOP, 0, true)
		item_playing.set_button(Column.PLAY, 0, PlayIcon)
		play_state = PlayState.STOPPED
		item_playing = null


func play(anim_name: String) -> void: # SpriteBaker.Animation group function
	if not item_playing:
		var item: TreeItem = get_root().get_children()
		while item:
			if item.get_metadata(Column.NAME) == anim_name:
				item_playing = item
				break
			item = item.get_next()
		var fps: float = item.get_range(Column.FPS)
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.set_key_frames(fps)
	if play_state == PlayState.STOPPED:
		item_playing.set_button_disabled(Column.STOP, 0, false)
		item_playing.set_button(Column.PLAY, 0, PauseIcon)
		play_state = PlayState.PLAYING
	elif play_state == PlayState.PLAYING:
		item_playing.set_button(Column.PLAY, 0, PlayIcon)
		play_state = PlayState.PAUSED
	elif play_state == PlayState.PAUSED:
		item_playing.set_button(Column.PLAY, 0, PauseIcon)
		play_state = PlayState.PLAYING


func stop() -> void: # SpriteBaker.Animation group function
	item_playing.set_button_disabled(Column.STOP, 0, true)
	item_playing.set_button(Column.PLAY, 0, PlayIcon)
	play_state = PlayState.STOPPED
	item_playing = null


func set_anim_time(_time: float) -> void: # SpriteBaker.Animation group function
	pass


func set_key_frames(_fps: float) -> void: # SpriteBaker.Animation group function
	pass


func set_info() -> void:
	var info_label: Label
	for node in get_tree().get_nodes_in_group("SpriteBaker.Info"):
		if node.name == "BakeInfo":
			info_label = node
			break
	var info_txt: String = "Animations: " + String(nanim)
	info_label.text = Tools.replace_info(info_label.text, info_txt, 1)


func set_item_frames(item: TreeItem, fps: float) -> void:
	var anim: Animation = anim_player.get_animation(item.get_metadata(Column.NAME))
	var nframes: int = int(round(anim.length * fps))
	if not anim.loop:
		nframes += 1
	item.set_text(Column.FRAMES, String(nframes))


func _on_button_pressed(item: TreeItem, column: int, _id: int) -> void:
	if column == Column.LOOP:
		var is_loop: bool = not item.get_metadata(Column.LOOP)
		var aname: String = item.get_metadata(Column.NAME)
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.set_loop(aname, is_loop)
		item.set_metadata(Column.LOOP, is_loop)
	elif column == Column.PLAY:
		check_anim_changed(item.get_metadata(Column.NAME))
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.play(item.get_metadata(Column.NAME))
	elif column == Column.STOP:
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.stop()


func _on_item_edited() -> void:
	var col: int = get_edited_column()
	var item: TreeItem = get_edited()
	if col == Column.FPS:
		var fps: float = item.get_range(Column.FPS)
		set_item_frames(item, fps)
	elif col == Column.CHECK:
		var anim_selected: bool = item.is_checked(Column.CHECK)
		if anim_selected:
			nanim += 1
			if not selected:
				selected = true
				emit_signal("selected_animations", true)
		else:
			nanim -= 1
			item = get_root().get_children()
			selected = false
			while item:
				selected = item.is_checked(Column.CHECK)
				if selected:
					break
				item = item.get_next()
			if not selected:
				emit_signal("selected_animations", false)
		set_info()


func _on_FPS_value_changed(value: float) -> void:
	var item: TreeItem = get_root().get_children()
	while item:
		if item.get_range(Column.FPS) == frame_rate:
			item.set_range(Column.FPS, value)
			set_item_frames(item, value)
		item = item.get_next()
	frame_rate = value
