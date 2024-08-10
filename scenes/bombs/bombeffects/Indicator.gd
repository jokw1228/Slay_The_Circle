extends Node2D
class_name Indicator

var size: float = 32

static func create(position_to_set: Vector2 = Vector2.ZERO, size_to_set: float = 32) -> Indicator:
	var inst: Indicator = Indicator.new()
	inst.position = position_to_set
	inst.size = size_to_set
	return inst

func _ready():
	modulate = Color(1,1,1,0.5)
	z_index = 3
	while true:
		var inst: IndicatorReverbEffect = IndicatorReverbEffect.new()
		inst.size = size
		add_child(inst)
		await get_tree().create_timer(0.5).timeout

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	draw_arc(Vector2.ZERO, size, 0, 2 * PI, 32, theme_color, 3.0, true)

func _process(_delta):
	queue_redraw()

func set_size(size_to_set: float): # legacy code
	size = size_to_set
