extends Sprite2D
class_name HazardBombEndedEffect

func _ready():
	var tween_shrink: Tween = get_tree().create_tween()
	tween_shrink.tween_property(self, "scale", Vector2(0, 0), 0.08)
	await tween_shrink.finished
	queue_free()
