extends Node2D
class_name RoomLogo

@export var room_menu: PackedScene

func _ready():
	'''
	Write your code here!
	'''
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(room_menu)
	pass
