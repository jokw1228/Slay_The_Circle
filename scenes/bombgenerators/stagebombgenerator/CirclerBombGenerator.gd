extends BombGenerator
class_name CirclerBombGenerator

var pattern_start_time: float
var prev_timescale: float = Engine.time_scale

var stage_phase: int = -1
const stage_phase_length = 25.0
var pattern_queue: PatternPriorityQueue
var pattern_weight: Dictionary = {}

func _ready():
	randomize()
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_PURPLE)
	PlayingFieldInterface.set_theme_bright(0)
	
	pattern_queue = PatternPriorityQueue.create()
	set_pattern_weight()
	await get_tree().create_timer(1.5).timeout # game start time offset
	pattern_shuffle_and_draw()

func set_pattern_weight():
	pattern_weight = {
		"pattern_diamond_with_hazard_puzzled" = 1.0,
		"pattern_maze" = 1.0,
		"pattern_narrow_road" = 1.0,
		"pattern_blocking" = 1.0,
		"pattern_scattered_hazards" = 1.0,
		
		"pattern_hide_in_hazard" = 2.0,
		"pattern_wall_timing" = 2.0,
		"pattern_random_shape" = 2.0,
		"pattern_pizza" = 2.0,
		
		"pattern_hazard_at_player_pos" = 3.0,
		"pattern_321_go" = 3.0,
		"pattern_reactspeed_test" = 3.0,
		
		"pattern_timing" = 3.0,
		"pattern_trafficlight" = 3.0
	}

func pattern_shuffle_and_draw():
	var current_time: float = PlayingFieldInterface.get_playing_time()
	if (stage_phase + 1) * stage_phase_length < current_time:
		stage_phase += 1
		choose_level_up_pattern()
	else:
		choose_random_pattern()

func choose_random_pattern():
	var popped: Dictionary = pattern_queue.heap_extract_min()
	Callable(self, popped["pattern_key"]).call()
	pattern_queue.min_heap_insert( \
	{
		"pattern_key" = popped["pattern_key"],
		"pattern_value" = popped["pattern_value"] + pattern_weight[popped["pattern_key"]] + randf_range(-0.25*pattern_weight[popped["pattern_key"]], 0.25*pattern_weight[popped["pattern_key"]])
	}
	)

func choose_level_up_pattern():
	if stage_phase == 0:
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_diamond_with_hazard_puzzled", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_maze", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_narrow_road", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_blocking", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_scattered_hazards", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_shuffle_and_draw() # no level up pattern
	elif stage_phase == 1:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_hide_in_hazard", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_wall_timing", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_random_shape", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_pizza", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_level_up_phase_1()
	elif stage_phase == 2:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_hazard_at_player_pos", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_321_go", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_reactspeed_test", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_level_up_phase_2()
	elif stage_phase == 3:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_timing", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_trafficlight", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_level_up_phase_3()
	elif stage_phase == 4:
		# no pattern addition
		pattern_level_up_phase_4()
	elif stage_phase >= 5:
		# no pattern addition
		pattern_level_up_phase_5() # infinitely repeated





##############################################################
# level up block start
##############################################################

###############################
# pattern_level_up_phase_1 start
# Game Speed Up

const pattern_level_up_phase_1_playing_time = 2.5

func pattern_level_up_phase_1():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var bomb: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.10)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5).timeout # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_1_playing_time / prev_timescale)
	pattern_shuffle_and_draw()
	

# pattern_level_up_phase_1 end
###############################

###############################
# pattern_level_up_phase_2 start
# Rotation Speed Up

const pattern_level_up_phase_2_playing_time = 2.5

func pattern_level_up_phase_2():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.4)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5).timeout # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_2_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_2 end
###############################

###############################
# pattern_level_up_phase_3 start
# Game Speed Up + Rotation Inversion

const pattern_level_up_phase_3_playing_time = 2.5

func pattern_level_up_phase_3():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	const dist = 96
	var bomb1: GameSpeedUpBomb = create_gamespeedup_bomb(dist * player_direction, 0.25, 1.75, 0.10)
	var bomb2: RotationInversionBomb = create_rotationinversion_bomb(-dist * player_direction, 0.25, 1.75)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	await link.both_bombs_removed
	await PlayingFieldInterface.player_grounded
	await get_tree().create_timer(0.5).timeout # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_3_playing_time / prev_timescale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_3 end
###############################

###############################
# pattern_level_up_phase_4 start
# Game Speed Up + Rotation Inversion + Rotation Speed Up

const pattern_level_up_phase_4_playing_time = 2.5

func pattern_level_up_phase_4():
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	PlayingFieldInterface.set_theme_bright(1)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	prev_timescale = Engine.time_scale
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	const dist = 160
	create_rotationspeedup_bomb(Vector2.ZERO, 0.25, 1.75, 0.2)
	var bomb1: GameSpeedUpBomb = create_gamespeedup_bomb(dist * player_direction, 0.25, 1.75, 0.05)
	var bomb2: RotationInversionBomb = create_rotationinversion_bomb(-dist * player_direction, 0.25, 1.75)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	await link.both_bombs_removed
	await PlayingFieldInterface.player_grounded
	await get_tree().create_timer(0.5).timeout # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_4_playing_time / prev_timescale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_4 end
###############################

###############################
# pattern_level_up_phase_5 start
# Rotation Inversion (infinitely repeated)

const pattern_level_up_phase_5_playing_time = 2.0

func pattern_level_up_phase_5():
	PlayingFieldInterface.set_theme_color(Color.BLACK)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb: RotationInversionBomb = create_rotationinversion_bomb(Vector2.ZERO, 0.25, 1.25)
	
	await bomb.tree_exited
	await get_tree().create_timer(0.5).timeout # rest time
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_level_up_phase_5_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_level_up_phase_5 end
###############################

##############################################################
# level up block end
##############################################################





##############################################################
# stage phase 0 block start
##############################################################

###############################
# pattern_numeric_diamond_with_hazard_puzzled block start
# made by Bae Sekang

const pattern_diamond_with_hazard_puzzled_playing_time = 3.5

func pattern_diamond_with_hazard_puzzled():
	PlayingFieldInterface.set_theme_color(Color.PLUM)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 3.25
	
	const bomb_position_length = 128
	var bomb_position: Vector2 = bomb_position_length * PlayingFieldInterface.get_player_position().normalized().rotated(PI/4)
	
	create_hazard_bomb(Vector2.ZERO, warning_time, bomb_time)
	
	create_numeric_bomb(bomb_position, warning_time, bomb_time, 1)
	bomb_position = bomb_position.rotated(PI/2)
	create_numeric_bomb(bomb_position, warning_time, bomb_time, 3)
	bomb_position = bomb_position.rotated(PI/2)
	create_numeric_bomb(bomb_position, warning_time, bomb_time, 2)
	bomb_position = bomb_position.rotated(PI/2)
	var bomb_end: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 4)
	bomb_end.connect("no_lower_value_bomb_exists", Callable(self, "pattern_diamond_with_hazard_puzzled_end"))

func pattern_diamond_with_hazard_puzzled_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_diamond_with_hazard_puzzled_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard_puzzled block end
###############################

###############################
# pattern_maze block start
# made by jinhyun

const pattern_maze_playing_time = 2.5

func pattern_maze():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.1
	const bomb_time = 2.4
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_mul: Vector2 =  player_position * 0.35
	var magnitude: float = player_mul.length()
	var perpendicular = Vector2(-player_mul.y / magnitude, player_mul.x / magnitude)
	
	for i in range(4):
		create_hazard_bomb(player_mul + perpendicular * (i-3.0) * 64, warning_time, bomb_time)
		create_hazard_bomb(-(player_mul + perpendicular * (i-3.0) * 64), warning_time, bomb_time)
	
	# HYPER MODE
	if stage_phase >= 4:
		create_hazard_bomb(player_mul + perpendicular * (1) * 64, warning_time, bomb_time)
		create_hazard_bomb(-(player_mul + perpendicular * (1) * 64), warning_time, bomb_time)
	
	var bomb = create_normal_bomb(-player_position * (256-32) / (256-16), warning_time, bomb_time)
	bomb.connect("player_body_entered", Callable(self, "pattern_maze_end"))

func pattern_maze_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_maze_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_maze end
###############################

###############################
# pattern_narrow_road block start
# made by Bae Sekang

const pattern_narrow_road_playing_time = 3.25

func pattern_narrow_road():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.1
	const bomb_time = 3.15
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	const bomb_diameter: float = 64.0
	
	var end_bomb: NumericBomb
	for i: int in range(5):
		end_bomb = create_numeric_bomb((bomb_diameter * (i-2)) * player_direction, warning_time, bomb_time, i+1)
	end_bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_narrow_road_end"))
	
	const hazard_bomb_clearance: float = bomb_diameter + 16
	for i: int in range(3):
		create_hazard_bomb((bomb_diameter * (i-1)) * player_direction + hazard_bomb_clearance * player_direction.rotated(PI/2), warning_time, bomb_time)
		create_hazard_bomb((bomb_diameter * (i-1)) * player_direction + hazard_bomb_clearance * player_direction.rotated(-PI/2), warning_time, bomb_time)
	
	# HYPER MODE
	if stage_phase >= 4:
		var coef: float = 1.0 if randi() % 2 else -1.0
		for i: float in range(2):
			create_hazard_bomb(((i+1) * bomb_diameter + hazard_bomb_clearance) * player_direction.rotated(coef*PI/2), warning_time, bomb_time)

func pattern_narrow_road_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_narrow_road_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_narrow_road block end
###############################

###############################
# pattern_blocking block start
# made by jinhyun

const pattern_blocking_playing_time = 3.0

func pattern_blocking():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	const warning_time = 0.1
	const bomb_time = 2.9
	
	for i in range(9):
		create_hazard_bomb(player_position.rotated((i-4)*PI/8) * 0.6, warning_time, bomb_time)
	
	var bomb1 = create_normal_bomb(player_position.rotated(3.0*PI/4.0) * 0.6, warning_time, bomb_time)
	var bomb2 = create_normal_bomb(player_position.rotated(-3.0*PI/4.0) * 0.6, warning_time, bomb_time)
	var link = create_bomb_link(bomb1, bomb2)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_blocking_end"))

func pattern_blocking_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_blocking_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_blocking end
###############################

###############################
# pattern_scattered_hazards start
# made by Jaeyong
const pattern_scattered_hazards_playing_time = 3.5
var pattern_scattered_hazards_bomb_count: int

func pattern_scattered_hazards():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 3.25
	
	var left_bomb = 3
	pattern_scattered_hazards_bomb_count = 3
	
	var player_pos_normalized = PlayingFieldInterface.get_player_position().normalized()
	
	for i in (6):
		create_hazard_bomb(player_pos_normalized.rotated(PI/3 * i).rotated(PI/6) * (256 - 32) , warning_time, bomb_time)
	
	var rotation_offset: float = randf_range(0, PI*2/3)
	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(player_pos_normalized.rotated(PI/3 * i * 2).rotated(rotation_offset) * 64 , warning_time, bomb_time)
		bomb.connect("player_body_entered", Callable(self, "pattern_scattered_hazards_end"))
	
func pattern_scattered_hazards_end():
	pattern_scattered_hazards_bomb_count -= 1
	if pattern_scattered_hazards_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_scattered_hazards_playing_time / Engine.time_scale)
		pattern_shuffle_and_draw()

# pattern_scattered_hazards block end
###############################

##############################################################
# stage phase 0 block end
##############################################################





##############################################################
# stage phase 1 block start
##############################################################

###############################
# pattern_hide_in_hazard block start
# made by seokhee

#위험하다고 피하는 건 좋지 않아요
#circle 정도의 쉬?운 난이도

const pattern_hide_in_hazard_playing_time = 5.0
# 3 * (hazard_bomb_time + hazard_warning_time) + hazard_warning_time
var pattern_hide_in_hazard_is_playing: bool

func pattern_hide_in_hazard():
	PlayingFieldInterface.set_theme_color(Color.DARK_VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	pattern_hide_in_hazard_is_playing = true
	
	const hazard_warning_time = 1.0
	const hazard_bomb_time = 0.5
	const bomb_time = 3 * (hazard_bomb_time + hazard_warning_time)
	
	const CIRCLE_FIELD_RADIUS = 256
	const bomb_position_length: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var bomb_position: Vector2 = bomb_position_length * PlayingFieldInterface.get_player_position().normalized()
	var ccw: float = 1 if randi() % 2 else -1
	var bomb_position_rotation_amount: float = PI/3 * ccw
	
	# HYPER MODE
	if stage_phase >= 4:
		if ccw == 1:
			bomb_position = bomb_position.rotated(PI/3)
		elif ccw == -1:
			bomb_position = bomb_position.rotated(-PI/3)
	
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount / 2)
	var bomb1: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 1)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb2: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 2)
	
	create_bomb_link(bomb1, bomb2)
	
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb3: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 3)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb4: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb5: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 5)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb6: NumericBomb = create_numeric_bomb(bomb_position, hazard_warning_time, bomb_time, 6)
	bomb6.connect("no_lower_value_bomb_exists", Callable(self, "pattern_hide_in_hazard_end"))
	
	create_bomb_link(bomb5, bomb6)
	
	const hazard_position_length = bomb_position_length * cos(PI/6)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var hazard_position: Vector2 = hazard_position_length * bomb_position.normalized().rotated(PI/6 * ccw)
	for i: int in range(3):
		if pattern_hide_in_hazard_is_playing == false:
			break
		for j: int in range(3):
			create_hazard_bomb(hazard_position, hazard_warning_time, hazard_bomb_time)
			hazard_position = hazard_position.rotated(2*PI/3)
		await get_tree().create_timer(hazard_warning_time + hazard_bomb_time).timeout

func pattern_hide_in_hazard_end():
	pattern_hide_in_hazard_is_playing = false
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_hide_in_hazard_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
#pattern_hide_in_hazard block end
###############################

###############################
# pattern_wall_timing start
# made by Jaeyong

const pattern_wall_timing_playing_time = 3.0
var pattern_wall_timing_bomb_count: int
var pattern_wall_timing_pos_nor: Vector2
var pattern_wall_timing_angle: float
const pattern_wall_timing_bomb_dist = 136

func pattern_wall_timing():
	PlayingFieldInterface.set_theme_color(Color.WEB_PURPLE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.75
	
	pattern_wall_timing_bomb_count = 4
	pattern_wall_timing_pos_nor = PlayingFieldInterface.get_player_position().normalized()
	pattern_wall_timing_angle = pattern_wall_timing_pos_nor.angle()

	var bomb1 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI /4), warning_time, bomb_time)
	bomb1.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	var bomb2 = create_normal_bomb(pattern_wall_timing_auto_rotate(3 * PI / 2 + PI/4), warning_time, bomb_time)
	bomb2.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	create_bomb_link(bomb1, bomb2)
		
	var bomb3 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI + PI/4), warning_time, bomb_time)
	bomb3.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	var bomb4 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI/2 + PI/4), warning_time, bomb_time)
	bomb4.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	create_bomb_link(bomb3, bomb4)
	
	const hazard_warning_time = 0.75
	const hazard_bomb_time = 0.25
	
	create_hazard_bomb(Vector2.ZERO, hazard_warning_time, hazard_bomb_time)
	for i: float in [1,2,3]:
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * i/4, hazard_warning_time, hazard_bomb_time)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * -i/4, hazard_warning_time, hazard_bomb_time)
	
	await get_tree().create_timer(hazard_warning_time + hazard_bomb_time).timeout
	
	create_hazard_bomb(Vector2.ZERO, hazard_warning_time, hazard_bomb_time)
	for i: float in [1,2,3]:
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * i/4, hazard_warning_time, hazard_bomb_time)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * -i/4, hazard_warning_time, hazard_bomb_time)
	
	await get_tree().create_timer(hazard_warning_time + hazard_bomb_time).timeout
	
	create_hazard_bomb(Vector2.ZERO, hazard_warning_time, hazard_bomb_time)
	for i: float in [1,2,3]:
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * i/4, hazard_warning_time, hazard_bomb_time)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * (256) * -i/4, hazard_warning_time, hazard_bomb_time)

func pattern_wall_timing_end():
	pattern_wall_timing_bomb_count -= 1
	if pattern_wall_timing_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_wall_timing_playing_time / Engine.time_scale)
		pattern_shuffle_and_draw()

func pattern_wall_timing_auto_rotate(angle):
	return Vector2(pattern_wall_timing_bomb_dist*cos(pattern_wall_timing_angle+angle),pattern_wall_timing_bomb_dist*sin(pattern_wall_timing_angle+angle))
	
# pattern_wall_timing block end
###############################

###############################
# pattern_random_shape block start
# made by kiyong

func pattern_random_shape():
	PlayingFieldInterface.set_theme_color(Color.REBECCA_PURPLE)
	
	const pattern_time = 1.2
	
	await Utils.timer(0.3)
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	var randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(1, randomrotation)
	await Utils.timer(pattern_time)
	
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(3, randomrotation)
	await Utils.timer(pattern_time)
	
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(2, randomrotation)
	await Utils.timer(pattern_time)
	
	pattern_shuffle_and_draw()

func pattern_random_shape_random(pattern: int, randomrotation: float):
	const pattern_time = 1
	match pattern:
		0: # cross
			for i in range(1, 4):
				create_hazard_bomb(Vector2(256/3*i,0).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(-256/3*i,0).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,256/3*i).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,-256/3*i).rotated(randomrotation), pattern_time, 0.1)
		#1: # outer circle
		#	var rotation_value = 0
		#	for i in range(16):
		#		create_hazard_bomb(Vector2(256*sin(rotation_value), 256*cos(rotation_value)), 1, 0.05)
		#		rotation_value += PI / 8
		1: # x
			for i in range(1, 4):
				create_hazard_bomb(Vector2(256/3*i,0).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(-256/3*i,0).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,256/3*i).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,-256/3*i).rotated(randomrotation+PI/4), pattern_time, 0.1)
		2: # *
			pattern_random_shape_random(0, randomrotation)
			pattern_random_shape_random(1, randomrotation)
		#3: # diamond
		#	var x = [150,75,75,0,0,-75,-75,-150]
		#	var y = [0,75,-75,150,-150,75,-75,0]
		#	for i in range(8):
		#		create_hazard_bomb(Vector2(x[i],y[i]).rotated(randomrotation), pattern_time, 0.1)
		3: # star
			var rotation_value = 0
			const inner_pentagon = 256 * tan(PI*3/20) / (tan(PI*1/5) + tan(PI*3/20)) / cos(PI/10)
			const outer_pentagon = sqrt(pow(256 - (256 * tan(PI*1/5) / (tan(PI*1/5) + tan(PI*3/20))) / 2, 2) + pow((inner_pentagon * sin(PI/10) / 2), 2))
			const outer_pentagon_angle = asin((inner_pentagon * sin(PI/10) / 2) / outer_pentagon)
			for i in range(5):
				create_hazard_bomb(Vector2(256*sin(rotation_value), 256*cos(rotation_value)).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(outer_pentagon*sin(rotation_value+outer_pentagon_angle), outer_pentagon*cos(rotation_value+outer_pentagon_angle)).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(outer_pentagon*sin(rotation_value-outer_pentagon_angle), outer_pentagon*cos(rotation_value-outer_pentagon_angle)).rotated(randomrotation), pattern_time, 0.1)
				rotation_value += PI / 2.5
			rotation_value = PI / 5
			for i in range(5):
				create_hazard_bomb(Vector2(90*sin(rotation_value), 90*cos(rotation_value)).rotated(randomrotation), pattern_time, 0.1)
				rotation_value += PI / 2.5

# pattern_random_shape block end
###############################

###############################
# pattern_pizza block start
# made by Bae Sekang

const pattern_pizza_playing_time = 3.5

func pattern_pizza():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const normal_bomb_time = 2.0
	const slayable_time = 0.75
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	const hazard_bomb_distance = 64
	const normal_bomb_distance = 220
	
	var center_bomb: Bomb
	# HYPER MODE
	if stage_phase >= 4:
		center_bomb = create_rotationinversion_bomb(Vector2(0, 0), warning_time, normal_bomb_time + slayable_time)
	else:
		center_bomb = create_normal_bomb(Vector2(0, 0), warning_time, normal_bomb_time + slayable_time)
	
	for i in range(6):
		create_hazard_bomb(hazard_bomb_distance * player_direction, warning_time, normal_bomb_time)
		player_direction = player_direction.rotated(PI/3)
	
	for i in range(1, 25):
		create_normal_bomb(normal_bomb_distance * player_direction, warning_time, normal_bomb_time)
		player_direction = player_direction.rotated(PI/12)
	
	await Utils.timer(1.0) # Player can't slay the center bomb at first!!
	center_bomb.connect("player_body_entered",Callable(self,"pattern_pizza_end"))

func pattern_pizza_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_pizza_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_pizza block end
###############################

##############################################################
# stage phase 1 block end
##############################################################





##############################################################
# stage phase 2 block start
##############################################################

###############################
# pattern_hazard_at_player_pos block start
# made by Lee Jinwoong

const pattern_hazard_at_player_pos_playing_time = 4.75

func pattern_hazard_at_player_pos():
	PlayingFieldInterface.set_theme_color(Color.RED)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb_position: Vector2
	
	for i in range(0, 5):
		const CIRCLE_FIELD_RADIUS = 256
		const bomb_radius = 32
		const rotation_offset = PI/12
		
		bomb_position = (CIRCLE_FIELD_RADIUS - bomb_radius) * PlayingFieldInterface.get_player_position().normalized()
		create_hazard_bomb(bomb_position, 0.75, 1.0)
		create_hazard_bomb(bomb_position.rotated(rotation_offset), 0.75, 1.0)
		create_hazard_bomb(bomb_position.rotated(-rotation_offset), 0.75, 1.0)
		
		# HYPER MODE
		if stage_phase >= 4:
			create_hazard_bomb(-bomb_position, 0.75, 1.0)
			create_hazard_bomb(-bomb_position.rotated(rotation_offset), 0.75, 1.0)
			create_hazard_bomb(-bomb_position.rotated(-rotation_offset), 0.75, 1.0)
		
		await Utils.timer(0.75)
	
	await Utils.timer(1.0)
	
	pattern_hazard_at_player_pos_end()

func pattern_hazard_at_player_pos_end():
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_hazard_at_player_pos_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_hazard_at_player_pos block end
###############################

###############################
# pattern_321_go block start
# made by Lee Jinwoong

func pattern_321_go():
	PlayingFieldInterface.set_theme_color(Color.CRIMSON)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	const hazard_warning_time = 0.5
	const delta_time: float = 0.75
	const time_offset: float = 0.2
	const dist: float = 208.0 / 240.0
	
	create_hazard_bomb(player_position * -dist,   hazard_warning_time,   delta_time * 4 - time_offset)
	create_hazard_bomb(player_position * -0.5,   hazard_warning_time,   delta_time - time_offset / 2.0)
	create_hazard_bomb(Vector2.ZERO,   hazard_warning_time,   delta_time * 2 - time_offset / 2.0)
	create_hazard_bomb(player_position * 0.5,   hazard_warning_time,   delta_time * 3 - time_offset / 2.0)
	for i in range(1, 8):
		if i % 2 == 0:
			create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 0.5,   hazard_warning_time,   delta_time * 4)
		create_hazard_bomb(player_position.rotated(i * PI / 8.0) * dist,   hazard_warning_time,   delta_time * 4)
	for i in range(9, 16):
		if i % 2 == 0:
			create_hazard_bomb(player_position.rotated(i * PI / 8.0) * 0.5,   hazard_warning_time,   delta_time * 4)
		create_hazard_bomb(player_position.rotated(i * PI / 8.0) * dist,   hazard_warning_time,   delta_time * 4)
	await Utils.timer(hazard_warning_time)
	
	var last: HazardBomb = create_hazard_bomb(player_position * dist,   delta_time * 4,   time_offset)
	await Utils.timer(delta_time - time_offset / 2.0)
	
	create_numeric_bomb(player_position * -0.5,   0,   delta_time * 4,   3)
	await Utils.timer(delta_time)
	create_numeric_bomb(Vector2.ZERO,   0,   delta_time * 3,   2)
	await Utils.timer(delta_time)
	create_numeric_bomb(player_position * 0.5,   0,   delta_time * 2,   1)
	await Utils.timer(delta_time + time_offset * 3.0 / 2.0)
	
	pattern_321_go_end()

func pattern_321_go_end():
	pattern_shuffle_and_draw()

# pattern_321_go block end
###############################

###############################
# pattern_reactspeed_test block start
# made by seokhee

#반응속도 테스트
#핸드폰으로 하면 circler 정도일듯 

#const pattern_reactspeed_test_playing_time = 5

func pattern_reactspeed_test():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	PlayingFieldInterface.set_theme_color(Color.DARK_MAGENTA)
	
	var indicator: Indicator = Indicator.create()
	add_child(indicator)
	
	await Utils.timer(0.5)
	for i in range(6):
		randomize()
		var which_bomb_decide_num: int = 1 if randi() % 3 else -1
		if which_bomb_decide_num == 1:
			var bomb : NormalBomb = create_normal_bomb(Vector2(0,0), 0.2, 0.8)
		else:
			var bomb : HazardBomb = create_hazard_bomb(Vector2(0,0), 0.2, 0.8)
		await Utils.timer(1.0)
	
	indicator.queue_free()
	await get_tree().create_timer(0.3)
	pattern_shuffle_and_draw()
	
#pattern_reactspeed_test block end
###############################

##############################################################
# stage phase 2 block end
##############################################################





##############################################################
# stage phase 3 block start
##############################################################

###############################
# pattern_timing block start
# made by Seonghyeon
const pattern_timing_playing_time = 2.75

func pattern_timing():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.75
	const bomb_time = 1.0
	const slayable_time = 1.0
	
	const SIZE = 96
	var randomness: float = randf_range(0, 60)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 60)), warning_time, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 120)), warning_time, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 240)), warning_time, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 300)), warning_time, 10)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 0)), warning_time, bomb_time)
	create_hazard_bomb(SIZE * Vector2.LEFT.rotated(deg_to_rad(randomness + 180)), warning_time, bomb_time)
	var bomb: NormalBomb = create_normal_bomb(Vector2.ZERO, warning_time, bomb_time + slayable_time)
	bomb.connect("player_body_entered", Callable(self, "pattern_timing_end"))

func pattern_timing_end():
	await PlayingFieldInterface.player_grounded
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	PlayingFieldInterface.set_playing_time(pattern_start_time + pattern_timing_playing_time / Engine.time_scale)
	pattern_shuffle_and_draw()
# pattern_timing block end
###############################

###############################
# pattern_trafficlight block start
# made by Seonghyeon
func pattern_trafficlight():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)

	const DIST: float = 96
	const UNIT: float = 0.75
	const START: float = 0.5
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

##############################################################
# stage phase 3 block end
##############################################################
