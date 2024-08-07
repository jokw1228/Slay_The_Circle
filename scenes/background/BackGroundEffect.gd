extends Node2D
class_name BackGroundEffect

@export var font: Font
@export var BackGroudEffectDrawer_Scene: PackedScene

var speed_up_times: int = 0
var rotation_up_times: int = 0

func text_effect(text: String, circle_index: int, arc_index: int, theme_color: Color = Color(1,1,1,1)):
	const radius_offset = 320
	const radius_difference = 64
	
	var center: Node2D = Node2D.new()

	var radian_of_arc: float = (PI/2)
	
	for i in range(text.length()):
		var text_eft = BackGroudEffectDrawer_Scene.instantiate()
		text_eft.theme_color = theme_color
		text_eft.font = font
		text_eft.radius = radius_offset + (circle_index-1) * radius_difference
		text_eft.text_to_print = text[i]
		text_eft.rotate((arc_index-1)*(PI/2))
		text_eft.rotate(-(i*radian_of_arc)/text.length())
		center.add_child(text_eft)
	
	add_child(center)
	var tween_rotate = get_tree().create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)
	tween_rotate.tween_property(center,"rotation",4*PI,2.0)
	await Utils.timer(2.0)
	tween_rotate.kill()
	remove_child(center)
	
func speed_up():
	text_effect("GAME SPEED UP!",1,2)
	speed_up_times += 1
	text_effect(("LEVEL:"+str(speed_up_times)),1,4)
	
func rotation_up():
	text_effect("ROTATION SPEED UP!",2,3)
	rotation_up_times += 1
	text_effect(("LEVEL:"+str(rotation_up_times)),2,1)
	
func rotation_inversion():
	text_effect("ROTATION INVESRION!",3,1)
		
func game_over_reset():
	speed_up_times = 0
	rotation_up_times = 0
