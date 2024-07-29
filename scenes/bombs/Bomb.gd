extends Area2D
class_name Bomb

signal player_body_entered()

var Particle_scene: Resource = preload("res://scenes/bombs/bombeffects/Flame.tscn")
var BombSlayedEffect_scene: Resource = preload("res://scenes/bombs/bombeffects/BombSlayedEffect.tscn")

var slayed_direction: Vector2 = Vector2.ZERO

func _on_body_entered(body):
	if body is Player:
		slayed_direction = body.velocity
		player_body_entered.emit()

func slayed(): # bomb slayed effect
	var BombSlayedEffect_inst: BombSlayedEffect = BombSlayedEffect_scene.instantiate()
	BombSlayedEffect_inst.position = position
	BombSlayedEffect_inst.direction = slayed_direction
	get_tree().current_scene.add_child(BombSlayedEffect_inst)
	
	var Particle_instance = Particle_scene.instantiate()
	get_tree().current_scene.add_child(Particle_instance)
	var particles = Particle_instance.get_node("flame")
	particles.position = position
	particles.emitting = true
	
func exploded(): # bomb explosion effect
	pass

func game_over():
	PlayingFieldInterface.game_over(position)
