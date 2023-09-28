class_name LicenseManager
extends Node

## loads license information from this directory and the sub-directory "license_links"
@export var load_dir: String = "res://licenses"

## export license information to this directory and the sub-directory "licenses"
@export var export_dir: String = "user://"

## This disables loading Godot's built-in license information [br]
## this is for mods, in which the main game will have already shown the Godot's built-in Licensing
@export var exclude_engine: bool = false

## contains all loaded [License]s [br]
## key = identifier [br]
## value = [License]
var licenses := {} 

## contains all loaded [LicenseLink]s [br]
## with searching in mind [br]
## "array" [] [br]
## "by_identifier" {} license identifier [br]
## "by_parent" {} parent component name [br]
var license_links := {
	'array': [],
	'by_identifier': {},
	'by_parent': {},
}


## Loads license information from [member load_dir] [br]
func load_license_information():
	licenses.clear()
	license_links.array.clear()
	license_links.by_identifier.clear()
	license_links.by_parent.clear()
	
	if not DirAccess.dir_exists_absolute(load_dir):
		printerr("Failed to find license directory ", load_dir)
		return
	
	licenses = License._load_licenses_in(load_dir)
	if licenses.has('Expat') and not licenses.has('MIT'):
		var l = licenses['Expat'].duplicate() as License
		l.identifier = 'MIT'
		licenses['MIT'] = l
	
	license_links = LicenseLink._load_links_in(load_dir.path_join('license_links'), exclude_engine)


## Returns a single string "file", that is formatted in the SPDX Standard [br]
## that contains all licensing information, contained in this instance, [br]
## if only_links, then the returned data will omit the licensing term files
func get_combined_copyright(only_links: bool = false) -> String:
	var lines = ""
	
	var used_licenses = {}
	
	# Links
	for link in license_links.array:
		if link is LicenseLink:
			lines += link.to_formatted_string(link.component_of == 'Godot Engine')
			lines += '\n'
			used_licenses.merge(get_all_valid_licenses(link))
	
	lines += '\n\n'
	
	if only_links:
		return lines
	
	# License Terms
	var values = used_licenses.values()
	for i in len(values):
		if i+1 < len(values):
			lines += values[i].to_formatted_string() + '\n'
		else:
			lines += values[i].to_formatted_string()

	return lines

## Returns all licenses that are "valid"/exist [br]
## Sometimes license files are missing, or Identifiers are incorrectly spelled, this helps with that.
func get_all_valid_licenses(link: LicenseLink) -> Dictionary:
	var d = {}
	for x in link.license_identifiers:
		if licenses.has(x):
			d[x] = licenses[x]
	return d

## export all license information to [member export_dir] and the sub-directory "licenses"
func export(directory: String = ""):
	if directory.is_empty():
		directory = export_dir
	
	var licenses_path = directory.path_join('licenses')
	if not DirAccess.dir_exists_absolute(licenses_path):
		DirAccess.make_dir_recursive_absolute(licenses_path)
	
	# Export the combined license file
	var f = FileAccess.open(directory.path_join('COPYRIGHT.txt'), FileAccess.WRITE)
	if f is FileAccess:
		f.store_string(self.get_combined_copyright())
	
	# Export the slim license file
	f = FileAccess.open(directory.path_join('COPYRIGHT_SLIM.txt'), FileAccess.WRITE)
	if f is FileAccess:
		f.store_string(self.get_combined_copyright(true))
	
	
	# Export the individual license files
	
	var used = {}
	for i in license_links.array.size():
		var license = license_links.array[i] as LicenseLink
		var ids = self.get_all_valid_licenses(license)
		used.merge(ids)
		
		for id in ids:
			var license_path = licenses_path.path_join(id)+'.txt'
			f = FileAccess.open(license_path, FileAccess.WRITE)
			f.store_string(licenses[id].to_formatted_string())
