extends CanvasLayer
class_name PlayingFieldUI

@export var Best_node: Control
@export var Time_node: Control

@export var Seconds_node: Label
@export var Milliseconds_node: Label

@export var Last_Seconds_node: Label
@export var Last_Milliseconds_node: Label

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"
var stage_index: int = PlayingFieldInterface.get_stage_index()

var seconds_value: int = 0
var milliseconds_value: int = 0
var is_new_record: bool = false

var best_record: float = -1

func _ready():
	Best_node.visible = false
	Time_node.visible = false
	%PanelGameOver.visible = false
	%PanelScore.visible = false
	%PanelNewRecord.visible = false
	%BackButton.visible = false
	%InGameNewRecord.visible = false

func playing_time_updated(time: float):
	seconds_value = floor(time)
	Seconds_node.text = str(seconds_value)
	
	milliseconds_value = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ".%02d" % milliseconds_value

	if best_record == -1:
		# stage_index 0-index로 통일
		best_record = SaveFileManager.get_best_record(stage_index)
		%LabelBestSec.text = "%d" % floor(best_record)
		%LabelBestMilli.text = ".%02d" % round((best_record - floor(best_record)) * 100)
	if time > best_record and %InGameNewRecord.visible == false:
		Utils.slide_in(%InGameNewRecord, 400, Vector2.RIGHT, 0.4)
		Best_node.visible = false

func close_Stopped_and_open_Playing():
	#해당 stage attempts 증가
	SaveFileManager.attempts[stage_index] +=1
	SaveFileManager.save_game()
	#스타트 범브 터지면 gameover UI 들어가게
	Utils.slide_out(%PanelGameOver, 800, Vector2.LEFT, 0.4)
	Utils.slide_out(%PanelScore, 800, Vector2.RIGHT, 0.4)
	Utils.slide_out(%BackButton, 200, Vector2(-0.25, -1), 0.4)
	if(is_new_record):
		Utils.slide_out(%PanelNewRecord, 800, Vector2.RIGHT, 0.4)
		is_new_record = false	

	await Utils.timer(0.9)
	if %InGameNewRecord.visible == false:
		Utils.slide_in(Best_node, 140, Vector2.DOWN, 0.5)
	await Utils.timer(0.1)
	Utils.slide_in(Time_node, 140, Vector2.DOWN, 0.8)

func close_Playing_and_open_Stopped():
	Best_node.visible = false
	Time_node.visible = false
	%InGameNewRecord.visible = false
	
	Last_Seconds_node.text = str(seconds_value)
	Last_Milliseconds_node.text = ".%02d" % milliseconds_value
	
	print_best_record()
	
	#game over UI transition
	await get_tree().create_timer(1.0).timeout
	Utils.slide_in(%PanelGameOver, 800, Vector2.RIGHT, 0.4)
	Utils.slide_in(%PanelScore, 800, Vector2.LEFT, 0.4)
	Utils.slide_in(%BackButton, 200, Vector2(0.25, 1), 0.4)
	
func print_best_record():
	var current_record: float = seconds_value + float(milliseconds_value)/100
	#최고기록을 갱신한 경우 
	if(current_record > best_record):
		new_record_transition()
		# stage_index 0-index
		SaveFileManager.update_record(stage_index,current_record)
		is_new_record = true

	best_record = -1
	
func new_record_transition():
	await get_tree().create_timer(1.0).timeout
	Utils.slide_in(%PanelNewRecord, 800, Vector2.LEFT, 0.4)
	
func _on_back_button_back():
	PlayingFieldInterface.disable_player_input()

	#백 버튼 클릭시 UI 정리 <- "스타트 범브 터지면 gameover UI 들어가게" 와 같은 상황
	Utils.slide_out(%PanelGameOver, 800, Vector2.LEFT, 0.4)
	Utils.slide_out(%PanelScore, 800, Vector2.RIGHT, 0.4)
	Utils.slide_out(%PanelNewRecord, 800, Vector2.RIGHT, 0.4)
	Utils.slide_out(%BackButton, 200, Vector2(-0.25, -1), 0.4)
	
	var tween: Tween = Utils.tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%PanelBackMessage, "position", Vector2(57.25, -167), 1.0)
	
	await tween.finished
	PlayingFieldInterface.enable_player_input()
	get_tree().change_scene_to_file(RoomMenu_room)
	
