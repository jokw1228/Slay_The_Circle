extends Sprite2D
class_name HazardBombEndedEffect

const HazardBombEndedEffect_scene = "res://scenes/bombs/bombeffects/HazardBombEndedEffect.tscn"

static func create(position_to_set: Vector2) -> HazardBombEndedEffect:
	var inst: HazardBombEndedEffect = load(HazardBombEndedEffect_scene).instantiate() as HazardBombEndedEffect
	inst.position = position_to_set
	return inst

func _ready():
	var tween_shrink: Tween = get_tree().create_tween()
	tween_shrink.tween_property(self, "scale", Vector2(0, 0), 0.06)
	await tween_shrink.finished
	queue_free()
