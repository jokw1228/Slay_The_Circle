extends Bomb
class_name NormalBomb

func slayed():
	queue_free()

func exploded():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		slayed()
