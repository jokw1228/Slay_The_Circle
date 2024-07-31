extends BombGenerator

@export var timer = false
@export var elapsed_time = 0.0

@export var pattern2_bomb: Array[Node2D]
@export var pattern2_moving = false

@export var pattern4_bomb: Array[Node2D]
@export var pattern4_real_bomb: Node2D
@export var pattern4_moving = false

@export var pattern6_bomb: Array[Node2D]
@export var pattern6_moving = false

func _ready():
	timer = true
	while 1:	
		await get_tree().create_timer(1.0).timeout
	
		pattern1()
		await get_tree().create_timer(12.0).timeout
	
		pattern2()
		await get_tree().create_timer(3.5).timeout
		pattern2()
		await get_tree().create_timer(3.5).timeout
	
		pattern3()
		await get_tree().create_timer(4.5).timeout
	
		pattern4()
		await get_tree().create_timer(7).timeout
	
		pattern5()
		await get_tree().create_timer(13).timeout
	
		pattern6()
		await get_tree().create_timer(3.5).timeout
		pattern6()
		await get_tree().create_timer(3.5).timeout
	
		create_gamespeedup_bomb(Vector2(0,0), 1, 1, 0.1)
		await get_tree().create_timer(2.5).timeout


func _process(delta):
	if timer:
		elapsed_time += delta
	pattern2_process(delta)
	pattern4_process(delta)
	pattern6_process(delta)


func pattern1(): # 10s
	pattern1_outer(elapsed_time)
	for i in range(0,5):
		var rotation_value = randf_range(0,2*PI)
		var dist = randf_range(0,120)
		create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0.5, 2)
		await get_tree().create_timer(2).timeout
		

func pattern1_outer(time: float):
	var start_time = time
	var rotation_value = 0
	while elapsed_time < start_time + 10:
		create_hazard_bomb(Vector2(220*sin(rotation_value), 220*cos(rotation_value)), 0.5, 0.2)
		rotation_value += PI / 8
		await get_tree().create_timer(0.07).timeout


func pattern2(): # 3s
	create_hazard_bomb(Vector2(180, 60), 1, 3)
	create_hazard_bomb(Vector2(-180, 60), 1, 3)
	create_hazard_bomb(Vector2(180, -60), 1, 3)
	create_hazard_bomb(Vector2(-180, -60), 1, 3)
	var bomb1 = create_normal_bomb(Vector2(0, 0), 1, 3)
	var bomb2 = create_normal_bomb(Vector2(0, 0), 1, 3)
	Utils.attach_node(pattern2_bomb[0], bomb1)
	Utils.attach_node(pattern2_bomb[1], bomb2)
	create_bomb_link(bomb1, bomb2)

const pattern2_speed = 500
var bomb_direction = [1, -1]
var bomb_dir_changed = [false, false]

func pattern2_process(delta):
	pattern2_bomb[0].position.x += pattern2_speed * bomb_direction[0] * delta
	pattern2_bomb[1].position.x += pattern2_speed * bomb_direction[1] * delta
	for i in range(2):
		if (pattern2_bomb[i].position.x > 170 or pattern2_bomb[i].position.x < -170) and bomb_dir_changed[i] == false:
			bomb_dir_changed[i] = true
			bomb_direction[i] *= -1
		else:
			bomb_dir_changed[i] = false


func pattern3(): # 4s
	var vector = [Vector2(100, 100), Vector2(-100, 100), Vector2(100, -100), Vector2(-100, -100)]
	vector.shuffle()
	var bombs = []
	for i in range(4):
		bombs.append(create_numeric_bomb(vector[i], 1.2, 4, i + 1))
	create_bomb_link(bombs[0], bombs[1])
	create_bomb_link(bombs[2], bombs[3])


const pos = 144
var rand = [0, 0, 0, 1]
const const_position = [Vector2(-pos, -pos), Vector2(pos, -pos), Vector2(-pos, pos), Vector2(pos, pos)]
var bomb_pos = [1, 2, 3, 4] # 각 폭탄의 현재 위치
	
func pattern4(): # 6.2s
	var bombs = []
	bomb_pos = [1, 2, 3, 4]
	rand.shuffle()
	var prev_value = 5
	var real_bomb
	var real_bomb_position
	
	for i in range(4):
		if rand[i]:
			bombs.append(create_hazard_bomb(const_position[i], 6, 0))
			pattern4_real_bomb.position = const_position[i]
			real_bomb = create_normal_bomb(const_position[i], 6, 1)
			Utils.attach_node(pattern4_real_bomb, real_bomb)
			real_bomb_position = i
		else:
			bombs.append(create_hazard_bomb(const_position[i], 6, 1))
		Utils.attach_node(pattern4_bomb[i], bombs[i])
		pattern4_bomb[i].position = const_position[i]
		
	await get_tree().create_timer(0.5).timeout
	pattern4_real_bomb.position = Vector2(1000, 1000)
	
	for i in range(10):
		var rand_result = randi_range(0,4)
		while rand_result == prev_value:
			rand_result = randi_range(0,4)
		prev_value = rand_result
		await pattern4_random(rand_result)
		await get_tree().create_timer(0.06).timeout
		
	await get_tree().create_timer(1.49).timeout
	pattern4_real_bomb.position = pattern4_bomb[real_bomb_position].position

func pattern4_random(pattern: int):
	match pattern:
		0:
			await pattern4_move([2, 4, 1, 3]) # Clockwise
		1:
			await pattern4_move([3, 1, 4, 2]) # Counterclockwise
		2:
			await pattern4_move([3, 4, 1, 2]) # Swap vertically
		3:
			await pattern4_move([2, 1, 4, 3]) # Swap horizontally
		4:
			await pattern4_move([4, 3, 2, 1]) # Swap diagonally

var pattern4_direction = [0,0,0,0]
var pattern4_distance = [0,0,0,0]
var pattern4_moveseed = [0,0,0,0]
var pattern4_speed = [0,0,0,0]

func pattern4_move(setseed: Array):
	for i in range(4):
		pattern4_moveseed[i] = setseed[i]
	for i in range(4):
		pattern4_speed[i] = (const_position[pattern4_moveseed[bomb_pos[i] - 1]- 1] - pattern4_bomb[i].position).length() * 4
		# print(pattern4_speed[i])
	# print(------)
	pattern4_moving = true
	await get_tree().create_timer(0.334).timeout
	pattern4_moving = false
	# for i in range(4):
		# pattern4_bomb[i].position = const_position[pattern4_moveseed[bomb_pos[i] - 1]- 1]
	for i in range(4):
		bomb_pos[i] = pattern4_moveseed[bomb_pos[i] - 1]

func pattern4_process(delta):
	if pattern4_moving == true:
		for i in range(4):
			pattern4_direction[i] = (const_position[pattern4_moveseed[bomb_pos[i] - 1]- 1] - pattern4_bomb[i].position).normalized()
			pattern4_distance[i] = (const_position[pattern4_moveseed[bomb_pos[i] - 1]- 1] - pattern4_bomb[i].position).length()
			
			if pattern4_distance[i] > 3:
				pattern4_bomb[i].position += pattern4_direction[i] * pattern4_speed[i] * delta
			else:
				pattern4_bomb[i].position = const_position[pattern4_moveseed[bomb_pos[i] - 1]- 1]


func pattern5(): # 12s
	var prev_value
	for i in range(12):
		create_normal_bomb(Vector2(0,0), 0, 1)
		var rand_result = randi_range(0,5)
		while rand_result == prev_value:
			rand_result = randi_range(0,5)
		prev_value = rand_result
		pattern5_random(rand_result)
		await get_tree().create_timer(1).timeout

func pattern5_random(pattern: int):
	match pattern:
		0: # cross
			var x = [0,0,0,0,0,100,200,-100,-200]
			var y = [0,100,200,-100,-200,0,0,0,0]
			for i in range(9):
				create_hazard_bomb(Vector2(x[i],y[i]), 1, 0.1)
		1: # outer circle
			var rotation_value = 0
			for i in range(16):
				create_hazard_bomb(Vector2(220*sin(rotation_value), 220*cos(rotation_value)), 1, 0.05)
				rotation_value += PI / 8
		2: # x
			var x = [0,75,75,150,150,-75,-75,-150,-150]
			var y = [0,75,-75,150,-150,75,-75,150,-150]
			for i in range(9):
				create_hazard_bomb(Vector2(x[i],y[i]), 1, 0.1)
		3: # *
			pattern5_random(0)
			pattern5_random(2)
		4: # diamond
			var x = [150,75,75,0,0,-75,-75,-150]
			var y = [0,75,-75,150,-150,75,-75,0]
			for i in range(8):
				create_hazard_bomb(Vector2(x[i],y[i]), 1, 0.1)
		5: # star
			var rotation_value = 0
			for i in range(5):
				create_hazard_bomb(Vector2(220*sin(rotation_value), 220*cos(rotation_value)), 1, 0.1)
				rotation_value += PI / 2.5
			rotation_value = PI / 5
			for i in range(5):
				create_hazard_bomb(Vector2(90*sin(rotation_value), 90*cos(rotation_value)), 1, 0.1)
				rotation_value += PI / 2.5


func pattern6(): # 3s
	create_normal_bomb(Vector2(0,0), 1, 2)
	pattern6_moving = true
	pattern6_random = randi_range(0,1)
	if pattern6_random == 0:
		pattern6_random = -1
		
	var bombs = []
	for i in range(6):
		bombs.append(create_hazard_bomb(Vector2(0,0), 1, 2))
		Utils.attach_node(pattern6_bomb[i], bombs[i])
		pattern6_bomb[i].position = pattern6_position[i]

var pattern6_position = [Vector2(p6sp, p6sp), Vector2(p6sp, 0), Vector2(p6sp, -p6sp), Vector2(-p6sp, p6sp), Vector2(-p6sp, 0), Vector2(-p6sp, -p6sp)]
const p6sp = 80
var pattern6_direction = [0,0,0,0,0,0]
const pattern6_rotation_speed = 160
const pattern6_speed = [pattern6_rotation_speed*sqrt(2), pattern6_rotation_speed, pattern6_rotation_speed*sqrt(2), pattern6_rotation_speed*sqrt(2), pattern6_rotation_speed, pattern6_rotation_speed*sqrt(2)]
var pattern6_random

func pattern6_process(delta):
	if pattern6_moving == true:
		for i in range(6):
			var x = pattern6_bomb[i].position.x
			var y = pattern6_bomb[i].position.y
			pattern6_direction[i] = Vector2(y * pattern6_random, -x * pattern6_random).normalized()
			pattern6_bomb[i].position += pattern6_direction[i] * pattern6_speed[i] * delta
