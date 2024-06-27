extends Node2D
#class_name PlayingFieldInterface

func get_PlayingField_node():
	var node: PlayingField = get_tree().current_scene.get_node("PlayingField")
	return node

func game_over():
	get_PlayingField_node().stop_PlayingField()

func rotation_speed_up(up: float):
	get_PlayingField_node().rotation_speed_up(up)

func rotation_inversion():
	get_PlayingField_node().rotation_inversion()

func game_speed_up(up: float):
	Engine.time_scale += up

func game_speed_reset():
	Engine.time_scale = 1.0
