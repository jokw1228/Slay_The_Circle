extends Node
class_name SlayParticle_creator

const SlayParticle_scene = "res://scenes/bombs/bombeffects/BombSlayedEffect/SlayParticle.tscn"

static func create(position_to_set: Vector2) -> SlayParticle:
	var inst: SlayParticle = load(SlayParticle_scene).instantiate() as SlayParticle
	inst.position = position_to_set
	inst.emitting = true
	return inst
