extends Area2D
class_name Bomb

signal player_body_entered()

@export var Particle: PackedScene

func _on_body_entered(body):
	if body is Player:
		player_body_entered.emit()

func slayed(): # safely defuse this bomb 
	var Particle_instance = Particle.instantiate()
	get_tree().current_scene.add_child(Particle_instance)
	var particles = Particle_instance.get_node("flame")
	particles.position = position # 포지션 구현 미완
	particles.emitting = true
	queue_free()
	
func exploded(): # game over
	var current_position = self.position
	PlayingFieldInterface.game_over(current_position)
	queue_free()
