extends Node
class_name BombExplodedEffect_creator

const BombExplodedEffect_scene = "res://scenes/bombs/bombeffects/BombExplodedEffect/BombExplodedEffect.tscn"

static func create(position_to_set: Vector2) -> BombExplodedEffect:
	var inst: BombExplodedEffect = preload(BombExplodedEffect_scene).instantiate() as BombExplodedEffect
	inst.position = position_to_set
	return inst
