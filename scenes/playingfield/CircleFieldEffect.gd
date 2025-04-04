extends Node2D

const CircleFieldRadius = 256
var PlayingFieldColor = Color.YELLOW

var survival_time = 1
@export var Timer_node: Timer

var radius_delta: float = 12
var alpha_delta: float = -0.1

var radius_to_draw: float = CircleFieldRadius
var color_to_draw: Color = PlayingFieldColor
var width_to_draw: float = 8.0
var origin_to_draw: Vector2 = Vector2(0, 0)

func _ready():
	Timer_node.wait_time = survival_time
	Timer_node.start()

func _draw():
	draw_arc(origin_to_draw, radius_to_draw, 0, 2 * PI, 1024, color_to_draw, width_to_draw, true)

func _process(_delta):
	queue_redraw()

func _on_timer_timeout():
	queue_free()
