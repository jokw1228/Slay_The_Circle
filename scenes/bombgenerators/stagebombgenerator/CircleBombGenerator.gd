extends BombGenerator
class_name CircleBombGenerator

var pattern_start_time: float
var prev_timescale: float = Engine.time_scale

var stage_phase: int = 0
const stage_phase_length = 15.0
var pattern_dict: Dictionary = {}

func _ready():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	PlayingFieldInterface.set_theme_bright(0)
	
	pattern_list_initialization()
	await get_tree().create_timer(1.0).timeout # game start time offset
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_dict = {
		"pattern_numeric_center_then_link" = 2.0,
		"pattern_numeric_triangle_with_link" = 2.0,
		"pattern_star" = 2.0,
		"pattern_random_link" = 2.0,
		"pattern_diamond" = 2.0
	}
'''
phase 0

"pattern_numeric_center_then_link" = 2.0,
"pattern_numeric_triangle_with_link" = 2.0,
"pattern_star" = 2.0,
"pattern_random_link" = 2.0,
"pattern_diamond" = 2.0

phase 1

"pattern_roll" = 1.0,
"pattern_colosseum" = 1.0,
"pattern_diamond_with_hazard" = 1.0,
"pattern_spiral" = 1.0

phase 2

"pattern_369" = 1.0,
"pattern_numeric_choice" = 1.0,
"pattern_twisted_numeric" = 1.0

phase 3

"pattern_numeric_inversion" = 3.0
'''

func pattern_shuffle_and_draw():
	var current_time: float = PlayingFieldInterface.get_playing_time()
	if (stage_phase + 1) * stage_phase_length > current_time:
		choose_random_pattern()
	else:
		choose_level_up_pattern()
		stage_phase += 1

func choose_random_pattern():
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

func choose_level_up_pattern():
	if stage_phase == 0:
		var pattern_dict_to_merge: Dictionary = {
			"pattern_roll" = 1.0,
			"pattern_colosseum" = 1.0,
			"pattern_diamond_with_hazard" = 1.0,
			"pattern_spiral" = 1.0
		}
		pattern_dict.merge(pattern_dict_to_merge)
		pattern_level_up_phase_0()
	elif stage_phase == 1:
		var pattern_dict_to_merge: Dictionary = {
			"pattern_369" = 1.0,
			"pattern_numeric_choice" = 1.0,
			"pattern_twisted_numeric" = 1.0
		}
		pattern_dict.merge(pattern_dict_to_merge)
		pattern_level_up_phase_1()
	elif stage_phase == 2:
		var pattern_dict_to_merge: Dictionary = {
			"pattern_numeric_inversion" = 3.0
		}
		pattern_dict.merge(pattern_dict_to_merge)
		pattern_level_up_phase_2()
	elif stage_phase == 3:
		pattern_level_up_phase_3()
	elif stage_phase >= 4:
		pattern_level_up_phase_4() # infinitely repeated

##############################################################
# level up block start
##############################################################

###############################
# pattern_level_up_phase_0 start
# Game Speed Up

const pattern_level_up_phase_0_playing_time = 2.5

func pattern_level_up_phase_0():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var bomb: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.1)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5) # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_0_playing_time / prev_timescale)
	pattern_shuffle_and_draw()
	

# pattern_level_up_phase_0 end
###############################

###############################
# pattern_level_up_phase_1 start
# Rotation Speed Up

const pattern_level_up_phase_1_playing_time = 2.5

func pattern_level_up_phase_1():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.2)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5) # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_1_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_1 end
###############################

###############################
# pattern_level_up_phase_2 start
# Game Speed Up + Rotation Inversion

const pattern_level_up_phase_2_playing_time = 2.5

func pattern_level_up_phase_2():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var player_angle: float = PlayingFieldInterface.get_player_position().angle()
	const dist = 96
	var bomb1: GameSpeedUpBomb = create_gamespeedup_bomb(dist * Vector2(cos(player_angle), sin(player_angle)), 0.25, 1.75, 0.1)
	var bomb2: RotationInversionBomb = create_rotationinversion_bomb(-dist * Vector2(cos(player_angle), sin(player_angle)), 0.25, 1.75)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	await link.both_bombs_removed
	await PlayingFieldInterface.player_grounded
	await get_tree().create_timer(0.5) # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_2_playing_time / prev_timescale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_2 end
###############################

###############################
# pattern_level_up_phase_3 start
# Game Speed Up + Rotation Inversion + Rotation Speed Up

const pattern_level_up_phase_3_playing_time = 2.5

func pattern_level_up_phase_3():
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	PlayingFieldInterface.set_theme_bright(1)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var player_angle: float = PlayingFieldInterface.get_player_position().angle()
	const dist = 160
	create_rotationspeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.2)
	var bomb1: GameSpeedUpBomb = create_gamespeedup_bomb(dist * Vector2(cos(player_angle), sin(player_angle)), 0.25, 1.75, 0.1)
	var bomb2: RotationInversionBomb = create_rotationinversion_bomb(-dist * Vector2(cos(player_angle), sin(player_angle)), 0.25, 1.75)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	await link.both_bombs_removed
	await PlayingFieldInterface.player_grounded
	await get_tree().create_timer(0.5) # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_3_playing_time / prev_timescale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_3 end
###############################

###############################
# pattern_level_up_phase_4 start
# Rotation Inversion (infinitely repeated)

const pattern_level_up_phase_4_playing_time = 2.5

func pattern_level_up_phase_4():
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb: RotationInversionBomb = create_rotationinversion_bomb(Vector2.ZERO, 0.25, 1.75)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5) # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_4_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_4 end

##############################################################
# level up block end
##############################################################





##############################################################
# stage phase 0 block start
##############################################################

###############################
# pattern_numeric_center_then_link block start
# made by Lee Jinwoong

const pattern_numeric_center_then_link_playing_time = 2.5

func pattern_numeric_center_then_link():
	PlayingFieldInterface.set_theme_color(Color.AQUA)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	create_numeric_bomb(Vector2.ZERO, 0.25, 2.25, 1)
	var bomb1: NumericBomb = create_numeric_bomb(player_position * -0.5, 0.25, 2.25, 2)
	var bomb2: NumericBomb = create_numeric_bomb(player_position * 0.5, 0.25, 2.25, 3)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	if stage_phase >= 4:
		create_hazard_bomb(player_position.rotated(PI / 2.0) * 208.0 / 240.0, 0.25, 2.25)
		create_hazard_bomb(player_position.rotated(PI / -2.0) * 208.0 / 240.0, 0.25, 2.25)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_numeric_center_then_link_end"))

func pattern_numeric_center_then_link_end():
	await PlayingFieldInterface.player_grounded
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_center_then_link_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_numeric_center_then_link block end
###############################

###############################
# pattern_numeric_triangle_with_link block start
# made by Jo Kangwoo

const pattern_numeric_tirangle_with_link_playing_time = 2.5

func pattern_numeric_triangle_with_link():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_offset: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var ccw: float = 1 if randi() % 2 else -1
	
	if stage_phase >= 4:
		angle_offset += PI / -3.0 if ccw == 1 else PI / 3.0
		
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 0.25, 2.25, 1)
	var bomb2: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 0.25, 2.25, 2)
	
	var link1: BombLink = create_bomb_link(bomb1, bomb2)
	link1.add_child(Indicator.create(Vector2(CIRCLE_FIELD_RADIUS * cos(angle_offset + ccw * 2*PI/3), CIRCLE_FIELD_RADIUS * -sin(angle_offset + ccw * 2*PI/3)), 32))
	
	var bomb3: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 0.25, 2.25, 3)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 0.25, 2.25, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 0.25, 2.25, 5)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 0.25, 2.25, 6)
	
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
const pattern_star_playing_time = 2.5

func pattern_star():
	PlayingFieldInterface.set_theme_color(Color.CORNFLOWER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 208
	
	create_numeric_bomb(Vector2(bomb_radius * cos(player_angle),bomb_radius*sin(player_angle)), 0.25, 2.25, 1)
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+4*PI/5),bomb_radius*sin(player_angle+4*PI/5)), 0.25, 2.25, 2)
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+8*PI/5),bomb_radius*sin(player_angle+8*PI/5)), 0.25, 2.25, 3)
	create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+2*PI/5),bomb_radius*sin(player_angle+2*PI/5)), 0.25, 2.25, 4)
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(bomb_radius*cos(player_angle+6*PI/5),bomb_radius*sin(player_angle+6*PI/5)), 0.25, 2.25, 5)

	bomb5.connect("no_lower_value_bomb_exists",Callable(self,"pattern_star_end"))

func pattern_star_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_star_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
#pattern_star end
###############################

###############################
# pattern_random_link block start
# made by kiyong

const pattern_random_link_playing_time = 2.5

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
	
	bombs.append(create_numeric_bomb(vector[0], 0.25, 2.25, 1))
	bombs.append(create_numeric_bomb(vector[order[0]], 0.25, 2.25, 2))
	bombs.append(create_numeric_bomb(vector[order[1]], 0.25, 2.25, 3))
	bombs.append(create_numeric_bomb(vector[order[2]], 0.25, 2.25, 4))
	create_bomb_link(bombs[0], bombs[1])
	create_bomb_link(bombs[2], bombs[3])
	
	bombs[3].connect("no_lower_value_bomb_exists",Callable(self,"pattern_random_link_end"))

func pattern_random_link_auto_rotate(angle):
	return Vector2(pattern_random_link_bomb_dist*cos(pattern_random_link_player_angle+angle),pattern_random_link_bomb_dist*sin(pattern_random_link_player_angle+angle))

func pattern_random_link_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_random_link_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()

# pattern_random_link block end
###############################

###############################
# pattern_diamond block start
# made by Jaeyong

const pattern_diamond_playing_time = 2.5
var pattern_diamond_bomb_count: int

func pattern_diamond():
	PlayingFieldInterface.set_theme_color(Color.DODGER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_diamond_bomb_count = 4
	var angle_offset: float = randf() if stage_phase >= 4 else PlayingFieldInterface.get_player_position().angle()
	var normal_bomb_list: Array[NormalBomb]
	
	const CIRCLE_FIELD_RADIUS = 256
	
	const normal_radius = CIRCLE_FIELD_RADIUS - 48
	const hazard_radius = CIRCLE_FIELD_RADIUS - 144
	
	for i in range(4):
		var bomb: NormalBomb = create_normal_bomb(Vector2(normal_radius * cos(angle_offset + i * PI/2), normal_radius * sin(angle_offset + i * PI/2)), 0.25, 2.25)
		bomb.connect("player_body_entered", Callable(self, "pattern_diamond_end"))
		create_hazard_bomb(Vector2(hazard_radius * cos(angle_offset + i * PI/2), hazard_radius * sin(angle_offset + i * PI/2)), 0.25, 2.25)

func pattern_diamond_end():
	pattern_diamond_bomb_count -= 1
	if pattern_diamond_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_playing_time / Engine.time_scale))
		pattern_shuffle_and_draw()

# pattern_diamond block end
###############################

##############################################################
# stage phase 0 block end
##############################################################





##############################################################
# stage phase 1 block start
##############################################################

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
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_roll_playing_time / Engine.time_scale))
		pattern_shuffle_and_draw()
	
# pattern_roll block end
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
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_colosseum_playing_time / Engine.time_scale))
		pattern_shuffle_and_draw()
	
# pattern_colosseum block end
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
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_with_hazard_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard block end
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
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_spiral_playing_time / Engine.time_scale))
		pattern_shuffle_and_draw()
	
# pattern_spiral end
###############################

##############################################################
# stage phase 1 block end
##############################################################





##############################################################
# stage phase 2 block start
##############################################################

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
			if stage_phase >= 4:
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
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_369_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
# pattern_369 block end
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
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_choice_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
# pattern_numeric_choice end
###############################

###############################
# pattern_twisted_numeric block start
# made by Jaeyong

const pattern_twisted_numeric_playing_time = 4.0

func pattern_twisted_numeric():
	PlayingFieldInterface.set_theme_color(Color.LIGHT_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var end_bomb: NumericBomb
	
	if stage_phase < 4:
		end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -144.0 / 240.0, 0.75, 3.25 ,4)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 144.0 / 240.0, 0.75, 3.25, 3)
	else:
		end_bomb = create_numeric_bomb(PlayingFieldInterface.get_player_position() * 144.0 / 240.0, 0.75, 3.25 ,4)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -144.0 / 240.0, 0.75, 3.25, 3)
	
	if stage_phase < 4:
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -48.0 / 240.0, 0.75, 3.25, 2)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 48.0 / 240.0, 0.75, 3.25, 1)
	else:
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * 48.0 / 240.0, 0.75, 3.25, 2)
		create_numeric_bomb(PlayingFieldInterface.get_player_position() * -48.0 / 240.0, 0.75, 3.25, 1)
	
	end_bomb.connect("player_body_entered", Callable(self, "pattern_twisted_numeric_end"))

func pattern_twisted_numeric_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_twisted_numeric_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()

# pattern_twisted_numeric block end
###############################

##############################################################
# stage phase 2 block end
##############################################################





##############################################################
# stage phase 3 block start
##############################################################

###############################
# pattern_numeric_inversion block start
# made by Seonghyeon

# this was pattern_manyrotation

const pattern_numeric_inversion_playing_time = 2.5

func pattern_numeric_inversion():
	PlayingFieldInterface.set_theme_color(Color.DARK_TURQUOISE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const DIST: float = 96
	
	var player_normalized: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	
	create_numeric_bomb(DIST * sqrt(3) * player_normalized.rotated(deg_to_rad(60)), 0.25, 2.25, 1)
	var bomb2: NumericBomb = create_numeric_bomb(DIST * player_normalized.rotated(deg_to_rad(120)), 0.25, 2.25, 2)
	var bomb3: RotationInversionBomb = create_rotationinversion_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), 0.25, 2.25)
	var link: BombLink = create_bomb_link(bomb2, bomb3)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_numeric_inversion_end"))

func pattern_numeric_inversion_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_inversion_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()

# pattern_numeric_inversion block end
###############################

##############################################################
# stage phase 3 block end
##############################################################
