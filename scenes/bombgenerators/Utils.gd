extends Node2D

var fixed_node: Array[Node2D]
var fixed_target: Array[Node2D]


# node가 지정된 position의 위치를 따라가도록 설정.
# 움직이는 폭탄 구현에 사용하였으나 모든 노드에 사용 가능.
func attach_node(target: Node2D, node: Node2D):
	fixed_node.append(node)
	fixed_target.append(target)

# alias
func attach(target: Node2D, node: Node2D):
	attach_node(target, node)

# get_tree().create_timer().timeout 너무 길어..
func timer(time: float):
	return get_tree().create_timer(time).timeout

# UI 애니메이션 구현할 때 사용
# offset이 날아가는 거리, direction은 날아갈 방향
var original_position: Dictionary
var previous_tween: Dictionary
func slide(node: Control, offset: float, direction: Vector2, duration: float):
	if not original_position.has(node):
		original_position[node] = node.position
	if previous_tween.has(node):
		previous_tween[node].kill()
		previous_tween.erase(node)
	node.position = original_position[node] - offset * direction
	previous_tween[node] = tween()
	previous_tween[node].tween_property(node, "position", node.position + offset * direction, duration)

func tween():
	return get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _process(_delta):
	for i in range(len(fixed_node)):
		if not is_instance_valid(fixed_node[i]) or not is_instance_valid(fixed_target[i]):
			continue
		fixed_node[i].global_position = fixed_target[i].global_position
