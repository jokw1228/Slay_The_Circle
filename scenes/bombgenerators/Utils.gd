extends Node2D

var fixed_node: Array[Node2D]
var fixed_target: Array[Node2D]


# node가 지정된 position의 위치를 따라가도록 설정.
# 움직이는 폭탄 구현에 사용하였으나 모든 노드에 사용 가능.
func attach_node(target: Node2D, node: Node2D):
	fixed_node.append(node)
	fixed_target.append(target)

func _process(_delta):
	for i in range(len(fixed_node)):
		if not is_instance_valid(fixed_node[i]) or not is_instance_valid(fixed_target[i]):
			continue
		fixed_node[i].global_position = fixed_target[i].global_position