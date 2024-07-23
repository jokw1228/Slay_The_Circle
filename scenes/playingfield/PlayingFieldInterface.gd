extends Node2D
#class_name PlayingFieldInterface

var current_PlayingField_node: PlayingField
var color = Color(1,1,1,1)

func get_PlayingField_node() -> PlayingField:
	return current_PlayingField_node

func set_PlayingField_node(node: PlayingField):
	current_PlayingField_node = node

func game_over(x):
	get_PlayingField_node().gameover_position(x)
	get_PlayingField_node().stop_PlayingField(x)
	
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
	
func get_player_position()->Vector2:
	return get_PlayingField_node().Player_node.now_position()
