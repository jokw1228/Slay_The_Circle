extends CharacterBody2D
class_name Player

@export var PlayerRayCast2D_node: RayCast2D
@export var PlayerSprite2D_node: AnimatedSprite2D

signal grounded
signal shooted(player_velocity: Vector2)

var click_queue: Array[Vector2]
var movement_queue: Array[Vector2]
var is_moving: bool = false
var current_position: Vector2 = Vector2.ZERO

const CIRCLE_FIELD_RADIUS = 256
const player_radius = 16

func _ready():
	var start_position: Vector2 = Vector2(0.0, CIRCLE_FIELD_RADIUS - player_radius)
	movement_queue.push_back(start_position)

func _physics_process(_delta):
	_click_queue_proccessing()
	_movement_queue_proccessing()
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT\
		and event.pressed\
		and PlayingFieldInterface.is_player_input_enabled\
		# store mouse input coordinates in queue
		# store up to 4
		and click_queue.size() < 4:
		click_queue.push_back(get_global_mouse_position())

func _click_queue_proccessing():
	if not click_queue.is_empty() and movement_queue.is_empty() and not is_moving:
		var popped_position: Vector2 = click_queue.pop_front()
		
		const click_available_offset = 64
		if popped_position.length() > CIRCLE_FIELD_RADIUS - click_available_offset:
			movement_queue.push_back( (CIRCLE_FIELD_RADIUS - player_radius) * popped_position.normalized() )
		else:
			PlayerRayCast2D_node.look_at(popped_position)
			await get_tree().physics_frame
			await get_tree().physics_frame
			movement_queue.push_back( PlayerRayCast2D_node.get_collision_point().normalized() * (CIRCLE_FIELD_RADIUS - player_radius) )

func _movement_queue_proccessing():
	if not movement_queue.is_empty():
		# start moving
		is_moving = true
		var position_to_go: Vector2 = movement_queue.pop_front()
		current_position = position_to_go # 이동 중에는 가야 하는 위치 저장하기
		
		# actual movement
		const speed = 2048.0
		velocity = (position_to_go - position).normalized() * speed
		shooted.emit(velocity) # shooted signal emit
		var d: Vector2 = position_to_go - position
		var distance: float = sqrt(d.x * d.x + d.y * d.y)
		var timer: SceneTreeTimer = get_tree().create_timer(distance / speed)
		
		await timer.timeout
		velocity = Vector2.ZERO
		position = position_to_go
		grounded.emit() # grounded signal emit
		is_moving = false

func now_position() -> Vector2:
	return current_position
