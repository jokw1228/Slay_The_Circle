extends Node2D
class_name Indicator

var size: float = 32

func _ready():
	while true:
		print(size)
		var inst: IndicatorReverbEffect = IndicatorReverbEffect.new()
		inst.size = size
		add_child(inst)
		await get_tree().create_timer(0.5).timeout

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	draw_arc(Vector2.ZERO, size, 0, 2 * PI, 32, theme_color, 3.0, true)

func _process(_delta):
	queue_redraw()

func set_size(size_to_set: float):
	size = size_to_set
