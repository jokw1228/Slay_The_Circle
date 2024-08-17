extends Node
class_name HazardBombEndedEffect_creator

const HazardBombEndedEffect_scene = "res://scenes/bombs/HazardBomb/HazardBombEndedEffect.tscn"

static func create(position_to_set: Vector2) -> HazardBombEndedEffect:
	var inst: HazardBombEndedEffect = preload(HazardBombEndedEffect_scene).instantiate() as HazardBombEndedEffect
	inst.position = position_to_set
	return inst
