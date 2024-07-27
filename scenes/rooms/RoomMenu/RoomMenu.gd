extends Node2D
class_name RoomMenu

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]
@export var playing_field: PlayingField
@export var ui_container_left: Control
@export var ui_container_right: Control
@export var ui_container_ready: Node2D
@export var camera: Camera2D
@export var reverb_effect_timer: Timer

@export var ui_ready_title: Label
@export var ui_ready_title_shadow: Label

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
	
	MusicManager.play("bgm_PF","test_fast",0,1)

func start_stage(): # A signal is connected by the select button.
	#var x: Vector2 = Vector2(0, 0)
	if stage_index == 0: 
		ui_ready_title.text = "CIRCLE"
		ui_ready_title_shadow.text = "CIRCLE"
		#x = Vector2(0, -144)
	if stage_index == 3: 
		ui_ready_title.text = "HYPER CIRCLE"
		ui_ready_title_shadow.text = "HYPER CIRCLE"
		#x = Vector2(0, -144)
	if stage_index == 1:
		ui_ready_title.text = "CIRCLER"
		ui_ready_title_shadow.text = "CIRCLER"
		#x = Vector2(-128, 64)
	if stage_index == 4:
		ui_ready_title.text = "HYPER CIRCLER"
		ui_ready_title_shadow.text = "HYPER CIRCLER"
		#x = Vector2(-128, 64)
	if stage_index == 2: 
		ui_ready_title.text = "CIRCLEST"
		ui_ready_title_shadow.text = "CIRCLEST"
		#x = Vector2(128, 64)
	if stage_index == 5: 
		ui_ready_title.text = "HYPER CIRCLEST"
		ui_ready_title_shadow.text = "HYPER CIRCLEST"
		#x = Vector2(128, 64)
	
	reverb_effect_timer.stop()
	
	# hides panel
	var tween_panel: Tween = get_tween().set_parallel()
	tween_panel.tween_property(start, "position", Vector2(600, 170), 0.4)
	tween_panel.tween_property(stage, "position", Vector2(-370, 0), 0.4)
	tween_panel.tween_property(info, "position", Vector2(528, 34), 0.4)
	if is_instance_valid(hyper): tween_panel.tween_property(hyper, "position", Vector2(-30, -84), 0.4)
	
	# zoom in
	var tween_playing_field: Tween = get_tween().set_trans(Tween.TRANS_CIRC)
	tween_playing_field.tween_property(camera, "zoom", Vector2(1.15, 1.15), 1.25)
	var tween_ready: Tween = get_tween()
	tween_ready.tween_property(ui_container_ready, "position", Vector2(150, 258), 1)
	#var tween_camera: Tween = get_tween().set_parallel()
	#tween_camera.tween_property(camera, "position", x, 0.4)
	
	# zoom out
	await tween_playing_field.finished
	var tween_playing_field1: Tween = get_tween().set_ease(Tween.EASE_IN)
	tween_playing_field1.tween_property(camera, "zoom", Vector2(1, 1), 0.3)
	var tween_ready1: Tween = get_tween().set_ease(Tween.EASE_IN)
	tween_ready1.tween_property(ui_container_ready, "position", Vector2(1200, 258), 0.3)
	var tween_camera1: Tween = get_tween().set_ease(Tween.EASE_IN)
	tween_camera1.tween_property(camera, "position", Vector2(0, 0), 0.3)
	
	# animation done
	await tween_playing_field1.finished
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
	if not start: # 시작 버튼 없을 경우 (처음 스테이지 선택한 경우)
		start = scene_start.instantiate()
		start.position = Vector2(544, 170)
		start.start.connect(start_stage)
		ui_container_right.add_child(start)
		
		var tween_start: Tween = get_tween()
		tween_start.tween_property(start, "position", Vector2(192, 170), 0.4)
	
	# 스테이지 패널.
	stage = scene_stage.instantiate()
	stage.position = Vector2(-370, 0)
	stage.difficulty = difficulty
	stage.stage_name = stage_name
	ui_container_left.add_child(stage)
	
	var tween: Tween = get_tween()
	tween.tween_property(stage, "position", Vector2(0, 0), 0.4)
	
	# 인포 패널.
	info = scene_info.instantiate()
	info.position = Vector2(528, 34)
	# 테스트 용 텍스트. 별 의미 없음. 실제로 표시할 만한 정보들이 생기면 채워 넣기
	info.info0 = str(difficulty)
	info.info1 = "test"
	info.info2 = stage_name
	ui_container_right.add_child(info)
	
	tween = get_tween()
	tween.tween_property(info, "position", Vector2(136, 34), 0.4)
	
	# 선택 사운드
	SoundManager.play("sfx_menu","select")

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
	
	#하이퍼 선택 사운드
	SoundManager.play("sfx_menu","h_select")
