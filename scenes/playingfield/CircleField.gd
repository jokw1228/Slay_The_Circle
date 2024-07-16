extends StaticBody2D

const CircleFieldRadius = 256
var PlayingFieldColor = Color.WHITE

@export var CircleFieldEffect_scene: PackedScene

@export var ReverbEffectTimer_node: Timer

func _draw():
	draw_arc(position, CircleFieldRadius, 0, 2 * PI, 50, PlayingFieldColor, 8.0, true)

func start_reverb_effect():
	ReverbEffectTimer_node.start()

func stop_reverb_effect():
	ReverbEffectTimer_node.stop()

func _on_reverb_effect_timer_timeout():
	var inst = CircleFieldEffect_scene.instantiate()
	
	const delay = 1.2
	
	inst.survival_time = delay
	
	inst.width_to_draw = 6.0
	
	var tween_alpha = get_tree().create_tween()
	tween_alpha.tween_property(inst, "color_to_draw", Color(PlayingFieldColor.r, PlayingFieldColor.g, PlayingFieldColor.b, 0.0), delay)
	
	var tween_radius = get_tree().create_tween()
	tween_radius.tween_property(inst, "radius_to_draw", CircleFieldRadius + 32, delay)
	
	add_child(inst)

func create_game_over_effect():
	const time_to_scale = 0.3
	const number_of_blinks = 3
	const blink_delay = 0.15
	const faded_delay = 1
	
	var inst = CircleFieldEffect_scene.instantiate()
	
	inst.survival_time = time_to_scale + blink_delay * 2 * number_of_blinks + faded_delay
	
	inst.width_to_draw = 16.0
	
	inst.color_to_draw = Color.RED
	
	inst.radius_to_draw = 0
	var tween_radius = get_tree().create_tween()
	tween_radius.tween_property(inst, "radius_to_draw", CircleFieldRadius, time_to_scale)
	
	add_child(inst)
	
	await get_tree().create_timer(time_to_scale).timeout
	
	for i in range(number_of_blinks):
		await get_tree().create_timer(blink_delay).timeout
		inst.color_to_draw.a = 0.3
		await get_tree().create_timer(blink_delay).timeout
		inst.color_to_draw.a = 1
	
	var tween_alpha = get_tree().create_tween()
	tween_alpha.tween_property(inst, "color_to_draw", Color.TRANSPARENT, faded_delay)
	
