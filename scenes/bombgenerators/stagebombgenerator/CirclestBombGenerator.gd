extends BombGenerator
class_name CirclestBombGenerator

var pattern_list: Array[Callable]

var pattern_start_time: float

var color_down : Color = Color.ORANGE_RED

var rotation_on : int = 20

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	PlayingFieldInterface.set_theme_color(Color.RED)
	pattern_cat_wheel()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_cat_wheel"))
	pattern_list.append(Callable(self, "pattern_fruitninja"))
	pattern_list.append(Callable(self, "pattern_windmill"))
	pattern_list.append(Callable(self, "pattern_rain"))
	pattern_list.append(Callable(self, "pattern_hazard_wave"))
	pattern_list.append(Callable(self, "pattern_rotate_timing"))
	pattern_list.append(Callable(self, "pattern_survive_random_slay"))
	pattern_list.append(Callable(self, "pattern_moving_link"))
	pattern_list.append(Callable(self, "pattern_shuffle_game"))
	pattern_list.append(Callable(self, "pattern_timing_return"))
	#pattern_list.append(Callable(self, "pattern_rotation")) 
	pattern_list.append(Callable(self, "pattern_trickery"))
	pattern_list.append(Callable(self, "pattern_darksight"))

func pattern_shuffle_and_draw():
	if PlayingFieldInterface.get_playing_time()>30:
		pattern_list.erase(pattern_cat_wheel) # 시간 날먹할 수 있는 패턴 삭제
	if PlayingFieldInterface.get_playing_time()>rotation_on:
		pattern_rotation()
		rotation_on+=20
	else:
		randomize()
		var random_index: int = randi() % pattern_list.size()
		pattern_list[random_index].call()
	if color_down.r >0.4:
		color_down.r -= 0.05
		PlayingFieldInterface.set_theme_color(color_down)

func _process(delta):
	pattern_moving_link_process(delta)
	pattern_shuffle_game_process(delta)

###############################
# pattern_cat_wheel block start
# made by Jo Kangwoo

func pattern_cat_wheel():
	 # -> circler(움직이는 폭탄 존재, 난이도가 그리 어렵지 않음)
	 # 수정사항 : 색상 DEEP_SKY_BLUE -> RED
	#PlayingFieldInterface.set_theme_color(Color.RED)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_start: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	const bomb_radius = CIRCLE_FIELD_RADIUS - 32
	
	var center: Node2D = Node2D.new()
	add_child(center)
	
	const number_of_hazard_bombs = 20
	const warning_time = 0.5
	const bomb_time = 4.5
	var ccw: float = 1 if randi() % 2 else -1
	for i in range(number_of_hazard_bombs):
		if i >= 5 and i <= number_of_hazard_bombs - 2:
			var inst: HazardBomb = HazardBomb.create(Vector2(bomb_radius * cos(angle_start + i * (ccw * (2*PI) / number_of_hazard_bombs)), bomb_radius * -sin(angle_start + i * (ccw * (2*PI) / number_of_hazard_bombs))), warning_time, bomb_time)
			center.add_child(inst)
	
	var tween_rotation: Tween = get_tree().create_tween()
	tween_rotation.tween_property(center, "rotation", ccw * (2*PI), warning_time + bomb_time)
	
	const rest_time = 0.5
	await get_tree().create_timer(warning_time + bomb_time + rest_time).timeout
	center.queue_free()
	pattern_list.erase(pattern_cat_wheel)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_cat_wheel)

# pattern_cat_wheel end
###############################

###############################
# pattern_fruitninja block start
# made by Seonghyeon

# Hyper에서 normal 사이에 hazard 끼워 넣으면 재미있을 듯
# 마지막 폭탄 일찍 종료 안하면 0.5초 쯤 길어짐
# 이렇게 짧은 친구들도 일찍 종료 걸어야 할까?
# 수정사항 : grounded 시그널 삭제, await 으로 변경
# player 가 가만히 있을 시 다음 패턴이 생성되지 않아 꼼수의 가능성 존재
func pattern_fruitninja():
	#PlayingFieldInterface.set_theme_color(Color.ORANGE_RED)

	var timer = get_tree().create_timer(4.0)

	var rigidbodies: Array[RigidBody2D] = [RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new()]
	var direction: Array[int] = [1, -1, 1, 1, -1] # 정해진 패턴 대신 완전 랜덤? 그런데 같은 방향 중복이 너무 많이 나올 때 있음.
	
	for i in range(5):
		add_child(rigidbodies[i])
		rigidbodies[i].gravity_scale = 1.5
		rigidbodies[i].linear_velocity = Vector2(direction[i] * 600, -900 + randf_range(-200, 100))
		rigidbodies[i].position = Vector2(-direction[i] * 400, 281)

		var bomb = create_normal_bomb(rigidbodies[i].global_position, 0, 1.2)
		Utils.attach_node(rigidbodies[i], bomb)

		if i == 4: # last bomb
			bomb.connect("player_body_entered", func ():	
				await Utils.timer(0.7)
				for rigidbody in rigidbodies:
					rigidbody.queue_free()
				
				PlayingFieldInterface.add_playing_time(timer.time_left)
				pattern_list.erase(pattern_fruitninja)
				pattern_shuffle_and_draw()
				pattern_list.append(pattern_fruitninja)
			)
		await Utils.timer(0.7)
# pattern_fruitninja block end
###############################

###############################
# pattern_windmill block start
# made by Seonghyeon
# 수정사항 X
func pattern_windmill():
	#PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
	const DIST: float = 70

	var rotator: Node2D = Node2D.new()
	add_child(rotator)

	for i in range(8):
		var marker: Node2D = Node2D.new()
		rotator.add_child(marker)
		marker.global_position = Vector2(-256 + 32 + i * 64, 0)
		Utils.attach_node(marker, create_hazard_bomb(marker.global_position, 1, 2))

	Utils.tween(Tween.TRANS_LINEAR).tween_property(rotator, "rotation", deg_to_rad(600), 3)
	create_normal_bomb(Vector2(1, 1) * DIST, 1, 2)
	create_normal_bomb(Vector2(-1, 1) * DIST, 1, 2)
	create_normal_bomb(Vector2(-1, -1) * DIST, 1, 2)
	create_normal_bomb(Vector2(1, -1) * DIST, 1, 2)

	await Utils.timer(3)
	rotator.queue_free()
	pattern_list.erase(pattern_windmill)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_windmill)
# pattern_windmill block end
###############################

###############################
# pattern_rain block start
# made by Seonghyeon
# 수정사항 : hazard bomb drop 시 trans_set_ease_in 추가
func pattern_rain():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)
 
	pattern_rain_spawn_drop()
	pattern_rain_spawn_bomb()

	await Utils.timer(5.5)
	pattern_list.erase(pattern_rain)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_rain)
 
func pattern_rain_spawn_drop():
	for i in range(6):
		pattern_rain_drop()
		await Utils.timer(0.5)

func pattern_rain_spawn_bomb():
	for i in range(6):
		pattern_rain_bomb()
		await Utils.timer(0.5)

func pattern_rain_drop():
	const DIST: float = 300
	const RANGE: float = 70

	var bomb: HazardBomb = create_hazard_bomb(DIST * Vector2.UP.rotated(deg_to_rad(randf_range(-RANGE, RANGE))), 1, 2)
	await Utils.timer(1)
	Utils.tween(Tween.TRANS_EXPO, Tween.EASE_IN).tween_property(bomb, "global_position", Vector2(bomb.global_position.x, 500), 2)
 
func pattern_rain_bomb():
	const RANGE: float = 45
	const DIST: float = 300

	var direction: int = 1 if randi_range(0, 1) == 1 else -1
	var pos: Vector2 = DIST * Vector2.LEFT.rotated(deg_to_rad(randf_range(-RANGE, 0)))
	pos.x *= direction
	var bomb: NormalBomb = create_normal_bomb(pos, 1, 2)
	await Utils.timer(1)
	Utils.tween(Tween.TRANS_LINEAR).tween_property(bomb, "global_position", Vector2(-pos.x, pos.y), 2).set_trans(Tween.EASE_IN)
	
# patter_rain block end
###############################

###############################
# pattern_hazard_wave block start
# made by Jaeyong
# 수정사항 X
func pattern_hazard_wave():
	var random: float = randf_range(0,2)
	var spawn: int = 1 if random >= 1 else -1
	
	var hazard_list: Array[HazardBomb] = []
	var rigidbody: Array[RigidBody2D] = [RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(),RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new()]

	for i in (9):
		add_child(rigidbody[i])
		rigidbody[i].gravity_scale = 0
		Utils.attach_node(rigidbody[i], create_hazard_bomb(Vector2(spawn * 400,-256 + (64 * i)),0,1.25))
		rigidbody[i].position = Vector2(spawn * 400,-256 + (64 * i))
		rigidbody[i].linear_velocity = Vector2(spawn * 700,0)
		pattern_hazard_wave_acceleration(i,rigidbody,-2 * spawn)
		await get_tree().create_timer(0.15).timeout
		
	await Utils.timer(1.25)

	pattern_list.erase(pattern_hazard_wave)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_hazard_wave)
	
func pattern_hazard_wave_acceleration(num: int,rigidbody: Array[RigidBody2D], ac: int):
	for i in (50):
			rigidbody[num].linear_velocity += Vector2(ac * i,0)
			await get_tree().create_timer(0.00001).timeout
		
# pattern_hazard_wave block end
###############################

###############################
# pattern_rotate_timing block start
# made by kiyong
# 잠재적 수정사항 : 판정을 좀 더 관대하게 하는 건 어떨까요
# circler 정도로 난이도 하락 예상됩니다
var pattern_rotate_timing_bomb: Array[Node2D]
var pattern_rotate_timing_direction = [0,0,0,0,0,0]
const pattern_rotate_timing_rotation_speed = 260
const pattern_rotate_timing_speed = [sqrt(2), 1, sqrt(2), sqrt(2), 1, sqrt(2)]
var pattern_rotate_timing_random = 1
signal pattern_rotate_timing_end_signal

const pattern_rotate_timing_playing_time = 2

func pattern_rotate_timing():
	#PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	pattern_rotate_timing_bomb.clear()
	const p6sp = 85
	var pattern_rotate_timing_position = [Vector2(p6sp, p6sp-10), Vector2(p6sp, 0), Vector2(p6sp, -p6sp+10), Vector2(-p6sp, p6sp-10), Vector2(-p6sp, 0), Vector2(-p6sp, -p6sp+10)]
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	
	var bomb = create_normal_bomb(Vector2(0,0), 0.2, 1.8)
	pattern_rotate_timing_random = randi_range(0,1)
	if pattern_rotate_timing_random == 0:
		pattern_rotate_timing_random = -1
	for i in range(6):
		pattern_rotate_timing_bomb.append(create_hazard_bomb(Vector2(0, 0), 0.2, 1.8))
		pattern_rotate_timing_bomb[i].position = pattern_rotate_timing_position[i].rotated(player_angle)
	
	var center: Node2D = Node2D.new()
	add_child(center)
	
	await Utils.timer(0.21)
	for i in range(6):
		pattern_rotate_timing_bomb[i].reparent(center)
	
	var tween_rotation: Tween = get_tree().create_tween()
	tween_rotation.tween_property(center, "rotation", pattern_rotate_timing_random * (2*PI), 1.79)
	
	bomb.connect("player_body_entered",Callable(self,"pattern_rotate_timing_end"))

func pattern_rotate_timing_end():
	await PlayingFieldInterface.player_grounded
	pattern_rotate_timing_end_signal.emit()
	for node in pattern_rotate_timing_bomb:
		if is_instance_valid(node):
			node.queue_free()
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_rotate_timing_playing_time) / Engine.time_scale)
	pattern_list.erase(pattern_rotate_timing)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_rotate_timing)

# pattern_rotate_timing block end
###############################

###############################
# pattern_survive_random_slay block start
# made by kiyong
# 잠재적 수정사항 : normal bomb 개수 늘리는 것 어떨까요
var pattern_survive_random_slay_hazard: Array[Node2D]
var pattern_survive_random_slay_bombs: Array[Node2D]
signal pattern_survive_random_slay_end_signal

var pattern_survive_random_slay_direction: Array = [0, 0, 0]
const pattern_survive_random_slay_playing_time = 4.2

func pattern_survive_random_slay():
	#PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	pattern_survive_random_slay_hazard.clear()
	pattern_survive_random_slay_bombs.clear()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var rotation_value = player_angle + 7*PI/8
	for i in range(3):
		pattern_survive_random_slay_hazard.append(create_hazard_bomb(Vector2(224*cos(rotation_value), 224*sin(rotation_value)), 0.1, 4.1))
		rotation_value += PI/8
		
	pattern_survive_random_slay_bomb0()
	await Utils.timer(0.2)
	
	var pattern_survive_random_slay_centernode: Node2D = Node2D.new()
	add_child(pattern_survive_random_slay_centernode)
	
	for i in range(3):
		pattern_survive_random_slay_hazard[i].reparent(pattern_survive_random_slay_centernode)
	
	var tween_rotation: Tween = get_tree().create_tween()
	tween_rotation.tween_property(pattern_survive_random_slay_centernode, "rotation", -6*PI, 4)
	
	await pattern_survive_random_slay_end_signal
	pattern_survive_random_slay_centernode.queue_free()

func pattern_survive_random_slay_bomb0():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0.2, 1))
	pattern_survive_random_slay_bombs[0].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb1"))

func pattern_survive_random_slay_bomb1():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	await PlayingFieldInterface.player_grounded
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[1].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb2"))

func pattern_survive_random_slay_bomb2():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	await PlayingFieldInterface.player_grounded
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[2].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb3"))

func pattern_survive_random_slay_bomb3():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	await PlayingFieldInterface.player_grounded
	pattern_survive_random_slay_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_bombs[3].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_end"))

func pattern_survive_random_slay_end():
	pattern_survive_random_slay_end_signal.emit()
	await PlayingFieldInterface.player_grounded
	for node in pattern_survive_random_slay_hazard:
		if is_instance_valid(node):
			node.queue_free()
	
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_survive_random_slay_playing_time) / Engine.time_scale)
	pattern_list.erase(pattern_survive_random_slay)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_survive_random_slay)

# pattern_survive_random_slay block end
###############################

###############################
# pattern_moving_link block start
# made by kiyong
# 수정사항 : hazard bomb 생성 위치 조정
var pattern_moving_link_playing_time = 2.25
var pattern_moving_link_bomb: Array[Node2D]
var pattern_moving_link_hazard: Array[Node2D]

const pattern_moving_link_speed = 500
var pattern_moving_link_bomb_direction = [1, -1]
var pattern_moving_link_bomb_dir_changed = [false, false]
var pattern_moving_link_active: bool = false

func pattern_moving_link():
	#PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	const hazard_inst_circle_radius = 160
	
	pattern_moving_link_active = false
	pattern_moving_link_bomb.clear()
	pattern_moving_link_hazard.clear()
	pattern_moving_link_bomb_direction = [(player_position.rotated(PI/2)).normalized(), -(player_position.rotated(PI/2)).normalized()]
	pattern_moving_link_bomb_dir_changed = [false, false]

	pattern_moving_link_hazard.append(create_hazard_bomb(pattern_moving_link_autorotate(hazard_inst_circle_radius * cos(PI/4), hazard_inst_circle_radius * sin(PI/4)), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(pattern_moving_link_autorotate(hazard_inst_circle_radius * cos(3*PI/4), hazard_inst_circle_radius * sin(3*PI/4)), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(pattern_moving_link_autorotate(hazard_inst_circle_radius * cos(5*PI/4), hazard_inst_circle_radius * sin(5*PI/4)), 0.25, 2))
	pattern_moving_link_hazard.append(create_hazard_bomb(pattern_moving_link_autorotate(hazard_inst_circle_radius * cos(7*PI/4), hazard_inst_circle_radius * sin(7*PI/4)), 0.25, 2))
	pattern_moving_link_bomb.append(create_normal_bomb(pattern_moving_link_autorotate(0, 40), 0.25, 2))
	pattern_moving_link_bomb.append(create_normal_bomb(pattern_moving_link_autorotate(0, -40), 0.25, 2))
	var link = create_bomb_link(pattern_moving_link_bomb[0], pattern_moving_link_bomb[1])
	pattern_moving_link_active = true
	
	link.connect("both_bombs_removed",Callable(self,"pattern_moving_link_end"))

func pattern_moving_link_process(delta):
	if pattern_moving_link_active == true:
		if is_instance_valid(pattern_moving_link_bomb[0]) and is_instance_valid(pattern_moving_link_bomb[1]):
			pattern_moving_link_bomb[0].position += pattern_moving_link_speed * pattern_moving_link_bomb_direction[0] * delta
			pattern_moving_link_bomb[1].position += pattern_moving_link_speed * pattern_moving_link_bomb_direction[1] * delta
			for i in range(2):
				if (pattern_moving_link_bomb[i].position.length() > 180 or pattern_moving_link_bomb[i].position.length() < -180) and pattern_moving_link_bomb_dir_changed[i] == false:
					pattern_moving_link_bomb_dir_changed[i] = true
					pattern_moving_link_bomb_direction[i] *= -1
				else:
					pattern_moving_link_bomb_dir_changed[i] = false

func pattern_moving_link_autorotate(posx: float, posy: float) -> Vector2: #풀레이어가 정남쪽에 있다고 가정할 때 폭탄을 자동으로 돌려줌 
	var player_direction = (PlayingFieldInterface.get_player_position()).normalized()
	if player_direction == Vector2(0, 0):
		player_direction = Vector2(0, 1)
	
	var rotate_value = Vector2(0, 1).angle_to(player_direction)
	return Vector2(posx, posy).rotated(rotate_value)

func pattern_moving_link_end():
	await PlayingFieldInterface.player_grounded
	pattern_moving_link_active = false
	for node in pattern_moving_link_hazard:
		if is_instance_valid(node):
			node.queue_free()
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_moving_link_playing_time) / Engine.time_scale)
	pattern_list.erase(pattern_moving_link)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_moving_link)

# pattern_moving_link block end
###############################

###############################
# pattern_shuffle_game block start
# made by kiyong
# 수정사항 : 종료 시 타이머 소폭 증가 -> 난이도 소폭 하향
var pattern_shuffle_game_bombs: Array[Node2D]
var pattern_shuffle_game_real_bomb: Bomb
var pattern_shuffle_game_moving: bool = false

var pattern_shuffle_game_rand = [0, 0, 0, 1]
const pattern_shuffle_game_const_position = [Vector2(-224 / sqrt(2), -224 / sqrt(2)), Vector2(224 / sqrt(2), -224 / sqrt(2)), Vector2(-224 / sqrt(2), 224 / sqrt(2)), Vector2(224 / sqrt(2), 224 / sqrt(2))]
var pattern_shuffle_game_bomb_pos = [1, 2, 3, 4] # 각 폭탄의 현재 위치

var pattern_shuffle_game_direction = [0,0,0,0]
var pattern_shuffle_game_distance = [0,0,0,0]
var pattern_shuffle_game_moveseed = [0,0,0,0]
var pattern_shuffle_game_speed = [0,0,0,0]
var pattern_shuffle_game_speed_increasing: float

func pattern_shuffle_game():
	var bomb_time = 0
	var calculation = 3.3
	for i in range(8):
		bomb_time += 0.1 + 1/calculation
		calculation += 0.3
	
	pattern_shuffle_game_speed_increasing = 3.3
	#PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	pattern_shuffle_game_bombs.clear()
	pattern_shuffle_game_moving = false

	pattern_shuffle_game_bomb_pos = [1, 2, 3, 4]
	pattern_shuffle_game_rand.shuffle()
	var prev_value = 5
	var real_bomb_position
	
	for i in range(4):
		if pattern_shuffle_game_rand[i]:
			pattern_shuffle_game_bombs.append(create_hazard_bomb(Vector2(1000, 1000), bomb_time + 1.6, 0))
			pattern_shuffle_game_real_bomb = create_normal_bomb(pattern_shuffle_game_const_position[i], 1, 6)
			pattern_shuffle_game_real_bomb.position = pattern_shuffle_game_const_position[i]
			real_bomb_position = i
		else:
			pattern_shuffle_game_bombs.append(create_hazard_bomb(pattern_shuffle_game_const_position[i], bomb_time + 1.6, 0.1))
			pattern_shuffle_game_bombs[i].position = pattern_shuffle_game_const_position[i]
	
	await Utils.timer(0.8)
	pattern_shuffle_game_bombs[real_bomb_position].position = pattern_shuffle_game_const_position[real_bomb_position]
	pattern_shuffle_game_real_bomb.position = Vector2(1000, 1000)
	
	for i in range(8): 
		var rand_result = randi_range(0,4)
		while rand_result == prev_value:
			rand_result = randi_range(0,4)
		prev_value = rand_result
		await pattern_shuffle_game_random(rand_result)
		await Utils.timer(0.05)
		pattern_shuffle_game_speed_increasing += 0.3
	
	pattern_shuffle_game_real_bomb.queue_free()
	await Utils.timer(0.8)
	# pattern_shuffle_game_bombs[real_bomb_position].position = Vector2(1000, 1000)
	# pattern_shuffle_game_real_bomb.position = pattern_shuffle_game_const_position[pattern_shuffle_game_bomb_pos[real_bomb_position]-1]
	var bomb = create_normal_bomb(pattern_shuffle_game_const_position[pattern_shuffle_game_bomb_pos[real_bomb_position]-1], 0, 0.1)
	await Utils.timer(0.6)
	
	pattern_list.erase(pattern_shuffle_game)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_shuffle_game)

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
		pattern_shuffle_game_speed[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).length() * pattern_shuffle_game_speed_increasing
	pattern_shuffle_game_moving = true
	await Utils.timer(1/pattern_shuffle_game_speed_increasing + 0.05)
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

# pattern_shuffle_game block end
###############################

###############################
# pattern_timing_return block start
# made by jinhyun
# player 가 땅을 연속적으로 클릭하는 이상한 행동을 보이면 
# 뒤 패턴이 바로 생성되는 버그 존재정
# -> 코드 수정, 원 코드 일단은 살려놓았음
func pattern_timing_return():
	#PlayingFieldInterface.set_theme_color(Color.VIOLET)
	var player_position: Vector2
	var player_position_shift: Vector2
	
	player_position = PlayingFieldInterface.get_player_position()
	
	create_hazard_bomb(player_position.rotated(PI/3) * 0.7, 0.5, 0.5)
	create_hazard_bomb(player_position.rotated(-PI/3) * 0.7, 0.5, 0.5)
	create_hazard_bomb(player_position.rotated(PI/2) * 0.7, 0.5, 1)
	create_hazard_bomb(player_position.rotated(-PI/2) * 0.7, 0.5, 1)
	create_hazard_bomb(player_position.rotated(2*PI/3) * 0.7, 0.5, 1.45)
	create_hazard_bomb(player_position.rotated(-2*PI/3) * 0.7, 0.5, 1.45)
	
	var bomb : NormalBomb = create_normal_bomb(Vector2(0, 0), 0.5, 1.6)
	create_hazard_bomb(Vector2(0, 0), 0.5, 1.35)
	
	await get_tree().create_timer(1).timeout
	player_position = PlayingFieldInterface.get_player_position()
	bomb.connect("player_body_entered", Callable(self, "make_linear_bombs"))
	
func make_linear_bombs():
	var player_position = PlayingFieldInterface.get_player_position()
	for i in range(6):
		create_normal_bomb(player_position * 0.3 * (i-3), 0.05, 1 - i*0.1)
		await get_tree().create_timer(0.015).timeout
	await get_tree().create_timer(0.02).timeout
	#var lasting_bool: bool = true
	#
	#while lasting_bool:
		#player_position_shift = PlayingFieldInterface.get_player_position()
		#if player_position != player_position_shift:
			#player_position = player_position_shift
			#lasting_bool = false
			
			#for i in range(6):
				#create_normal_bomb(player_position * 0.3 * (i-3), 0.05, 1 - i*0.1)
				#await get_tree().create_timer(0.025).timeout
		#await get_tree().create_timer(0.02).timeout
	await get_tree().create_timer(1).timeout
	pattern_list.erase(pattern_timing_return)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_timing_return)
	
# pattern_timing_return end
###############################

###############################
# pattern_rotation block start
# made by seokhee

#회전 필요할 때 쉬어가는 코너. bomb exploded 되는 속도가 빨라서
#circlest 나 hyper 혹은 일정 시간이 지난 후 사용하면 좋을 듯합니다 
# rotation pattern 중 쉬운 난이도에 속함 -> 자주 등장하게 조정..?
const pattern_rotation_playing_time = 2.3

func pattern_rotation():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	#PlayingFieldInterface.set_theme_color(Color.BISQUE)
	var bomb_rotation: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(0, 0), 0.5, 1.8, 0.06)
	bomb_rotation.connect("player_body_entered", Callable(self, "pattern_rotation_end"))
	
func pattern_rotation_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_rotation_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
#pattern_rotation block end
###############################

###############################
# pattern_trickery block start
# made by seokhee

# life is gamble
# 일정 시간이 지난 후 (60초 정도?) 플레이어를 억까시키고 싶을때
# 사용하면 좋을 듯합니다 
# 수정사항 : bomb timer 소폭 감소
# 잠재적 수정사항 : 난이도 circle 로 들어가도 될 정도의 쉬운 난이도
# indicator 도입으로 인하여 난이도 대폭 하향
const pattern_trickery_playing_time = 3

func pattern_trickery():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	#PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	var num_rng = RandomNumberGenerator.new()
	num_rng.randomize()
	var trick_num = num_rng.randi_range(1,3)
	
	var bomb1: NormalBomb = create_normal_bomb(Vector2(-144, 0), 0.3, 2.0)
	var bomb2: NormalBomb = create_normal_bomb(Vector2(0, 0), 0.3, 2.0)
	var bomb3: NormalBomb = create_normal_bomb(Vector2(144, 0), 0.3, 2.0)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(-144, -64), 0.3, 2, trick_num%3 + 1)
	var bomb5: NumericBomb = create_numeric_bomb(Vector2(0, -64), 0.3, 2, (trick_num + 2)%3 + 1)
	var bomb6: NumericBomb = create_numeric_bomb(Vector2(144, -64), 0.3, 2, (trick_num + 1)%3 + 1)
	var last_bomb: NumericBomb = create_numeric_bomb(Vector2(0, -192), 2, 1, 4)
	
	var tween1_position_change = get_tree().create_tween()
	var tween2_position_change = get_tree().create_tween()
	var tween3_position_change = get_tree().create_tween()
	tween1_position_change.tween_property(bomb4, "position", Vector2(-144,0), 0.3)
	tween2_position_change.tween_property(bomb5, "position", Vector2(0,0), 0.3)
	tween3_position_change.tween_property(bomb6, "position", Vector2(144,0), 0.3)
	
	last_bomb.connect("player_body_entered", Callable(self, "pattern_trickery_end"))
	
func pattern_trickery_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_trickery_playing_time) / Engine.time_scale)
	pattern_list.erase(pattern_trickery)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_trickery)
	
#pattern_trickery block end
###############################

###############################
# pattern_darksight block start
# made by seokhee

#캐릭터 위치 정도는 기억하시죠?
#당황시킬 수 있기에 circlest 정도 잡는 게 좋을 것 같습니다 
# 수정사항 : darksight fade_in time 소폭 증가, numeric bomb 추가
const pattern_darksight_playing_time = 6.75

var pattern_darksight_darksight_node: Darksight

func pattern_darksight():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var bomb1 : NumericBomb = create_numeric_bomb(Vector2(128,0), 1, 5, 1)
	var bomb2 : NumericBomb = create_numeric_bomb(Vector2(-128,0), 1, 5, 2)
	var bomb3 : NumericBomb = create_numeric_bomb(Vector2(0,128), 1, 5, 4)
	var bomb4 : NumericBomb = create_numeric_bomb(Vector2(0,-128), 1, 5, 5)
	
	var ccw_x : int = 1 if randi()%2 == 1 else -1
	var ccw_y : int = 1 if randi()%2 == 1 else -1
	
	var random_pos_numeric_bomb : NumericBomb = create_numeric_bomb(Vector2(ccw_x * 128, ccw_y * 128), 1, 5, 3)
	
	var link1 = create_bomb_link(bomb1, bomb2)
	var link2 = create_bomb_link(bomb3, bomb4)
	
	link2.connect("both_bombs_removed", Callable(self, "pattern_darksight_end"))
	
	#await get_tree().create_timer(1)
	pattern_darksight_darksight_node = Darksight.create()
	add_child(pattern_darksight_darksight_node)
	
func pattern_darksight_end():
	pattern_darksight_darksight_node.fade_out()
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_darksight_playing_time) / Engine.time_scale)
	await get_tree().create_timer(1).timeout
	pattern_list.erase(pattern_darksight)
	pattern_shuffle_and_draw()
	pattern_list.append(pattern_darksight)
	
#pattern_darksight block end
###############################
