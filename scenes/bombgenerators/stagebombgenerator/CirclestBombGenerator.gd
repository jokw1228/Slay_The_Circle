extends BombGenerator
class_name CirclestBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	# pattern_list.append(Callable(self, "pattern_test_1"))
	pattern_list.append(Callable(self, "pattern_rotate_timing"))
	pattern_list.append(Callable(self, "pattern_survive_random_slay"))
	pattern_list.append(Callable(self, "pattern_moving_link"))
	pattern_list.append(Callable(self, "pattern_shuffle_game"))
	
func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

func _process(delta):
	pattern_rotate_timing_process(delta)
	pattern_survive_random_slay_process(delta)
	pattern_moving_link_process(delta)
	pattern_shuffle_game_process(delta)

###############################
# pattern_test_1 block start

func pattern_test_1():
	await Utils.timer(0.1) # do nothing
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################

###############################
# pattern_rotate_timing block start
# made by kiyong

var pattern_rotate_timing_timer: float
var pattern_rotate_timing_timer_tween: Tween

var pattern_rotate_timing_bomb: Array[Node2D]
var pattern_rotate_timing_direction = [0,0,0,0,0,0]
const pattern_rotate_timing_rotation_speed = 350
const pattern_rotate_timing_speed = [sqrt(2), 1, sqrt(2), sqrt(2), 1, sqrt(2)]
var pattern_rotate_timing_random = 1
var pattern_rotate_timing_moving = false

func pattern_rotate_timing():
	pattern_rotate_timing_moving = false
	pattern_rotate_timing_timer = 1.2
	
	if pattern_rotate_timing_timer_tween != null:
		pattern_rotate_timing_timer_tween.kill()
	pattern_rotate_timing_timer_tween = get_tree().create_tween()
	pattern_rotate_timing_timer_tween.tween_property(self, "pattern_rotate_timing_timer", 0, 1.2)
	
	pattern_rotate_timing_bomb.clear()
	const p6sp = 80
	var pattern_rotate_timing_position = [Vector2(p6sp, p6sp), Vector2(p6sp, 0), Vector2(p6sp, -p6sp), Vector2(-p6sp, p6sp), Vector2(-p6sp, 0), Vector2(-p6sp, -p6sp)]
	
	var bomb = create_normal_bomb(Vector2(0,0), 0.2, 1)
	pattern_rotate_timing_moving = true
	pattern_rotate_timing_random = randi_range(0,1)
	if pattern_rotate_timing_random == 0:
		pattern_rotate_timing_random = -1
	for i in range(6):
		pattern_rotate_timing_bomb.append(create_hazard_bomb(Vector2(0, 0), 0.2, 1))
		pattern_rotate_timing_bomb[i].position = pattern_rotate_timing_position[i]
	
	bomb.connect("player_body_entered",Callable(self,"pattern_rotate_timing_end"))

func pattern_rotate_timing_process(delta):
	if pattern_rotate_timing_moving == true:
		for i in range(6):
			if is_instance_valid(pattern_rotate_timing_bomb[i]):
				var x = pattern_rotate_timing_bomb[i].position.x
				var y = pattern_rotate_timing_bomb[i].position.y
				pattern_rotate_timing_direction[i] = Vector2(y * pattern_rotate_timing_random, -x * pattern_rotate_timing_random).normalized()
				pattern_rotate_timing_bomb[i].position += pattern_rotate_timing_direction[i] * pattern_rotate_timing_rotation_speed * pattern_rotate_timing_speed[i] * delta

func pattern_rotate_timing_end():
	for i in range(6):
		pattern_rotate_timing_bomb[i].queue_free()
	pattern_rotate_timing_moving = false
	PlayingFieldInterface.add_playing_time(pattern_rotate_timing_timer)
	pattern_shuffle_and_draw()

# pattern_rotate_timing block end
###############################

###############################
# pattern_survive_random_slay block start
# made by kiyong

var pattern_survive_random_slay_timer: float
var pattern_survive_random_slay_timer_tween: Tween
var pattern_survive_random_slay_hazard: Array[Node2D]
var pattern_survive_random_slay_bombs: Array[Node2D]
var pattern_survive_random_slay_active: bool = false

var pattern_survive_random_slay_direction: Array = [0, 0, 0]

func pattern_survive_random_slay():
	pattern_survive_random_slay_hazard.clear()
	pattern_survive_random_slay_bombs.clear()
	pattern_survive_random_slay_active = false
	
	pattern_survive_random_slay_timer = 4.3
	
	if pattern_survive_random_slay_timer_tween != null:
		pattern_survive_random_slay_timer_tween.kill()
	pattern_survive_random_slay_timer_tween = get_tree().create_tween()
	pattern_survive_random_slay_timer_tween.tween_property(self, "pattern_survive_random_slay_timer", 0, 4.3)
	
	await Utils.timer(0.3)
	pattern_survive_random_slay_active = true
	pattern_survive_random_slay_outer()
	pattern_survive_random_slay_bomb0()
	

func pattern_survive_random_slay_bomb0():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[0].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb1"))

func pattern_survive_random_slay_bomb1():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[1].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb2"))

func pattern_survive_random_slay_bomb2():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[2].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb3"))

func pattern_survive_random_slay_bomb3():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[3].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_end"))

func pattern_survive_random_slay_outer():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var rotation_value = player_angle + 7*PI/8
	for i in range(3):
		pattern_survive_random_slay_hazard.append(create_hazard_bomb(Vector2(256*cos(rotation_value), 256*sin(rotation_value)), 0, 4.3))
		rotation_value += PI/8

func pattern_survive_random_slay_process(delta):
	if pattern_survive_random_slay_active == true:
			for i in range(3):
				if is_instance_valid(pattern_survive_random_slay_hazard[i]):
					var x = pattern_survive_random_slay_hazard[i].position.x
					var y = pattern_survive_random_slay_hazard[i].position.y
					pattern_survive_random_slay_direction[i] = Vector2(y, -x).normalized()
					pattern_survive_random_slay_hazard[i].position += pattern_survive_random_slay_direction[i] * 1000 * delta

func pattern_survive_random_slay_end():
	pattern_survive_random_slay_active = false
	for node in pattern_survive_random_slay_hazard:
		if is_instance_valid(node):
			node.queue_free()
	PlayingFieldInterface.add_playing_time(pattern_survive_random_slay_timer)
	pattern_shuffle_and_draw()

# pattern_survive_random_slay block end
###############################

###############################
# pattern_moving_link block start
# made by kiyong

var pattern_moving_link_timer: float
var pattern_moving_link_timer_tween: Tween
var pattern_moving_link_bomb: Array[Node2D]
var pattern_moving_link_hazard: Array[Node2D]

const pattern_moving_link_speed = 500
var pattern_moving_link_bomb_direction = [1, -1]
var pattern_moving_link_bomb_dir_changed = [false, false]
var pattern_moving_link_active: bool = false

func pattern_moving_link():
	pattern_moving_link_active = false
	pattern_moving_link_bomb.clear()
	pattern_moving_link_hazard.clear()
	pattern_moving_link_bomb_direction = [1, -1]
	pattern_moving_link_bomb_dir_changed = [false, false]
	pattern_moving_link_timer = 2.25
	
	if pattern_moving_link_timer_tween != null:
		pattern_moving_link_timer_tween.kill()
	pattern_moving_link_timer_tween = get_tree().create_tween()
	pattern_moving_link_timer_tween.tween_property(self, "pattern_moving_link_timer", 0, 2.25)

	pattern_moving_link_hazard.append(create_hazard_bomb(Vector2(180, 60), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(Vector2(-180, 60), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(Vector2(180, -60), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(Vector2(-180, -60), 0.25, 2))
	pattern_moving_link_bomb.append(create_normal_bomb(Vector2(0, 40), 0.25, 2))
	pattern_moving_link_bomb.append(create_normal_bomb(Vector2(0, -40), 0.25, 2))
	var link = create_bomb_link(pattern_moving_link_bomb[0], pattern_moving_link_bomb[1])
	pattern_moving_link_active = true
	
	link.connect("both_bombs_removed",Callable(self,"pattern_moving_link_end"))

func pattern_moving_link_process(delta):
	if pattern_moving_link_active == true:
		if is_instance_valid(pattern_moving_link_bomb[0]) and is_instance_valid(pattern_moving_link_bomb[1]):
			pattern_moving_link_bomb[0].position.x += pattern_moving_link_speed * pattern_moving_link_bomb_direction[0] * delta
			pattern_moving_link_bomb[1].position.x += pattern_moving_link_speed * pattern_moving_link_bomb_direction[1] * delta
			for i in range(2):
				if (pattern_moving_link_bomb[i].position.x > 170 or pattern_moving_link_bomb[i].position.x < -170) and pattern_moving_link_bomb_dir_changed[i] == false:
					pattern_moving_link_bomb_dir_changed[i] = true
					pattern_moving_link_bomb_direction[i] *= -1
				else:
					pattern_moving_link_bomb_dir_changed[i] = false


func pattern_moving_link_end():
	pattern_moving_link_active = false
	for node in pattern_moving_link_hazard:
		if is_instance_valid(node):
			node.queue_free()
	PlayingFieldInterface.add_playing_time(pattern_moving_link_timer)
	pattern_shuffle_and_draw()

# pattern_moving_link block end
###############################

###############################
# pattern_shuffle_game block start
# made by kiyong

var pattern_shuffle_game_timer: float
var pattern_shuffle_game_timer_tween: Tween
var pattern_shuffle_game_bombs: Array[Node2D]
var pattern_shuffle_game_real_bomb: Bomb
var pattern_shuffle_game_moving: bool = false

var pattern_shuffle_game_rand = [0, 0, 0, 1]
const pattern_shuffle_game_const_position = [Vector2(-256 / sqrt(2), -256 / sqrt(2)), Vector2(256 / sqrt(2), -256 / sqrt(2)), Vector2(-256 / sqrt(2), 256 / sqrt(2)), Vector2(256 / sqrt(2), 256 / sqrt(2))]
var pattern_shuffle_game_bomb_pos = [1, 2, 3, 4] # 각 폭탄의 현재 위치

var pattern_shuffle_game_direction = [0,0,0,0]
var pattern_shuffle_game_distance = [0,0,0,0]
var pattern_shuffle_game_moveseed = [0,0,0,0]
var pattern_shuffle_game_speed = [0,0,0,0]

func pattern_shuffle_game():
	pattern_shuffle_game_bombs.clear()
	pattern_shuffle_game_moving = false
	pattern_shuffle_game_timer = 4.6
	
	if pattern_shuffle_game_timer_tween != null:
		pattern_shuffle_game_timer_tween.kill()
	pattern_shuffle_game_timer_tween = get_tree().create_tween()
	pattern_shuffle_game_timer_tween.tween_property(self, "pattern_shuffle_game_timer", 0, 4.6)

	pattern_shuffle_game_bomb_pos = [1, 2, 3, 4]
	pattern_shuffle_game_rand.shuffle()
	var prev_value = 5
	var real_bomb_position
	
	for i in range(4):
		if pattern_shuffle_game_rand[i]:
			pattern_shuffle_game_bombs.append(create_hazard_bomb(Vector2(1000, 1000), 4.2, 0))
			pattern_shuffle_game_real_bomb = create_normal_bomb(pattern_shuffle_game_const_position[i], 4.2, 0.1)
			pattern_shuffle_game_real_bomb.position = pattern_shuffle_game_const_position[i]
			real_bomb_position = i
		else:
			pattern_shuffle_game_bombs.append(create_hazard_bomb(pattern_shuffle_game_const_position[i], 4.2, 0.1))
			pattern_shuffle_game_bombs[i].position = pattern_shuffle_game_const_position[i]
	
	await Utils.timer(0.8)
	pattern_shuffle_game_bombs[real_bomb_position].position = pattern_shuffle_game_const_position[real_bomb_position]
	pattern_shuffle_game_real_bomb.position = Vector2(1000, 1000)
	
	for i in range(8): # 1회당 0.3초 
		var rand_result = randi_range(0,4)
		while rand_result == prev_value:
			rand_result = randi_range(0,4)
		prev_value = rand_result
		await pattern_shuffle_game_random(rand_result)
		await Utils.timer(0.05)
		
	await Utils.timer(1)
	pattern_shuffle_game_real_bomb.connect("player_body_entered",Callable(self,"pattern_shuffle_game_end"))
	# pattern_shuffle_game_bombs[real_bomb_position].position = Vector2(1000, 1000)
	pattern_shuffle_game_real_bomb.position = pattern_shuffle_game_const_position[pattern_shuffle_game_bomb_pos[real_bomb_position]-1]

func pattern_shuffle_game_random(pattern: int):
	match pattern:
		0:
			await pattern_shuffle_game_move([2, 4, 1, 3]) # Clockwise
		1:
			await pattern_shuffle_game_move([3, 1, 4, 2]) # Counterclockwise
		2:
			await pattern_shuffle_game_move([3, 4, 1, 2]) # Swap vertically
		3:
			await pattern_shuffle_game_move([2, 1, 4, 3]) # Swap horizontally
		4:
			await pattern_shuffle_game_move([4, 3, 2, 1]) # Swap diagonally

func pattern_shuffle_game_move(setseed: Array):
	for i in range(4):
		pattern_shuffle_game_moveseed[i] = setseed[i]
	for i in range(4):
		pattern_shuffle_game_speed[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).length() * 5
	pattern_shuffle_game_moving = true
	await Utils.timer(0.25)
	pattern_shuffle_game_moving = false
	
	for i in range(4):
		pattern_shuffle_game_bomb_pos[i] = pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]

func pattern_shuffle_game_process(delta):
	if pattern_shuffle_game_moving == true:
		for i in range(4):
			pattern_shuffle_game_direction[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).normalized()
			pattern_shuffle_game_distance[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).length()
			
			if pattern_shuffle_game_distance[i] > 3:
				pattern_shuffle_game_bombs[i].position += pattern_shuffle_game_direction[i] * pattern_shuffle_game_speed[i] * delta
			else:
				pattern_shuffle_game_bombs[i].position = pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1]

func pattern_shuffle_game_end():
	await Utils.timer(0.3)
	PlayingFieldInterface.add_playing_time(pattern_shuffle_game_timer)
	pattern_shuffle_and_draw()

# pattern_shuffle_game block end
###############################
