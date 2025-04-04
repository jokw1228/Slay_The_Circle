extends Node2D
class_name RoomMenu

var RoomCredit_room = "res://scenes/rooms/RoomCredit/RoomCredit.tscn"
var RoomTutorial_room = "res://scenes/rooms/RoomTutorial/RoomTutorial.tscn"

# 0: Cicle, 1: Circler, 2: Circlest, 3: Hyper Circle, 4: Hyper Circler, 5: Hyper Circlest
@export var room_to_go: Array[PackedScene]
@export var playing_field: PlayingField
@export var ui_container_ready: Control
@export var camera: Camera2D
@export var reverb_effect_timer: Timer
@export var menu_bomb_generator: Node2D


# The index of the stage currently selected in the menu window
# -1: not selected any stage
var stage_index: int = -1

const stage_index_maximum = 6

var option_activated: bool = false

func _ready():
	#if OS.get_name() == "iOS":
	#%ExitGame.hide()
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	# BombGenerator는 런타임에 생성되므로 get_node()를 통해 가져온다.
	%MenuBombGenerator.room_menu = self
	
	MusicManager.play("bgm_RM","main_fast",0,true)
	
	
	var tween_camera_zoom_out: Tween = Utils.tween()
	tween_camera_zoom_out.set_ease(Tween.EASE_IN)
	tween_camera_zoom_out.tween_property(camera, "zoom", Vector2(0.75, 0.75), 0.5)

	%HyperStage.visible = false
	%Stage.visible = false
	%Info.visible = false
	%Start.visible = false
	
	%Option.visible = false
	
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)

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
			high_score = SaveFileManager.records[0]
			%InfoLabel2.text = "HARD"
			%InfoLabel2.modulate = Color(1,1,0,1)
			%InfoLabel3.text = str(SaveFileManager.attempts[0])
			%InfoLabel3.modulate = Color.DEEP_SKY_BLUE
		1:
			high_score = SaveFileManager.records[1]
			%InfoLabel2.text = "HARDER"
			%InfoLabel2.modulate = Color(1,0.8,0,1)
			%InfoLabel3.text = str(SaveFileManager.attempts[1])
			%InfoLabel3.modulate = Color.MEDIUM_PURPLE
		2:
			high_score = SaveFileManager.records[2]
			%InfoLabel2.text = "HARDEST"
			%InfoLabel2.modulate = Color(1,0.6,0,1)
			%InfoLabel3.text =  str(SaveFileManager.attempts[2])
			%InfoLabel3.modulate = Color.ORANGE_RED
	%InfoLabel1.text = str(high_score)
	
	Utils.slide_in(%Info, 400, Vector2.LEFT, 0.4)
	
	if %Start.visible == false: # 시작 버튼 없을 경우 (처음 스테이지 선택한 경우)
		$UIContainerSkewed/Start/Button.disabled = false
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
			high_score = SaveFileManager.records[3]
			%InfoLabel2.text = "F**K"
			%InfoLabel2.modulate = Color(1,0.4,0,1)
			%InfoLabel3.text = str(SaveFileManager.attempts[3])
		4:
			high_score = SaveFileManager.records[4]
			%InfoLabel2.text = "F**KER"
			%InfoLabel2.modulate = Color(1,0.2,0,1)
			%InfoLabel3.text = str(SaveFileManager.attempts[4])
		5:
			high_score = SaveFileManager.records[5]
			%InfoLabel2.text = "F**KEST"
			%InfoLabel2.modulate = Color(1,0,0,1)
			%InfoLabel3.text = str(SaveFileManager.attempts[5])
	%InfoLabel1.text = str(high_score)
	Utils.slide_in(%Info, 400, Vector2.LEFT, 0.4)
	
	#하이퍼 선택 사운드
	SoundManager.play("sfx_menu","h_select")

	# 옵션 보이기
func _on_option_button_pressed():
	PlayingFieldInterface.disable_player_input()
	%Option.visible = true
	option_activated = true
	$UIContainerSkewed/Start/Button.disabled = true
	Utils.slide_in(%Option, 800, Vector2.LEFT, 0.6)
	SoundManager.play("sfx_menu","select")
	
	# 옵션 없애기
func _on_option_quit_pressed():
	PlayingFieldInterface.enable_player_input()
	option_activated = false
	$UIContainerSkewed/Start/Button.disabled = false
	Utils.slide_out(%Option, 800, Vector2.RIGHT, 0.6)
	SoundManager.play("sfx_menu","select")

func _on_to_credit_pressed():
	PlayingFieldInterface.enable_player_input()
	SoundManager.play("sfx_menu","select")
	MusicManager.stop(0)
	get_tree().change_scene_to_file(RoomCredit_room)
	
func _on_to_tutorial_pressed():
	PlayingFieldInterface.enable_player_input()
	SoundManager.play("sfx_menu","select")
	MusicManager.stop(0)
	get_tree().change_scene_to_file(RoomTutorial_room)

func _on_exit_game_pressed():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if option_activated:
			_on_option_quit_pressed()
		else:
			_on_option_button_pressed()
