@tool
extends EditorPlugin

# Following Godot's official tutorial - Making plugins:
# https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html

const Main := preload("res://addons/godot_style/main.tscn")

var main_instance: Control

func _enter_tree() -> void:
	
	# Initialization of the plugin goes here.
	main_instance = Main.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_instance)
	_make_visible(false)
	
	if not main_instance.gdscript_syntax_highlighter:
		main_instance.gdscript_syntax_highlighter = _get_godot_syntax_highlighter()
	return


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if main_instance:
		main_instance.queue_free()
	return

func _has_main_screen() -> bool:
	return true
	
	
func _make_visible(visible: bool) -> void:
	if main_instance:
		main_instance.visible = visible
		if not main_instance.gdscript_syntax_highlighter:
			main_instance.gdscript_syntax_highlighter = _get_godot_syntax_highlighter()
	return
	
	
func _get_plugin_name() -> String:
	return "Style"
	
	
func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Script", "EditorIcons")


# Re-assign the SyntaxHighlighter on editor startups
# after first-use of the plugin
func _set_window_layout(configuration: ConfigFile) -> void:
	if not main_instance.gdscript_syntax_highlighter:
		main_instance.gdscript_syntax_highlighter = _get_godot_syntax_highlighter()
	return
	

func _enable_plugin() -> void:
	if not main_instance.gdscript_syntax_highlighter:
		main_instance.gdscript_syntax_highlighter = _get_godot_syntax_highlighter()
	return
	

func _get_godot_syntax_highlighter() -> SyntaxHighlighter:
	var editor_interface: EditorInterface
	var script_editor: ScriptEditor
	var open_scripts_editors: Array[ScriptEditorBase]
	var code_edit: CodeEdit
	var syntax_highlighter: SyntaxHighlighter
	
	editor_interface = get_editor_interface()
	if editor_interface:
		script_editor = editor_interface.get_script_editor()
	if script_editor:
		open_scripts_editors = script_editor.get_open_script_editors()
		
	for editor in open_scripts_editors:
		if editor.is_class("ScriptTextEditor"):
			code_edit = editor.get_base_editor()
			syntax_highlighter = code_edit.get_syntax_highlighter()
			
			if syntax_highlighter.is_class("GDScriptSyntaxHighlighter"):
				return syntax_highlighter
	return null
