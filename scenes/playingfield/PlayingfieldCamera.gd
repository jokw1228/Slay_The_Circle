extends Camera2D
class_name PlayingFieldCamera

var rotation_amount: float = 0
var rotation_direction = 1.0

func _ready():
	#rotation_amount = PI / 4
	pass

func _process(delta):
	rotation += rotation_amount * rotation_direction * delta

func rotation_speed_up(up: float):
	rotation_amount += up

func rotation_inversion():
	rotation_direction *= -1;

func rotation_stop():
	rotation_amount = 0

func rotation_reset():
	rotation = 0
	rotation_direction = 1
