extends Node2D

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

@onready var KoreaUniv_node: Sprite2D = $CanvasLayer/KoreaUniv
@onready var Catdog_node: Sprite2D = $CanvasLayer/Catdog
@onready var BackGroundBlack_node: ColorRect = $CanvasLayer/BackGroundBlack
@onready var CircleField_node: CircleField = $CircleField
@onready var Camera2D_node: Camera2D = $Camera2D

func _ready():
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
	await tween_catdog_on.finished
	await get_tree().create_timer(0.7).timeout
	
	
	
	for i in 4:
		var tween_korea_univ_twinkle: Tween = get_tree().create_tween()
		var tween_catdog_twinkle: Tween = get_tree().create_tween()
		if i%2==0:
			tween_korea_univ_twinkle.tween_property(KoreaUniv_node, "modulate", Color(0, 0, 0, 1), 0.032)
			tween_catdog_twinkle.tween_property(Catdog_node, "modulate", Color(0, 0, 0, 1), 0.032)	
		else:
			tween_korea_univ_twinkle.tween_property(KoreaUniv_node, "modulate", Color(1, 1, 1, 1), 0.032)
			tween_catdog_twinkle.tween_property(Catdog_node, "modulate", Color(1, 1, 1, 1), 0.032)
		await tween_korea_univ_twinkle.finished
		await tween_catdog_twinkle.finished
		await get_tree().create_timer(0.025).timeout
		
	
	await get_tree().create_timer(1.25).timeout
	
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
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(RoomMenu_room)
