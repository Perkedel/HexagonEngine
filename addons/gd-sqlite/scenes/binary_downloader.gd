tool

extends Control

class_name GDSQLiteBinaryDownloader

onready var http_request := $http_request as HTTPRequest
onready var close_timer := $close_timer as Timer
onready var message_label := $margin/panel/margin/v_box/h_box/v_box/status/value as Label
onready var download_progress_bar := $margin/panel/margin/v_box/progress_bar as ProgressBar

const download_url_format : String = "https://github.com/felaugmar/gd-sqlite/releases/download/{version}/{filename}"
var download_url : String

var version : String

func _ready() -> void:
	if version == null or version.empty():
		push_error('Version not informed!')
		return
	
	var native_library : GDNativeLibrary = preload("res://addons/gd-sqlite/gd-sqlite.gdnlib")
	var library_path := native_library.get_current_library_path()
	var library_path_file := library_path.get_file()
	
	$margin/panel/margin/v_box/h_box/v_box/version/value.text = version
	$margin/panel/margin/v_box/h_box/v_box/filename/value.text = library_path_file
	
	message_label.text = "Downloading the binary"
	
	http_request.download_file = library_path
	download_url = download_url_format.format({
		"version": version,
		"filename": library_path_file
	})
	http_request.request(download_url)

func _process(delta: float) -> void:
	download_progress_bar.value = float(http_request.get_downloaded_bytes()) / http_request.get_body_size()

func _on_http_request_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var success_message = "The binary was successfully downloaded"
		message_label.text = success_message
		print_debug(success_message)
		
		close_timer.start(3)
	else:
		message_label.text = "An error occurred, more info in the console"
		# Print detailed stuff to the console
		push_error('There was an error downloading the binary at "%s".' % download_url)
		push_error('The response code was "%d".' % response_code)
		
		# Remove the file in case of error
		var dir := Directory.new()
		if dir.file_exists(http_request.download_file):
			# But print the file content before removing it
			var file := File.new()
			if file.open(http_request.download_file, File.READ) == OK:
				if file.get_len() < 256: # Don't print if the file is too big
					var file_content := file.get_as_text()
					if not file_content.empty():
						push_error(file_content)
				file.close()
			
			dir.remove(http_request.download_file)
		
		close_timer.start(5)

func _on_close_timer_timeout() -> void:
	queue_free()
