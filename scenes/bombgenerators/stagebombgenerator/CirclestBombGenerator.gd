extends BombGenerator
class_name CirclestBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	# pattern_list.append(Callable(self, "pattern_test_1"))
	pattern_list.append(Callable(self, "pattern_moving_link"))

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

func _process(delta):
	pattern_moving_link_process(delta)

###############################
# pattern_test_1 block start

func pattern_test_1():
	await Utils.timer(0.1) # do nothing
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################

###############################
# pattern_moving_link block start
# made by kiyong

var pattern_moving_link_timer: float
var pattern_moving_link_timer_tween: Tween

var pattern_moving_link_bomb: Array
var pattern_moving_link_direction = [0,0,0,0,0,0]
const pattern_moving_link_rotation_speed = 300
const pattern_moving_link_speed = [sqrt(2), 1, sqrt(2), sqrt(2), 1, sqrt(2)]
var pattern_moving_link_random = 1
var pattern_moving_link_moving = false

func pattern_moving_link():
	pattern_moving_link_moving = false
	pattern_moving_link_timer = 1.5
	
	if pattern_moving_link_timer_tween != null:
		pattern_moving_link_timer_tween.kill()
	pattern_moving_link_timer_tween = get_tree().create_tween()
	pattern_moving_link_timer_tween.tween_property(self, "pattern_moving_link_timer", 0, 1.5)
	
	pattern_moving_link_bomb.clear()
	const p6sp = 70
	var pattern_moving_link_position = [Vector2(p6sp, p6sp), Vector2(p6sp, 0), Vector2(p6sp, -p6sp), Vector2(-p6sp, p6sp), Vector2(-p6sp, 0), Vector2(-p6sp, -p6sp)]
	
	var bomb = create_normal_bomb(Vector2(0,0), 0.25, 1.25)
	pattern_moving_link_moving = true
	pattern_moving_link_random = randi_range(0,1)
	if pattern_moving_link_random == 0:
		pattern_moving_link_random = -1
	for i in range(6):
		pattern_moving_link_bomb.append(create_hazard_bomb(Vector2(0, 0), 0.25, 1.25))
		pattern_moving_link_bomb[i].position = pattern_moving_link_position[i]
	
	bomb.connect("player_body_entered",Callable(self,"pattern_moving_link_end"))

func pattern_moving_link_process(delta):
	if pattern_moving_link_moving == true:
		for i in range(6):
			if is_instance_valid(pattern_moving_link_bomb[i]):
				var x = pattern_moving_link_bomb[i].position.x
				var y = pattern_moving_link_bomb[i].position.y
				pattern_moving_link_direction[i] = Vector2(y * pattern_moving_link_random, -x * pattern_moving_link_random).normalized()
				pattern_moving_link_bomb[i].position += pattern_moving_link_direction[i] * pattern_moving_link_rotation_speed * pattern_moving_link_speed[i] * delta

func pattern_moving_link_end():
	for i in range(6):
		pattern_moving_link_bomb[i].queue_free()
	pattern_moving_link_moving = false
	PlayingFieldInterface.add_playing_time(pattern_moving_link_timer)
	pattern_shuffle_and_draw()

# pattern_moving_link block end
###############################
