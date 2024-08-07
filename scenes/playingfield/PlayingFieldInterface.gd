extends Node2D
#class_name PlayingFieldInterface

var current_PlayingField_node: PlayingField

var theme_color: Color = Color.WHITE
var theme_bright: float = 0.0 # [0.0, 1.0]

var tween_theme_color: Tween
func set_theme_color(theme_color_to_set: Color):
	if tween_theme_color != null:
		tween_theme_color.kill()
	tween_theme_color = get_tree().create_tween()
	tween_theme_color.tween_property(self, "theme_color", theme_color_to_set, 0.5)

func get_theme_color() -> Color:
	return PlayingFieldInterface.theme_color

var tween_theme_bright: Tween
func set_theme_bright(theme_bright_to_set: float):
	if tween_theme_bright != null:
		tween_theme_bright.kill()
	tween_theme_bright = get_tree().create_tween()
	tween_theme_bright.tween_property(self, "theme_bright", theme_bright_to_set, 0.5)

func get_theme_bright() -> float:
	return theme_bright

func get_PlayingField_node() -> PlayingField:
	return current_PlayingField_node

func set_PlayingField_node(node: PlayingField):
	current_PlayingField_node = node

func game_over(x):
	get_PlayingField_node().stop_PlayingField(x)
	
func rotation_speed_up(up: float):
	get_PlayingField_node().rotation_speed_up(up)

func rotation_inversion():
	get_PlayingField_node().rotation_inversion()

func rotation_stop():
	get_PlayingField_node().rotation_stop()

func game_speed_up(up: float):
	Engine.time_scale += up
	get_PlayingField_node().game_speed_up()

func game_speed_reset():
	Engine.time_scale = 1
	
func get_player_position() -> Vector2:
	return get_PlayingField_node().Player_node.now_position()

func get_playing_time():
	return get_PlayingField_node().get_playing_time()

func add_playing_time(time_to_add: float):
	get_PlayingField_node().add_playing_time(time_to_add)
