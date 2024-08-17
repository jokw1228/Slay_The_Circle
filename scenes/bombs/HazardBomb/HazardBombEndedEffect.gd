extends Sprite2D
class_name HazardBombEndedEffect

static func create(position_to_set: Vector2) -> HazardBombEndedEffect:
	return HazardBombEndedEffect_creator.create(position_to_set)

func _ready():
	var tween_shrink: Tween = get_tree().create_tween()
	tween_shrink.tween_property(self, "scale", Vector2(0, 0), 0.06)
	await tween_shrink.finished
	queue_free()
