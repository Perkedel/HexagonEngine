extends Node

onready var http = $HTTPRequest
onready var notif = $Label

onready var logined = false
onready var new_profile = false
onready var information_sent = false

var result_body_http

# https://www.youtube.com/watch?v=Udm7uDQM05w
# https://www.youtube.com/watch?v=-vDNk7BzOGc

var emaile
var passworde
var Datapush = {
	
}

func _ready():
	
	pass


func _on_Emaile_text_changed(new_text):
	emaile = new_text
	pass # Replace with function body.


func _on_Pasworde_text_changed(new_text):
	passworde = new_text
	pass # Replace with function body.


func _on_Regist_pressed():
	FirebaseQuest.register(emaile,passworde,http)
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	result_body_http = JSON.parse(body.get_string_from_ascii()).result as Dictionary
	
	if not logined:
		if response_code != 200:
			notif.text = response_body.result.error.message.capitalize()
			print(notif.text)
		else:
			notif.text = "Auth sucessful!"
			logined = true
			# 
	
	match response_code:
		404:
			notif.text = "Please, enter your information"
			new_profile = true
			return
		200:
			if information_sent:
				notif.text = "Information saved successfully"
				information_sent = false
	
	
	pass # Replace with function body.


func _on_Login_pressed():
	FirebaseQuest.login(emaile,passworde,http)
	pass # Replace with function body.


func _on_DATAPUSH_text_changed(new_text):
	Datapush["Andel"] = {"stringValue":new_text}
	pass # Replace with function body.


func _on_PUSH_pressed():
	
	FirebaseQuest.update_document("pengguna/%s" % FirebaseQuest.user_info.id, Datapush, http)
	information_sent = true
	pass # Replace with function body.


func _on_refreshClip_pressed():
	if logined:
		FirebaseQuest.get_document("pengguna/%s" % FirebaseQuest.user_info.id,http)
		yield(http,"request_completed")
		if logined:
			Datapush = result_body_http.fields
			notif.text = "Fields are:\n" + String(Datapush)
			$DATAPUSH.text = String(Datapush["Andel"].stringValue)
	else:
		notif.text = "Not logined"
	pass # Replace with function body.
