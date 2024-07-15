extends Node2D
class_name RoomLogo

@export var room_menu: PackedScene
@export var Logos_node: Node2D
@export var RoomMainMenu_room: PackedScene

func _ready():
	var tween1=get_tree().create_tween()
	var tween2=get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(0,0,1,1), 2.0)
	#await tween.finished
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(room_menu)
	

	
