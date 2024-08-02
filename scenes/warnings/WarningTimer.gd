extends Control

@export var Bar: TextureProgressBar
var set_time: float = 1

func _ready():
	Bar.max_value = set_time * 100
	Bar.value = Bar.max_value

func _process(delta):
	Bar.value -= 100 * delta
	if Bar.value <= 0:
		queue_free()
