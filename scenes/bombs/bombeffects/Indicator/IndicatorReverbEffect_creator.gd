extends Node
class_name IndicatorReverbEffect_creator

const IndicatorReverbEffect_scene = "res://scenes/bombs/bombeffects/Indicator/IndicatorReverbEffect.tscn"

static func create(size_to_set: float) -> IndicatorReverbEffect:
	var inst: IndicatorReverbEffect = preload(IndicatorReverbEffect_scene).instantiate() as IndicatorReverbEffect
	inst.size = size_to_set
	return inst
