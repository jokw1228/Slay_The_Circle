extends BombGenerator

@export var timer = false
@export var elapsed_time = 0.0

@export var pattern2_bomb: Array[Node2D]
@export var pattern2_moving = false

func _ready():
	timer = true
	await get_tree().create_timer(1.0).timeout
	
	pattern2()
	await get_tree().create_timer(12.0).timeout
	
	pattern2()


func _process(delta):
	if timer:
		elapsed_time += delta
	pattern2_process(delta)


func pattern1():
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


func pattern2():
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

