tool
extends Control
# https://www.keshikan.net/fonts-e.html
# JOELwindows7 remake the clock again in Godot, add Unix time too!

export(Color) var textColor = Color.greenyellow
export(Color) var offColor = Color(0.1,0.1,0.1)
export(Color) var bekgronColor = Color.black
onready var bekgron = $Bekgron
onready var dayText = $ThoughFields/topField/Day
onready var dateText = $ThoughFields/topField/Date
onready var hourMinText = $ThoughFields/bottomField/HourMin
onready var secondText = $ThoughFields/bottomField/Second
onready var unixTimeText = $ThoughFields/underField/UnixTime

onready var dayTextFake = $BehindFields/topField/Day
onready var dateTextFake = $BehindFields/topField/Date
onready var hourMinTextFake = $BehindFields/bottomField/HourMin
onready var secondTextFake = $BehindFields/bottomField/Second
onready var unixTimeTextFake = $BehindFields/underField/UnixTime

var weekdayName = "SEN"

var datetime = OS.get_datetime()
var unixtime = OS.get_unix_time()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _startClock():
	bekgron.self_modulate = bekgronColor
	
	dayTextFake.replaceColor(offColor)
	dateTextFake.replaceColor(offColor)
	hourMinTextFake.replaceColor(offColor)
	secondTextFake.replaceColor(offColor)
	unixTimeTextFake.replaceColor(offColor)
	
	dayText.replaceColor(textColor)
	dateText.replaceColor(textColor)
	hourMinText.replaceColor(textColor)
	secondText.replaceColor(textColor)
	unixTimeText.replaceColor(textColor)
	

	_updateClock()
	pass

func _updateClock():
	datetime = OS.get_datetime()
	unixtime = OS.get_unix_time()
	bekgron.self_modulate = bekgronColor
	
	match(datetime["weekday"]):
		0:
			weekdayName = "HUH"
		1:
			weekdayName = "SEN"
		2:
			weekdayName = "SEL"
		3:
			weekdayName = "RAB"
		4:
			weekdayName = "KAM"
		5:
			weekdayName = "JUM"
		6:
			weekdayName = "SAB"
		7:
			weekdayName = "MIN"
		_:
			weekdayName = "~~~"
			pass
	
	dayText.text = "{hari}.".format({
		hari = weekdayName
	})
	dateText.text = "{tanggal}-{bulan}-{tahun}".format({
		tanggal = String(datetime.day).pad_zeros(2),
		bulan = String(datetime.month).pad_zeros(2),
		tahun = String(datetime.year).pad_zeros(4)
	})
	hourMinText.text = "{jam}:{menit}".format({
		jam = String(datetime.hour).pad_zeros(2),
		menit = String(datetime.minute).pad_zeros(2)
	})
	secondText.text = "{detik}".format({
		detik = String(datetime.second).pad_zeros(2)
	})
	unixTimeText.text = "{waktuUnix}".format({
		waktuUnix = String(unixtime).pad_zeros(20)
	})
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_startClock()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_updateClock()
	pass
