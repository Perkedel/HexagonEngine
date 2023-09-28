class_name LicenseLink
extends Resource

## Files that are under this license [br]
## [color=red]WARNING[/color] DO NOT put in any file that Godot Cannot load, via Resource.load() [br]
## or it will prevent the game from launching. files like .txt .csg etc
@export var link_files: Array[Resource]

## Directories that are under this license [br]
## The given file's Parent Directory will be tracked [br]
## [color=red]WARNING[/color] DO NOT put in any file that Godot Cannot load, via Resource.load()  [br]
## or it will prevent the game from launching. files like .txt .csg etc
@export var link_dirs: Array[Resource]

## Files that are under this license [br]
## Note: These paths are [b]NOT[/b] automatically tracked, [br]
## you will have to, manually keep these paths up to date 
@export var link_paths: Array

## Example: Godot_Icon, Custom Font Name, Your Games Name, etc
@export var componet_name: String = ""

## Gets included in [method to_formatted_string] right after [member componet_name] [br]
## as part of the "Comment:" Section of the SPDX format
@export var extra: String = ""

## SPDX-License-Identifier or similar to it.  CASE SENSITIVE[br]
## Like "CC0-1.0" or more complex entries like [br]
## "CC0-1.0 or MIT" [br]
## "CC0-1.0 and MIT" [br]
## See [url=https://spdx.org/licenses/]SPDX Identifier List[/url]
@export var license_identifier: String = "" : set = _set_identifier

## who and when was the copyright was created [br]
## example [br]
## 2022, John Doe [br]
## (next entry) [br]
## 2022-2023, Jim Stirling, Corp xyz [br]
@export var copyright: Array[String]

var license: License

## Unlike [member license_identifier] this contains [b]ONLY[/b] the identifiers [br]
var license_identifiers: Array[String]

## Either "Godot Engine" or "Game" [br]
## This value is AUTO GENERATED [br]
## [b]DON'T SET THIS VALUE MANUALLY[/b], IT CAN BREAK THINGS
var component_of: String = ""


func _init() -> void:
	_set_identifier(license_identifier)


func _set_identifier(v: String):
	license_identifier = v
	
	var tmp = v.replace(' and ', '!break!').replace(' or ', '!break!').split('!break!', false)
	for x in tmp:
		license_identifiers.append(x)


func _to_string() -> String:
	return self.to_formatted_string()

## Returns a string containing this link's information, formatted to [url=https://spdx.dev/resources/use/]SPDX Standards[/url]
func to_formatted_string(hide_files: bool = false):
	var _files = ""
	if not hide_files:
		for x in link_files:
			_files += x.resource_path.replace("res://", " ./").strip_edges() + "\n"
		for x in link_dirs:
			_files += (
				x.resource_path.replace("res://", " ./").rsplit("/", false, 1)[0].strip_edges()
				+ "/*\n"
			)
		for x in link_paths:
			_files += x.replace("res://", " ./").strip_edges() + "\n"
	_files = _files.strip_edges()

	var _comment = ""
	if not componet_name.is_empty():
		_comment += componet_name
		if not extra.is_empty():
			_comment += "\n"
	if not extra.is_empty():
		_comment += extra

	return "Files:{files}\nComment:{comment}\nCopyright:{copyright}\nLicense:{identifier}\n".format(
		{
			"files": _add_line_padding(_files, " "),
			"comment": _add_line_padding(_comment, " "),
			"copyright": _add_line_padding("\n".join(copyright), " "),
			"identifier": _add_line_padding(license_identifier, " "),
		}
	)


# wouldn't recomend using this, unless you know what your doing
# but if you do, this loads and parses all links (LicenseLink Resource files) in a directory, 
# plus Godot's built-in Licenses
#
# exclude engine: excludes loading Godot's built-in license information
# this is for mods, in which the main game will have already shown the Godot Engine's Licensing
static func _load_links_in(dir: String, exclude_engine: bool = false):
	var dict = {
		'array': [],
		'by_identifier': {},
		'by_parent': {},
	}
	
	if not DirAccess.dir_exists_absolute(dir):
		printerr('Simple License: LicenseLinks directory is missing! ', dir)
		return dict
	
	
	# get Game license links
	var names = DirAccess.get_files_at(dir)
	if len(names) == 0:
		print_verbose("\nSimple License: No LicenseLinks found in dir\n", dir, "\nif you have no LicenseLinks there, then this can be ignored\n")
	for name in names:
		name = name.replace('.remap', '')
		var path = dir.path_join(name)
		var res = ResourceLoader.load(path)
		if res is Resource and res.get("copyright") != null:
			if res.component_of.is_empty():
				res.component_of = "Game"
			
			dict.array.append(res)
			
			dict.by_identifier[res.license_identifier] = res
			
			if not dict.by_parent.has(res.component_of):
				dict.by_parent[res.component_of] = {}
			dict.by_parent[res.component_of][res.componet_name] = res
	
	# Get Engine license links
	if not exclude_engine:
		for a in Engine.get_copyright_info():
			var l = new()
			l.componet_name = a.name
			l.component_of = "Godot Engine"
			l.link_paths = a.parts[0].files
			
			l.license_identifier = a.parts[0].license
			l.copyright.append_array(a.parts[0].copyright)
			
			dict.array.append(l)
			
			dict.by_identifier[l.license_identifier] = l
			
			if not dict.by_parent.has(l.component_of):
				dict.by_parent[l.component_of] = {}
			
			if not dict.by_parent[l.component_of].has(l.license_identifier):
				dict.by_parent[l.component_of][l.componet_name] = l
	
	return dict

# this is for formatting individual lines accoring to SPDX standards
static func _add_line_padding(combined_lines: String, padding: String) -> String:
	if combined_lines.is_empty():
		return combined_lines
	
	var lines = combined_lines.split("\n")
		
	var s = ""
	for i in len(lines):
		if lines[i].is_empty() or lines[i] == "\n":
			if i+1 < len(lines):
				s += padding + "." + "\n"
			else:
				s += '\n'
		else:
			s += padding + lines[i] + "\n"
	s = s.strip_edges(false)
	return s
