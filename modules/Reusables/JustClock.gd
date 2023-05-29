@tool
extends Control
# https://www.keshikan.net/fonts-e.html
# JOELwindows7 remake the clock again in Godot, add Unix time too!

@export var textColor: Color = Color.GREEN_YELLOW: set = set_text_color
@export var offColor: Color = Color(0.1,0.1,0.1): set = set_off_color
@export var bekgronColor: Color = Color.BLACK: set = set_bekgron_color
@onready var bekgron = $Bekgron
@onready var dayText = $ThoughFields/topField/Day
@onready var dateText = $ThoughFields/topField/Date
@onready var hourMinText = $ThoughFields/bottomField/HourMin
@onready var secondText = $ThoughFields/bottomField/Second
@onready var unixTimeText = $ThoughFields/underField/UnixTime

@onready var dayTextFake = $BehindFields/topField/Day
@onready var dateTextFake = $BehindFields/topField/Date
@onready var hourMinTextFake = $BehindFields/bottomField/HourMin
@onready var secondTextFake = $BehindFields/bottomField/Second
@onready var unixTimeTextFake = $BehindFields/underField/UnixTime

var weekdayName = "SEN"

var datetime = Time.get_datetime_dict_from_system()
var unixtime = Time.get_unix_time_from_system()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_text_color(with:Color = Color.GREEN_YELLOW):
	textColor = with
	_syncParameter()

func set_off_color(with:Color = Color(0.1,0.1,0.1)):
	offColor = with
	_syncParameter()

func set_bekgron_color(with:Color = Color.BLACK):
	bekgronColor = with
	_syncParameter()

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

func _syncParameter():
	_startClock()
	pass

func _updateClock():
	datetime = Time.get_datetime_dict_from_system()
	unixtime = Time.get_unix_time_from_system()
	if bekgron != null:
		bekgron.self_modulate = bekgronColor
#		bekgron.set_deferred("self_modulate", bekgron)
	
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
	
	if dayText != null:
		dayText.text = "{hari}.".format({
			hari = weekdayName
		})
		dateText.text = "{tanggal}-{bulan}-{tahun}".format({
			tanggal = String.num(datetime.day).pad_zeros(2),
			bulan = String.num(datetime.month).pad_zeros(2),
			tahun = String.num(datetime.year).pad_zeros(4)
		})
	
	if hourMinText != null:
		hourMinText.text = "{jam}:{menit}".format({
			jam = String.num(datetime.hour).pad_zeros(2),
			menit = String.num(datetime.minute).pad_zeros(2)
		})
	
	if secondText != null:
		secondText.text = "{coloning}{detik}".format({
			detik = String.num(datetime.second).pad_zeros(2),
			coloning = ":" if datetime.second % 2 == 0 else " "
		})
	
	if unixTimeText != null:
		unixTimeText.text = "{waktuUnix}".format({
			waktuUnix = String.num_int64(unixtime).pad_zeros(20)
		})
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_startClock()
	pass # Replace with function body.

func _init():
#	call_deferred("_syncParameter")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_updateClock()
	pass
