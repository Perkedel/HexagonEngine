#*******************************************************************************#
#  extend.gd                                                                    #
#*******************************************************************************#
#                             This file is part of:                             #
#                                    EXTEND                                     #
#                    https://github.com/hoontee/godot-extend                    #
#*******************************************************************************#
#  Copyright (c) 2020 hoontee @ Iron Stag Games.                                #
#                                                                               #
#  Extend is free software: you can redistribute it and/or modify               #
#  it under the terms of the GNU Affero General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or            #
#  (at your option) any later version.                                          #
#                                                                               #
#  Extend is distributed in the hope that it will be useful,                    #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of               #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                #
#  GNU Affero General Public License for more details.                          #
#                                                                               #
#  You should have received a copy of the GNU Affero General Public License     #
#  along with Extend.  If not, see <https://www.gnu.org/licenses/>.             #
#*******************************************************************************#

tool
extends EditorPlugin

const classes := [
	"Spatial",
	"CSGCombiner",
	"MeshInstance",
	"RigidBody",
	"StaticBody",
]
const GizmoPlugin := preload("res://addons/extend/ExtendGizmoPlugin.gd")

var editor_settings := get_editor_interface().get_editor_settings()
var color: Color = editor_settings.get_setting("editors/3d_gizmos/gizmo_colors/shape")
var gizmo_plugins := []
var old_global_transform: Transform

onready var undo_redo := get_undo_redo()

func _init() -> void:
	for v in classes:
		var gizmo_plugin := GizmoPlugin.new(v, color)
		gizmo_plugin.connect("start_drag", self, "start_drag")
		gizmo_plugin.connect("end_drag", self, "end_drag")
		gizmo_plugins.push_back(gizmo_plugin)

func _enter_tree() -> void:
	for gizmo_plugin in gizmo_plugins:
		add_spatial_gizmo_plugin(gizmo_plugin)

func _exit_tree() -> void:
	for gizmo_plugin in gizmo_plugins:
		remove_spatial_gizmo_plugin(gizmo_plugin)

func start_drag(spatial: Spatial) -> void:
	old_global_transform = spatial.global_transform

func end_drag(spatial: Spatial) -> void:
	undo_redo.create_action("Translate Scale")
	undo_redo.add_do_property(spatial, "global_transform", spatial.global_transform)
	undo_redo.add_undo_property(spatial, "global_transform", old_global_transform)
	undo_redo.commit_action()
