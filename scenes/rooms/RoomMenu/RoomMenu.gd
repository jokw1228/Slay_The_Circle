extends Node2D
class_name RoomMenu

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]
@export var playing_field: PlayingField
@export var ui_container_ready: Control
@export var camera: Camera2D
@export var reverb_effect_timer: Timer
@export var menu_bomb_generator: Node2D


# The index of the stage currently selected in the menu window
# -1: not selected any stage
var stage_index: int = -1;

const stage_index_maximum = 6

func _ready():
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	# BombGenerator는 런타임에 생성되므로 get_node()를 통해 가져온다.
	%MenuBombGenerator.room_menu = self
	
	MusicManager.play("bgm_RM","main_fast",0,1)
	
	var tween_camera_zoom_out: Tween = Utils.tween()
	tween_camera_zoom_out.set_ease(Tween.EASE_IN)
	tween_camera_zoom_out.tween_property(camera, "zoom", Vector2(0.75, 0.75), 0.5)

	%HyperStage.visible = false
	%Stage.visible = false
	%Info.visible = false
	%Start.visible = false
	
	%Option.visible = false

func start_stage(): # A signal is connected by the select button.=
	%ReadyStage.text = ["CIRCLE", "CIRCLER", "CIRCLEST",\
		"HYPER CIRCLE", "HYPER CIRCLER", "HYPER CIRCLEST"][stage_index]
	
	reverb_effect_timer.stop()
	PlayingFieldInterface.disable_player_input()
	
	# hides panel
	Utils.tween().tween_property(%HyperStage, "position", %HyperStage.position + Vector2(-400, 0), 0.4)
	Utils.tween().tween_property(%Stage, "position", %Stage.position + Vector2(-400, 0), 0.4)
	Utils.tween().tween_property(%Info, "position", %Info.position + Vector2(400, 0), 0.4)
	Utils.tween().tween_property(%Start, "position", %Start.position + Vector2(500, 0), 0.4)
	
	Utils.slide_out(%OptionButton, 400, Vector2.RIGHT, 0.6)
	
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
	PlayingFieldInterface.enable_player_input()
	PlayingFieldInterface.set_stage_index(stage_index)
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
	var high_score: float
	match stage_index:
		0:
			high_score = SaveFileManager.circle_record
			%InfoLabel2.text = "HARD"
			%InfoLabel2.modulate = Color(1,1,0,1)
			%InfoLabel3.text = "SIMPLE!"
			%InfoLabel3.modulate = Color.CHOCOLATE
		1:
			high_score = SaveFileManager.circler_record
			%InfoLabel2.text = "HARDER"
			%InfoLabel2.modulate = Color(1,0.8,0,1)
			%InfoLabel3.text = "HARZARD!!"
			%InfoLabel3.modulate = Color.DEEP_SKY_BLUE
		2:
			high_score = SaveFileManager.circlest_record
			%InfoLabel2.text = "HARDEST"
			%InfoLabel2.modulate = Color(1,0.6,0,1)
			%InfoLabel3.text = "MOVING!!!"
			%InfoLabel3.modulate = Color.AQUAMARINE
	%InfoLabel1.text = str(high_score)
	
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
	var high_score: float
	match stage_index:
		3:
			high_score = SaveFileManager.hypercircle_record
			%InfoLabel2.text = "F**K"
			%InfoLabel2.modulate = Color(1,0.4,0,1)
			%InfoLabel3.text = "..."
			%InfoLabel3.modulate = Color.CHOCOLATE
		4:
			high_score = SaveFileManager.hypercircler_record
			%InfoLabel2.text = "F**KER"
			%InfoLabel2.modulate = Color(1,0.2,0,1)
			%InfoLabel3.text = "..?"
			%InfoLabel3.modulate = Color.DEEP_SKY_BLUE
		5:
			high_score = SaveFileManager.hypercirclest_record
			%InfoLabel2.text = "F**KEST"
			%InfoLabel2.modulate = Color(1,0,0,1)
			%InfoLabel3.text = "..!"
			%InfoLabel3.modulate = Color.AQUAMARINE
	%InfoLabel1.text = str(high_score)
	Utils.slide_in(%Info, 400, Vector2.LEFT, 0.4)
	
	#하이퍼 선택 사운드
	SoundManager.play("sfx_menu","h_select")

	# 옵션 보이기
func _on_option_button_pressed():
	PlayingFieldInterface.disable_player_input()
	%Option.visible = true
	Utils.slide_in(%Option, 800, Vector2.LEFT, 0.6)
	SoundManager.play("sfx_menu","select")
	
	# 옵션 없애기
func _on_option_quit_pressed():
	PlayingFieldInterface.enable_player_input()
	Utils.slide_out(%Option, 800, Vector2.RIGHT, 0.6)
	SoundManager.play("sfx_menu","select")

