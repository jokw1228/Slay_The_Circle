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
	pattern_list.append(Callable(self, "pattern_fruitninja"))

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

###############################
# pattern_fruitninja block start
# made by Seonghyeon

# Hyper에서 normal 사이에 hazard 끼워 넣으면 재미있을 듯
# 마지막 폭탄 일찍 종료 안하면 0.5초 쯤 길어짐
# 이렇게 짧은 친구들도 일찍 종료 걸어야 할까?
func pattern_fruitninja():
	PlayingFieldInterface.set_theme_color(Color.HOT_PINK)

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
				print(timer.time_left)
				for rigidbody in rigidbodies:
					rigidbody.queue_free()
				
				PlayingFieldInterface.add_playing_time(timer.time_left)
				pattern_shuffle_and_draw()
			)
		await Utils.timer(0.7)
# pattern_fruitninja block end
###############################