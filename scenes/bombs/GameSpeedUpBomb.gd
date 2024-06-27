extends Bomb
class_name GameSpeedUpBomb

var game_speed_up_value: float = 0.1

func slayed():
	PlayingFieldInterface.game_speed_up(game_speed_up_value)
	super()
