extends StaticBody2D

const CircleFieldRadius = 256
var PlayingFieldColor = Color.WHITE

@export var CircleFieldEffect_scene: PackedScene

func _draw():
	draw_arc(position, CircleFieldRadius, 0, 2 * PI, 50, PlayingFieldColor, 8.0, false)


func _on_circle_field_effect_timer_timeout():
	var inst = CircleFieldEffect_scene.instantiate()
	add_child(inst)
