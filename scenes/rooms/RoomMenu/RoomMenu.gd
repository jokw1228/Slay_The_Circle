extends Node2D
class_name RoomMenu

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]
@export var playing_field: PlayingField
@export var ui_container_ready: Control
@export var camera: Camera2D
@export var reverb_effect_timer: Timer


# The index of the stage currently selected in the menu window
# -1: not selected any stage
var stage_index: int = -1;

const stage_index_maximum = 6

func _ready():
	# BombGenerator는 런타임에 생성되므로 get_node()를 통해 가져온다.
	get_node("PlayingField/MenuBombGenerator").room_menu = self
	
	MusicManager.play("bgm_PF","test_fast",0,1)
	
	var tween_camera_zoom_out: Tween = Utils.tween()
	tween_camera_zoom_out.set_ease(Tween.EASE_IN)
	tween_camera_zoom_out.tween_property(playing_field.PlayingFieldCamera_node, "zoom", Vector2(0.75, 0.75), 0.5)

	%HyperStage.visible = false
	%Stage.visible = false
	%Info.visible = false
	%Start.visible = false

func start_stage(): # A signal is connected by the select button.=
	%ReadyStage.text = ["CIRCLE", "CIRCLER", "CIRCLEST",\
		"HYPER CIRCLE", "HYPER CIRCLER", "HYPER CIRCLEST"][stage_index]
	
	reverb_effect_timer.stop()
	
	# hides panel
	Utils.tween().tween_property(%HyperStage, "position", %HyperStage.position + Vector2(-400, 0), 0.4)
	Utils.tween().tween_property(%Stage, "position", %Stage.position + Vector2(-400, 0), 0.4)
	Utils.tween().tween_property(%Info, "position", %Info.position + Vector2(400, 0), 0.4)
	Utils.tween().tween_property(%Start, "position", %Start.position + Vector2(500, 0), 0.4)
	
	# zoom in
	Utils.tween().set_trans(Tween.TRANS_CIRC)\
		.tween_property(camera, "zoom", Vector2(1.15, 1.15), 1.25)
	Utils.tween().tween_property(ui_container_ready, "position", Vector2(237, 233), 1)
	
	# zoom out
	await Utils.timer(1.25)
	Utils.tween().set_ease(Tween.EASE_IN)\
		.tween_property(camera, "zoom", Vector2(1, 1), 0.3)
	Utils.tween().set_ease(Tween.EASE_IN)\
		.tween_property(ui_container_ready, "position", Vector2(1261, 233), 0.3)
	Utils.tween().set_ease(Tween.EASE_IN)\
		.tween_property(camera, "position", Vector2(0, 0), 0.3)
	
	# animation done
	await Utils.timer(0.3)
	get_tree().change_scene_to_packed(room_to_go[stage_index])
	
func select_stage(difficulty: int):
	if stage_index == difficulty: return
	stage_index = difficulty

	%HyperStage.visible = false
	
	%Stage.visible = true
	%StageLabel.text = ["CIRCLE", "CIRCLER", "CIRCLEST"][difficulty]
	%StageStar1.visible = true
	%StageStar2.visible = true if difficulty >= 1 else false
	%StageStar3.visible = true if difficulty >= 2 else false
	Utils.slide_in(%Stage, 400, Vector2.RIGHT, 0.4)
	
	%Info.visible = true
	%InfoLabel1.text = str(stage_index) # 테스트용 텍스트.
	Utils.slide_in(%Info, 400, Vector2.LEFT, 0.4)
	
	if %Start.visible == false: # 시작 버튼 없을 경우 (처음 스테이지 선택한 경우)
		%Start.visible = true
		Utils.slide_in(%Start, 400, Vector2.LEFT, 0.4)

	# 선택 사운드
	SoundManager.play("sfx_menu","select")

func select_hyper():
	if stage_index >= 3 or stage_index < 0: return
	stage_index += 3
	
	%HyperStage.visible = true
	Utils.slide_in(%HyperStage, 400, Vector2.RIGHT, 0.4)
	
	%Info.visible = true
	%InfoLabel1.text = str(stage_index) # 테스트용 텍스트.
	Utils.slide_in(%Info, 400, Vector2.LEFT, 0.4)
	
	#하이퍼 선택 사운드
	SoundManager.play("sfx_menu","h_select")
