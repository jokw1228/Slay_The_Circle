extends Camera2D
class_name PlayingFieldCamera

var rotation_amount: float = 0
var rotation_direction = 1.0

func _ready():
	#rotation_amount = PI / 4
	pass

func _process(delta):
	rotation += rotation_amount * rotation_direction * delta

func rotation_speed_up(up: float):
	rotation_amount += up

func rotation_inversion():
	rotation_direction *= -1;

func rotation_stop():
	rotation_amount = 0

func rotation_reset():
	rotation = 0
	rotation_direction = 1

func zoom_transition():	
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"zoom",Vector2(2,2),0.5)
	await get_tree().create_timer(2.5).timeout
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(self,"zoom",Vector2(1,1),0.5)

func position_transition(x: Vector2):
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"position",x,0.5)
	await get_tree().create_timer(2.5).timeout
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(self,"position",Vector2(0,0),0.5)
