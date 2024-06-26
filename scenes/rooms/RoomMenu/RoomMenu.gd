extends Node2D
class_name RoomMenu

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]

var stage_index: int = 0; #The index of the stage currently selected in the menu window

const stage_index_maximum = 6

func stage_selected(): # A signal is connected by the select button.
	get_tree().change_scene_to_packed(room_to_go[stage_index])

func set_stage_index_increase(): # A signal is connected by the right button.
	stage_index += 1
	if stage_index >= stage_index_maximum:
		stage_index = 0

func set_stage_index_decrease(): # A signal is connected by the left button.
	stage_index -= 1
	if stage_index < 0:
		stage_index = stage_index_maximum - 1
