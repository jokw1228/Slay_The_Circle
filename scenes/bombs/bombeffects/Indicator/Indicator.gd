extends Node2D
class_name Indicator

@export var size: float = 32

static func create(position_to_set: Vector2 = Vector2.ZERO, size_to_set: float = 32) -> Indicator:
	return Indicator_creator.create(position_to_set, size_to_set)

func _ready():
	while true:
		add_child( IndicatorReverbEffect.create(size) )
		await get_tree().create_timer(0.5).timeout

func _draw():
	draw_arc(Vector2.ZERO, size, 0, 2 * PI, 32, Color.WHITE, 3.0, true)

func _process(_delta):
	queue_redraw()
