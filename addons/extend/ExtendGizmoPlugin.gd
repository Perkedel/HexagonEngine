#*******************************************************************************#
#  ExtendGizmoPlugin.gd                                                         #
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

extends EditorSpatialGizmoPlugin

const Gizmo := preload("res://addons/extend/ExtendGizmo.gd")

var gizmo_class_name: String

signal start_drag
signal end_drag

func _init(gizmo_class_name2: String, color: Color) -> void:
	gizmo_class_name = gizmo_class_name2
	create_material("lines", color)
	create_handle_material("handles")

func create_gizmo(spatial: Spatial) -> EditorSpatialGizmo:
	if spatial.get_class() == gizmo_class_name:
		return Gizmo.new()
	else:
		return null

func get_name() -> String:
	return "﻿Extend:" + gizmo_class_name
#           ^-- This is a ZERO WIDTH NO-BREAK SPACE (U+FEFF)
