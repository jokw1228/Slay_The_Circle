extends Sprite2D
class_name BombDeathEffect

const max_radius = 64
const max_angle = PI
const end_time = 1.0

var elapsed_time: float = 0.0
var angle_offset: float = 0.0


func _ready():
	'''
	# The parent node of this BombDeathEffect_inst will be queue_freed. 
	await get_tree().create_timer(end_time).finished
	queue_free()
	'''
	
	var tween_scale: Tween = get_tree().create_tween()
	tween_scale.tween_property(self, "scale", Vector2.ZERO, end_time)
	


func _process(delta):
	elapsed_time += delta
	var radius: float = max_radius * sin(PI*elapsed_time/end_time)
	var radian: float = angle_offset + max_angle * elapsed_time/end_time
	position = Vector2(radius * cos(radian), radius * sin(radian))
