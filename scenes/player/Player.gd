extends CharacterBody2D
class_name Player

signal change_click_queue_to_movement_queue(click_position)
signal grounded
signal shooted

var click_queue: Array
var is_raycasting: bool = false
var movement_queue: Array
var is_moving: bool = false
var current_position = null

func _physics_process(_delta):
	_movement_queue_proccessing()
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# store mouse input coordinates in queue
		# store up to 4
		if click_queue.size() < 4:
			click_queue.push_back(get_global_mouse_position())

func _on_player_ray_cast_2d_move_player(position_to_go):
	movement_queue.push_back(position_to_go)
	is_raycasting = false

func _movement_queue_proccessing():
	if is_moving == false && not movement_queue.is_empty():
		# start moving
		shooted.emit()
		is_moving = true
		var position_to_go = movement_queue.pop_front()
		current_position = position_to_go # 이동 중에는 가야 하는 위치 저장하기
		
		# actual movement
		var speed: float = 2048
		velocity = (position_to_go - position).normalized() * speed
		var d = position_to_go - position
		var distance: float = sqrt(d.x * d.x + d.y * d.y)
		var timer = get_tree().create_timer(distance / speed)
		await timer.timeout
		velocity = Vector2.ZERO
		position = position_to_go
		
		# adjust ground offset
		const GROUND_OFFSET = 16
		const CIRCLE_FIELD_RADIUS = 256
		position = position.normalized() * (CIRCLE_FIELD_RADIUS - GROUND_OFFSET)
		
		# grounded signal emit
		grounded.emit()
		is_moving = false
		
	if is_moving == false && not click_queue.is_empty() && is_raycasting == false:
		change_click_queue_to_movement_queue.emit(click_queue.pop_front())
		is_raycasting = true

func now_position() -> Vector2:
	if is_moving == false and click_queue.is_empty(): # 플레이어가 가만히 있는 경우
		return get_global_transform().origin
	else:
		return current_position # 플레이어가 움직이는 중인 경우
