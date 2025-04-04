extends Sprite2D
class_name BombSlayedEffect

var direction: Vector2 = Vector2.ZERO

static func create(position_to_set: Vector2, direction_to_set: Vector2) -> BombSlayedEffect:
	return BombSlayedEffect_creator.create(position_to_set, direction_to_set)

func _ready():
	rotate(direction.angle())
	
	var tween_cross: Tween = get_tree().create_tween()
	tween_cross.tween_property(self, "scale", Vector2(8, 0), 0.08)
	await tween_cross.finished
	queue_free()
