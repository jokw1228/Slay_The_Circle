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

###############################
# pattern_numeric_diamond_with_hazard block start
# made by Bae Sekang

var pattern_diamond_with_hazard_timer: float
var pattern_diamond_with_hazard_timer_tween: Tween

func pattern_diamond_with_hazard():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_diamond_with_hazard_timer = 3.0
	if pattern_diamond_with_hazard_timer_tween != null:
		pattern_diamond_with_hazard_timer_tween.kill()
	pattern_diamond_with_hazard_timer_tween = get_tree().create_tween()
	pattern_diamond_with_hazard_timer_tween.tween_property(self, "pattern_diamond_with_hazard_timer", 0.0, 3.0)
	
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(70,0), 0.5, 2.5, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(-70,0), 0.5, 2.5, 2)
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(0,100), 0.5, 2.5, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(0,-100), 0.5, 2.5, 4)
	create_hazard_bomb(Vector2(0,0), 0.5,1)
	
	

func pattern_diamond_with_hazard_end():
	PlayingFieldInterface.add_playing_time(pattern_diamond_with_hazard_timer)
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard block end
###############################



###############################
# pattern_numeric_diamond_with_hazard block start
# made by Bae Sekang

var pattern_narrow_road_timer: float
var pattern_narrow_road_timer_tween: Tween

func pattern_narrow_road():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	
	pattern_narrow_road_timer = 3.0
	if pattern_narrow_road_timer_tween != null:
		pattern_narrow_road_timer_tween.kill()
	pattern_narrow_road_timer_tween = get_tree().create_tween()
	pattern_narrow_road_timer_tween.tween_property(self, "pattern_narrow_road_timer", 0.0, 3.0)
	var rng = RandomNumberGenerator.new()
	var random_range_integer = rng.randi_range(-120, 120)
	var rng2 = RandomNumberGenerator.new()
	var is_upsidedown = rng2.randi_range(1, 2)
	if is_upsidedown==2:
		is_upsidedown = -1
	for i in range(0,5,1):
		create_hazard_bomb(Vector2(random_range_integer-80,is_upsidedown*(-100+50*i)), 0.5,2.5)
		create_hazard_bomb(Vector2(random_range_integer+80,is_upsidedown*(-100+50*i)), 0.5,2.5)
		create_numeric_bomb(Vector2(random_range_integer,is_upsidedown*(-100+50*i)), 0.5, 2.5, i+1)


func pattern_narrow_road_end():
	PlayingFieldInterface.add_playing_time(pattern_narrow_road_timer)
	pattern_shuffle_and_draw()
	
# pattern_narrow_road block end
###############################


###############################
# pattern_369 block start
# made by Bae Sekang

var pattern_369_timer: float
var pattern_369_timer_tween: Tween

func pattern_369():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_369_timer = 3.0
	if pattern_369_timer_tween != null:
		pattern_369_timer_tween.kill()
	pattern_369_timer_tween = get_tree().create_tween()
	pattern_369_timer_tween.tween_property(self, "pattern_369_timer", 0.0, 3.0)
	for i in range(1, 10):
		var i_ones_place=i%10
		if i_ones_place%3!=0 or i_ones_place==0:
			create_numeric_bomb(Vector2(200 * cos(i * PI/4.0), 200 * sin(i * PI/4.0)), 1.0, 2.5,i)
		else:
			create_hazard_bomb(Vector2(200 * cos(i * PI/4.0), 200 * sin(i * PI/4.0)), 2.5,1.5)
		await get_tree().create_timer(0.4).timeout


func pattern_369_end():
	PlayingFieldInterface.add_playing_time(pattern_369_timer)
	pattern_shuffle_and_draw()
	
# pattern_369 block end
###############################



###############################
# pattern_colosseum block start
# made by Bae Sekang

var pattern_colosseum_timer: float
var pattern_colosseum_timer_tween: Tween

func pattern_colosseum():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_colosseum_timer = 3.0
	if pattern_colosseum_timer_tween != null:
		pattern_colosseum_timer_tween.kill()
	pattern_colosseum_timer_tween = get_tree().create_tween()
	pattern_colosseum_timer_tween.tween_property(self, "pattern_colosseum_timer", 0.0, 3.0)

	for i in range(1, 7):
		create_hazard_bomb(Vector2(140 * cos(i * PI/3.0), 140 * sin(i * PI/3.0)), 1.0, 1.0)
		create_normal_bomb(Vector2(100 * cos((2*i-1) * PI/6.0), 100 * sin((2*i-1) * PI/6.0)), 1.0, 2.5)
		create_normal_bomb(Vector2(100 * cos(2*i * PI/6.0), 100 * sin(2*i * PI/6.0)), 1.0, 2.5)

func pattern_colosseum_end():
	PlayingFieldInterface.add_playing_time(pattern_colosseum_timer)
	pattern_shuffle_and_draw()
	
# pattern_colosseum block end
###############################



###############################
# pattern_pizza block start
# made by Bae Sekang

var pattern_pizza_timer: float
var pattern_pizza_timer_tween: Tween

func pattern_pizza():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_pizza_timer = 3.0
	if pattern_pizza_timer_tween != null:
		pattern_pizza_timer_tween.kill()
	pattern_pizza_timer_tween = get_tree().create_tween()
	pattern_pizza_timer_tween.tween_property(self, "pattern_pizza_timer", 0.0, 3.0)

	var bomb1: NumericBomb = create_numeric_bomb(Vector2(40,35), 0.5, 2.5, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(-110,105), 0.5, 2.5, 2)
	create_normal_bomb(Vector2(-20,-75), 0.5, 2.5)
	create_normal_bomb(Vector2(85,-10), 0.5, 2.5)
	create_rotationspeedup_bomb(Vector2(0,0), 0.5, 2.5,1.5)
	for i in range(1, 25):
		create_hazard_bomb(Vector2(220 * cos(i * PI/12.0), 220 * sin(i * PI/12.0)), 2.5,0.1)

func pattern_pizza_end():
	PlayingFieldInterface.add_playing_time(pattern_pizza_timer)
	pattern_shuffle_and_draw()
	
# pattern_pizza block end
###############################
