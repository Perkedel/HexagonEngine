@tool
#class_name
extends Control

## Main UI of the addon

## Preloading section.tscn into a PackedScene ready to be instantiated
const SectionUI := preload("res://addons/godot_style/section_ui.tscn")

## Preloading markdown_implementation.gd as a helper
## (to keep codes seperate and relevant)
const Markdown := preload("res://addons/godot_style/markdown/markdown_implementation.gd")

## Passing Godot's SyntaxHighlighter to markdown_helper
var gdscript_syntax_highlighter: SyntaxHighlighter:
	set(value):
		gdscript_syntax_highlighter = value
		if markdown_helper:
			markdown_helper.gdscript_syntax_highlighter = gdscript_syntax_highlighter

var _selected_section_ui_tree: Tree = null

## Sections of type SectionResource to be displayed
@export var sections: Array[SectionResource]

## The first one will be default
@export var markdown_themes: Array[MarkdownTheme] = []

## MarkdownTheme resource - affecting this addon's custom controls and BBCode tags (color, bgcolor, etc.)
var markdown_theme: MarkdownTheme:
	set(new):
		markdown_theme = new
		set_theme(markdown_theme.controls_theme)
		# Re-select TreeItem to update custom theme
		if _selected_section_ui_tree:
			_selected_section_ui_tree.set_selected(_selected_section_ui_tree.get_selected(), 0)
		

@onready var sections_container: VBoxContainer = $HBoxContainer/NavigationTrees/SectionsContainer
@onready var markdown_helper := Markdown.new()
@onready var theme_button: OptionButton = $ThemePopup/ThemeButton

func _ready() -> void:
	_update_ThemeButton()
	markdown_theme = markdown_themes[0] # Must set a MarkdownTheme before _update()
	
	_update()
	return


func _shortcut_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if OS.get_keycode_string(event.get_key_label_with_modifiers()) == "Ctrl+T":
			%ThemePopup.visible = not %ThemePopup.visible
			get_viewport().set_input_as_handled()
			
		if OS.get_keycode_string(event.get_key_label_with_modifiers()) == "Ctrl+R":
				_update_ThemeButton()
				markdown_theme = markdown_themes[0]
				_update()
	return


func _update() -> void:
	# Deletion
	for child in sections_container.get_children():
		sections_container.remove_child(child)
		child.queue_free()
	
	# Adding sections to container
	for section in sections:
		if not section:
			push_warning("Godot Style: Empty SectionResource")
			continue
		
		var section_ui := SectionUI.instantiate()
		sections_container.add_child(section_ui) ## Ensuring tree is ready
		
		section_ui.tree.item_selected.connect(
			_on_SectionUI_Tree_item_selected.bind(section_ui.tree)
			# Pass in the corresponding Tree to have access to the correct selected item
		)
		
		section_ui.tree.add_to_group("trees")
		section_ui.display(section)
		
	# Selecting the first item
	var first_section_ui := sections_container.get_child(0)
	if not first_section_ui:
		push_warning("Godot Style: Cannot find any SectionUI")
		return
	
	first_section_ui.tree.set_selected(
		first_section_ui.tree.get_root().get_first_child(),
		0
	)
	
	# Apply custom controls' theme
	set_theme(markdown_theme.controls_theme)
	return


func _update_ThemeButton() -> void:
	theme_button.clear()
	
	for res in markdown_themes:
		if not res:
			return
		
		var text := "  " + res.name + "  " 
		theme_button.add_item(text)
	return


func _on_SectionUI_Tree_item_selected(tree: Tree) -> void:
	_selected_section_ui_tree = tree
	var selected_tree_item: TreeItem = tree.get_selected()
	var item: ItemResource = selected_tree_item.get_metadata(0) # This was set in the display() function
	
	# De-selecting items in other trees
	for tr in get_tree().get_nodes_in_group("trees"):
		if tr == tree:
			continue
		tr.deselect_all()
	
	# Setting content title
	if item.content_title:
		%ItemName.text = item.content_title
	else:
		%ItemName.text = ""
	
	# Deleting existing contents
	for child in %Contents.get_children():
		%Contents.remove_child(child)
		child.queue_free()
		
	# Markdown theme (setting colors to BBCode tags)
	markdown_helper.markdown_theme = markdown_theme
	
	# Adding Content of type file_path
	var viewer := markdown_helper.create_text_file_viewer(item.content_path)
	if viewer:
		%Contents.add_child(viewer)
	return


func _on_ThemeButton_item_selected(index: int) -> void:
	markdown_theme = markdown_themes[index]
	%ThemePopup.hide()
	return
