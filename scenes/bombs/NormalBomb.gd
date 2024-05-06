extends Bomb
class_name NormalBomb

func slayed():
	queue_free()

func exploded():
	queue_free()
