A simple plugin, to make dealing with licensing simple.
Files: ./addons/simplelicense/*
License: CC0-1.0

Developed in Godot version: v4.0.beta.custom_build [166df0896]

Quick Example: (A License Viewer Scene, that you can also drop into one of your game scenes)
	Run the Scene at
	res://addons/simplelicense/GUI/LicenseGUI.tscn
	
	look around, then
	click on the "open data directory" button
	then click on the "save licenses" button
	and watch the data directory populate with license files


Quick Start:
	1. Create a "LicenseLink" Resource file inside the
		res://licenses/license_links/

	2. Click on the the new Resource file, and try it out
		There are docs on how to use it, so just F1 + LicenseLink, to find out more

	3. Load license information
		Create an instance of "LicenseManager" either in code or by adding the node to the scene
		then call "load_license_information" on the LicenseManager

	4. Export License information
		call "export" function on the LicenseManager
		it will populate the "user://" directory with your license files
		one combined "COPYRIGHT.txt" file
		and individual copyright files into "user://licenses/<license_identifier>.txt".
		The license text will be formatted in the SPDX standard.
		It's the way the Godot Engine does it.
		 in the Godot Editor: Help -> About Godot -> Third-party Licenses
		There is more you can do, just visit the docs!
		(Like support for loading mod's license information!)
