extends CanvasLayer
class_name PlayingFieldUI

@export var Playing_node: Node2D
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

const SAVE_PATH = "res://best_record.dat"

var seconds_value: int = 0
var milliseconds_value: int = 0

func playing_time_updated(time: float):
	seconds_value = floor(time)
	Seconds_node.text = str(seconds_value)
	
	milliseconds_value = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ":" + str(milliseconds_value)


func close_Stopped_and_open_Playing():
	#스타트 범브 터지면 gameover UI 들어가게
	var tween_close_left = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_right = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_up = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	StoppedLeft_node.position = Vector2(0,0)
	StoppedRight_node.position = Vector2(0,0)
	StoppedUp_node.position = Vector2(0,0)
	tween_close_left.tween_property(StoppedLeft_node,"position",Vector2(-800,0),0.4)
	tween_close_right.tween_property(StoppedRight_node,"position",Vector2(800,0),0.4)
	tween_close_up.tween_property(StoppedUp_node,"position",Vector2(0,-400),0.4)
	await get_tree().create_timer(0.4).timeout
	
	NewRecord_node.visible = false
	StoppedLeft_node.visible = false
	StoppedRight_node.visible = false
	StoppedUp_node.visible = false
	
	# 게임 시작 시 화면 위쪽 끝에서 점수 창 내려오는 효과 
	# 일관성을 위해 close_Playing_and_open_Stopped에도 사라지는 애니메이션 추가 가능.
	# BEST랑 TIME 간 내려 오는 시간에 약간의 차이 두어 좀 더 디테일하게 만들고 싶었으나
	# merge 복잡할 것 같아 일단 보류.

	Playing_node.visible = false # 이미 visible일 경우 애니메이션 전에 보이는 것 방지
	await get_tree().create_timer(0.7).timeout
	Playing_node.visible = true
	Playing_node.position = Vector2(0, -100)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(Playing_node,"position",Vector2(0,0),0.6)

func close_Playing_and_open_Stopped():
	Playing_node.visible = false
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


func _on_back_button_back():
	#백 버튼 클릭시 UI 정리 <- "스타트 범브 터지면 gameover UI 들어가게" 와 같은 상황
	var tween_close_left = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_right = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var tween_close_up = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	StoppedLeft_node.position = Vector2(0,0)
	StoppedRight_node.position = Vector2(0,0)
	StoppedUp_node.position = Vector2(0,0)
	tween_close_left.tween_property(StoppedLeft_node,"position",Vector2(-800,0),0.4)
	tween_close_right.tween_property(StoppedRight_node,"position",Vector2(800,0),0.4)
	tween_close_up.tween_property(StoppedUp_node,"position",Vector2(0,-400),0.4)
	
	var tween_back_in: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween_back_in.tween_property(BackToMenu_node, "position", Vector2(96, 249), 1.25)
	await tween_back_in.finished
	
	var tween_back_out: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween_back_out.tween_property(BackToMenu_node, "position", Vector2(96, -166), 1.25)
	await tween_back_out.finished
	
	get_tree().change_scene_to_file(RoomMenu_room)
	
