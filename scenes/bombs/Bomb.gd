extends Area2D
class_name Bomb

@export var sound: AudioStreamPlayer2D

signal player_body_entered()

func _on_body_entered(body):
	if body is Player:
		player_body_entered.emit()

func slayed(): # safely defuse this bomb 
	print("Slayed")
	queue_free()

func exploded(): # game over
	print("Boom")
	PlayingFieldInterface.game_over()
	#queue_free()
