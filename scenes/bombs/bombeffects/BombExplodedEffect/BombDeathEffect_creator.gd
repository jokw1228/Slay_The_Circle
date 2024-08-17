extends Node
class_name BombDeathEffect_creator

const BombDeathEffect_scene = "res://scenes/bombs/bombeffects/BombExplodedEffect/BombDeathEffect.tscn"

static func create(angle_offset_to_set: float) -> BombDeathEffect:
	var inst: BombDeathEffect = preload(BombDeathEffect_scene).instantiate() as BombDeathEffect
	inst.angle_offset = angle_offset_to_set
	return inst
