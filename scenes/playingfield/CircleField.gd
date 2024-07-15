extends StaticBody2D

const CircleFieldRadius = 256
var PlayingFieldColor = Color.WHITE

@export var CircleFieldEffect_scene: PackedScene

func _draw():
	draw_arc(position, CircleFieldRadius, 0, 2 * PI, 50, PlayingFieldColor, 8.0, false)


func _on_circle_field_effect_timer_timeout():
	var inst = CircleFieldEffect_scene.instantiate()
	
	const delay = 1.2
	
	inst.survival_time = delay
	
	inst.width_to_draw = 6.0
	
	var tween_alpha = get_tree().create_tween()
	tween_alpha.tween_property(inst, "color_to_draw", Color(PlayingFieldColor.r, PlayingFieldColor.g, PlayingFieldColor.b, 0.0), delay)
	
	var tween_radius = get_tree().create_tween()
	tween_radius.tween_property(inst, "radius_to_draw", CircleFieldRadius + 32, delay)
	
	add_child(inst)
