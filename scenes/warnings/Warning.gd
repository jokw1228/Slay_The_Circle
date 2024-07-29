extends Area2D
class_name Warning

@export var warningtime: float = 1.5
var elapsed_time = 0.0
var timer = false
var child_node

func _ready():
	timer = true
	child_node = get_node("Sprite2D")
	
	await get_tree().create_timer(warningtime).timeout
	queue_free()

func _process(delta):
	if timer:
		elapsed_time += delta
		
	if warningtime - elapsed_time > 1.0:
		if int(elapsed_time * 10) % 2 == 1:
			warning_visible()
		else:
			warning_invisible()
	else:
		if int(elapsed_time * 20) % 2 == 1:
			warning_invisible()
		else:
			warning_visible()

func warning_invisible():
	child_node.modulate.a = 0
	
	
func warning_visible():
	child_node.modulate.a = 1
