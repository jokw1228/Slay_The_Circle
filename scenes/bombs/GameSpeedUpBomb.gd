extends Bomb
class_name GameSpeedUpBomb

var game_speed_up_value: float = 0.1

func slayed():
	Engine.time_scale += game_speed_up_value
	queue_free()

func exploded():
	queue_free()
