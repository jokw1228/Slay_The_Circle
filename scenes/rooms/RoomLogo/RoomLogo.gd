extends Node2D

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"
var RoomTutorial_room = "res://scenes/rooms/RoomTutorial/RoomTutorial.tscn"

@export var KoreaUniv_node: Sprite2D
@export var Catdog_node: Sprite2D
@export var BackGroundBlack_node: ColorRect
@export var CircleField_node: CircleField
@export var Camera2D_node: Camera2D

func _ready():
	SaveFileManager.load_game()
	CircleField_node.stop_reverb_effect()
	
	await get_tree().create_timer(0.5).timeout
	
	var tween_korea_univ_on: Tween = get_tree().create_tween()
	tween_korea_univ_on.set_ease(Tween.EASE_OUT)
	tween_korea_univ_on.set_trans(Tween.TRANS_CIRC)
	tween_korea_univ_on.tween_property(KoreaUniv_node, "position", Vector2(288, 324), 1)
	
	var tween_catdog_on: Tween = get_tree().create_tween()
	tween_catdog_on.set_ease(Tween.EASE_OUT)
	tween_catdog_on.set_trans(Tween.TRANS_CIRC)
	tween_catdog_on.tween_property(Catdog_node, "position", Vector2(864, 324), 1)
	
	await tween_korea_univ_on.finished
	await get_tree().create_timer(1).timeout
	
	var tween_korea_univ_off: Tween = get_tree().create_tween()
	tween_korea_univ_off.set_ease(Tween.EASE_IN)
	tween_korea_univ_off.set_trans(Tween.TRANS_CIRC)
	tween_korea_univ_off.tween_property(KoreaUniv_node, "position", Vector2(864, 324), 1)

	var tween_catdog_off: Tween = get_tree().create_tween()
	tween_catdog_off.set_ease(Tween.EASE_IN)
	tween_catdog_off.set_trans(Tween.TRANS_CIRC)
	tween_catdog_off.tween_property(Catdog_node, "position", Vector2(288, 324), 1)
	
	await tween_korea_univ_off.finished
	await get_tree().create_timer(0.5).timeout
	
	var tween_white: Tween = get_tree().create_tween()
	tween_white.set_ease(Tween.EASE_IN_OUT)
	tween_white.set_trans(Tween.TRANS_SINE)
	tween_white.tween_property(BackGroundBlack_node, "modulate", Color.TRANSPARENT, 1)

	var tween_camera: Tween = get_tree().create_tween()
	tween_camera.set_ease(Tween.EASE_IN_OUT)
	tween_camera.set_trans(Tween.TRANS_SINE)
	tween_camera.tween_property(Camera2D_node, "zoom", Vector2(1, 1), 1.5)
	
	await tween_camera.finished
	await get_tree().create_timer(0.3).timeout
	if(!SaveFileManager.is_tutorial_cleared):
		get_tree().change_scene_to_file(RoomTutorial_room)
	else:
		get_tree().change_scene_to_file(RoomMenu_room)
	#get_tree().change_scene_to_file(RoomMenu_room)
