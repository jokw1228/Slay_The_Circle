extends BombGenerator
class_name CircleBombGenerator

var pattern_list: Array[Callable]
var levelup_list: Array[Callable]

var pattern_start_time: float
var pattern_count: int = 0

var prev_pattern_index: int = -1
var prev_timescale: float = Engine.time_scale

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_numeric_center_then_link"))
	pattern_list.append(Callable(self, "pattern_numeric_triangle_with_link"))
	pattern_list.append(Callable(self, "pattern_star"))
	pattern_list.append(Callable(self, "pattern_random_link"))
	pattern_list.append(Callable(self, "pattern_numeric_inversion"))
	pattern_list.append(Callable(self, "pattern_diamond"))
	pattern_list.append(Callable(self, "pattern_twisted_numeric"))
	pattern_list.append(Callable(self, "pattern_spiral"))
	pattern_list.append(Callable(self, "pattern_numeric_choice"))
	pattern_list.append(Callable(self, "pattern_369"))
	
	levelup_list.append(Callable(self, "pattern_inversion_speedup"))
	levelup_list.append(Callable(self, "pattern_speed_and_rotation"))
	
	# difficult patterns
	#pattern_list1.append(Callable(self, "pattern_roll"))
	#pattern_list1.append(Callable(self, "pattern_colosseum"))
	#pattern_list1.append(Callable(self, "pattern_diamond_with_hazard"))
	
	# circler
	#pattern_list.append(Callable(self, "pattern_hazard_at_player_pos")) circler
	#pattern_list.append(Callable(self, "pattern_321_go")) circler
	#pattern_list.append(Callable(self, "pattern_timing")) circler
	#pattern_list.append(Callable(self, "pattern_trafficlight")) circler
	#pattern_list.append(Callable(self, "pattern_hide_in_hazard")) circler

func pattern_shuffle_and_draw():
	randomize()
	pattern_count += 1
	if pattern_count % 4 != 0 or Engine.time_scale >= 2.0:
		var random_index: int = randi() % pattern_list.size()
		while random_index == prev_pattern_index:
			random_index = randi() % pattern_list.size()
		prev_pattern_index = random_index
		pattern_list[random_index].call()
	else:
		var random_index: int = randi() % levelup_list.size()
		levelup_list[random_index].call()

###############################
# pattern_numeric_center_then_link block start
# made by Lee Jinwoong

const pattern_numeric_center_then_link_playing_time = 4.0

func pattern_numeric_center_then_link():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	create_numeric_bomb(Vector2.ZERO, 1.0, 2.0, 1)
	var bomb1: NumericBomb = create_numeric_bomb(player_position * -0.5, 1.0, 3.0, 2)
	var bomb2: NumericBomb = create_numeric_bomb(player_position * 0.5, 1.0, 3.0, 3)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_numeric_center_then_link_end"))

func pattern_numeric_center_then_link_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_center_then_link_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_numeric_center_then_link block end
###############################

###############################
# pattern_hazard_at_player_pos block start
# made by Lee Jinwoong

const pattern_hazard_at_player_pos_playing_time = 4.5

func pattern_hazard_at_player_pos():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2
	const bomb_radius: Vector2 = Vector2(32, 32)
	
	for i in range(0, 5):
		player_position = PlayingFieldInterface.get_player_position()
		create_hazard_bomb(player_position * 224 / 240, 0.75, 0.75)
		create_hazard_bomb(-player_position * 224 / 240, 0.75, 0.75)
		await Utils.timer(0.75)
	
	await Utils.timer(0.75)
	
	pattern_hazard_at_player_pos_end()

func pattern_hazard_at_player_pos_end():
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_hazard_at_player_pos_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_hazard_at_player_pos block end
###############################

###############################
# pattern_inversion_speedup block start
# made by Lee Jinwoong

const pattern_inversion_speedup_playing_time = 4.0
const pattern_inversion_speedup_rest_time = 0.5

func pattern_inversion_speedup():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var speedup_value: float = 0.2 if pattern_count < 20 else 0.1
	
	create_rotationinversion_bomb(Vector2.ZERO, 1.0, 3.0)
	var bomb1: RotationSpeedUpBomb = create_rotationspeedup_bomb(player_position.rotated(PI / 2.0) * 0.5, 1.0, 3.0, speedup_value)
	var bomb2: GameSpeedUpBomb = create_gamespeedup_bomb(player_position.rotated(PI / -2.0) * 0.5, 1.0, 3.0, speedup_value)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_inversion_speedup_end"))

func pattern_inversion_speedup_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_inversion_speedup_playing_time) / prev_timescale)
	prev_timescale = Engine.time_scale
	await Utils.timer(pattern_inversion_speedup_rest_time)
	pattern_shuffle_and_draw()

# pattern_inversion_speedup block end
###############################

###############################
# pattern_321_go block start
# made by Lee Jinwoong

const pattern_321_go_playing_time = 5.2 # 2.0 + delta_time * 4 + time_offset

func pattern_321_go():
	PlayingFieldInterface.set_theme_color(Color.CRIMSON)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	const delta_time: float = 0.75
	const time_offset: float = 0.2
	
	create_hazard_bomb(player_position * -224 / 240,   2.0,   delta_time * 4 - time_offset)
	create_hazard_bomb(player_position * -0.5,   2.0,   delta_time - time_offset / 2.0)
	create_hazard_bomb(Vector2.ZERO,   2.0,   delta_time * 2 - time_offset / 2.0)
	create_hazard_bomb(player_position * 0.5,   2.0,   delta_time * 3 - time_offset / 2.0)
	for i in range(1, 8):
		if i % 2 == 0:
			create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 0.5,   2.0,   delta_time * 4)
		create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 224 / 240,   2.0,   delta_time * 4)
	for i in range(9, 16):
		if i % 2 == 0:
			create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 0.5,   2.0,   delta_time * 4)
		create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 224 / 240,   2.0,   delta_time * 4)
	await Utils.timer(2.0)
	
	var last: HazardBomb = create_hazard_bomb(player_position * 224 / 240,   delta_time * 4,   time_offset)
	await Utils.timer(delta_time - time_offset / 2.0)
	
	create_numeric_bomb(player_position * -0.5,   0,   delta_time * 4,   3)
	await Utils.timer(delta_time)
	create_numeric_bomb(Vector2.ZERO,   0,   delta_time * 3,   2)
	await Utils.timer(delta_time)
	create_numeric_bomb(player_position * 0.5,   0,   delta_time * 2,   1)
	await Utils.timer(delta_time + time_offset * 3.0 / 2.0)
	
	pattern_321_go_end()

func pattern_321_go_end():
	#PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_pattern_321_go_end_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_321_go block end
###############################

###############################
# pattern_numeric_triangle_with_link block start
# made by Jo Kangwoo

const pattern_numeric_tirangle_with_link_playing_time = 3.0

func pattern_numeric_triangle_with_link():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_offset: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var ccw: float = 1 if randi() % 2 else -1
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 1.0, 3.0, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 1.0, 3.0, 2)
	
	var link1: BombLink = create_bomb_link(bomb1, bomb2)
	link1.add_child(Indicator.create(Vector2(CIRCLE_FIELD_RADIUS * cos(angle_offset + ccw * 2*PI/3), CIRCLE_FIELD_RADIUS * -sin(angle_offset + ccw * 2*PI/3)), 32))
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 1.0, 3.0, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 1.0, 3.0, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 1.0, 3.0, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 1.0, 3.0, 6)
	
	var link3: BombLink = create_bomb_link(bomb5, bomb6)
	
	link3.connect("both_bombs_removed", Callable(self, "pattern_numeric_triangle_with_link_end"))

func pattern_numeric_triangle_with_link_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_tirangle_with_link_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_numeric_triangle_with_link block end
###############################

###############################
# pattern_star block start
# made by jooyoung

#var pattern_star_start_time: float
const pattern_star_playing_time = 4.0

func pattern_star():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 192
	
	#bomb1
	create_numeric_bomb(Vector2(bomb_radius * cos(player_angle),bomb_radius*sin(player_angle)), 1.0, 3.0, 1)
	#bomb2
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+4*PI/5),bomb_radius*sin(player_angle+4*PI/5)), 1.0, 3.0, 2)
	#bomb3
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+8*PI/5),bomb_radius*sin(player_angle+8*PI/5)), 1.0, 3.0, 3)
	#bomb4
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+2*PI/5),bomb_radius*sin(player_angle+2*PI/5)), 1.0, 3.0, 4)
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+6*PI/5),bomb_radius*sin(player_angle+6*PI/5)), 1.0, 3.0, 5)

	bomb5.connect("no_lower_value_bomb_exists",Callable(self,"pattern_star_end"))

func pattern_star_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_star_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
#pattern_star end
###############################

###############################
# pattern_random_link block start
# made by kiyong

const pattern_random_link_playing_time = 4.0

var pattern_random_link_player_position: Vector2
var pattern_random_link_player_angle: float
const pattern_random_link_bomb_dist = 128

func pattern_random_link():
	PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_random_link_player_position = PlayingFieldInterface.get_player_position()
	pattern_random_link_player_angle = pattern_random_link_player_position.angle()
	
	var order = [1,2,3]
	order.shuffle()
	var correction = (order[0]-2) * -(acos(sqrt(2)/4)-PI/4)
	
	var vector = [pattern_random_link_auto_rotate(0+correction), pattern_random_link_auto_rotate(PI/2+correction), pattern_random_link_auto_rotate(PI+correction), pattern_random_link_auto_rotate(3*PI/2+correction)]
	var bombs = []
	
	bombs.append(create_numeric_bomb(vector[0], 1.0, 3.0, 1))
	bombs.append(create_numeric_bomb(vector[order[0]], 1.0, 3.0, 2))
	bombs.append(create_numeric_bomb(vector[order[1]], 1.0, 3.0, 3))
	bombs.append(create_numeric_bomb(vector[order[2]], 1.0, 3.0, 4))
	create_bomb_link(bombs[0], bombs[1])
	create_bomb_link(bombs[2], bombs[3])
	
	bombs[3].connect("no_lower_value_bomb_exists",Callable(self,"pattern_random_link_end"))

func pattern_random_link_auto_rotate(angle):
	return Vector2(pattern_random_link_bomb_dist*cos(pattern_random_link_player_angle+angle),pattern_random_link_bomb_dist*sin(pattern_random_link_player_angle+angle))

func pattern_random_link_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_random_link_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_random_link block end
###############################

###############################
# pattern_timing block start
# made by Seonghyeon
const pattern_timing_playing_time = 2.3

func pattern_timing():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const SIZE = 96
	var randomness: float = randf_range(0, 60)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 60)), 0.8, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 120)), 0.8, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 240)), 0.8, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 300)), 0.8, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 0)), 0.8, 1.2)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 180)), 0.8, 1.2)
	var bomb: NormalBomb = create_normal_bomb(Vector2.ZERO, 0.8, 1.5)
	bomb.connect("player_body_entered", Callable(self, "pattern_timing_end"))

func pattern_timing_end():
	await PlayingFieldInterface.player_grounded
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_timing_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
# pattern_timing block end
###############################

###############################
# pattern_trafficlight block start
# made by Seonghyeon
func pattern_trafficlight():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)

	const DIST: float = 96
	const UNIT: float = 0.5
	const START: float = 1
	const WARNING: float = 0.5

	var rotator: Node2D = Node2D.new()
	add_child(rotator)

	var rotation_value: float = PlayingFieldInterface.get_player_position().angle() + 3*PI/2

	create_hazard_bomb((Vector2.LEFT * DIST * 2).rotated(rotation_value), WARNING, START + UNIT * 1)
	create_hazard_bomb((Vector2.LEFT * DIST * 1).rotated(rotation_value), WARNING, START + UNIT * 2)
	create_hazard_bomb((Vector2.ZERO).rotated(rotation_value), WARNING, START + UNIT * 3)
	create_hazard_bomb((Vector2.RIGHT * DIST * 1).rotated(rotation_value), WARNING, START + UNIT * 4)
	create_hazard_bomb((Vector2.RIGHT * DIST * 2).rotated(rotation_value), WARNING, START + UNIT * 5)

	await Utils.timer(WARNING + START - UNIT)
	create_normal_bomb((Vector2.LEFT * DIST * 2).rotated(rotation_value), 2 * UNIT, UNIT)
	await Utils.timer(UNIT)
	create_normal_bomb((Vector2.LEFT * DIST * 1).rotated(rotation_value), 2 * UNIT, UNIT)
	await Utils.timer(UNIT)
	create_normal_bomb((Vector2.ZERO).rotated(rotation_value), 2 * UNIT, UNIT)
	await Utils.timer(UNIT)
	create_normal_bomb((Vector2.RIGHT * DIST * 1).rotated(rotation_value), 2 * UNIT, UNIT)
	create_hazard_bomb((Vector2.LEFT * DIST * 2).rotated(rotation_value), 0, UNIT * 4)
	await Utils.timer(UNIT)
	create_normal_bomb((Vector2.RIGHT * DIST * 2).rotated(rotation_value), 2 * UNIT, UNIT)
	create_hazard_bomb((Vector2.LEFT * DIST * 1).rotated(rotation_value), 0, UNIT * 3)
	await Utils.timer(UNIT)
	create_hazard_bomb((Vector2.ZERO).rotated(rotation_value), 0, UNIT * 2)
	await Utils.timer(UNIT)
	create_hazard_bomb((Vector2.RIGHT * DIST * 1).rotated(rotation_value), 0, UNIT * 1)
	
	await Utils.timer(3 * UNIT)

	pattern_shuffle_and_draw()
# pattern_trafficlight block end
###############################

###############################
# pattern_numeric_inversion block start
# made by Seonghyeon

# this was pattern_manyrotation

const pattern_numeric_inversion_playing_time = 4.0

func pattern_numeric_inversion():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const DIST: float = 96
	
	var player_normalized: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	
	var bomb1: NumericBomb = create_numeric_bomb(DIST * sqrt(3) * player_normalized.rotated(deg_to_rad(60)), 1.0, 3.0, 1)
	var bomb2: NumericBomb = create_numeric_bomb(DIST * player_normalized.rotated(deg_to_rad(120)), 1.0, 3.0, 2)
	var bomb3: Bomb
	if PlayingFieldInterface.get_rotation_speed() != 0:
		bomb3 = create_rotationinversion_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), 1.0, 3.0)
	else:
		bomb3 = create_normal_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), 1.0, 3.0)
	var link: BombLink = create_bomb_link(bomb2, bomb3)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_numeric_inversion_end"))

func pattern_numeric_inversion_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_inversion_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_numeric_inversion block end
###############################

###############################
# pattern_speed_and_roation block start
# made by jooyoung

const pattern_speed_and_rotation_playing_time = 4.0
const pattern_speed_and_rotation_rest_time = 0.5

func pattern_speed_and_rotation():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var speedup_value: float = 0.2 if pattern_count < 20 else 0.1
	const bomb_radius = 64
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle), 2 * bomb_radius * sin(player_angle)),1.0,3.0,1)
	var bomb2: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(bomb_radius * cos(player_angle), bomb_radius * sin(player_angle)),1.0,3.0,speedup_value)
	
	create_bomb_link(bomb1,bomb2)
	
	var bomb3: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2(bomb_radius * cos(player_angle+PI), bomb_radius * sin(player_angle+PI)),1.0,3.0,speedup_value)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle+PI), 2 * bomb_radius * sin(player_angle+PI)),1.0,3.0,2)
	
	var link2: BombLink = create_bomb_link(bomb3,bomb4)
	
	link2.connect("both_bombs_removed",Callable(self,"pattern_speed_and_roation_end"))

func pattern_speed_and_roation_end():
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_speed_and_rotation_playing_time) / prev_timescale)
	prev_timescale = Engine.time_scale
	await get_tree().create_timer(pattern_speed_and_rotation_rest_time).timeout
	pattern_shuffle_and_draw()
	
#pattern_speed_and_roation end
###############################

###############################
# pattern_roll block start
# made by Jaeyong

const pattern_roll_playing_time = 3.0
var pattern_roll_bomb_count: int

func pattern_roll():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var angle_offset: float = PlayingFieldInterface.get_player_position().angle()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var hazard_line: int = rng.randi_range(1,4)
	if hazard_line == 4:
		hazard_line = 2 #가운데 나오는 비율을 더 많이 주고 싶어서...
	
	pattern_roll_bomb_count = 10 if hazard_line == 2 else 11
	var bomb_list: Array[NormalBomb]

	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(Vector2(96 * i,192 - 96 * i).rotated(angle_offset - PI/2), 0.2, 2.4)
		bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(0.1).timeout
	
	
	if hazard_line == 1:
		create_hazard_bomb(Vector2(96, 0).rotated(angle_offset - PI/2), 0.2, 2.4)
		create_hazard_bomb(Vector2(0, 96).rotated(angle_offset - PI/2), 0.2, 2.4)
	else :
		for i in (2):
			var bomb: NormalBomb = create_normal_bomb(Vector2(96 - 96 * i,96 * i).rotated(angle_offset - PI/2), 0.2, 2.4)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(0.1).timeout

	
	if hazard_line == 2:
		create_hazard_bomb(Vector2(-96, 96).rotated(angle_offset - PI/2), 0.2, 2.4)
		create_hazard_bomb(Vector2(0, 0).rotated(angle_offset - PI/2), 0.2, 2.4)
		create_hazard_bomb(Vector2(96, -96).rotated(angle_offset - PI/2), 0.2, 2.4)
	else :		
		for i in (3):
			var bomb: NormalBomb = create_normal_bomb(Vector2(-96 + 96 * i, 96 - 96 * i).rotated(angle_offset - PI/2), 0.2, 2.4)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(0.1).timeout
		
		
	if hazard_line == 3:
		create_hazard_bomb(Vector2(-96, 0).rotated(angle_offset - PI/2), 0.2, 2.4)
		create_hazard_bomb(Vector2(0, -96).rotated(angle_offset - PI/2), 0.2, 2.4)
	else :
		for i in (2):
			var bomb: NormalBomb = create_normal_bomb(Vector2(-96 + 96 * i,- 96 * i).rotated(angle_offset - PI/2), 0.2, 2.4)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(0.1).timeout
	
	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(Vector2(-96 * i, -192 + 96 * i).rotated(angle_offset - PI/2), 0.2, 2.4)
		bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))

func pattern_roll_end():
	pattern_roll_bomb_count -= 1
	if pattern_roll_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_roll_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()
	
# pattern_roll block end
###############################

###############################
# pattern_diamond block start
# made by Jaeyong

const pattern_diamond_playing_time = 3
var pattern_diamond_bomb_count: int

func pattern_diamond():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_diamond_bomb_count = 4
	var angle_offset: float = randf() if pattern_start_time > 30.0 else PlayingFieldInterface.get_player_position().angle()
	var normal_bomb_list: Array[NormalBomb]
	
	const CIRCLE_FIELD_RADIUS = 256
	
	const normal_radius = CIRCLE_FIELD_RADIUS - 48
	const hazard_radius = CIRCLE_FIELD_RADIUS - 144
	
	for i in range(4):
		var bomb: NormalBomb = create_normal_bomb(Vector2(normal_radius * cos(angle_offset + i * PI/2), normal_radius * sin(angle_offset + i * PI/2)), 0.5, 2.5)
		bomb.connect("player_body_entered", Callable(self, "pattern_diamond_end"))
		create_hazard_bomb(Vector2(hazard_radius * cos(angle_offset + i * PI/2), hazard_radius * sin(angle_offset + i * PI/2)), 0.5, 2.5)

func pattern_diamond_end():
	pattern_diamond_bomb_count -= 1
	if pattern_diamond_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()

# pattern_diamond block end
###############################

###############################
# pattern_twisted_numeric block start
# made by Jaeyong

const pattern_twisted_numeric_playing_time = 4.0

func pattern_twisted_numeric():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var end_bomb: NumericBomb
	
	end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -144 / 240, 1.0, 3.0 ,4)
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * -48 / 240, 1.0, 3.0, 2)
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * 48 / 240, 1.0, 3.0, 1)
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * 144 / 240, 1.0, 3.0, 3)
	
	end_bomb.connect("player_body_entered", Callable(self, "pattern_twisted_numeric_end"))

func pattern_twisted_numeric_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_twisted_numeric_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_fast_numeric block end
###############################

###############################
# pattern_spiral block start
# made by jinhyun

const pattern_spiral_playing_time = 5.5
var pattern_spiral_bomb_count: int

func pattern_spiral():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var init_position: Vector2 = Vector2.UP
	
	pattern_spiral_bomb_count = 16
	for i in range(16):
		var bomb: NormalBomb = create_normal_bomb(init_position.rotated(i*PI/3) * (i+1) * 14, 0.3, 3.7)
		bomb.connect("player_body_entered",Callable(self,"pattern_spiral_end"))
		await get_tree().create_timer(0.1).timeout

func pattern_spiral_end():
	pattern_spiral_bomb_count -= 1
	if pattern_spiral_bomb_count == 0:
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_spiral_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()
	
# pattern_spiral end
###############################

###############################
# pattern_numeric_choice block start
# made by jinhyun

const pattern_numeric_choice_playing_time = 4.125

func pattern_numeric_choice():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	var rotation_inv_box: Array = [-PI/2, PI, PI/2, 0]
	
	randomize()
	var rand: int = randi() % 2
	
	if rand == 0:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 208 / 240, 0.5, 1.0, i+1)
			if i == 7:
				bomb.connect("player_body_entered",Callable(self,"pattern_numeric_choice_end"))
			await get_tree().create_timer(0.375).timeout
	else:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_inv_box[i%4]) * 208 / 240, 0.5, 1.0, i+1)
			if i == 7:
				bomb.connect("player_body_entered",Callable(self,"pattern_numeric_choice_end"))
			await get_tree().create_timer(0.375).timeout

func pattern_numeric_choice_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_choice_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_numeric_choice end
###############################

###############################
# pattern_hide_in_hazard block start
# made by seokhee

#위험하다고 피하는 건 좋지 않아요
#circle 정도의 쉬?운 난이도

const pattern_hide_in_hazard_playing_time = 6.75
var bomb_count = 0

func pattern_hide_in_hazard():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_offset: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var ccw: float = 1 if randi() % 2 else -1
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 0.75, 6, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 0.75, 6, 2)
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 0.75, 6, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 0.75, 6, 4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 0.75, 6, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 0.75, 6, 6)
	
	bomb6.connect("player_body_entered", Callable(self, "pattern_hide_in_hazard_end"))
	
	for i in range(3):
		for j in range(6):
			var bomb : HazardBomb = create_hazard_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * (2*j-1)*PI/6), bomb_radius * -sin(angle_offset + ccw * (2*j-1)*PI/6)), 0.75, 1)
		await Utils.timer(1.75)

func pattern_hide_in_hazard_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_hide_in_hazard_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
#pattern_hide_in_hazard block end
###############################

###############################
# pattern_numeric_diamond_with_hazard block start
# made by Bae Sekang

const pattern_diamond_with_hazard_playing_time = 3.0

func pattern_diamond_with_hazard():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var player_angle2: float = player_position.angle() * -1
	var bomb_radius = 64
	create_hazard_bomb(Vector2(0,0), 0.5, 2.5)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+4*PI/2),2*bomb_radius*sin(player_angle+4*PI/2)), 0.5, 2.5, 1)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+1*PI/2),2*bomb_radius*sin(player_angle+1*PI/2)), 0.5, 2.5, 2)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+2*PI/2),2*bomb_radius*sin(player_angle+2*PI/2)), 0.5, 2.5, 3)
	var bomb: NumericBomb = create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+3*PI/2),2*bomb_radius*sin(player_angle+3*PI/2)), 0.5, 2.5, 4)
	bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_diamond_with_hazard_end"))

func pattern_diamond_with_hazard_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_with_hazard_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard block end
###############################


###############################
# pattern_369 block start
# made by Bae Sekang

const pattern_369_playing_time = 6.0

func pattern_369():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var angle_offset: float = PlayingFieldInterface.get_player_position().angle()
	for i in range(1, 9):
		if i % 3 != 0:
			create_numeric_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0), 208 * sin(angle_offset + i * PI/4.0)), 0.5, 1.5, i)
		else:
			create_hazard_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0), 208 * sin(angle_offset + i * PI/4.0)), 0.5, 1.5)
			create_numeric_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0+PI), 208 * sin(angle_offset + i * PI/4.0+PI)), 0.5, 1.5, i)
		await get_tree().create_timer(0.5).timeout
	var end_bomb: NumericBomb
	create_hazard_bomb(Vector2(208 * cos(angle_offset + 9 * PI/4.0), 208 * sin(angle_offset + 9 * PI/4.0)), 0.5, 1.5)
	end_bomb = create_numeric_bomb(Vector2(208 * cos(angle_offset + 9 * PI/4.0+PI), 208 * sin(angle_offset + 9 * PI/4.0+PI)), 0.5, 1.5, 9)
	end_bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_369_end"))

func pattern_369_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_369_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_369 block end
###############################



###############################
# pattern_colosseum block start
# made by Bae Sekang

const pattern_colosseum_playing_time = 3.0
var pattern_colosseum_bomb_count: int

func pattern_colosseum():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var player_angle2: float = player_position.angle() * -1
	var bomb_radius = 72
	
	pattern_colosseum_bomb_count = 6
	for i in range(0,12):
		if i%2==0:
			var bomb: NormalBomb = create_normal_bomb(Vector2(1.5*bomb_radius*cos(player_angle+i*PI/6),1.5*bomb_radius*sin(player_angle+i*PI/6)), 0.5, 2.5)
			bomb.connect("player_body_entered",Callable(self,"pattern_colosseum_end"))
		else:
			create_hazard_bomb(Vector2(2.1*bomb_radius*cos(player_angle+i*PI/6),2.1*bomb_radius*sin(player_angle+i*PI/6)), 0.5, 2.5)
	
func pattern_colosseum_end():
	pattern_colosseum_bomb_count -= 1
	if pattern_colosseum_bomb_count == 0:
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_colosseum_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()
	
# pattern_colosseum block end
###############################
