tool
extends Control

var api = preload("./SheetsApi.gd").new()
var current_sheet = -1
var enabled = false

func _ready():
	api.enabled = enabled
	if(enabled == false):
		return
	api.connect("auth_code_granted",self,"auth_code_granted")
	api.connect("access_revoked",self,"access_revoked")
	api.connect("log_msg",self,"handle_log")
	#api.connect("sheet_loaded",self,"handle_sheet_loaded")

	add_child(api)
	if(api.sheets.size() > 0):
		# add list item
		current_sheet = 0
		var menu = $WindowDialog/padding/content/main/SheetSelect/menu

		menu.add_item(api.sheets[0][0])
		menu.set_item_metadata(0,api.sheets[0][1])
		menu.selected = 0

func handle_log(message):
	if(enabled == false):
		return
	var Log = $WindowDialog/padding/content/main/Errors/Log as TextEdit
	Log.text += "\r\n"+message


func auth_code_granted(code):
	if(enabled == false):
		return

	$WindowDialog/padding/content/buttons/Revoke.disabled = false

	$WindowDialog/padding/content/buttons/SignIn.hide()
	$WindowDialog/padding/content/buttons/Revoke.show()
	$WindowDialog/padding/content/main/SheetSelect.show()

func access_revoked():
	if(enabled == false):
		return
	$WindowDialog/padding/content/buttons/SignIn.disabled = false

	$WindowDialog/padding/content/buttons/SignIn.show()
	$WindowDialog/padding/content/buttons/Revoke.hide()
	$WindowDialog/padding/content/main/SheetSelect.hide()

func _on_SignIn_pressed():
	if(enabled == false):
		return
	#if($WindowDialog/padding/content/main/SheetSelect/LineEdit.text == ""):
	#	$UiAnimations.play("Need Sheet ID")
	#	return
	api.request_auth_code()
	$WindowDialog/padding/content/buttons/SignIn.disabled = true


func _on_Revoke_pressed():
	if(enabled == false):
		return
	api.revoke_access()
	$WindowDialog/padding/content/buttons/Revoke.disabled = true


func _on_refresh_pressed():
	if(enabled == false):
		return

	var menu = $WindowDialog/padding/content/main/SheetSelect/menu
	api.get_all_sheet_values(menu.get_item_metadata(current_sheet))

	pass # Replace with function body.


func _on_menu_pressed():
	if(enabled == false):
		return
	var menu = $WindowDialog/padding/content/main/SheetSelect/menu
	var current_selection = menu.get_item_metadata(current_sheet)

	menu.text = "Loading Sheets..."

	api.get_drive_sheets()
	var data = yield(api,"json_handled")
	menu.clear()
	var new_selection=0
	if(data.has("items")):
		for file in data.items:
			menu.add_item(file.title)
			menu.set_item_metadata(menu.get_item_count()-1,file.id)
			if(file.id == current_selection):
				new_selection = menu.get_item_count()-1
	
	current_selection = new_selection
	menu.selected = new_selection

func _on_menu_item_selected(ID):
	if(enabled == false):
		return
	current_sheet = ID
