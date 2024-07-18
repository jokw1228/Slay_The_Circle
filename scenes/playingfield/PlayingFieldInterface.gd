extends Node2D
#class_name PlayingFieldInterface

var current_PlayingField_node: PlayingField

func get_PlayingField_node() -> PlayingField:
	return current_PlayingField_node

func set_PlayingField_node(node: PlayingField):
	current_PlayingField_node = node

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

func gameover_camera(x):
	get_PlayingField_node().merge_transition(x)
