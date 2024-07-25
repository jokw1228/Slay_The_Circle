extends BombGenerator

@export var rotation_field: Node2D
@export var test1: Node2D
@export var test2: Node2D

const rotation_speed: float = 1

var fixed_node: Array[Node2D]
var fixed_target: Array[Node2D]

func _ready():
	await get_tree().create_timer(1.0).timeout
	
	pattern1()
	await get_tree().create_timer(5.0).timeout
	
func _process(delta):
	for i in range(len(fixed_node)):
		if not is_instance_valid(fixed_node[i]):
			continue
		fixed_node[i].position = global_position - fixed_target[i].global_position

	rotation_field.rotation += rotation_speed * delta

func pattern1():
	var bomb1 = create_hazard_bomb(Vector2(-100, 100), 2, 3)
	var bomb2 = create_hazard_bomb(Vector2(100, 100), 2, 3)

	attach_node(test1, bomb1)
	attach_node(test2, bomb2)
	
	
# node가 지정된 position의 위치를 따라가도록 설정.
func attach_node(target: Node2D, node: Node2D):
	fixed_node.append(node)
	fixed_target.append(target)
