extends BombGenerator

@export var pattern1_rotation_marker: Node2D
@export var pattern1_bomb_marker: Node2D
@export var pattern1_rotation_locations: Array[Node2D]
@export var pattern1_bomb_locations: Array[Node2D]

@export var pattern2_bomb_locations: Array[Node2D]
@export var pattern2_off_duration: float
@export var pattern2_on_duration: float
@export var pattern2_count: int
@export var pattern2_speedup_amount: float

@export var pattern3_rigidbody: RigidBody2D
@export var pattern3_marker: Node2D

func _ready():

	# create_rotationspeedup_bomb(Vector2.ZERO, 0, 1, 1)
	await get_tree().create_timer(1.0).timeout
	
	# pattern1_ready()
	# pattern2_ready()
	pattern5_ready()
	
func _process(delta):
	pass
	# pattern1_process(delta)

func _physics_process(delta):
	pass
	# pattern4_physics_process(delta)

# 움직이는 패턴 살짝 써봄
# 경고가 따라 움직이지 않는 것 외엔 잘 되는 편..
const pattern1_rotation_speed: float = 3
var pattern1_rotation_enabled: bool = false

func pattern1_ready():
	for location in pattern1_rotation_locations:
		Utils.attach_node(location, create_hazard_bomb(location.position, 0.5, 3))
	
	await get_tree().create_timer(0.7).timeout
	# 플레이어가 위에 있을 시 뒤집지 않고, 아래에 있을 시 180도 뒤집어서 진행.
	if PlayingFieldInterface.get_player_position().y > 0: pattern1_bomb_marker.rotation_degrees = 180
	create_normal_bomb(pattern1_bomb_locations[0].global_position, 0.5, 0.7)
	
	await get_tree().create_timer(0.3).timeout
	pattern1_rotation_enabled = true

	create_normal_bomb(pattern1_bomb_locations[1].global_position, 0.8, 0.7)
	
	await get_tree().create_timer(0.6).timeout
	create_normal_bomb(pattern1_bomb_locations[2].global_position, 0.8, 0.7)
	
	await get_tree().create_timer(0.6).timeout
	create_normal_bomb(pattern1_bomb_locations[3].global_position, 0.8, 0.7)


func pattern1_process(delta):
	if pattern1_rotation_enabled:
		pattern1_rotation_marker.rotation += pattern1_rotation_speed * delta

# BombGenerator쪽에서 언제 특정 폭탄이 slay되었는지 알 수 있는 방법이 제공되었으면 좋겠다. (시그널..?)
# 5초 짜리 긴 패턴을 빠르게 해치운 경우 BombGenerator쪽에서는 이를 감지하고 빨리 다음 폭탄을 넘겨줄 수가 없다.
func pattern2_ready():
	for i in range(pattern2_count):
		var bombs: Array[Bomb] = []
		for j in range(len(pattern2_bomb_locations)):
			bombs.append(create_normal_bomb(pattern2_bomb_locations[j].global_position, 0.5, pattern2_on_duration))
		bombs.shuffle()
		create_bomb_link(bombs[0], bombs[1])

		await timer(pattern2_on_duration + 0.5).timeout
		if randi_range(0, 1): create_rotationspeedup_bomb(Vector2.ZERO, 0.5, pattern2_off_duration, pattern2_speedup_amount)
		else: create_rotationinversion_bomb(Vector2.ZERO, 0.5, pattern2_off_duration)

		await timer(pattern2_off_duration + 0.3).timeout

# 물리엔진?
func pattern3_ready():
	var rigidbody: Array[RigidBody2D] = [RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new(), RigidBody2D.new()]
	var direction: Array[int] = [1, -1, 1, 1, -1]
	for i in range(5):
		rigidbody[i].gravity_scale = 1.5
		add_child(rigidbody[i])

		await timer(0.7).timeout
		Utils.attach_node(rigidbody[i], create_normal_bomb(rigidbody[i].global_position, 0, 1.0))
		rigidbody[i].linear_velocity = Vector2(direction[i] * 600, -900 + randf_range(-200, 100))
		rigidbody[i].position = Vector2(-direction[i] * 400, 281)

		# await timer(2).timeout

# 유도탄
# 그냥 폭탄의 애드온으로 분리해도 될 듯?
# https://kidscancode.org/godot_recipes/3.x/ai/homing_missile/index.html
# @export var pattern4_marker: Node2D
# @export var pattern4_max_speed: Vector2
# @export var steer_force: float

# var velocity = [Vector2.ZERO]
# var accel = [Vector2.ZERO]
# var pos = [Node2D.new()]
# func pattern4_ready():
# 	for p in pos:
# 		add_child(p)
# 		p.global_position = pattern4_marker.global_position

# 		Utils.attach_node(p, create_hazard_bomb(pattern4_marker.global_position, 1, 5))


# func pattern4_physics_process(delta):
# 	for i in range(len(velocity)):
# 		var desired = (PlayingFieldInterface.get_PlayingField_node().Player_node.global_position - pos[i].global_position).normalized() * pattern4_max_speed
# 		accel[i] = (desired - velocity[i]).normalized() * steer_force

# 		velocity[i] += accel[i] * delta
# 		velocity[i] = velocity[i].clamp(-pattern4_max_speed, pattern4_max_speed)
# 		pos[i].global_position += velocity[i] * delta

@export var pattern5_positions: Array[Node2D]
func pattern5_ready():
	var b1 = create_hazard_bomb(pattern5_positions[0].global_position, 0.5, 1)
	var b2 = create_hazard_bomb(pattern5_positions[1].global_position, 0.5, 2)
	var b3 = create_hazard_bomb(pattern5_positions[2].global_position, 0.5, 3)
	var b4 = create_hazard_bomb(pattern5_positions[3].global_position, 0.5, 4)
	var b5 = create_hazard_bomb(pattern5_positions[4].global_position, 0.5, 5)

	await timer(1.5).timeout
	var b6 = create_normal_bomb(b1.global_position, 0, 1.2)
	# var b11 = create_hazard_bomb(b6.global_position, 1, 5) # warningtime의 1초와 bombtime의 1초가 다른 버그?
	await timer(1).timeout
	var b7 = create_normal_bomb(b2.global_position, 0, 1.2)
	# var b12 = create_hazard_bomb(b7.global_position, 1, 5)
	await timer(1).timeout
	var b8 = create_normal_bomb(b3.global_position, 0, 1.2)
	# var b13 = create_hazard_bomb(b8.global_position, 1, 5)
	await timer(1).timeout
	var b9 = create_normal_bomb(b4.global_position, 0, 1.2)
	# var b14 = create_hazard_bomb(b9.global_position, 1, 5)
	await timer(1).timeout
	var b10 = create_normal_bomb(b5.global_position, 0, 1.2)
	# var b15 = create_hazard_bomb(b10.global_position, 1, 5)


@export var pattern6_positions: Array[Node2D]
func pattern6_ready():
	var b1 = create_hazard_bomb(pattern6_positions[4].global_position, 0.5, 2)
	var b2 = create_hazard_bomb(pattern6_positions[1].global_position, 0.5, 2)
	var b3 = create_hazard_bomb(pattern6_positions[2].global_position, 0.5, 2)
	var b4 = create_hazard_bomb(pattern6_positions[3].global_position, 0.5, 2)
	var b5 = create_hazard_bomb(pattern6_positions[5].global_position, 0.5, 1.7)
	var b6 = create_hazard_bomb(pattern6_positions[6].global_position, 0.5, 1.7)
	var b7 = create_normal_bomb(pattern6_positions[0].global_position, 1.5, 1.2) # warningtime의 1초와 bombtime의 1초가 다른 버그?

func timer(time: float):
	return get_tree().create_timer(time)
