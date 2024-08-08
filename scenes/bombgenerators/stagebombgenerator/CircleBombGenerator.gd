extends BombGenerator
class_name CircleBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_numeric_triangle_with_link"))
	pattern_list.append(Callable(self, "pattern_star"))
	pattern_list.append(Callable(self, "pattern_random_link"))
	pattern_list.append(Callable(self, "pattern_timing"))
	pattern_list.append(Callable(self, "pattern_trafficlight"))
	pattern_list.append(Callable(self, "pattern_manyrotation"))
	pattern_list.append(Callable(self, "pattern_speed_and_roation"))
	pattern_list.append(Callable(self, "pattern_roll"))
	pattern_list.append(Callable(self, "pattern_diamond"))
	pattern_list.append(Callable(self, "pattern_twisted_numeric"))
	pattern_list.append(Callable(self, "pattern_spiral"))
	pattern_list.append(Callable(self, "pattern_numeric_choice"))
	pattern_list.append(Callable(self, "pattern_hide_in_hazard"))
	pattern_list.append(Callable(self, "pattern_diamond_with_hazard"))
	pattern_list.append(Callable(self, "pattern_narrow_road"))
	pattern_list.append(Callable(self, "pattern_369"))
	pattern_list.append(Callable(self, "pattern_colosseum"))
	pattern_list.append(Callable(self, "pattern_pizza"))
	
func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

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
const pattern_random_link_bomb_dist = 128

func pattern_random_link():
	PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
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
# pattern_timing block start
# made by Seonghyeon
func pattern_timing():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)

	const SIZE = 70
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(60)), 0.8, 1.5)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(120)), 0.8, 1.5)
	create_hazard_bomb(SIZE * Vector2.RIGHT.rotated(deg_to_rad(60)), 0.8, 1.5)
	create_hazard_bomb(SIZE * Vector2.RIGHT.rotated(deg_to_rad(120)), 0.8, 1.5)
	create_hazard_bomb(SIZE * Vector2.LEFT, 0.8, 1.3)
	create_hazard_bomb(SIZE * Vector2.RIGHT, 0.8, 1.3)
	create_normal_bomb(Vector2.ZERO, 0.8, 1.5) 

	await Utils.timer(2.3)
	pattern_shuffle_and_draw()
# pattern_timing block end
###############################

###############################
# pattern_trafficlight block start
# made by Seonghyeon
func pattern_trafficlight():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)

	const DIST: float = 75
	const UNIT: float = 0.5
	const START: float = 1
	const WARNING: float = 0.5

	create_hazard_bomb(Vector2.LEFT * DIST * 2, WARNING, START + UNIT * 1)
	create_hazard_bomb(Vector2.LEFT * DIST * 1, WARNING, START + UNIT * 2)
	create_hazard_bomb(Vector2.ZERO, WARNING, START + UNIT * 3)
	create_hazard_bomb(Vector2.RIGHT * DIST * 1, WARNING, START + UNIT * 4)
	create_hazard_bomb(Vector2.RIGHT * DIST * 2, WARNING, START + UNIT * 5)

	await Utils.timer(WARNING + START)
	create_normal_bomb(Vector2.LEFT * DIST * 2, UNIT, UNIT)
	create_hazard_bomb(Vector2.LEFT * DIST * 2, 2 * UNIT, UNIT * 4)

	await Utils.timer(UNIT)
	create_normal_bomb(Vector2.LEFT * DIST * 1, UNIT, UNIT)
	create_hazard_bomb(Vector2.LEFT * DIST * 1, 2 * UNIT, UNIT * 3)

	await Utils.timer(UNIT)
	create_normal_bomb(Vector2.ZERO, UNIT, UNIT)
	create_hazard_bomb(Vector2.ZERO, 2 * UNIT, UNIT * 2)

	await Utils.timer(UNIT)
	create_normal_bomb(Vector2.RIGHT * DIST * 1, UNIT, UNIT)
	create_hazard_bomb(Vector2.RIGHT * DIST * 1, 2 * UNIT, UNIT * 1)

	await Utils.timer(UNIT)
	create_normal_bomb(Vector2.RIGHT * DIST * 2, UNIT, UNIT)

	await Utils.timer(2 * UNIT)

	pattern_shuffle_and_draw()
# pattern_trafficlight block end
###############################

###############################
# pattern_manyrotation block start
# made by Seonghyeon
func pattern_manyrotation():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
	const COUNT: int = 3
	const DIST: float = 100
	const UNIT: float = 0.7

	for i in range(COUNT):
		var bombs: Array[Bomb] = []
		for j in range(3):
			bombs.append(create_normal_bomb(DIST * Vector2.UP.rotated(deg_to_rad(120 * j)), UNIT, 2 * UNIT))
		bombs.shuffle()
		create_bomb_link(bombs[0], bombs[1])

		await Utils.timer(2 * UNIT)
		if randi_range(0, 1): create_rotationspeedup_bomb(Vector2.ZERO, UNIT, UNIT, 0.3)
		else: create_rotationinversion_bomb(Vector2.ZERO, UNIT, UNIT)

		await Utils.timer(2 * UNIT)

	pattern_shuffle_and_draw()
# pattern_manyrotation block end
###############################

###############################
# pattern_speed_and_roation block start
# made by jooyoung

var pattern_speed_or_rotation_timer: float
var pattern_speed_or_rotation_timer_tween: Tween

func pattern_speed_and_roation():
	pattern_speed_or_rotation_timer = 3
	if pattern_speed_or_rotation_timer_tween != null:
		pattern_speed_or_rotation_timer_tween.kill()
	pattern_speed_or_rotation_timer_tween = get_tree().create_tween()
	pattern_speed_or_rotation_timer_tween.tween_property(self,"pattern_star_timer",0.0,2.5)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 64
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle), 2 * bomb_radius * sin(player_angle)),0.5,2.0,1)
	var bomb2: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(bomb_radius * cos(player_angle), bomb_radius * sin(player_angle)),0.5,2.0,0.5)
	
	create_bomb_link(bomb1,bomb2)
	
	var bomb3: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2(bomb_radius * cos(player_angle+PI), bomb_radius * sin(player_angle+PI)),0.5,2.0,0.5)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle+PI), 2 * bomb_radius * sin(player_angle+PI)),0.5,2.0,2)
	
	var link2: BombLink = create_bomb_link(bomb3,bomb4)
	
	link2.connect("both_bombs_removed",Callable(self,"pattern_speed_and_roation_end"))

func pattern_speed_and_roation_end():
	PlayingFieldInterface.add_playing_time(pattern_speed_or_rotation_timer)
	pattern_shuffle_and_draw()
	
#pattern_speed_and_roation end
###############################

###############################
# pattern_roll block start
# made by Jaeyong

var pattern_roll_timer: float
var pattern_roll_timer_tween: Tween

func pattern_roll():
	
	pattern_roll_timer = 3.0
	if pattern_roll_timer_tween != null:
		pattern_roll_timer_tween.kill()
	pattern_roll_timer_tween = get_tree().create_tween()
	pattern_roll_timer_tween.tween_property(self, "pattern_roll_timer", 0.0, 3.0)
	
	var left_bomb = 13
	var end_bomb: NormalBomb = create_normal_bomb(Vector2(0, -200), 0.5, 2.5)
	create_normal_bomb(Vector2(0, -100), 0.5, 2.5)
	create_normal_bomb(Vector2(0, 0), 0.5, 2.5)
	create_normal_bomb(Vector2(0, 100), 0.5, 2.5)
	create_normal_bomb(Vector2(0, 200), 0.5, 2.5)
	
	create_normal_bomb(Vector2(100, -100), 0.5, 2.5)
	create_normal_bomb(Vector2(100, 0), 0.5, 2.5)
	create_normal_bomb(Vector2(100, 100), 0.5, 2.5)

	create_normal_bomb(Vector2(-100, -100), 0.5, 2.5)
	create_normal_bomb(Vector2(-100, 0), 0.5, 2.5)
	create_normal_bomb(Vector2(-100, 100), 0.5, 2.5)
	
	create_normal_bomb(Vector2(200, 0), 0.5, 2.5)

	create_normal_bomb(Vector2(-200, 0), 0.5, 2.5)

	end_bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))

func pattern_roll_end():
	PlayingFieldInterface.add_playing_time(pattern_roll_timer)
	pattern_shuffle_and_draw()
	
# pattern_roll block end
###############################

###############################
# pattern_diamond block start
# made by Jaeyong

func pattern_diamond():
	
	var left_bomb: int = 4
	create_hazard_bomb(Vector2(100, 0), 0.5, 2.5)
	create_normal_bomb(Vector2(200, 0), 0.5, 2.5)
	
	create_hazard_bomb(Vector2(-100, 0), 0.5, 2.5)
	create_normal_bomb(Vector2(-200, 0), 0.5, 2.5)
	
	create_hazard_bomb(Vector2(0, 100), 0.5, 2.5)
	create_normal_bomb(Vector2(0, 200), 0.5, 2.5)
	
	create_hazard_bomb(Vector2(0, -100), 0.5, 2.5)
	create_normal_bomb(Vector2(0, -200), 0.5, 2.5)

	await Utils.timer(3.0)
	
	pattern_shuffle_and_draw()
	
# pattern_diamond block end
###############################

###############################
# pattern_twisted_numeric block start
# made by Jaeyong

var pattern_twisted_numeric_timer: float
var pattern_twisted_numeric_timer_tween: Tween

func pattern_twisted_numeric():
	
	pattern_twisted_numeric_timer = 3.0
	if pattern_twisted_numeric_timer_tween != null:
		pattern_twisted_numeric_timer_tween.kill()
	pattern_twisted_numeric_timer_tween = get_tree().create_tween()
	pattern_twisted_numeric_timer_tween.tween_property(self, "pattern_twisted_numeric_timer", 0.0, 3.0)
	
	var left_bomb = 4
	var end_bomb: NumericBomb
	
	if(PlayingFieldInterface.get_player_position() != Vector2(0,0)):
		end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.6, 0.5, 2.5 ,4)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.2, 0.5, 2.5, 2)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.2 , 0.5, 2.5, 1)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.6, 0.5, 2.5, 3)
	else:
		end_bomb = create_numeric_bomb(Vector2(256,0) * -0.6, 0.5, 2.5 ,4)
		create_numeric_bomb(Vector2(256,0) * -0.2, 0.5, 2.5, 2)
		create_numeric_bomb(Vector2(256,0) * 0.2 , 0.5, 2.5, 1)
		create_numeric_bomb(Vector2(256,0) * 0.6, 0.5, 2.5, 3)
		
	end_bomb.connect("player_body_entered", Callable(self, "pattern_twisted_numeric_end"))

func pattern_twisted_numeric_end():
	PlayingFieldInterface.add_playing_time(pattern_twisted_numeric_timer)
	pattern_shuffle_and_draw()

# pattern_fast_numeric block end
###############################

###############################
# pattern_spiral block start
# made by jinhyun

var pattern_spiral_timer: float
var pattern_spiral_timer_tween: Tween

func pattern_spiral():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_spiral_timer = 3.0
	if pattern_spiral_timer_tween != null:
		pattern_spiral_timer_tween.kill()
	pattern_spiral_timer_tween = get_tree().create_tween()
	pattern_spiral_timer_tween.tween_property(self,"pattern_spiral_timer",0.0,3.0)
	
	var init_position: Vector2 = Vector2.UP
	
	for i in range(16):
		create_normal_bomb(init_position.rotated(i*PI/3) * (i+1) * 14, 0.3, 3)
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(2).timeout
	var bomb = create_normal_bomb(Vector2(0, 0), 0.3, 3)
	bomb.connect("player_body_entered",Callable(self,"pattern_spiral_end"))

func pattern_spiral_end():
	PlayingFieldInterface.add_playing_time(pattern_spiral_timer)
	pattern_shuffle_and_draw()
	
# pattern_spiral end
###############################

###############################
# pattern_numeric_choice block start
# made by jinhyun

var pattern_numeric_choice_timer: float
var pattern_numeric_choice_timer_tween: Tween

func pattern_numeric_choice():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_numeric_choice_timer = 3.0
	if pattern_numeric_choice_timer_tween != null:
		pattern_numeric_choice_timer_tween.kill()
	pattern_numeric_choice_timer_tween = get_tree().create_tween()
	pattern_numeric_choice_timer_tween.tween_property(self,"pattern_numeric_choice_timer",0.0,3.0)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	var rotation_inv_box: Array = [-PI/2, PI, PI/2, 0]
	var rand: int = randi() % 2
	
	if rand == 0:
		for i in range(8):
			create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 0.8, 0.3, 1, i+1)
			await get_tree().create_timer(0.25).timeout
	else:
		for i in range(8):
			create_numeric_bomb(player_position.rotated(rotation_inv_box[i%4]) * 0.8, 0.3, 1, i+1)
			await get_tree().create_timer(0.25).timeout
	
	await get_tree().create_timer(2).timeout
	var bomb = create_normal_bomb(Vector2(0, 0), 0.3, 3)
	bomb.connect("player_body_entered",Callable(self,"pattern_numeric_choice_end"))

func pattern_numeric_choice_end():
	PlayingFieldInterface.add_playing_time(pattern_numeric_choice_timer)
	pattern_shuffle_and_draw()
	
# pattern_numeric_choice end
###############################

###############################
# pattern_hide_in_hazard block start
# made by seokhee

#위험하다고 피하는 건 좋지 않아요
#circle 정도의 쉬?운 난이도

var pattern_hide_in_hazard_timer : float
var pattern_hide_in_hazard_timer_tween : Tween

func pattern_hide_in_hazard():
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	pattern_hide_in_hazard_timer = 6.0
	
	if pattern_hide_in_hazard_timer_tween != null:
		pattern_hide_in_hazard_timer_tween.kill()
	pattern_hide_in_hazard_timer_tween = get_tree().create_tween()
	pattern_hide_in_hazard_timer_tween.tween_property(self, "pattern_hide_in_hazard_timer", 0.0, 6.0)
	
	for i in range(8):
		var bomb : NormalBomb = create_normal_bomb(Vector2(150 * cos(i*PI/4), 150 * sin(i*PI/4)), 0.4, 5.6)
	
	for i in range(4):	
		for j in range(8):
			var bomb : HazardBomb = create_hazard_bomb(Vector2(150 * cos(j*PI/4), 150 * sin(j*PI/4)), 0.5, 1)
		await Utils.timer(1.5)
	pattern_shuffle_and_draw()
	
	
func pattern_hide_in_hazard_end():
	PlayingFieldInterface.add_playing_time(pattern_hide_in_hazard_timer)
	pattern_shuffle_and_draw()
	
#pattern_hide_in_hazard block end
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
	await Utils.timer(2.5)
	pattern_diamond_with_hazard_end()

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
	await Utils.timer(2.5)
	pattern_narrow_road_end()

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
	
	await Utils.timer(2.5)
	pattern_369_end()

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
	
	await Utils.timer(2.5)
	pattern_colosseum_end()
	
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
	await Utils.timer(2.5)
	pattern_pizza_end()
	
func pattern_pizza_end():
	PlayingFieldInterface.add_playing_time(pattern_pizza_timer)
	pattern_shuffle_and_draw()
	
# pattern_pizza block end
###############################
