extends BombGenerator

@export var pattern1_rotation_marker: Node2D
@export var pattern1_bomb_marker: Node2D
@export var pattern1_rotation_locations: Array[Node2D]
@export var pattern1_bomb_locations: Array[Node2D]

func _ready():
	await get_tree().create_timer(1.0).timeout
	
	pattern1_ready()
	await get_tree().create_timer(5.0).timeout
	
func _process(delta):
	pattern1_process(delta)

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
