extends Area2D
class_name Bomb

signal player_body_entered()

var slayed_direction: Vector2 = Vector2.ZERO

func _on_body_entered(body):
	if body is Player:
		slayed_direction = body.velocity
		player_body_entered.emit()

func slayed(): # bomb slayed effect
	get_tree().current_scene.add_child( BombSlayedEffect.create(global_position, slayed_direction) )
	#get_tree().current_scene.add_child( SlayParticle.create(global_position) )

func exploded(): # bomb explosion effect
	get_tree().current_scene.add_child( BombExplodedEffect.create(global_position) )

func game_over():
	PlayingFieldInterface.game_over(global_position)
