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

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

func _process(delta):
	pattern_rotate_timing_process(delta)

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

var pattern_rotate_timing_bomb: Array
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
var pattern_survive_random_slay_timer_hazard: Array
var pattern_survive_random_slay_timer_bombs: Array
var pattern_survive_random_slay_timer_active: bool = false

func pattern_survive_random_slay():
	pattern_survive_random_slay_timer_hazard.clear()
	pattern_survive_random_slay_timer_bombs.clear()
	pattern_survive_random_slay_timer_active = false
	
	pattern_survive_random_slay_timer = 4.3
	
	if pattern_survive_random_slay_timer_tween != null:
		pattern_survive_random_slay_timer_tween.kill()
	pattern_survive_random_slay_timer_tween = get_tree().create_tween()
	pattern_survive_random_slay_timer_tween.tween_property(self, "pattern_survive_random_slay_timer", 0, 4.3)
	
	await Utils.timer(0.3)
	pattern_survive_random_slay_timer_active = true
	pattern_survive_random_slay_outer()
	pattern_survive_random_slay_bomb0()
	

func pattern_survive_random_slay_bomb0():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_timer_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_timer_bombs[0].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb1"))

func pattern_survive_random_slay_bomb1():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_timer_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_timer_bombs[1].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb2"))

func pattern_survive_random_slay_bomb2():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_timer_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_timer_bombs[2].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_bomb3"))

func pattern_survive_random_slay_bomb3():
	var rotation_value = randf_range(0,2*PI)
	var dist = randf_range(0,120)
	pattern_survive_random_slay_timer_bombs.append(create_normal_bomb(Vector2(dist*cos(rotation_value), dist*sin(rotation_value)), 0, 1))
	pattern_survive_random_slay_timer_bombs[3].connect("player_body_entered",Callable(self,"pattern_survive_random_slay_end"))

func pattern_survive_random_slay_outer():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var rotation_value = player_angle + PI
	while pattern_survive_random_slay_timer_active == true:
		pattern_survive_random_slay_timer_hazard.append(create_hazard_bomb(Vector2(256*cos(rotation_value), 256*sin(rotation_value)), 0, 0.15))
		rotation_value -= PI / 8
		await Utils.timer(0.07)
		
func pattern_survive_random_slay_end():
	pattern_survive_random_slay_timer_active = false
	for node in pattern_survive_random_slay_timer_hazard:
		if is_instance_valid(node):
			node.queue_free()
	PlayingFieldInterface.add_playing_time(pattern_survive_random_slay_timer)
	pattern_shuffle_and_draw()

# pattern_survive_random_slay block end
###############################
