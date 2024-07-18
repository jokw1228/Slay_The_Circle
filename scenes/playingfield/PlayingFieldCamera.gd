extends Camera2D
class_name PlayingFieldCamera

@export var GlitchEffect_node: Node2D


var rotation_amount: float = 0
var rotation_direction = 1.0
var position_array: Array = []

func _ready():
	#rotation_amount = PI / 4
	GlitchEffect_node.visible = false
	pass

func _process(delta):
	rotation += rotation_amount * rotation_direction * delta

func rotation_speed_up(up: float):
	rotation_amount += up

func rotation_inversion():
	rotation_direction *= -1;

func rotation_stop():
	rotation_amount = 0
	await get_tree().create_timer(2.0).timeout
	rotation_transition()
	await get_tree().create_timer(0.4).timeout
	rotation_reset()

func rotation_reset():
	rotation = 0
	rotation_direction = 1

func zoom_transition():	
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"zoom",Vector2(2,2),0.5)
	await get_tree().create_timer(2.0).timeout
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(self,"zoom",Vector2(1,1),0.5)

func position_transition(x: Vector2, y: float):
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"position",x,y)

func rotation_transition():
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"rotation",0.0,0.4)

func add_transition(x: Vector2):
	position_array.append(x)

func gameover_position_transition():
	GlitchEffect_node.visible = true
	GlitchEffect_node.rotation = self.rotation
	var times_to_trans: int = len(position_array)
	var time_for_trans: float = 0.5/times_to_trans
	for i in range(times_to_trans):
		position_transition(position_array[i],time_for_trans)
		await get_tree().create_timer(time_for_trans).timeout
	await get_tree().create_timer(1.5).timeout
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"position",Vector2(0,0),0.5)
	position_array.clear()
	GlitchEffect_node.visible = false
