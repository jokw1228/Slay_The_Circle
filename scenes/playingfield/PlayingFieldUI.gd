extends CanvasLayer
class_name PlayingFieldUI

@export var Playing_node: Node2D
@export var StoppedRight_node: Node2D
@export var StoppedLeft_node: Node2D

@export var Seconds_node: Label
@export var Milliseconds_node: Label

@export var last_Seconds_node: Label
@export var last_Milliseconds_node: Label
@export var Gameover_node: Label


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
	
	# 게임 시작 시 화면 위쪽 끝에서 점수 창 내려오는 효과 
	# 일관성을 위해 close_Playing_and_open_Stopped에도 사라지는 애니메이션 추가 가능.
	# BEST랑 TIME 간 내려 오는 시간에 약간의 차이 두어 좀 더 디테일하게 만들고 싶었으나
	# conflict가 두려워 다음 기회에..
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

	
	

	
	last_Seconds_node.text = str(seconds_value)
	last_Milliseconds_node.text = ":" + str(milliseconds_value)
	

