tool extends EditorImportPlugin

enum Presets {PRESET_DEFAULT}

func get_importer_name():
	return "nknz.scale_importer"

func get_visible_name():
	return "Scale Importer"

func get_recognized_extensions():
	return ["png"]

func get_save_extension():
	return "tex"

func get_resource_type():
	return "Texture"

func get_preset_count():
	return Presets.size()

func get_preset_name(preset):
	match preset:
		Presets.PRESET_DEFAULT:
			return "Default"
		_:
			return "Custom"

func get_import_options(preset):
	match preset:
		Presets.PRESET_DEFAULT:
			return [{
				"name": "scale_factor",
				"default_value": Vector2(1.0,1.0)},
				{
				"name": "interpolate_bilinear",
				"default_value": false
				}]
		_:
			return []

func get_option_visibility(option, options):
    return true

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var image=Image.new()
	var err=image.load(source_file)
	if err!=OK:
		return err
	var v:Vector2=options.scale_factor
	var it=Image.INTERPOLATE_NEAREST
	if options.interpolate_bilinear:
		it=Image.INTERPOLATE_BILINEAR
	image.resize(v.x*image.get_width(),v.y*image.get_height(),it)
	var itex:ImageTexture=ImageTexture.new()
	itex.create_from_image(image)
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], itex)