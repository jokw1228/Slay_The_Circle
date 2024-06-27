extends Area2D
class_name Bomb

signal player_body_entered()

func _on_body_entered(body):
	if body is Player:
		player_body_entered.emit()

func slayed(): # safely defuse this bomb 
	queue_free()

func exploded(): # game over
	PlayingFieldInterface.game_over()
	queue_free()
