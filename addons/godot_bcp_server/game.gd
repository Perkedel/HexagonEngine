# Godot BCP Server
# For use with the Mission Pinball Framework https://missionpinball.org
# Original code © 2021 Anthony van Winkle / Paradigm Tilt
# Released under the MIT License


extends Node
class_name MPFGame

# The list of modes currently active in MPF
var active_modes := []
# The full list of audit values
var audits := {}
# A list of player variables that are their own signal names
var auto_signal_vars := []
# All of the machine variables
var machine_vars := {}
# The current player
var player: Dictionary = {}
# All of the players in the current game
var players := []
# A lookup for preloaded scenes
var preloaded_scenes: Dictionary
# All of the machine settings
var settings: Dictionary = {}


signal player_update(variable_name, value)
signal player_added
signal credits


func _init() -> void:
  randomize()


func add_player(kwargs: Dictionary) -> void:
  players.append({
    "score": 0,
    "number": kwargs.player_num
  })
  emit_signal("player_added")


func preload_scene(path: String) -> void:
  if not preloaded_scenes.has(path):
    preloaded_scenes[path] = load(path)


func reset() -> void:
  players = []
  player = {}
  preloaded_scenes = {}


func retrieve_preloaded_scene(path: String) -> PackedScene:
  var scene: PackedScene
  if preloaded_scenes.has(path):
    scene = preloaded_scenes[path]
  else:
    Log.warn("Attempting to retrieve path '%s' which was not preloaded", path)
    scene = load(path)
  preloaded_scenes = {}
  return scene


func start_player_turn(kwargs: Dictionary) -> void:
  # Player nums are 1-based, so subtract 1
  player = players[kwargs.player_num - 1]


func update_machine(kwargs: Dictionary) -> void:
  var value = kwargs.value
  if value is String:
    value = value.http_unescape()
  if kwargs.name.begins_with("audit"):
    audits[kwargs.name] = value
  else:
    machine_vars[kwargs.name] = value
    if kwargs.name.begins_with("credits"):
      emit_signal("credits", kwargs.name, kwargs.value)


func update_modes(kwargs: Dictionary) -> void:
  active_modes = []
  while kwargs.running_modes:
    active_modes.push_back(kwargs.running_modes.pop_back()[0])


func update_player(kwargs: Dictionary) -> void:
  var target_player: Dictionary = players[kwargs.player_num - 1]
  # Ignore the initial values
  if not target_player.has(kwargs.name):
    target_player[kwargs.name] = kwargs.value
  else:
    target_player[kwargs.name] = kwargs.value
    if player == target_player:
      # Support specific events for designated listeners
      if kwargs.name in auto_signal_vars:
        emit_signal(kwargs.name, kwargs.value)
      # Also broadcast the general update for all subscribers
      emit_signal("player_update", kwargs.name, kwargs.value)


func update_settings(result: Dictionary) -> void:
  # TODO: Determine if settings changes are individual or the whole package
  settings = {}
  for option in result.settings:
    var s := {}
    # [name, label, sort, machine_var, default, values, settingType ]
    s.label = option[1]
    s.priority = option[2]
    s.variable = option[3]
    s.default = option[4]
    s.type = option[6]
    s.options = {}
    # The default interpretation uses strings as keys, convert to ints
    for key in option[5].keys():
      s.options[int(key)] = option[5][key]
    # The default brightness settings include percent signs, update them for string printing
    if s.label == "brightness":
      for key in s.options.keys():
        s.options[key] = s.options[key].replace("%", "%%")
    settings[option[0]] = s


## Receive an integer value and return a comma-separated string
static func comma_sep(n: int) -> String:
  var result := ""
  var i: int = int(abs(n))

  while i > 999:
    result = ",%03d%s" % [i % 1000, result]
    i /= 1000

  return "%s%s%s" % ["-" if n < 0 else "", i, result]


## Receive a string template and an integer, return the string
## formatted with an "s" if the number is anything other than 1
static func pluralize(template: String, val: int) -> String:
  return template % ("" if val == 1 else "s")
