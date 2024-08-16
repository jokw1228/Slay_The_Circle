extends StaticBody2D
class_name CircleField

const CIRCLE_FIELD_RADIUS = 256

@export var CircleFieldReverbEffect_scene: PackedScene
@export var CircleFieldEffect_scene: PackedScene

@export var ReverbEffectTimer_node: Timer
@export var BackgroundEffect_node: CanvasLayer

var bomb_position = Vector2(0, 0)

func _ready():
	# make a CollisionPolygon2D in a circle shape
	make_collision_polygon()
	
	BackgroundEffect_node.hide()

func make_collision_polygon():
	for i: float in range(0, 2*PI, PI/2):
		make_partial_collision_polygon(i)

func make_partial_collision_polygon(radian: float):
	var inst: CollisionPolygon2D = CollisionPolygon2D.new()
	var list: PackedVector2Array = []
	# make a circle shape
	const NUMBER_OF_POINTS = 32
	const INNER_OFFSET = 0
	const OUTER_OFFSET = 32
	for i in range(NUMBER_OF_POINTS):
		list.append(Vector2((CIRCLE_FIELD_RADIUS+INNER_OFFSET) * cos((i*(PI/2)/NUMBER_OF_POINTS) + radian),\
		(CIRCLE_FIELD_RADIUS+INNER_OFFSET) * -sin((i*(PI/2)/NUMBER_OF_POINTS) + radian)))
	# make outer edges
	for i in range(NUMBER_OF_POINTS - 1, -1, -1):
		list.append(Vector2((CIRCLE_FIELD_RADIUS+OUTER_OFFSET) * cos((i*(PI/2)/NUMBER_OF_POINTS) + radian),\
		(CIRCLE_FIELD_RADIUS+OUTER_OFFSET) * -sin((i*(PI/2)/NUMBER_OF_POINTS) + radian)))
	inst.polygon = list
	add_child(inst)

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	draw_arc(Vector2.ZERO, CIRCLE_FIELD_RADIUS, 0, 2 * PI, 1024, theme_color, 8.0, true)

func _process(_delta):
	queue_redraw()

func start_reverb_effect():
	ReverbEffectTimer_node.start()

func stop_reverb_effect():
	ReverbEffectTimer_node.stop()

func _on_reverb_effect_timer_timeout():
	var inst: CircleFieldReverbEffect = CircleFieldReverbEffect_scene.instantiate()
	add_child(inst)

func create_game_over_effect():
	const time_to_zoom_in = 1
	
	const time_to_scale = 0.3
	const number_of_blinks = 2
	const blink_delay = 0.1
	const faded_delay = 0.3
	
	var inst = CircleFieldEffect_scene.instantiate()
	
	await get_tree().create_timer(time_to_zoom_in).timeout
	
	inst.survival_time = time_to_scale + blink_delay * 2 * number_of_blinks + faded_delay
	inst.width_to_draw = 16.0
	inst.color_to_draw = Color.RED
	inst.radius_to_draw = 0
	inst.origin_to_draw = bomb_position
	
	var tween_radius = get_tree().create_tween().set_parallel(true)
	tween_radius.tween_property(inst, "radius_to_draw", CIRCLE_FIELD_RADIUS, time_to_scale)
	tween_radius.tween_property(inst, "origin_to_draw", Vector2(0, 0), time_to_scale)
	add_child(inst)
	
	await get_tree().create_timer(time_to_scale).timeout
	
	var animation_player: AnimationPlayer = BackgroundEffect_node.get_node("WaveAnimation")
	BackgroundEffect_node.show()
	animation_player.play("MoveWaveOut") # 0.4sec
	
	for i in range(number_of_blinks):
		await get_tree().create_timer(blink_delay).timeout
		inst.color_to_draw.a = 0.3
		await get_tree().create_timer(blink_delay).timeout
		inst.color_to_draw.a = 1
	
	var tween_alpha = get_tree().create_tween()
	tween_alpha.tween_property(inst, "color_to_draw", Color.TRANSPARENT, faded_delay)

func create_game_ready_effect():
	const time_to_scale = 0.3
	
	var inst = CircleFieldEffect_scene.instantiate()
	
	var animation_player = BackgroundEffect_node.get_node("WaveAnimation")
	animation_player.play("MoveWaveIn")
	
	await get_tree().create_timer(time_to_scale).timeout
	BackgroundEffect_node.hide()
	
	inst.survival_time = time_to_scale
	inst.width_to_draw = 16.0
	inst.color_to_draw = Color.BLUE
	inst.radius_to_draw = CIRCLE_FIELD_RADIUS
	inst.origin_to_draw = Vector2(0, 0)
	
	var tween_radius = get_tree().create_tween()
	tween_radius.tween_property(inst, "radius_to_draw", 0, time_to_scale)
	add_child(inst)

func set_bomb_position(x: Vector2):
	bomb_position = x
