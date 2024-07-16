extends Node2D
class_name RoomMenu

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]
@export var playing_field: PlayingField
@export var ui_container_left: Control
@export var ui_container_right: Control

@export var scene_stage: PackedScene
@export var scene_hyper: PackedScene
@export var scene_info: PackedScene
@export var scene_start: PackedScene

# The index of the stage currently selected in the menu window
# -1: not selected any stage
var stage_index: int = -1;

var stage: PanelStage
var hyper: Node2D
var info: PanelInfo
var start: Node2D

const stage_index_maximum = 6

func _ready():
	# BombGenerator는 런타임에 생성되므로 get_node()를 통해 가져온다.
	get_node("PlayingField/MenuBombGenerator").room_menu = self

func start_stage(): # A signal is connected by the select button.
	get_tree().change_scene_to_packed(room_to_go[stage_index])

func get_tween():
	return get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
func select_stage(difficulty: int, stage_name: String):
	if is_instance_valid(stage):
		stage.queue_free()
	if is_instance_valid(hyper):
		hyper.queue_free()
	if is_instance_valid(info):
		info.queue_free()
	if not start:
		start = scene_start.instantiate()
		start.position = Vector2(544, 170)
		start.start.connect(start_stage)
		ui_container_right.add_child(start)
		
		var tween: Tween = get_tween()
		tween.tween_property(start, "position", Vector2(192, 170), 0.4)
	
	stage = scene_stage.instantiate()
	stage.position = Vector2(-370, 0)
	stage.difficulty = difficulty
	stage.stage_name = stage_name
	ui_container_left.add_child(stage)
	
	var tween: Tween = get_tween()
	tween.tween_property(stage, "position", Vector2(0, 0), 0.4)
	
	info = scene_info.instantiate()
	info.position = Vector2(528, 34)
	# 테스트 용 텍스트. 별 의미 없음. 실제로 표시할 만한 정보들이 생기면 채워 넣기
	info.info0 = str(difficulty)
	info.info1 = "test"
	info.info2 = stage_name
	ui_container_right.add_child(info)
	
	tween = get_tween()
	tween.tween_property(info, "position", Vector2(136, 34), 0.4)

func select_circle():
	stage_index = 0
	select_stage(0, "CIRCLE")

func select_circler():
	stage_index = 1
	select_stage(1, "CIRCLER")

func select_circlest():
	stage_index = 2
	select_stage(2, "CIRCLEST")

func select_hyper():
	if stage_index >= 3 or stage_index < 0: return
	stage_index += 3
	info.queue_free()
	
	hyper = scene_hyper.instantiate()
	hyper.position = Vector2(-30, -86)
	ui_container_left.add_child(hyper)
	
	var tween: Tween = get_tween()
	tween.tween_property(hyper, "position", Vector2(304, -86), 0.4)
	
	info = scene_info.instantiate()
	info.position = Vector2(528, 34)
	# 테스트 용 텍스트. 별 의미 없음. 실제로 표시할 만한 정보들이 생기면 채워 넣기
	info.info0 = str(stage_index)
	info.info1 = "test"
	info.info2 = "HYPER"
	ui_container_right.add_child(info)
	
	tween = get_tween()
	tween.tween_property(info, "position", Vector2(136, 34), 0.4)
