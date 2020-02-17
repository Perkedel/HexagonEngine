extends Node

export (String) var Inters = "Interstitial"
export (String) var Banner = "Banner"
export (String) var RewVid = "RewardedVideo"
enum StatusLED {LED_OFF, LED_OK, LED_FAILED}
#export (String) var KixlonzWalletPath = "user://Currency/Kixlonz.txt"
#var KixlonzFile
#export (float) var KixlonzCurrency = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# https://github.com/Shin-NiL/Godot-Android-Admob-Plugin
# https://github.com/kloder-games/godot-admob
#  https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number

func TriLoad():
	$Admob.load_banner()
	$Admob.load_interstitial()
	$Admob.load_rewarded_video()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#LoadKixlonz()
	TriLoad()
	pass # Replace with function body.

#Ad Reward
func LoadKixlonz():
#	KixlonzFile = File.new()
#	KixlonzFile.open(KixlonzWalletPath, File.READ)
#	var formater = KixlonzFile.get_as_text()
#	KixlonzCurrency = float(formater)
#	KixlonzFile.close()
	Kixlonzing.LoadKixlonz()
	pass
func SaveKixlonz():
#	KixlonzFile = File.new()
#	KixlonzFile.open(KixlonzWalletPath, File.WRITE)
#	var formatter = String(KixlonzCurrency)
#	KixlonzFile.store_string(formatter)
#	KixlonzFile.close()
	Kixlonzing.SaveKixlonz()
	pass
func AdRewardUserNow(HowMuch:float):
#	KixlonzCurrency+=HowMuch
#	SaveKixlonz()
	Kixlonzing.AdRewardUserNow(HowMuch)
	printWorke("REWARD KXZ GET = " + String(HowMuch))
	pass
#EndOfSection AdReward

#LED
#func PrepareLED():
#	#$UIman/Control/PreControl/PastaGigi/RemotIklan/Statuser/LEDs
#	pass
func SetLED(nodeName:String, statusSelect):
	$UIman/Control/PreControl/PastaGigi/RemotIklan/Statuser/LEDs.SetStatus(nodeName, statusSelect)
	pass
#EndOfSection LED

func printWorke(say):
	$"UIman/Control/PreControl/PastaGigi/RemotQUit/QuitDialoguer".printDebugMessage(say)
	printerr(String(say))
	pass

func printFaile(say):
	$"UIman/Control/PreControl/PastaGigi/RemotQUit/QuitDialoguer".printDebugMessage(say)
	printerr("\n\nUh oh... = " + String(say) + "\n\n")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UIman/Control/PreControl/PastaGigi/RemotQUit/CoinRewardShow.text = "Ad Reward = " + String(Kixlonzing.KixlonzCurrency) + " Kxz"
	pass

#AdMob Engine
func _on_Admob_banner_failed_to_load(error_code):
	printFaile(Banner + " Banner Failed To Load\n"+ String(error_code))
	SetLED(Banner,1)
	pass # Replace with function body.


func _on_Admob_banner_loaded():
	SetLED(Banner,0)
	printWorke(Banner + " Banner Loaded")
	AdRewardUserNow(5)
	pass # Replace with function body.


func _on_Admob_insterstitial_failed_to_load(error_code):
	SetLED(Inters,1)
	printFaile(Inters + " Interstitial Failed To Load"+String(error_code))
	pass # Replace with function body.


func _on_Admob_interstitial_closed():
	SetLED(Inters,-1)
	printWorke(Inters + " Interstitial Closed")
	pass # Replace with function body.


func _on_Admob_interstitial_loaded():
	SetLED(Inters, 0)
	printWorke(Inters + " Interstitial Loaded")
	AdRewardUserNow(10)
	pass # Replace with function body.


func _on_Admob_rewarded(currency, ammount):
	printWorke(RewVid + " Rewarded Video, Currency = " + String(currency) + ", Ammount = " + String(ammount))
	AdRewardUserNow(20 + ammount)
	pass # Replace with function body.


func _on_Admob_rewarded_video_closed():
	SetLED(RewVid,-1)
	printWorke(RewVid + " Rewarded Video Closed")
	pass # Replace with function body.


func _on_Admob_rewarded_video_failed_to_load(error_code):
	SetLED(RewVid,1)
	printFaile(RewVid + " Rewarded Videos Failed To Load" + String(error_code))
	pass # Replace with function body.


func _on_Admob_rewarded_video_left_application():
	printWorke(RewVid + " Rewarded Video, User Left Application")
	AdRewardUserNow(5)
	pass # Replace with function body.


func _on_Admob_rewarded_video_loaded():
	SetLED(RewVid, 0)
	printWorke(RewVid + " Rewarded Video Loaded")
	AdRewardUserNow(10)
	pass # Replace with function body.


func _on_Admob_rewarded_video_opened():
	printWorke(RewVid + " Rewarded Video Opened")
	AdRewardUserNow(10)
	pass # Replace with function body.


func _on_Admob_rewarded_video_started():
	printWorke(RewVid + " Rewarded Video Started")
	pass # Replace with function body.


# Buttons
# Load
func _on_Banner_pressed():
	$Admob.load_banner()
	pass # Replace with function body.

func _on_Interstitial_pressed():
	$Admob.load_interstitial()
	pass # Replace with function body.

func _on_RewardedVideo_pressed():
	$Admob.load_rewarded_video()
	pass # Replace with function body.

#Show
func _on_BannerSHow_pressed():
	$Admob.show_banner()
	pass # Replace with function body.

func _on_InterstitialSHow_pressed():
	$Admob.show_interstitial()
	pass # Replace with function body.

func _on_RewardedVideoSHow_pressed():
	$Admob.show_rewarded_video()
	pass # Replace with function body.

#Hide
func _on_BannerHide_pressed():
	$Admob.hide_banner()
	pass # Replace with function body.


func _on_QuitDialoguer_ChangeDVDPls():
	$Admob.hide_banner()
	emit_signal("ChangeDVD_Exec")
	printWorke("Change the DVD, My first message. GoodCool!")
	pass # Replace with function body.


func _on_QuitDialoguer_ShutdownSixLittleNightmarePls():
	$Admob.hide_banner()
	emit_signal("Shutdown_Exec")
	printWorke("Change the World, My final message. Goodb ye!")
	pass # Replace with function body.
