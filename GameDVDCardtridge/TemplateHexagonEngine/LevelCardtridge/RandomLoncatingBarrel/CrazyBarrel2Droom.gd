extends Node2D

# https://en.wikipedia.org/wiki/Pop-up_Pirate
# https://patents.google.com/patent/US4398719?oq=Pop+up+pirate
# https://godot.readthedocs.io/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#match
# Switch case found!
# https://godotengine.org/qa/6925/does-gdscript-have-switch-or-case-statement

@export (int) var ButtonNumbers = 5
var currentGameButtonNumbers = 5
var currentButtonPressed = 0
var ButtonPressCounter = 0
@export (bool) var hasItPopped = false
@export (bool) var GameWon = false
@export (bool) var GameLost = false
@export (int) var Dicing = 0
@export (PackedScene) var PrussieButtons = load("res://GameDVDCardtridge/TemplateHexagonEngine/LevelCardtridge/RandomLoncatingBarrel/SparePart/PrussieButtonChanceAnezic.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal reportHP(level)
signal reportScore(number)
signal reportNextLevel(cardWhich)

func ApplyResetGame():
#	for i in $"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child_count():
#		$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).queue_free()
#		pass
	# https://github.com/godotengine/godot/issues/8125#issuecomment-518620363
	for child in $"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_children():
		print("Delete Prussie of " + child.name)
		child.free()
		
		pass
	currentGameButtonNumbers = ButtonNumbers
	ButtonPressCounter = 0
	hasItPopped = false
	GameWon = false
	GameLost = false
	# https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number
	#Dicing = rand_range(0, ButtonNumbers) # results float and sometimes decimal!
	#Dicing = randi()%0+ButtonNumbers # Division by zero error
	#Dicing = range(0,ButtonNumbers)[randi()%range(0,ButtonNumbers).size()]
	for i in ButtonNumbers:
		Dicing = range(0,ButtonNumbers)[randi()%range(0,ButtonNumbers).size()]
		var PrussieInstancer = PrussieButtons.instantiate()
		$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".add_child(PrussieInstancer)
		pass
	
	
	ConReNectPrussi()
	DisplayStatement(hasItPopped)
	$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(0).grab_focus()
	pass

func freshStart():
	Dicing = range(0,ButtonNumbers)[randi()%range(0,ButtonNumbers).size()]
	ApplyResetGame()
	Dicing = range(0,ButtonNumbers)[randi()%range(0,ButtonNumbers).size()]
	emit_signal("reportHP",100)
	pass

func ConReNectPrussi():
	for i in $"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child_count():
		$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).SetPrussieNumber(i)
		print("Setting Prussie " + String(i))
		$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).connect("IamPressed", Callable(self, "_PressThePrussie"))
		pass
	pass

func DisplayStatement(isItPoppedYet:bool):
	# https://godot.readthedocs.io/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#match
	# https://godotengine.org/qa/6925/does-gdscript-have-switch-or-case-statement
	# second answer
	match isItPoppedYet:
		false:
			$"UI-Standpoint/UI Game/Contains/Panel".self_modulate = Color.BLACK
			$"UI-Standpoint/UI Game/Contains/Panel/Display/Label".text = "Pop Up Barrel Game. Try your luck!"
			emit_signal("reportHP", 100)
			pass
		true:
			$"UI-Standpoint/UI Game/Contains/Panel".self_modulate = Color.RED
			$"UI-Standpoint/UI Game/Contains/Panel/Display/Label".text = "POP!!! It was Prussie No. " + String(currentButtonPressed+1) 
			emit_signal("reportHP", 0)
			pass
		_: # Bool doesn't need "default" switch case!
			pass
	pass

func itHasPopped():
	if ButtonNumbers < 2:
		Dicing = range(0,ButtonNumbers+1)[randi()%range(0,ButtonNumbers+1).size()]
		match Dicing:
			0:
				GameLost = true
				pass
			1:
				GameWon = true
				pass
			_:
				GameLost = true
				pass
		
		if GameWon:
			$"UI-Standpoint/UI Game/Contains/Panel".self_modulate = Color.BLUE
			$"UI-Standpoint/UI Game/Contains/Panel/Display/Label".text = "You won! You are very lucky!"
			emit_signal("reportHP", 100)
			pass
		elif GameLost:
			$BarrelSpeaker.play()
			$"UI-Standpoint/UI Game/Contains/Panel".self_modulate = Color.RED
			$"UI-Standpoint/UI Game/Contains/Panel/Display/Label".text = "POP!!! Better luck next time."
			emit_signal("reportHP", 0)
			pass
		pass
	else:
		if currentButtonPressed == Dicing:
			$BarrelSpeaker.play()
			hasItPopped = true
			if !GameWon:
				for i in $"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child_count():
					if i == currentButtonPressed:
						$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).modulate = Color.RED
						pass
					else:
						$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).modulate = Color.GREEN
						pass
					pass
				
				DisplayStatement(hasItPopped)
				GameLost = true
				pass
			pass
		else:
			if ButtonPressCounter >= ButtonNumbers-1 && !GameLost:
				GameWon = true
				$"UI-Standpoint/UI Game/Contains/Panel".self_modulate = Color.BLUE
				$"UI-Standpoint/UI Game/Contains/Panel/Display/Label".text = "You won! All but Prussie No. " +String(Dicing+1)+ " have been pressed!!!"
				emit_signal("reportHP", 100)
				
				for i in $"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child_count():
					if i == Dicing:
						$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).modulate = Color.RED
						pass
					else:
						$"UI-Standpoint/UI Game/Contains/ButtonSetsAccountable".get_child(i).modulate = Color.BLUE
						pass
					pass
				pass
			pass
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#ConReNectPrussi()
	freshStart()
	emit_signal("reportHP",100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singletoner.isGamePaused:
		if $"UI-Standpoint/UI Game".visible:
			print("Barrel Paused")
			$"UI-Standpoint/UI Game".hide()
			pass
		pass
	else:
		if !$"UI-Standpoint/UI Game".visible:
			print("Barrel Unpaused")
			$"UI-Standpoint/UI Game".show()
			pass # I know, after adding statement, pass is optional
		pass # But I have to know which is the end mark. idk.
	pass

func _PressThePrussie(NumberWhich):
	currentButtonPressed = NumberWhich
	ButtonPressCounter += 1
	itHasPopped()
	pass


func _on_BarrelSetupController_SendButtonNumbers(HowMany):
	ButtonNumbers = HowMany
	pass # Replace with function body.


func _on_BarrelSetupController_resetBarrelgame():
	ApplyResetGame()
	pass # Replace with function body.


func _on_HPlagWorkaround_timeout():
	DisplayStatement(hasItPopped)
	print("Refresh Digital HP")
	pass # Replace with function body.
