class_name License
extends Resource
## Holds AUTO GENERATED License information

## SPDX-License-Identifier or similar to it.  CASE SENSITIVE[br]
## Like "CC0-1.0"[br]
## See [url=https://spdx.org/licenses/]SPDX Identifier List[/url]
var identifier: String = ""

## The License's Name. [br]
## Like "CC0 1.0 Universal"
var name: String = ""

## License Terms; The text of a license file
var terms: String = ""

## Returns a string containing this license's information, formatted to [url=https://spdx.dev/resources/use/]SPDX Standards[/url]
func to_formatted_string() -> String:
	return "License: {identifier}\n{terms}".format({
		'identifier': identifier,
		'terms': _add_line_padding(terms)
		})


# wouldn't recomend using this, unless you know what your doing
# but if you do, this loads and parses all licenses (.txt files) in a directory, 
# plus Godot's built-in Licenses
static func _load_licenses_in(dir: String):
	var dict = {}
	
	# get game licenses
	var names = DirAccess.get_files_at(dir)
	if names.size() == 0:
		print_verbose("\nSimple License: No License files found in dir\n", dir, "\nif you have no license files there, then this can be ignored\n")
	for _name in names:
		var ext = _name.rsplit('.', false, 1)
		if ext.size() == 0 or ext[-1] != 'txt':
			continue
		
		var l = new()
		l.identifier = _name.split('.', false, 1)[0]
		l.name = l.identifier
		l.terms = FileAccess.open(dir.path_join(_name), FileAccess.READ).get_as_text()
		dict[l.identifier] = l
	
	# get licenses built into the Godot Engine
	var tmp = Engine.get_license_info()
	for id in tmp:
		if dict.has(id):
			continue
		
		var l = new()
		l.identifier = id
		l.terms = tmp[id]
		dict[id] = l
	
	return dict


# this is for formatting individual lines accoring to SPDX standards
static func _add_line_padding(combined_lines: String, padding: String = " ") -> String:
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
	s += '\n'
	return s
