extends Node

#const save_file_path: String = "res://savegame.save"
const save_file_path: String = "user://savegame.save"

var records: Array[float] = [0,0,0,0,0,0]
var attempts: Array[int] = [0,0,0,0,0,0]

var bgm_volume: float = 1.0
var sfx_volume: float = 1.0

var is_tutorial_cleared: bool = false

func get_best_record(stage_index: int) -> float:
	return records[stage_index]
		
func update_record(stage_index: int, record: float):
	records[stage_index] = record
	save_game()
	
func tutorial_clear():
	is_tutorial_cleared = true
	save_game()

func load_game():
	var load_file = FileAccess.open(save_file_path, FileAccess.READ)
	if load_file:
		var current_line = JSON.parse_string(load_file.get_as_text())
		if("circler_record" in current_line):
			records[0] = current_line["circle_record"]
		if("circler_record" in current_line):
			records[1] = current_line["circler_record"]
		if("circlest_record" in current_line):
			records[2] = current_line["circlest_record"]
		if("hypercircle_record" in current_line):
			records[3] = current_line["hypercircle_record"]
		if("hypercircler_record" in current_line):
			records[4] = current_line["hypercircler_record"]
		if("hypercirclest_record" in current_line):
			records[5] = current_line["hypercirclest_record"]
		if("is_tutorial_cleared" in current_line):
			is_tutorial_cleared = current_line["is_tutorial_cleared"]
		if("circle_attempts" in current_line):
			attempts[0] = int(current_line["circle_attempts"])
		if("circler_attempts" in current_line):
			attempts[1] = int(current_line["circler_attempts"])
		if("circlest_attempts" in current_line):
			attempts[2] = int(current_line["circlest_attempts"])
		if("hypercircle_attempts" in current_line):
			attempts[3] = int(current_line["hypercircle_attempts"])
		if("hypercircler_attempts" in current_line):
			attempts[4] = int(current_line["hypercircler_attempts"])
		if("hypercirclest_attempts" in current_line):
			attempts[5] = int(current_line["hypercirclest_attempts"])	
		if("bgm_volume" in current_line):
			bgm_volume = current_line["bgm_volume"]
		if("sfx_volume" in current_line):
			sfx_volume = current_line["sfx_volume"]
		
func save_game():
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

func save():
	var save_dict = {
		"circle_record" : records[0],
		"circler_record" : records[1],
		"circlest_record" : records[2],
		"hypercircle_record" : records[3],
		"hypercircler_record" : records[4],
		"hypercirclest_record" : records[5],
		"circle_attempts" : attempts[0],
		"circler_attempts" : attempts[1],
		"circlest_attempts" : attempts[2],
		"hypercircle_attempts" : attempts[3],
		"hypercircler_attempts" : attempts[4],
		"hypercirclest_attempts" : attempts[5],		
		"is_tutorial_cleared" : is_tutorial_cleared,
		"bgm_volume" : bgm_volume,
		"sfx_volume" : sfx_volume
	}
	return save_dict
