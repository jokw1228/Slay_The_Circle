extends CharacterBody2D
class_name Player

@export var PlayerRayCast2D: RayCast2D

signal change_click_queue_to_movement_queue(click_position)

var click_queue: Array
var is_raycasting: bool = false
var movement_queue: Array
var is_moving: bool = false

func _draw():
	draw_arc(position, 32, 0, 2 * PI, 9, Color.WHITE, 4.0, false)

func _physics_process(_delta):
	_movement_queue_proccessing()
	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		click_queue.push_back(get_global_mouse_position())

func _on_player_ray_cast_2d_move_player(position_to_go):
	movement_queue.push_back(position_to_go)
	is_raycasting = false

func _movement_queue_proccessing():
	if is_moving == false && not movement_queue.is_empty():
		is_moving = true
		var position_to_go = movement_queue.pop_front()
		
		var speed: float = 2048
		velocity = (position_to_go - position).normalized() * speed
		var d = position_to_go - position
		var distance: float = sqrt(d.x * d.x + d.y * d.y)
		var timer = get_tree().create_timer(distance / speed)
		await timer.timeout
		velocity = Vector2.ZERO
		position = position_to_go
		
		is_moving = false
	if is_moving == false && not click_queue.is_empty() && is_raycasting == false:
		change_click_queue_to_movement_queue.emit(click_queue.pop_front())
		is_raycasting = true
