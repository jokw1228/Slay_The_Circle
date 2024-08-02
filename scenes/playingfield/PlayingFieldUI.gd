extends CanvasLayer
class_name PlayingFieldUI

@export var Best_node: Control
@export var Time_node: Control
@export var StoppedRight_node: Node2D
@export var StoppedLeft_node: Node2D
@export var NewRecord_node: Node2D
@export var StoppedUp_node: Node2D
@export var BackToMenu_node: Node2D

@export var Seconds_node: Label
@export var Milliseconds_node: Label

@export var Last_Seconds_node: Label
@export var Last_Milliseconds_node: Label
@export var Gameover_node: Label

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"
var stage_index: int = 1

var seconds_value: int = 0
var milliseconds_value: int = 0
var is_new_record: bool = false

func _ready():
	Best_node.visible = false
	Time_node.visible = false

func playing_time_updated(time: float):
	seconds_value = floor(time)
	Seconds_node.text = str(seconds_value)
	
	milliseconds_value = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ".%02d" % milliseconds_value


func close_Stopped_and_open_Playing():
	#스타트 범브 터지면 gameover UI 들어가게
	NewRecord_node.visible = false
	var tween_close_left = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_right = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_up = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	StoppedLeft_node.position = Vector2(0,0)
	StoppedRight_node.position = Vector2(0,0)
	StoppedUp_node.position = Vector2(0,0)
	tween_close_left.tween_property(StoppedLeft_node,"position",Vector2(-800,0),0.4)
	tween_close_right.tween_property(StoppedRight_node,"position",Vector2(800,0),0.4)
	tween_close_up.tween_property(StoppedUp_node,"position",Vector2(0,-400),0.4)
	if(is_new_record):
		var tween_record = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		NewRecord_node.position = Vector2(0,0)
		tween_record.tween_property(NewRecord_node,"position",Vector2(800,0),0.4)
		is_new_record = false		
	await get_tree().create_timer(0.4).timeout
	
	NewRecord_node.visible = false
	StoppedLeft_node.visible = false
	StoppedRight_node.visible = false
	StoppedUp_node.visible = false
	
	await Utils.timer(0.5)
	Utils.slide_in(Best_node, 140, Vector2.DOWN, 0.5)
	await Utils.timer(0.1)
	Utils.slide_in(Time_node, 140, Vector2.DOWN, 0.8)

func close_Playing_and_open_Stopped():
	Best_node.visible = false
	Time_node.visible = false
	StoppedLeft_node.visible = true
	StoppedRight_node.visible = true
	StoppedUp_node.visible = true
	
	Last_Seconds_node.text = str(seconds_value)
	Last_Milliseconds_node.text = ":" + str(milliseconds_value)
	
	print_best_record()
	
	#game over UI transition
	StoppedLeft_node.position = Vector2(-800,0)
	StoppedRight_node.position = Vector2(800,0)
	StoppedUp_node.position = Vector2(0,-400)
	await get_tree().create_timer(1.0).timeout
	var tween_open_left = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_open_right = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_open_up = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween_open_left.tween_property(StoppedLeft_node,"position",Vector2(0,0),0.4)
	tween_open_right.tween_property(StoppedRight_node,"position",Vector2(0,0),0.4)
	tween_open_up.tween_property(StoppedUp_node,"position",Vector2(0,0),0.4)
	await get_tree().create_timer(1.4).timeout

	

	
func print_best_record():
	var best_record = SaveFileManager.get_best_record(stage_index)
	var current_record: float = seconds_value + float(milliseconds_value)/100
	#최고기록을 갱신한 경우 
	if(current_record > best_record):
		NewRecord_node.visible = true
		new_record_transition()
		SaveFileManager.update_record(stage_index,current_record)
		is_new_record = true
	
func new_record_transition():
	NewRecord_node.position = Vector2(800,0)
	await get_tree().create_timer(1.0).timeout
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(NewRecord_node,"position",Vector2(0,0),0.4)
	
func _on_back_button_back():
	#백 버튼 클릭시 UI 정리 <- "스타트 범브 터지면 gameover UI 들어가게" 와 같은 상황
	var tween_close_left = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_right = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_up = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_record = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	StoppedLeft_node.position = Vector2(0,0)
	StoppedRight_node.position = Vector2(0,0)
	StoppedUp_node.position = Vector2(0,0)
	NewRecord_node.position = Vector2(0,0)
	tween_close_left.tween_property(StoppedLeft_node,"position",Vector2(-800,0),0.4)
	tween_close_right.tween_property(StoppedRight_node,"position",Vector2(800,0),0.4)
	tween_close_up.tween_property(StoppedUp_node,"position",Vector2(0,-400),0.4)
	tween_record.tween_property(NewRecord_node,"position",Vector2(800,0),0.4)
	
	var tween_back_in: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween_back_in.tween_property(BackToMenu_node, "position", Vector2(96, 249), 1.25)
	await tween_back_in.finished
	
	var tween_back_out: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween_back_out.tween_property(BackToMenu_node, "position", Vector2(96, -166), 1.25)
	await tween_back_out.finished
	
	get_tree().change_scene_to_file(RoomMenu_room)
	
