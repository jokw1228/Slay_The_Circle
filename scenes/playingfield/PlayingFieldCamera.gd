extends Camera2D
class_name PlayingFieldCamera

@export var GlitchEffect_node: Node2D


var rotation_amount: float = 0
var rotation_direction = 1.0
var bomb_position: Vector2 = Vector2(0, 0)

func _ready():
	GlitchEffect_node.visible = false

func _process(delta):
	rotation += rotation_amount * rotation_direction * delta / Engine.time_scale

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
	tween1.tween_property(self,"zoom",Vector2(2,2),0.25)
	await get_tree().create_timer(1).timeout
	var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(self,"zoom",Vector2(1,1),0.25)

func position_transition(x: Vector2, y: float):
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"position",x,y)

func rotation_transition():
	var tween1 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(self,"rotation",0.0,0.4)
	
func set_bomb_position(x: Vector2):
	bomb_position = x

func gameover_position_transition():
	#GlitchEffect_node.visible = true
	#GlitchEffect_node.rotation = self.rotation
	var time_for_trans: float = 0.3
	position_transition(bomb_position, time_for_trans)
	await get_tree().create_timer(time_for_trans).timeout
	
	await get_tree().create_timer(0.7).timeout
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"position",Vector2(0,0),0.25)
	#GlitchEffect_node.visible = false
