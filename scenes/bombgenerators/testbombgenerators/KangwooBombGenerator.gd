extends BombGenerator

func _ready():
	while true:
		create_gamespeedup_bomb(Vector2(0, 0), 1.0, 4, 10)
		await get_tree().create_timer(5.0).timeout
