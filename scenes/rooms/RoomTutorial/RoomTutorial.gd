extends Node2D

@onready var TutorialBombGenerator_node = $TutorialBombGenerator

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

func _on_tutorial_bomb_generator_tutorial_end():
	SaveFileManager.tutorial_clear()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(RoomMenu_room)
	
