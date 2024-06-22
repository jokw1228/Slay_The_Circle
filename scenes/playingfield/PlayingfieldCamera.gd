extends Camera2D
class_name PlayingfieldCamera

var rotation_amount: float = 0
var rotation_direction = 1.0

func _ready():
	rotation_amount = PI / 4

func _process(delta):
	rotation += rotation_amount * rotation_direction * delta

func rotation_speed_up(up: float):
	rotation_amount += up

func rotation_inversion():
	rotation_direction *= -1;
