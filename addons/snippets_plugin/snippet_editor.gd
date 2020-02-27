tool
extends WindowDialog

var snippet_path = ""
var code = ""

#flags
var save_prompt
var txtChg

# Make simpler
onready var menu = $vbox/code.get_menu()
onready var editor = $vbox/code

func _ready():
	# Set flags
	save_prompt = false
	txtChg = 0
	# setup menu
	setup_menu()
# Setup Editor
	$vbox/menu/btnSave.disabled = true
	$vbox/menu/btnNumbers.pressed = true
	$vbox/menu/btnHighlight.pressed = true
	$vbox/menu/btnSyntax.pressed = true



func setup_menu():
	# Setup Context Menu
	editor.set_context_menu_enabled( true)
	menu.add_separator()
	menu.add_item("Line Numbers",-1,0)
	menu.add_item("Line Highlight",-1,0)
	menu.add_item("Syntax Highlight",-1,0)
#	menu.add_separator()

	# Setup Signal for added entries
	menu.connect( "id_pressed", self, "_on_menu_item_pressed")
#	set_visible(true)

func _on_menu_item_pressed(ID):
	# Check for added context menu items
#	print(menu.get_item_text(ID))
	if menu.get_item_text(ID) == "Line Numbers":
		# Line Number Toggle Method
		if editor.show_line_numbers: # Line numbers On
			editor.show_line_numbers = false # Line Numbers Off
		else:
			editor.show_line_numbers = true # Line Numbers On

	if menu.get_item_text(ID) == "Line Highlight":
		# Line Hightlight Toggle Method
		if editor.highlight_current_line:
			editor.highlight_current_line = false # Line Highlighting Off
		else:
			editor.highlight_current_line = true # Line Highlighting On

	if menu.get_item_text(ID) == "Syntax Highlight":
		# Line Hightlight Toggle Method
		if editor.syntax_highlighting:
			editor.syntax_highlighting = false # Line Highlighting Off
		else:
			editor.syntax_highlighting = true # Line Highlighting On


func savefile(content, path):
# Save Text Content to file
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(content)
	file.close()


func loadfile(path):
# Load Text Content from File
	var file = File.new()
	file.open(path, file.READ)
	var content = file.get_as_text()
	file.close()
	return content

func quit():
#	print("Save File: " + str(save_prompt))
	txtChg = 0

	if save_prompt == true:
		save_prompt = false # reset save flag to false
		$vbox/menu/btnSave.disabled = true
		# Save or Save As File
		$FileDialog.current_path = snippet_path
		$FileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
		$FileDialog.resizable = true
		$FileDialog.visible = true
		$FileDialog.popup_centered()



func _on_FileDialog_file_selected(path):
	if $FileDialog.MODE_SAVE_FILE:
#		print(ProjectSettings.globalize_path($FileDialog.current_path))
#		print($FileDialog.current_file)
		if not $FileDialog.current_file == "":
			savefile(editor.text, ProjectSettings.globalize_path($FileDialog.current_path))

func _on_snippet_editor_hide():
	quit()

func _on_code_text_changed():
	txtChg += 1 # Increment when text changes
#	print(txtChg)
	if txtChg > 2: # 2 is the default # of times txt changed when loading file
		# Hightlight Save Button
		$vbox/menu/btnSave.disabled = false
		save_prompt = true


func _on_btnSave_pressed():
	save_prompt = false # reset save flag to false
	$vbox/menu/btnSave.disabled = true
	# Save or Save As File
	$FileDialog.current_path = snippet_path
	$FileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
	$FileDialog.resizable = true
	$FileDialog.visible = true
	$FileDialog.popup_centered()

func _on_btnSyntax_toggled(button_pressed):
	# Line Hightlight Toggle Method
	if editor.syntax_highlighting:
		editor.syntax_highlighting = false # Line Highlighting Off
	else:
		editor.syntax_highlighting = true # Line Highlighting On


func _on_btnHighlight_toggled(button_pressed):
	# Line Hightlight Toggle Method
	if editor.highlight_current_line:
		editor.highlight_current_line = false # Line Highlighting Off
	else:
		editor.highlight_current_line = true # Line Highlighting On


func _on_btnNumbers_toggled(button_pressed):
	# Line Number Toggle Method
	if editor.show_line_numbers: # Line numbers On
		editor.show_line_numbers = false # Line Numbers Off
	else:
		editor.show_line_numbers = true # Line Numbers On
