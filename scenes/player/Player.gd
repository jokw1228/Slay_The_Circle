extends CharacterBody2D

@export var PlayerRayCast2D: RayCast2D

signal slay

var moving_queue: Array
var is_moving = false

func _draw():
	draw_arc(position, 32, 0, 2 * PI, 9, Color.WHITE, 4.0, false)

func _physics_process(_delta):
	_moving_queue_proccessing()
	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		look_at(get_global_mouse_position())
		slay.emit()

func _on_player_ray_cast_2d_move_player(position_to_go):
	moving_queue.push_back(position_to_go)

func _moving_queue_proccessing():
	if is_moving == false && not moving_queue.is_empty():
		is_moving = true
		var position_to_go = moving_queue.pop_front()
		
		var speed: float = 2048
		velocity = (position_to_go - position).normalized() * speed
		var d = position_to_go - position
		var distance: float = sqrt(d.x * d.x + d.y * d.y)
		var timer = get_tree().create_timer(distance / speed)
		await timer.timeout
		velocity = Vector2.ZERO
		position = position_to_go
		
		is_moving = false
