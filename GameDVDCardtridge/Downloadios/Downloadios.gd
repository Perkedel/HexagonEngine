extends Node

# https://godotengine.org/qa/40181/unpackaged-images-question?show=40229#a40229
# http://www.mocky.io/v2/5185415ba171ea3a00704eed
# https://via.placeholder.com/500
# https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html
# https://godotengine.org/qa/40181/unpackaged-images-question?show=40229#a40229
# https://godotengine.org/qa/40649/download-load-file-texture-into-sprite-node-using-httprequest
var loaded = false
var doDownload = false
var werror
@onready var statusBox = $Control/VBoxContainer/Splitron/StatusBox
@onready var imager = $Control/VBoxContainer/Splitron/Gambar
@onready var http = $HTTPRequest
@onready var httpJust = $HTTPRequestJustDownload
@onready var lineEditURL = $Control/VBoxContainer/URL/LineEditURL
@onready var lineEditDownload = $Control/VBoxContainer/DownloadInto/LineEditDownload
@onready var dialogDownload = $Control/DownloadFileDialog
@export var urlIs: String = "https://example.com"
@export var downloadInto: String = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/file" # folder

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogDownload.set_current_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	httpJust.set_download_file( downloadInto)
	lineEditDownload.text = downloadInto
	loaded = true
	pass # Replace with function body.

func launchDownload():
	werror = http.request(urlIs)
	if doDownload:
		httpJust.request(urlIs)
	print("Request werror is: ", String(werror))
	statusBox.text = String(werror)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_changed(new_text):
	if loaded:
		urlIs = new_text
	pass # Replace with function body.


func _on_Button_pressed():
	launchDownload()
	pass # Replace with function body.


func _on_LineEditDownload_text_changed(new_text):
	if loaded:
		downloadInto = new_text
		httpJust.set_download_file(new_text)
	pass # Replace with function body.


func _on_ButtonDownload_pressed():
	dialogDownload.popup_centered()
	pass # Replace with function body.


func _on_DownloadFileDialog_dir_selected(dir):
#	if loaded:
#		downloadInto = dir
#		lineEditDownload.text = dir
	pass # Replace with function body.


func _on_LineEditURL_text_entered(new_text):
	if loaded:
		urlIs = new_text
		launchDownload()
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var outputo = "\nResult: " + String(result) + "\nResponse:" + String(response_code) + "\nHeader: " + String(headers) + "\nBody: \n" + String(body) + "\nHex: \n" + String(body.hex_encode()) + "\nUTF-8: \n" + String(body.get_string_from_utf8()) + "\nJSON: \n"
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var jsoning = test_json_conv.get_data()
	var byteArray = body
	var imaging = Image.new()
	var image_werror = imaging.load_png_from_buffer(body)
	outputo += ""
	print("Result: ", String(body))
	print("Image werror = ", String(image_werror))
	if image_werror != OK:
		print("Image werror")
	var texturer = ImageTexture.new()
	texturer.create_from_image(imaging)

	imager.texture = texturer
	statusBox.text += outputo
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.


func _on_ChangeDVDButton_pressed():
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


func _on_DownloadFileDialog_file_selected(path):
	if loaded:
		lineEditDownload.text = path
		downloadInto = path
		httpJust.set_download_file(path)
	pass # Replace with function body.

"""
BUG! HTTP request only has body bytes if the download_file parameter isn't set or empty? idk.
if you set download_file, the completed request body wont return anything, nil!

it supposed to also has the value even download_file is set
"""
func _on_HTTPRequestJust_request_completed(result, response_code, headers, body):
#	var outputo = "\nResult: " + String(result) + "\nResponse:" + String(response_code) + "\nHeader: " + String(headers) + "\nBody: \n" + String(body) + "\nHex: \n" + String(body.hex_encode()) + "\nUTF-8: \n" + String(body.get_string_from_utf8()) + "\nJSON: \n"
#	var jsoning = JSON.parse(body.get_string_from_utf8())
#	var byteArray = body
#	var imaging = Image.new()
#	var image_werror = imaging.load_png_from_buffer(body)
#	#outputo += JSONBeautifier.beautify_json(jsoning.result)
#	print("Result: ", String(body))
#	print("Image werror = ", String(image_werror))
#	if image_werror != OK:
#		print("Image werror")
#	var texturer = ImageTexture.new()
#	texturer.create_from_image(imaging)
#
#	imager.texture = texturer
#	statusBox.text += outputo
	pass # Replace with function body.


func _on_CheckButton_toggled(button_pressed):
	doDownload = button_pressed
	pass # Replace with function body.
