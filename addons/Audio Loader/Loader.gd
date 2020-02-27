extends Control
var path_song
var audio_stream_player
signal _play
func load_ogg(file):
	var path = file
	var ogg_file = File.new()
	ogg_file.open(path, File.READ)
	var bytes = ogg_file.get_buffer(ogg_file.get_len())
	var stream = AudioStreamOGGVorbis.new()
	stream.data = bytes
	emit_signal("_play", stream)
	ogg_file.close()

func _on_FileDialog_file_selected(path):
	print('LOADING FILE FROM: ' + str(path))
	load_ogg(path)

func file_popup():
	var popup = FileDialog.new()
	popup.resizable = true
	popup.set_access(FileDialog.ACCESS_FILESYSTEM)
	popup.add_filter('*.ogg')
	popup.set_mode(FileDialog.MODE_OPEN_FILE)
	popup.connect("file_selected", self, "_on_FileDialog_file_selected")
	get_tree().root.add_child(popup)
	popup.set_owner(get_tree().root)
	popup.popup_centered()
