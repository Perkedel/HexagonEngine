@tool
#class_name
extends Resource

# Use RichTextLabel:
# Bold, italic, strikethrough texts
# Headings
# Lists
# Quoting inline codes
# Links
# Images
# Comments

# Use other Controls:
# Quoting texts (Label)
# Quoting code blocks (TextEdit)

# Might implement:
# Nested lists (BBCode's [indent] tag?)
# Alerts (Custom Control?)

# Won't implement yet:
# Supported color models
# Section links
# Relative links
# Specifying the theme an image is shown to
# Task lists
# Mentioning people and teams
# Referencing issues and pull requests
# Uploading assets
# Using emoji
# Footnotes

# Isn't used - Put on hold
enum List {
	NONE,
	ORDERED,
	UNORDERED,
}


const MarkdownViewer := preload("res://addons/godot_style/markdown/custom_controls/markdown_viewer.tscn")
const MarkdownRTL := preload("res://addons/godot_style/markdown/custom_controls/markdown_rtl.tscn")
const CodeBlock := preload("res://addons/godot_style/markdown/custom_controls/code_block.tscn")
const HeadingSpacer := preload("res://addons/godot_style/markdown/custom_controls/heading_spacer.tscn")
const LevelOneHeading := preload("res://addons/godot_style/markdown/custom_controls/level_one_heading.tscn")
const LevelTwoHeading := preload("res://addons/godot_style/markdown/custom_controls/level_two_heading.tscn")
const LevelThreeHeading := preload("res://addons/godot_style/markdown/custom_controls/level_three_heading.tscn")
const QuoteControl := preload("res://addons/godot_style/markdown/custom_controls/quote.tscn")


# Default colors - Github theme
# This is just for quick `replace all`
const color_inline_code := "#e6edf3"
const bgcolor_inline_code := "#343942"
const color_link := "#2c77e3"


var gdscript_syntax_highlighter: SyntaxHighlighter
var markdown_theme: MarkdownTheme


var _is_code_block := false
var _code_block_stack:  PackedStringArray = []
var _bbcode_stack: PackedStringArray = []


func create_text_file_viewer(path: String) -> VBoxContainer:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_warning("Godot Style: Cannot open file: " + "\"" + path + "\"")
		return null
	var content = file.get_as_text()
	
	if path.ends_with(".md"):
		return _create_md_viewer(content)
	return _create_txt_viewer(content)


# Not implemented yet
# Is this necessary?
func _create_txt_viewer(content: String) -> VBoxContainer:
	return


func _create_md_viewer(content: String) -> VBoxContainer:
	var viewer: VBoxContainer = MarkdownViewer.instantiate()
	
	# For every line, detect Headings, Quotes and Code Blocks
	# deal with those
	# and keep everything in order
	var lines := content.split("\n")
	for line in lines: # Looping through every line of content
		if line.begins_with("```"):
			if not _is_code_block:
				_add_bbcode_stack(viewer)
				_is_code_block = true
				continue
			else:
				_add_code_block(viewer)
				_is_code_block = false
				continue
		if _is_code_block:
			_stack_code_block(line)
			continue
		if line.begins_with("### "):
			_add_bbcode_stack(viewer)
			_add_heading_3(line.right(-4), viewer)
			continue
		if line.begins_with("## "):
			_add_bbcode_stack(viewer)
			_add_heading_2(line.right(-3), viewer)
			continue
		if line.begins_with("# "):
			_add_bbcode_stack(viewer)
			_add_heading_1(line.right(-2), viewer)
			continue
		if line.begins_with(">"):
			_add_bbcode_stack(viewer)
			_add_quote(line.right(-1), viewer)
			continue
		# Doesn't support nested quotes
		# Treat them as normal quotes
		if line.begins_with(">>"):
			_add_bbcode_stack(viewer)
			_add_quote(line.right(-1), viewer)
			continue
		_stack_bbcode(line)
		continue
	
	# Adding the remaining
	if _bbcode_stack.size():
		_add_bbcode_stack(viewer)
	if _code_block_stack.size():
		_add_code_block(viewer)
	return viewer


func _stack_bbcode(line: String) -> void:
	_bbcode_stack.append(line)
	return


func _clean_bbcode_stack() -> void:
	var clean: PackedStringArray = []
	for line in _bbcode_stack:
		if line == "":
			continue
			
		var regex := RegEx.new()
		regex.compile("[^\\t\\s]") # If the line contains only \t or \s
		if not regex.search(line):
			continue
		
		clean.append(line)
	_bbcode_stack = clean
	return


func _add_bbcode_stack(container: VBoxContainer) -> void:
	if _bbcode_stack.size() == 0:
		return
	# Clean-up - removing empty lines
	# - lines that only have \t or \s or have nothing
	_clean_bbcode_stack()
	if _bbcode_stack.size() == 0:
		return
	
	# New item
	var rt_label := MarkdownRTL.instantiate()
	rt_label.text = "\n".join(_bbcode_stack)
	rt_label.text = _markdown_to_bbcode(rt_label.text)
	container.add_child(rt_label)
	
	# Handling [url]
	rt_label.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	
	_bbcode_stack.clear()
	return


func _stack_code_block(line: String) -> void:	
	_code_block_stack.append(line)
	return


func _add_code_block(container: VBoxContainer) -> void:
	var code_block := CodeBlock.instantiate()
	
	if gdscript_syntax_highlighter:
		code_block.set_syntax_highlighter(gdscript_syntax_highlighter)
	else:
		push_warning("Godot Style: No SyntaxHighlighter")
	
	code_block.set_deferred("text", "\n".join(_code_block_stack))
	container.add_child(code_block)
	
	_code_block_stack.clear()
	return


func _add_heading_spacer(container: VBoxContainer) -> void:
	if container.get_child_count() == 0:
		return
		
	var control := HeadingSpacer.instantiate()
	container.add_child(control)
	return


func _add_heading_1(text: String, container: VBoxContainer) -> void:
	var label := LevelOneHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	label.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	_add_heading_spacer(container)
	container.add_child(label)
	return


func _add_heading_2(text: String, container: VBoxContainer) -> void:
	var label := LevelTwoHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	label.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	_add_heading_spacer(container)
	container.add_child(label)
	return
	
	
func _add_heading_3(text: String, container: VBoxContainer) -> void:
	var label := LevelThreeHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	label.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	_add_heading_spacer(container)
	container.add_child(label)
	return


func _add_quote(text: String, container: VBoxContainer) -> void:
	var hbox_container := QuoteControl.instantiate()
	var label := hbox_container.get_node("%Quote")
	text = _convert_styling(text)
	label.text = text
	label.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	container.add_child(hbox_container)
	return


func _markdown_to_bbcode(md: String) -> String:
	var content = md
	content = _convert_image(content) # Before _convert_link() which is in _convert_styling()
	content = _convert_styling(content)
	content = _convert_newline(content)
#	content = _convert_link(content)
#	content = _convert_unordered_list(content)
	
	# Indenting
	for _i in range(5): # I hope nobody indents more than 5 levels lol
		content = _convert_indentation(content)
		
	return content


# RegEx
func _convert_bolded(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\*\\*(?<bolded>[^*\\n]+?)\\*\\*")
	return regex.sub(md, "[b]${bolded}[/b]", true)


func _convert_italics(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\*(?<italics>[^*\\n]+?)\\*")
	return regex.sub(md, "[i]${italics}[/i]", true)


func _convert_strikethrough(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("~~(?<strikethrough>[^~\\n]+?)~~")
	return regex.sub(md, "[s]${strikethrough}[/s]", true)

# Github changes the bgcolor
# VSCode changes the font color
func _convert_inline_code(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("`(?<inline_code>[^`\\n]+?)`")
	
	var replacement := "[bgcolor=#%s][color=#%s][code]${inline_code}[/code][/color][/bgcolor]"
	var theme_applied := replacement % [
		markdown_theme.bgcolor_inline_code.to_html(),
		markdown_theme.color_inline_code.to_html()
	]
	return regex.sub(md, theme_applied, true)


func _convert_image(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("!\\[(?<alt_text>.+?)\\]\\((?<path>.+?)\\)")
	return regex.sub(md, "[img]${path}[/img]", true)


func _convert_link(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\[(?<text>.+?)\\]\\((?<path>.+?)\\)")
	
	var replacement := "[color=#%s][url=${path}]${text}[/url][/color]"
	var theme_applied := replacement % [
		markdown_theme.color_link.to_html()
	]
	return regex.sub(md, theme_applied, true)


func _convert_unordered_list(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("[+*-]\\s(?<item>.*)")
	return regex.sub(md, "[ul]${item}[/ul]", true)


func _convert_indentation(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\t(?<text>[^\\t\\n].*)")
	return regex.sub(md, "[indent]${text}[/indent]", true)


func _convert_newline(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\s\\s\\n")
	return regex.sub(md, "\n\n", true)


func _convert_styling(md: String) -> String:
	md = _convert_link(md) # Has to be before others
	md = _convert_bolded(md)
	md = _convert_italics(md)
	md = _convert_strikethrough(md)
	md = _convert_inline_code(md)
	return md


# Unsatisfactory results
# Put on hold
func _convert_lists() -> void:
	var temp_bb_code_stack: PackedStringArray = []
	var prev_ordered_items: PackedStringArray = []
	var prev_unordered_items: PackedStringArray = []
	var deepest_ordered_level: int = 0
	var deepest_unordered_level: int = 0
	
	for _i in range(5): # Five indentation levels
		prev_ordered_items.append("")
		prev_unordered_items.append("")
	
	# Categorizing lines into lists
	for line in _bbcode_stack:
		# Find potential lists
		var list_type := _can_be_list(line)
		if list_type == List.NONE:
			temp_bb_code_stack.append(line)
			continue
	
		# Calculate indentation level
		var space_level: int = 0
		for s in line.split("\t"):
			if s == "": # Is a tab
				space_level += 4
			else: # Encountered a character
				break
		
		for s in line.split(" "):
			if s == "":
				space_level += 1
			else:
				break
				
		var tab_level: int = floori(space_level / 4)

		line = line.dedent() # Remove current indentation

		# Adding the opening list tag
		if list_type == List.ORDERED:
			deepest_ordered_level = max(deepest_ordered_level, tab_level)
			line = line.right(-2) # Removing "1." - leaving the space
			
			if prev_ordered_items[tab_level] == "": # First ordered item of this indentation level
				line = "[ol]" + line
				prev_ordered_items[tab_level] = line
			else:
				prev_ordered_items[tab_level] = line
				
		elif list_type == List.UNORDERED:
			deepest_unordered_level = max(deepest_unordered_level, tab_level)
			line = line.right(-2) # Removing "- "
			
			if prev_unordered_items[tab_level] == "": # First unordered item of this indentation level
				line = "[ul]" + line
				prev_unordered_items[tab_level] = line
			else:
				prev_unordered_items[tab_level] = line
	
		temp_bb_code_stack.append(line)
	
	# Adding the closing list tag
	for last_item in prev_ordered_items:
		if last_item == "":
			continue
		var idx := temp_bb_code_stack.rfind(last_item)
		temp_bb_code_stack[idx] = last_item + "[/ol]"
		
	for last_item in prev_unordered_items:
		if last_item == "":
			continue
		var idx := temp_bb_code_stack.rfind(last_item)
		temp_bb_code_stack[idx] = last_item + "[/ul]"
		
	_bbcode_stack = temp_bb_code_stack
	return


func _can_be_list(line: String) -> List:
	var can_be_ordered := false
	var can_be_unordered := false
	var regex := RegEx.new()
	
	regex.compile("[1-9]\\.\\s")
	if regex.search(line, 0, 4):
		can_be_ordered = true
		
	regex.compile("[+*-]\\s")
	if regex.search(line, 0, 2):
		can_be_unordered = true
		
	if can_be_ordered:
		return List.ORDERED
	if can_be_unordered:
		return List.UNORDERED
		
	
	# Removing all the spacing (\t or \s) at the beginning of the line
#	regex.compile("[\\s\\t]*(?<line>.*)")
#	var no_prepend_space := regex.sub(line, "${line}", false) # Only the first occurence
	var no_prepend_space := line.dedent()
	
	# Continue with the same criteria
	regex.compile("[1-9]\\.\\s") # Note: Number starting the list can only be single-digit
	if regex.search(no_prepend_space, 0, 3):
		can_be_ordered = true
		
	regex.compile("[+*-]\\s")
	if regex.search(no_prepend_space, 0, 2):
		can_be_unordered = true
	
	if can_be_ordered:
		return List.ORDERED
	if can_be_unordered:
		return List.UNORDERED
	return List.NONE


# Handles RichTextLabel's [url] tag
func _on_RichTextLabel_meta_clicked(meta) -> void:
	var path := str(meta)
	var e
	
	var dir := DirAccess.open("res://")
	# Does this work?
	if dir.file_exists(path): # Is in the project
		e = OS.shell_open(ProjectSettings.globalize_path(path))
	else: # Is an external link
		e = OS.shell_open(path)
	
	if not e == OK:
		push_warning("Cannot open path: " + path + " or " + ProjectSettings.globalize_path(path))
	return
