extends Node2D
class_name IndicatorReverbEffect

const IndicatorReverbEffect_scene = "res://scenes/bombs/bombeffects/IndicatorReverbEffect.tscn"

var size: float = 32

var color_alpha: float = 1.0
var radius_to_draw: float

static func create(size_to_set: float) -> IndicatorReverbEffect:
	var inst: IndicatorReverbEffect = load(IndicatorReverbEffect_scene).instantiate() as IndicatorReverbEffect
	inst.size = size_to_set
	return inst

func _ready():
	const delay = 1.2
	
	radius_to_draw = size
	
	var tween_alpha: Tween = get_tree().create_tween()
	tween_alpha.tween_property(self, "color_alpha", 0, delay)
	
	var tween_radius: Tween = get_tree().create_tween()
	tween_radius.tween_property(self, "radius_to_draw", size + size / 2.0, delay)
	
	await tween_alpha.finished
	queue_free()

func _draw():
	draw_arc(Vector2.ZERO, radius_to_draw, 0, 2*PI, 32, Color(1, 1, 1, color_alpha), 2, true)

func _process(_delta):
	queue_redraw()
