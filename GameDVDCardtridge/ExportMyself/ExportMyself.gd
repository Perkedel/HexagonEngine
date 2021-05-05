extends Node

# Quine
# I have been downvoted
# pls. don't turn me into Indonesian version of Dev! no pls no!
# pls. don't turn me into Failing Narwhals (Dr Apeis former brand) Indonesian version!

# This coding right here is what this DVD runs. Litterally!
# You are right now reading the code being ran for this demo.

# Here is example and proof that this DVD prints its own GDscript
var b = 1
var c = 3

# See, it indeed copy everything here right to the node of CodeFillSelf the
# TextEdit node.


## Big gap just to clarify

# haha big gap

# don't try this at actual coding job!

# This DVD replicates its own source code!!!
# Here's quine. Technique to print own source code
# https://en.wikipedia.org/wiki/Quine_%28computing%29
onready var theTextEdit = $Sgond/CodeFillSelf
onready var AreYouSureDialog = $AreYouSureDialog
enum AreYouSureActions {ChangeDVD, Shutdown, Export}
var SelectAction

signal ChangeDVD_Exec()
signal Shutdown_Exec()

var Directorie

var ownSelfThisScript:String
export var ExportDVDDir = "user://GameDVDCartridge"
export var ExportDVDname = "ExportMyself"

func ExportMeSelf():
	# Coming soon
	Directorie = Directory.new()
	var testDir = Directorie.open(ExportDVDDir + ExportDVDname)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sgond/CodeFillSelf.text = String(self.get_script().source_code)
	# Get this node (ExportMyself), 
	# get the GDscript Resource, 
	# and get the source code in this GDscript Resource.
	print("Print me now!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# r/downvotesreally I went salty. Can this classify as Dev?
# r/downvotedintooblivion Serious Karma issue

# by JOELwindows7
# Perkedel Technologies
# GNU GPL v3


func _on_ChangeDVDButton_pressed():
	AreYouSureDialog.SpawnDialogWithAppendSure("Change DVD")
	SelectAction = AreYouSureActions.ChangeDVD
	pass # Replace with function body.

func _on_ShutdownButton_pressed():
	AreYouSureDialog.SpawnDialogWithAppendSure("Shutdown Hexagon Engine")
	SelectAction = AreYouSureActions.Shutdown
	pass # Replace with function body.

func _on_Export_This_DVD_to_user_data_pressed():
	AreYouSureDialog.SpawnDialogWithAppendSure("Export this DVD to user://GameDVDCartridge")
	SelectAction = AreYouSureActions.Export
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	match SelectAction:
		AreYouSureActions.ChangeDVD:
			emit_signal("ChangeDVD_Exec")
		AreYouSureActions.Shutdown:
			emit_signal("Shutdown_Exec")
		AreYouSureActions.Export:
			pass
	pass # Replace with function body.


func _on_AreYouSureDialog_NoImNotSure():
	pass # Replace with function body.
