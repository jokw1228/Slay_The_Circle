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
	pattern_list.append(Callable(self, "pattern_star"))
	pattern_list.append(Callable(self, "pattern_random_link"))
	
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
	pattern_numeric_triangle_with_link_timer_tween.tween_property(self, "pattern_numeric_triangle_with_link_timer", 0.0, 3.0)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_offset: float = player_position.angle() * -1
	#print(player_position, angle_offset)
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var ccw: float = 1 if randi() % 2 else -1
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 0.5, 2.5, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 0.5, 2.5, 2)
	
	create_bomb_link(bomb1, bomb2)
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 0.5, 2.5, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 0.5, 2.5, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 0.5, 2.5, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 0.5, 2.5, 6)
	
	var link3: BombLink = create_bomb_link(bomb5, bomb6)
	
	link3.connect("both_bombs_removed", Callable(self, "pattern_numeric_triangle_with_link_end"))

func pattern_numeric_triangle_with_link_end():
	PlayingFieldInterface.add_playing_time(pattern_numeric_triangle_with_link_timer)
	pattern_shuffle_and_draw()

# pattern_numeric_triangle_with_link block end
###############################

###############################
# pattern_star block start
# made by jooyoung

var pattern_star_timer: float
var pattern_star_timer_tween: Tween

func pattern_star():
	pattern_star_timer = 3.0
	if pattern_star_timer_tween != null:
		pattern_star_timer_tween.kill()
	pattern_star_timer_tween = get_tree().create_tween()
	pattern_star_timer_tween.tween_property(self,"pattern_star_timer",0.0,3.0)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 192
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(player_angle),bomb_radius*sin(player_angle)), 0.5, 2.5, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+4*PI/5),bomb_radius*sin(player_angle+4*PI/5)), 0.5, 2.5, 2)
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+8*PI/5),bomb_radius*sin(player_angle+8*PI/5)), 0.5, 2.5, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+2*PI/5),bomb_radius*sin(player_angle+2*PI/5)), 0.5, 2.5, 4)
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+6*PI/5),bomb_radius*sin(player_angle+6*PI/5)), 0.5, 2.5, 5)

	bomb5.connect("no_lower_value_bomb_exists",Callable(self,"pattern_star_end"))

func pattern_star_end():
	PlayingFieldInterface.add_playing_time(pattern_star_timer)
	pattern_shuffle_and_draw()
	
#pattern_star end
###############################

###############################
# pattern_random_link block start
# made by kiyong

var pattern_random_link_timer: float
var pattern_random_link_timer_tween: Tween

var pattern_random_link_player_position: Vector2
var pattern_random_link_player_angle: float
const pattern_random_link_bomb_dist = 140

func pattern_random_link():
	pattern_random_link_timer = 2.5
	
	if pattern_random_link_timer_tween != null:
		pattern_random_link_timer_tween.kill()
	pattern_random_link_timer_tween = get_tree().create_tween()
	pattern_random_link_timer_tween.tween_property(self, "pattern_random_link_timer", 0, 2.5)
	
	pattern_random_link_player_position = PlayingFieldInterface.get_player_position()
	pattern_random_link_player_angle = pattern_random_link_player_position.angle()
	
	var order = [1,2,3]
	order.shuffle()
	var correction = (order[0]-2) * -(acos(sqrt(2)/4)-PI/4)
	
	var vector = [pattern_random_link_auto_rotate(0+correction), pattern_random_link_auto_rotate(PI/2+correction), pattern_random_link_auto_rotate(PI+correction), pattern_random_link_auto_rotate(3*PI/2+correction)]
	var bombs = []
	
	bombs.append(create_numeric_bomb(vector[0], 0.5, 2, 1))
	bombs.append(create_numeric_bomb(vector[order[0]], 0.5, 2, 2))
	bombs.append(create_numeric_bomb(vector[order[1]], 0.5, 2, 3))
	bombs.append(create_numeric_bomb(vector[order[2]], 0.5, 2, 4))
	create_bomb_link(bombs[0], bombs[1])
	create_bomb_link(bombs[2], bombs[3])
	
	bombs[3].connect("no_lower_value_bomb_exists",Callable(self,"pattern_random_link_end"))

func pattern_random_link_auto_rotate(angle):
	return Vector2(pattern_random_link_bomb_dist*cos(pattern_random_link_player_angle+angle),pattern_random_link_bomb_dist*sin(pattern_random_link_player_angle+angle))

func pattern_random_link_end():
	PlayingFieldInterface.add_playing_time(pattern_random_link_timer)
	pattern_shuffle_and_draw()

# pattern_random_link block end
###############################
