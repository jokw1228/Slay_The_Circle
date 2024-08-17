extends Node
class_name BombSlayedEffect_creator

const BombSlayedEffect_scene = "res://scenes/bombs/bombeffects/BombSlayedEffect/BombSlayedEffect.tscn"

static func create(position_to_set: Vector2, direction_to_set: Vector2) -> BombSlayedEffect:
	var inst: BombSlayedEffect = preload(BombSlayedEffect_scene).instantiate() as BombSlayedEffect
	inst.position = position_to_set
	inst.direction = direction_to_set
	return inst
