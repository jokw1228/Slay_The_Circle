extends CanvasLayer
class_name PlayingFieldUI

@export var Playing_node: Node2D
@export var StoppedRight_node: Node2D
@export var StoppedLeft_node: Node2D
@export var NewRecord_node: Node2D

@export var Seconds_node: Label
@export var Milliseconds_node: Label

@export var Last_Seconds_node: Label
@export var Last_Milliseconds_node: Label
@export var Gameover_node: Label

const SAVE_PATH = "res://best_record.dat"

var seconds_value: int = 0
var milliseconds_value: int = 0

func playing_time_updated(time: float):
	seconds_value = floor(time)
	Seconds_node.text = str(seconds_value)
	
	milliseconds_value = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ":" + str(milliseconds_value)


func close_Stopped_and_open_Playing():
	StoppedLeft_node.visible = false
	StoppedRight_node.visible = false
	Playing_node.visible = true
	NewRecord_node.visible = false

func close_Playing_and_open_Stopped():
	Playing_node.visible = false
	StoppedLeft_node.visible = true
	StoppedRight_node.visible = true
	
	Last_Seconds_node.text = str(seconds_value)
	Last_Milliseconds_node.text = ":" + str(milliseconds_value)
	
	print_best_record()
	
	#game over UI transition
	StoppedLeft_node.position = Vector2(-800,0)
	StoppedRight_node.position = Vector2(800,0)
	await get_tree().create_timer(1.0).timeout
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(StoppedLeft_node,"position",Vector2(0,0),0.4)
	tween2.tween_property(StoppedRight_node,"position",Vector2(0,0),0.4)
	await get_tree().create_timer(1.4).timeout
	var tween3 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween4 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	StoppedLeft_node.position = Vector2(0,0)
	StoppedRight_node.position = Vector2(0,0)
	tween3.tween_property(StoppedLeft_node,"position",Vector2(-800,0),0.4)
	tween4.tween_property(StoppedRight_node,"position",Vector2(800,0),0.4)
	await get_tree().create_timer(0.4).timeout
	

	
func print_best_record():

	var load_file = FileAccess.open(SAVE_PATH, FileAccess.READ_WRITE)
	if load_file == null:
		load_file.store_float(0)
	
	if FileAccess.file_exists(SAVE_PATH) == false:
		return
		
	var current_line = load_file.get_line()
	var existing_record:float = float(current_line)
	var current_record:float = seconds_value + float(milliseconds_value)/100

	if (current_record > existing_record):
		NewRecord_node.visible = true
		load_file.store_string(str (current_record))
		new_record_transition()

	
func new_record_transition():
	NewRecord_node.position = Vector2(800,0)
	await get_tree().create_timer(1.0).timeout
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(NewRecord_node,"position",Vector2(0,0),0.4)
	await get_tree().create_timer(1.4).timeout
	NewRecord_node.position = Vector2(0,0)
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(NewRecord_node,"position",Vector2(800,0),0.4)


