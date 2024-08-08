extends Node

#const save_file_path: String = "res://savegame.save"
const save_file_path: String = "user://savegame.save"

var circle_record: float = 0.0
var circler_record: float = 0.0
var circlest_record: float = 0.0
var hypercircle_record: float = 0.0
var hypercircler_record: float = 0.0
var hypercirclest_record: float = 0.0

var sound_volume: float

var is_tutorial_cleared: bool = false

func get_best_record(stage_index: int) -> float:
	if stage_index == 1:
		return circle_record
	if stage_index == 2:
		return circler_record
	if stage_index == 3:
		return circlest_record
	if stage_index == 4:
		return hypercircle_record
	if stage_index == 5:
		return hypercircler_record
	else:
		return hypercirclest_record
		
func update_record(stage_index: int, record: float):
	if stage_index == 1:
		circle_record = record
	if stage_index == 2:
		circler_record = record
	if stage_index == 3:
		circlest_record = record
	if stage_index == 4:
		hypercircle_record = record
	if stage_index == 5:
		hypercircler_record = record
	else:
		hypercirclest_record = record
	save_game()
	
func tutorial_clear():
	is_tutorial_cleared = true
	save_game()

func load_game():
	var load_file = FileAccess.open(save_file_path, FileAccess.READ)
	if load_file:
		var current_line = JSON.parse_string(load_file.get_as_text())
		circle_record = current_line["circle_record"]
		circler_record = current_line["circler_record"]
		circlest_record = current_line["circlest_record"]
		hypercircle_record = current_line["hypercircle_record"]
		hypercircler_record = current_line["hypercircler_record"]
		hypercirclest_record = current_line["hypercirclest_record"]
		is_tutorial_cleared = current_line["is_tutorial_cleared"]
		
func save_game():
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

func save():
	var save_dict = {
		"circle_record" : circle_record,
		"circler_record" : circler_record,
		"circlest_record" : circlest_record,
		"hypercircle_record" : hypercircle_record,
		"hypercircler_record" : hypercircler_record,
		"hypercirclest_record" : hypercirclest_record,
		"is_tutorial_cleared" : is_tutorial_cleared
	}
	return save_dict
