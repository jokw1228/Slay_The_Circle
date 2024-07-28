extends Node2D

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

@onready var KoreaUniv_node: Sprite2D = $KoreaUniv
@onready var Catdog_node: Sprite2D = $Catdog

func _ready():
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
	
	get_tree().change_scene_to_file(RoomMenu_room)
