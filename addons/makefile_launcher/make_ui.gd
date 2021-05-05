tool
extends Control


const make_target_scene = preload("make_target.tscn")

onready var targets_container = $HSplitContainer/TargetsAndTools/Panel/MarginContainer/TargetsContainer/Targets
onready var output_label = $HSplitContainer/OutputAndTools/Output/MarginContainer/Label
onready var output_container = $HSplitContainer/OutputAndTools
onready var show_hide_output_button = $HSplitContainer/TargetsAndTools/Tools/ShowHideOutput/ShowHideButton
onready var confirmation_dialog = $ConfirmationDialog

var processing = false
var thread = null
var current_make_node = null



func _ready():
	reload_makefile()
	confirmation_dialog.set_as_toplevel(true)


func reload_makefile():
	var project_dir = Directory.new()
	project_dir.open("res://")
	var file_name = null
	if project_dir.file_exists("makefile"):
		file_name = "makefile"
	elif project_dir.file_exists("Makefile"):
		file_name = "Makefile"
	if file_name != null:
		var makefile = File.new()
		makefile.open("res://" + file_name, File.READ)
		var make_contents = makefile.get_as_text()
		
		makefile.close()
		for c in targets_container.get_children():
			targets_container.remove_child(c)
			c.queue_free()
		_parse(make_contents)


func _get_command_string(target_name, properties : Dictionary):
	var command_text = target_name
	
	for k in properties:
		command_text += " " + k + "=\"" + properties[k] + "\""
	return command_text


func _on_target_selected(target_name, properties : Dictionary, make_node):
	if processing:
		return
	
	var command_text = _get_command_string(target_name, properties)
	var commands = [target_name]
	
	for k in properties:
		commands.append(k + "=" + properties[k])

	thread = Thread.new()
	processing = true
	current_make_node = make_node
	current_make_node.set_loading(true)
	thread.start(self, "_thread_process", [commands, command_text])


func _on_target_require_confirmation(target_name, properties : Dictionary, make_node):
	if processing:
		return
	
	confirmation_dialog.connect("confirmed", self, "_on_target_selected", [target_name, properties, make_node])
	confirmation_dialog.dialog_text = "make " + _get_command_string(target_name, properties)
	confirmation_dialog.popup_centered(Vector2(260, 100))


func _on_confirmation_dialog_hide():
	confirmation_dialog.disconnect("confirmed", self, "_on_target_selected")


func _thread_process(commands_and_text):
	var output = []
	var exit_code = OS.execute("make", commands_and_text[0], true, output, true)
	
	var output_lines = ""
	for line in output:
		output_lines += line
	call_deferred("_thread_terminated", commands_and_text[1], output_lines, exit_code)


func _thread_terminated(command_text, output_text, exit_code):
	output_label.append_bbcode("[b]" + ("[color=#a5efac]✓ " if exit_code == 0 else "[color=#ff5d5d]✖ ") + "make " + command_text + "[/color][/b]\n" + output_text + "\n")
	current_make_node.set_loading(false)
	processing = false
	thread.wait_to_finish()
	thread = null


func toggle_output_visibility():
	output_container.visible = not output_container.visible
	show_hide_output_button.rect_rotation = 90 * (1 if output_container.visible else -1)


func clear_output():
	output_label.bbcode_text = ""


func _parse(make_contents : String):
	var lines = make_contents.split("\n")
	var properties_regex = RegEx.new()
	properties_regex.compile("(\\w+)")
	var target_regex = RegEx.new()
	target_regex.compile("^(\\w+):")
	
	var properties = []
	var confirmation_required = false
	for l in lines:
		var target_res = target_regex.search(l)
		var l_trimmed : String  = l.strip_edges(true, true)
		if l_trimmed.find("#args: ") == 0:
			var l_args = l_trimmed.substr("#args: ".length())
			var res = properties_regex.search_all(l_args)
			for r in res:
				if not properties.has(r.get_string(1)):
					properties.append(r.get_string(1))
		elif l_trimmed.find("#confirm") == 0:
			confirmation_required = true
		elif target_res != null:
			_submit_target(target_res.get_string(1), properties, confirmation_required)
			properties = []
			confirmation_required = false


func _submit_target(target_name, property_names, confirmation_required):
	var make_entry = make_target_scene.instance()
	if confirmation_required:
		make_entry.connect("target_selected", self, "_on_target_require_confirmation", [make_entry])
	else:
		make_entry.connect("target_selected", self, "_on_target_selected", [make_entry])
	targets_container.add_child(make_entry)
	make_entry.initialize(target_name, property_names, confirmation_required)
