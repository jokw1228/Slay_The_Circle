extends BombGenerator
class_name CircleBombGenerator

var pattern_start_time: float
var prev_timescale: float = Engine.time_scale

var stage_phase: int = -1
const stage_phase_length = 25.0
var pattern_queue: PatternPriorityQueue
var pattern_weight: Dictionary = {}

func _ready():
	randomize()
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	PlayingFieldInterface.set_theme_bright(0)
	
	pattern_queue = PatternPriorityQueue.create()
	set_pattern_weight()
	await get_tree().create_timer(1.5).timeout # game start time offset
	pattern_shuffle_and_draw()

func set_pattern_weight():
	pattern_weight = {
		"pattern_numeric_center_then_link" = 1.0,
		"pattern_numeric_triangle_with_link" = 1.0,
		"pattern_star" = 1.0,
		"pattern_random_link" = 1.0,
		"pattern_diamond" = 1.0,
		
		"pattern_twisted_numeric" = 2.0,
		"pattern_numeric_choice" = 2.0,
		"pattern_369" = 2.0,
		
		"pattern_spiral" = 3.0,
		"pattern_roll" = 3.0,
		"pattern_diamond_with_hazard" = 3.0,
		"pattern_colosseum" = 3.0,
		
		"pattern_numeric_inversion" = 1.5
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
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_numeric_center_then_link", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_numeric_triangle_with_link", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_star", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_random_link", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_diamond", "pattern_value" = randf_range(-0.1, 0.0) } )
		pattern_shuffle_and_draw() # no level up pattern
	elif stage_phase == 1:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_twisted_numeric", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_numeric_choice", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_369", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_level_up_phase_1()
	elif stage_phase == 2:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_spiral", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_roll", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_diamond_with_hazard", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_colosseum", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
		pattern_level_up_phase_2()
	elif stage_phase == 3:
		var start_offset: float = pattern_queue.queue[0]["pattern_value"]
		pattern_queue.min_heap_insert( { "pattern_key" = "pattern_numeric_inversion", "pattern_value" = randf_range(-0.1, 0.0) + start_offset } )
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
# pattern_numeric_center_then_link block start
# made by Lee Jinwoong

const pattern_numeric_center_then_link_playing_time = 2.75

func pattern_numeric_center_then_link():
	PlayingFieldInterface.set_theme_color(Color.AQUA)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.5
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	create_numeric_bomb(Vector2.ZERO, 0.25, 2.25, 1)
	var bomb1: NumericBomb = create_numeric_bomb(player_position * -0.5, warning_time, bomb_time, 2)
	var bomb2: NumericBomb = create_numeric_bomb(player_position * 0.5, warning_time, bomb_time, 3)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	# HYPER MODE
	if stage_phase >= 4:
		create_hazard_bomb(player_position.rotated(PI / 2.0) * 208.0 / 240.0, warning_time, bomb_time)
		create_hazard_bomb(player_position.rotated(PI / -2.0) * 208.0 / 240.0, warning_time, bomb_time)
	
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

const pattern_numeric_tirangle_with_link_playing_time = 2.75

func pattern_numeric_triangle_with_link():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.5
	
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
	var bomb1: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 1)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb2: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 2)
	
	create_bomb_link(bomb1, bomb2)
	
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb3: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 3)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb4: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 4)
	
	create_bomb_link(bomb3, bomb4)
	
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb5: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 5)
	bomb_position = bomb_position.rotated(bomb_position_rotation_amount)
	var bomb6: NumericBomb = create_numeric_bomb(bomb_position, warning_time, bomb_time, 6)
	
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
const pattern_star_playing_time = 3.25

func pattern_star():
	PlayingFieldInterface.set_theme_color(Color.CORNFLOWER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 3.0
	
	const distance = 208.0
	var bomb_position: Vector2 = PlayingFieldInterface.get_player_position().normalized() * distance
	
	# HYPER MODE
	if stage_phase >= 4:
		bomb_position = bomb_position.rotated(PI*1/5)
	
	create_numeric_bomb(bomb_position, warning_time, bomb_time, 1)
	create_numeric_bomb(bomb_position.rotated(PI*2/5), warning_time, bomb_time, 4)
	create_numeric_bomb(bomb_position.rotated(PI*4/5), warning_time, bomb_time, 2)
	var bomb_end: NumericBomb = create_numeric_bomb(bomb_position.rotated(PI*6/5), warning_time, bomb_time, 5)
	create_numeric_bomb(bomb_position.rotated(PI*8/5), warning_time, bomb_time, 3)
	
	bomb_end.connect("no_lower_value_bomb_exists",Callable(self,"pattern_star_end"))

func pattern_star_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_star_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
#pattern_star end
###############################

###############################
# pattern_random_link block start
# made by kiyong

const pattern_random_link_playing_time = 2.75

var pattern_random_link_player_position: Vector2
var pattern_random_link_player_angle: float
const pattern_random_link_bomb_dist = 128

func pattern_random_link():
	PlayingFieldInterface.set_theme_color(Color.DARK_CYAN)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.5
	
	pattern_random_link_player_position = PlayingFieldInterface.get_player_position()
	pattern_random_link_player_angle = pattern_random_link_player_position.angle()
	
	var order = [1,2,3]
	order.shuffle()
	var correction = (order[0]-2) * -(acos(sqrt(2)/4)-PI/4)
	
	var vector = [pattern_random_link_auto_rotate(0+correction), pattern_random_link_auto_rotate(PI/2+correction), pattern_random_link_auto_rotate(PI+correction), pattern_random_link_auto_rotate(3*PI/2+correction)]
	var bombs = []
	
	bombs.append(create_numeric_bomb(vector[0], warning_time, bomb_time, 1))
	bombs.append(create_numeric_bomb(vector[order[0]], warning_time, bomb_time, 2))
	bombs.append(create_numeric_bomb(vector[order[1]], warning_time, bomb_time, 3))
	bombs.append(create_numeric_bomb(vector[order[2]], warning_time, bomb_time, 4))
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

const pattern_diamond_playing_time = 2.75
var pattern_diamond_bomb_count: int

func pattern_diamond():
	PlayingFieldInterface.set_theme_color(Color.DODGER_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.5
	
	pattern_diamond_bomb_count = 4
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	
	# HYPER MODE
	if stage_phase >= 4:
		player_direction = player_direction.rotated(randf())
	
	const CIRCLE_FIELD_RADIUS = 256
	
	const normal_radius = CIRCLE_FIELD_RADIUS - 48
	const hazard_radius = CIRCLE_FIELD_RADIUS - 144
	
	for i in range(4):
		var bomb: NormalBomb = create_normal_bomb(normal_radius * player_direction, warning_time, bomb_time)
		bomb.connect("player_body_entered", Callable(self, "pattern_diamond_end"))
		create_hazard_bomb(hazard_radius * player_direction, 0.25, 2.25)
		player_direction = player_direction.rotated(PI/2)

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
# pattern_twisted_numeric block start
# made by Jaeyong

const pattern_twisted_numeric_playing_time = 3.25

func pattern_twisted_numeric():
	PlayingFieldInterface.set_theme_color(Color.LIGHT_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 3.0
	
	var end_bomb: NumericBomb
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	if stage_phase < 4:
		end_bomb = create_numeric_bomb(player_position * -144.0 / 240.0, warning_time, bomb_time ,4)
		create_numeric_bomb(player_position * 144.0 / 240.0, warning_time, bomb_time, 3)
	else:
		end_bomb = create_numeric_bomb(player_position * 144.0 / 240.0, warning_time, bomb_time ,4)
		create_numeric_bomb(player_position * -144.0 / 240.0, warning_time, bomb_time, 3)
	
	if stage_phase < 4:
		create_numeric_bomb(player_position * -48.0 / 240.0, warning_time, bomb_time, 2)
		create_numeric_bomb(player_position * 48.0 / 240.0, warning_time, bomb_time, 1)
	else:
		create_numeric_bomb(player_position * 48.0 / 240.0, warning_time, bomb_time, 2)
		create_numeric_bomb(player_position * -48.0 / 240.0, warning_time, bomb_time, 1)
	
	end_bomb.connect("player_body_entered", Callable(self, "pattern_twisted_numeric_end"))

func pattern_twisted_numeric_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_twisted_numeric_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()

# pattern_twisted_numeric block end
###############################

###############################
# pattern_numeric_choice block start
# made by jinhyun

const pattern_numeric_choice_playing_time = 4.8125 # next_wait_time * (8-1) + warning_time + bomb_time

func pattern_numeric_choice():
	PlayingFieldInterface.set_theme_color(Color.ROYAL_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 1.5
	const next_wait_time = (warning_time + bomb_time) / 4
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	var rotation_inv_box: Array = [-PI/2, PI, PI/2, 0]
	
	randomize()
	var rand: int = randi() % 2
	
	if rand == 0:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 208.0 / 240.0, warning_time, bomb_time, i+1)
			if i == 7:
				bomb.connect("no_lower_value_bomb_exists", Callable(self,"pattern_numeric_choice_end"))
			await get_tree().create_timer(next_wait_time).timeout
	else:
		for i in range(8):
			var bomb: NumericBomb = create_numeric_bomb(player_position.rotated(rotation_inv_box[i%4]) * 208.0 / 240.0, warning_time, bomb_time, i+1)
			if i == 7:
				bomb.connect("no_lower_value_bomb_exists", Callable(self,"pattern_numeric_choice_end"))
			await get_tree().create_timer(next_wait_time).timeout

func pattern_numeric_choice_end():
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_numeric_choice_playing_time / Engine.time_scale))
	await get_tree().create_timer(0.2).timeout # rest time
	pattern_shuffle_and_draw()
	
# pattern_numeric_choice end
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

##############################################################
# stage phase 1 block end
##############################################################





##############################################################
# stage phase 2 block start
##############################################################

###############################
# pattern_spiral block start
# made by jinhyun

const pattern_spiral_playing_time = 5.0
var pattern_spiral_bomb_count: int

func pattern_spiral():
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var init_position: Vector2 = Vector2.UP
	
	pattern_spiral_bomb_count = 16
	for i in range(16):
		var bomb: NormalBomb = create_normal_bomb(init_position.rotated(i*PI/3) * (i+1) * 14, 0.25, 3.25)
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

###############################
# pattern_roll block start
# made by Jaeyong

const pattern_roll_playing_time = 4.0 # 4 * next_wait_time + warning_time + bomb_time
var pattern_roll_bomb_count: int

func pattern_roll():
	PlayingFieldInterface.set_theme_color(Color.DARK_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.2
	const bomb_time = 3.4
	const next_wait_time = 0.1
	
	var angle_offset: float = PlayingFieldInterface.get_player_position().angle()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var hazard_line: int = rng.randi_range(1,4)
	if hazard_line == 4:
		hazard_line = 2 #가운데 나오는 비율을 더 많이 주고 싶어서...
	
	pattern_roll_bomb_count = 10 if hazard_line == 2 else 11
	var bomb_list: Array[NormalBomb]

	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(Vector2(96 * i,192 - 96 * i).rotated(angle_offset - PI/2), warning_time, bomb_time)
		bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(next_wait_time).timeout
	
	
	if hazard_line == 1:
		create_hazard_bomb(Vector2(96, 0).rotated(angle_offset - PI/2), warning_time, bomb_time)
		create_hazard_bomb(Vector2(0, 96).rotated(angle_offset - PI/2), warning_time, bomb_time)
	else :
		for i in (2):
			var bomb: NormalBomb = create_normal_bomb(Vector2(96 - 96 * i,96 * i).rotated(angle_offset - PI/2), warning_time, bomb_time)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(next_wait_time).timeout

	
	if hazard_line == 2:
		create_hazard_bomb(Vector2(-96, 96).rotated(angle_offset - PI/2), warning_time, bomb_time)
		create_hazard_bomb(Vector2(0, 0).rotated(angle_offset - PI/2), warning_time, bomb_time)
		create_hazard_bomb(Vector2(96, -96).rotated(angle_offset - PI/2), warning_time, bomb_time)
	else :
		for i in (3):
			var bomb: NormalBomb = create_normal_bomb(Vector2(-96 + 96 * i, 96 - 96 * i).rotated(angle_offset - PI/2), warning_time, bomb_time)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(next_wait_time).timeout
		
		
	if hazard_line == 3:
		create_hazard_bomb(Vector2(-96, 0).rotated(angle_offset - PI/2), warning_time, bomb_time)
		create_hazard_bomb(Vector2(0, -96).rotated(angle_offset - PI/2), warning_time, bomb_time)
	else :
		for i in (2):
			var bomb: NormalBomb = create_normal_bomb(Vector2(-96 + 96 * i,- 96 * i).rotated(angle_offset - PI/2), warning_time, bomb_time)
			bomb.connect("player_body_entered", Callable(self, "pattern_roll_end"))
	await get_tree().create_timer(next_wait_time).timeout
	
	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(Vector2(-96 * i, -192 + 96 * i).rotated(angle_offset - PI/2), warning_time, bomb_time)
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
# pattern_numeric_diamond_with_hazard block start
# made by Bae Sekang

const pattern_diamond_with_hazard_playing_time = 3.0

func pattern_diamond_with_hazard():
	PlayingFieldInterface.set_theme_color(Color.NAVY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 2.75
	
	create_hazard_bomb(Vector2(0,0), warning_time, bomb_time)
	
	const bomb_position_length = 128
	var bomb_position: Vector2 = bomb_position_length * PlayingFieldInterface.get_player_position().normalized().rotated(PI/4)
	
	var bomb_end: NumericBomb
	for i: int in range(4):
		bomb_end = create_numeric_bomb(bomb_position, warning_time, bomb_time, i+1)
		bomb_position = bomb_position.rotated(PI/2)
	
	bomb_end.connect("no_lower_value_bomb_exists", Callable(self, "pattern_diamond_with_hazard_end"))

func pattern_diamond_with_hazard_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_with_hazard_playing_time / Engine.time_scale))
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard block end
###############################

###############################
# pattern_colosseum block start
# made by Bae Sekang

const pattern_colosseum_playing_time = 4.0
var pattern_colosseum_bomb_count: int

func pattern_colosseum():
	PlayingFieldInterface.set_theme_color(Color.MIDNIGHT_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 3.75
	
	var player_direction: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	const normal_bomb_distance = 108
	const hazard_bomb_distance = 152
	
	pattern_colosseum_bomb_count = 6
	for i in range(0, 12):
		if i % 2 == 0:
			var bomb: NormalBomb = create_normal_bomb(normal_bomb_distance * player_direction, warning_time, bomb_time)
			bomb.connect("player_body_entered", Callable(self,"pattern_colosseum_end"))
		else:
			create_hazard_bomb(hazard_bomb_distance * player_direction, warning_time, bomb_time)
		player_direction = player_direction.rotated(PI/6)
	
	# HYPER MODE
	if stage_phase >= 4:
		create_rotationinversion_bomb(Vector2.ZERO, warning_time, bomb_time)
	
func pattern_colosseum_end():
	pattern_colosseum_bomb_count -= 1
	if pattern_colosseum_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_colosseum_playing_time / Engine.time_scale))
		pattern_shuffle_and_draw()
	
# pattern_colosseum block end
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

const pattern_numeric_inversion_playing_time = 2.0

func pattern_numeric_inversion():
	PlayingFieldInterface.set_theme_color(Color.DARK_TURQUOISE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	const warning_time = 0.25
	const bomb_time = 1.75
	
	const DIST: float = 96
	
	var player_normalized: Vector2 = PlayingFieldInterface.get_player_position().normalized()
	
	create_numeric_bomb(DIST * sqrt(3) * player_normalized.rotated(deg_to_rad(60)), warning_time, bomb_time, 1)
	var bomb2: NumericBomb = create_numeric_bomb(DIST * player_normalized.rotated(deg_to_rad(120)), warning_time, bomb_time, 2)
	var bomb3: RotationInversionBomb = create_rotationinversion_bomb(DIST * player_normalized.rotated(deg_to_rad(240)), warning_time, bomb_time)
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
