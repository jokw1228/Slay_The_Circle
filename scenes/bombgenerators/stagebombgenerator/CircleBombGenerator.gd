extends BombGenerator
class_name CircleBombGenerator

#var pattern_list: Array[Callable] # legacy code
var levelup_list: Array[Callable] # legacy code

var pattern_start_time: float
var pattern_count: int = 0 # lecacy code

var prev_pattern_index: int = -1 # legacy code
var prev_timescale: float = Engine.time_scale

var stage_phase: int = 0
const stage_phase_length = 20.0
var pattern_dict: Dictionary = {}

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_dict = {
		"pattern_numeric_center_then_link" = 1.0,
		"pattern_numeric_triangle_with_link" = 1.0,
		"pattern_star" = 1.0,
		"pattern_random_link" = 1.0,
		"pattern_diamond" = 1.0
	}
	'''
	pattern_list.append(Callable(self, "pattern_numeric_center_then_link")) # phase 0
	pattern_list.append(Callable(self, "pattern_numeric_triangle_with_link")) # phase 0
	pattern_list.append(Callable(self, "pattern_star")) # phase 0
	pattern_list.append(Callable(self, "pattern_random_link")) # phase 0
	pattern_list.append(Callable(self, "pattern_diamond")) # phase 0
	
	pattern_list.append(Callable(self, "pattern_numeric_inversion"))
	pattern_list.append(Callable(self, "pattern_twisted_numeric"))
	pattern_list.append(Callable(self, "pattern_spiral"))
	pattern_list.append(Callable(self, "pattern_numeric_choice"))
	pattern_list.append(Callable(self, "pattern_369"))
	
	levelup_list.append(Callable(self, "pattern_inversion_speedup"))
	levelup_list.append(Callable(self, "pattern_speed_and_rotation"))
	
	# difficult patterns
	pattern_list.append(Callable(self, "pattern_roll"))
	pattern_list.append(Callable(self, "pattern_colosseum"))
	pattern_list.append(Callable(self, "pattern_diamond_with_hazard"))
	'''

func pattern_shuffle_and_draw():
	randomize()
	
	var weight_sum: float = 0.0
	for i: float in pattern_dict.values():
		weight_sum += i
	var remaining_weight: float = randf_range(0, weight_sum)
	
	var pattern_index = 0
	var pattern_dict_keys: Array = pattern_dict.keys()
	for i: String in pattern_dict_keys:
		if remaining_weight >= pattern_dict[i]:
			pattern_index += 1
			remaining_weight -= pattern_dict[i]
		else:
			break
	
	Callable(self, pattern_dict_keys[pattern_index] ).call()
	'''
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
	'''

###############################
# pattern_numeric_center_then_link block start
# made by Lee Jinwoong

const pattern_numeric_center_then_link_playing_time = 4.0

func pattern_numeric_center_then_link():
	PlayingFieldInterface.set_theme_color(Color.AQUA)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	create_numeric_bomb(Vector2.ZERO, 0.75, 2.25, 1)
	var bomb1: NumericBomb = create_numeric_bomb(player_position * -0.5, 0.75, 3.25, 2)
	var bomb2: NumericBomb = create_numeric_bomb(player_position * 0.5, 0.75, 3.25, 3)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	if pattern_count > 16:
		create_hazard_bomb(player_position.rotated(PI / 2.0) * 208.0 / 240.0, 0.75, 2.25)
		create_hazard_bomb(player_position.rotated(PI / -2.0) * 208.0 / 240.0, 0.75, 2.25)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_numeric_center_then_link_end"))

func pattern_numeric_center_then_link_end():
	await PlayingFieldInterface.player_grounded
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_center_then_link_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_numeric_center_then_link block end
###############################

###############################
# pattern_inversion_speedup block start
# made by Lee Jinwoong

const pattern_inversion_speedup_playing_time = 4.0
const pattern_inversion_speedup_rest_time = 0.5

func pattern_inversion_speedup():
	PlayingFieldInterface.set_theme_color(Color.BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var speedup_value: float = 0.2 if pattern_count < 20 else 0.1
	
	create_rotationinversion_bomb(Vector2.ZERO, 0.75, 3.25)
	var bomb1: RotationSpeedUpBomb = create_rotationspeedup_bomb(player_position.rotated(PI / 2.0) * 0.5, 0.75, 3.25, speedup_value * 2.0)
	var bomb2: GameSpeedUpBomb = create_gamespeedup_bomb(player_position.rotated(PI / -2.0) * 0.5, 0.75, 3.25, speedup_value)
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
	
	if pattern_count > 16:
		angle_offset += PI / -3.0 if ccw == 1 else PI / 3.0
		
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 0.75, 3.25, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 0.75, 3.25, 2)
	
	var link1: BombLink = create_bomb_link(bomb1, bomb2)
	link1.add_child(Indicator.create(Vector2(CIRCLE_FIELD_RADIUS * cos(angle_offset + ccw * 2*PI/3), CIRCLE_FIELD_RADIUS * -sin(angle_offset + ccw * 2*PI/3)), 32))
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 0.75, 3.25, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 0.75, 3.25, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 0.75, 3.25, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 0.75, 3.25, 6)
	
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
	PlayingFieldInterface.set_theme_color(Color.CORNFLOWER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 208
	
	#bomb1
	create_numeric_bomb(Vector2(bomb_radius * cos(player_angle),bomb_radius*sin(player_angle)), 0.75, 3.25, 1)
	#bomb2
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+4*PI/5),bomb_radius*sin(player_angle+4*PI/5)), 0.75, 3.25, 2)
	#bomb3
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+8*PI/5),bomb_radius*sin(player_angle+8*PI/5)), 0.75, 3.25, 3)
	#bomb4
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+2*PI/5),bomb_radius*sin(player_angle+2*PI/5)), 0.75, 3.25, 4)
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+6*PI/5),bomb_radius*sin(player_angle+6*PI/5)), 0.75, 3.25, 5)

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
	PlayingFieldInterface.set_theme_color(Color.DARK_CYAN)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_random_link_player_position = PlayingFieldInterface.get_player_position()
	pattern_random_link_player_angle = pattern_random_link_player_position.angle()
	
	var order = [1,2,3]
	order.shuffle()
	var correction = (order[0]-2) * -(acos(sqrt(2)/4)-PI/4)
	
	var vector = [pattern_random_link_auto_rotate(0+correction), pattern_random_link_auto_rotate(PI/2+correction), pattern_random_link_auto_rotate(PI+correction), pattern_random_link_auto_rotate(3*PI/2+correction)]
	var bombs = []
	
	bombs.append(create_numeric_bomb(vector[0], 0.75, 3.25, 1))
	bombs.append(create_numeric_bomb(vector[order[0]], 0.75, 3.25, 2))
	bombs.append(create_numeric_bomb(vector[order[1]], 0.75, 3.25, 3))
	bombs.append(create_numeric_bomb(vector[order[2]], 0.75, 3.25, 4))
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
# pattern_numeric_inversion block start
# made by Seonghyeon

# this was pattern_manyrotation

const pattern_numeric_inversion_playing_time = 4.0

func pattern_numeric_inversion():
	PlayingFieldInterface.set_theme_color(Color.DARK_TURQUOISE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const DIST: float = 96
	
	var player_normalized: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	
	if pattern_count < 16 or randi() % 2:
		create_numeric_bomb(DIST * sqrt(3) * player_normalized.rotated(deg_to_rad(60)), 0.75, 3.25, 1)
	else:
		create_numeric_bomb(DIST * sqrt(3) * player_normalized.rotated(deg_to_rad(-60)), 0.75, 3.25, 1)
	var bomb2: NumericBomb = create_numeric_bomb(DIST * player_normalized.rotated(deg_to_rad(120)), 0.75, 3.25, 2)
	var bomb3: Bomb
	if PlayingFieldInterface.get_rotation_speed() != 0:
		bomb3 = create_rotationinversion_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), 0.75, 3.25)
	else:
		bomb3 = create_normal_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), 0.75, 3.25)
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
	PlayingFieldInterface.set_theme_color(Color.BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var speedup_value: float = 0.2 if pattern_count < 20 else 0.1
	const bomb_radius = 64
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle), 2 * bomb_radius * sin(player_angle)),0.5,3.5,1)
	var bomb2: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(bomb_radius * cos(player_angle), bomb_radius * sin(player_angle)),0.5,3.5,speedup_value * 2.0)
	
	create_bomb_link(bomb1,bomb2)
	
	var bomb3: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2(bomb_radius * cos(player_angle+PI), bomb_radius * sin(player_angle+PI)),0.5,3.5,speedup_value)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle+PI), 2 * bomb_radius * sin(player_angle+PI)),0.5,3.5,2)
	
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
	PlayingFieldInterface.set_theme_color(Color.DARK_BLUE)
	
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
	PlayingFieldInterface.set_theme_color(Color.DODGER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_diamond_bomb_count = 4
	var angle_offset: float = randf() if pattern_count > 16 else PlayingFieldInterface.get_player_position().angle()
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
	PlayingFieldInterface.set_theme_color(Color.LIGHT_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var end_bomb: NumericBomb
	
	if pattern_count < 16 or randi() % 2:
		end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -144.0 / 240.0, 0.75, 3.25 ,4)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 144.0 / 240.0, 0.75, 3.25, 3)
	else:
		end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * 144.0 / 240.0, 0.75, 3.25 ,4)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -144.0 / 240.0, 0.75, 3.25, 3)
	
	if pattern_count < 16 or randi() % 2:
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -48.0 / 240.0, 0.75, 3.25, 2)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 48.0 / 240.0, 0.75, 3.25, 1)
	else:
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 48.0 / 240.0, 0.75, 3.25, 2)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -48.0 / 240.0, 0.75, 3.25, 1)
	
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
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_BLUE)
	
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
	PlayingFieldInterface.set_theme_color(Color.ROYAL_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	var rotation_inv_box: Array = [-PI/2, PI, PI/2, 0]
	
	randomize()
	var rand: int = randi() % 2
	
	if rand == 0:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 208.0 / 240.0, 0.3, 1.2, i+1)
			if i == 7:
				bomb.connect("player_body_entered",Callable(self,"pattern_numeric_choice_end"))
			await get_tree().create_timer(0.375).timeout
	else:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_inv_box[i%4]) * 208.0 / 240.0, 0.3, 1.2, i+1)
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
# pattern_numeric_diamond_with_hazard block start
# made by Bae Sekang

const pattern_diamond_with_hazard_playing_time = 3.0

func pattern_diamond_with_hazard():
	PlayingFieldInterface.set_theme_color(Color.NAVY_BLUE)
	
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
	PlayingFieldInterface.set_theme_color(Color.STEEL_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var angle_offset: float = PlayingFieldInterface.get_player_position().angle()
	for i in range(1, 9):
		if i % 3 != 0:
			create_numeric_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0), 208 * sin(angle_offset + i * PI/4.0)), 0.4, 1.6, i)
			if pattern_count > 16:
				create_hazard_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0+PI), 208 * sin(angle_offset + i * PI/4.0+PI)), 0.4, 1.6)
		else:
			create_hazard_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0), 208 * sin(angle_offset + i * PI/4.0)), 0.4, 1.6)
			create_numeric_bomb(Vector2(208 * cos(angle_offset + i * PI/4.0+PI), 208 * sin(angle_offset + i * PI/4.0+PI)), 0.4, 1.6, i)
		await get_tree().create_timer(0.5).timeout
	var end_bomb: NumericBomb
	create_hazard_bomb(Vector2(208 * cos(angle_offset + 9 * PI/4.0), 208 * sin(angle_offset + 9 * PI/4.0)), 0.4, 1.6)
	end_bomb = create_numeric_bomb(Vector2(208 * cos(angle_offset + 9 * PI/4.0+PI), 208 * sin(angle_offset + 9 * PI/4.0+PI)), 0.4, 1.6, 9)
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
	PlayingFieldInterface.set_theme_color(Color.MIDNIGHT_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var player_angle2: float = player_position.angle() * -1
	var bomb_radius = 72
	
	pattern_colosseum_bomb_count = 6
	for i in range(0,12):
		if i%2==0:
			var bomb: NormalBomb = create_normal_bomb(Vector2(1.5*bomb_radius*cos(player_angle+i*PI/6),1.5*bomb_radius*sin(player_angle+i*PI/6)), 0.5, 2.5)
			bomb.connect("player_body_entered", Callable(self,"pattern_colosseum_end"))
		else:
			create_hazard_bomb(Vector2(2.1*bomb_radius*cos(player_angle+i*PI/6),2.1*bomb_radius*sin(player_angle+i*PI/6)), 0.5, 2.5)
	
func pattern_colosseum_end():
	pattern_colosseum_bomb_count -= 1
	if pattern_colosseum_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_colosseum_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()
	
# pattern_colosseum block end
###############################
