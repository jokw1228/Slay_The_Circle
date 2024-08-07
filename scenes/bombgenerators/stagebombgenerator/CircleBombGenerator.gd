extends BombGenerator
class_name CircleBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	#pattern_list.append(Callable(self, "pattern_test_1"))
	#pattern_list.append(Callable(self, "pattern_test_2"))
	pattern_list.append(Callable(self, "pattern_numeric_triangle_with_link"))

func pattern_shuffle_and_draw():
	print("pattern_shuffle_and_draw")
	
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()
	

###############################
# pattern_test_1 block start

func pattern_test_1():
	print("pattern_test_1 has been activated!")
	
	await Utils.timer(4.0) # pattern_test_1 is in progress...
	
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################


###############################
# pattern_test_2 block start

func pattern_test_2():
	print("pattern_test_2 has been activated!")
	
	await Utils.timer(4.0) # pattern_test_2 is in progress...
	
	pattern_shuffle_and_draw()

# pattern_test_2 block end
###############################

###############################
# pattern_numeric_triangle_with_link block start
# made by Jo Kangwoo

var pattern_numeric_triangle_with_link_timer: float
var pattern_numeric_triangle_with_link_timer_tween: Tween

func pattern_numeric_triangle_with_link():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_numeric_triangle_with_link_timer = 3.0
	if pattern_numeric_triangle_with_link_timer_tween != null:
		pattern_numeric_triangle_with_link_timer_tween.kill()
	pattern_numeric_triangle_with_link_timer_tween = get_tree().create_tween()
	pattern_numeric_triangle_with_link_timer_tween.tween_property(self, "pattern_triangle_with_link_timer", 0.0, 3.0)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(PI/6), bomb_radius * -sin(PI/6)), 0.5, 2.5, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(PI/2), bomb_radius * -sin(PI/2)), 0.5, 2.5, 2)
	
	create_bomb_link(bomb1, bomb2)
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(5*PI/6), bomb_radius * -sin(5*PI/6)), 0.5, 2.5, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(7*PI/6), bomb_radius * -sin(7*PI/6)), 0.5, 2.5, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(3*PI/2), bomb_radius * -sin(3*PI/2)), 0.5, 2.5, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(11*PI/6), bomb_radius * -sin(11*PI/6)), 0.5, 2.5, 6)
	
	var link3: BombLink = create_bomb_link(bomb5, bomb6)
	
	link3.connect("both_bombs_removed", Callable(self, "pattern_numeric_triangle_with_link_end"))

func pattern_numeric_triangle_with_link_end():
	PlayingFieldInterface.add_playing_time(pattern_numeric_triangle_with_link_timer)
	pattern_shuffle_and_draw()

# pattern_numeric_triangle_with_link block end
###############################
