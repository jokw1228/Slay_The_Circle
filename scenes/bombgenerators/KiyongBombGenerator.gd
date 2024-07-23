extends BombGenerator

func _ready():
	await get_tree().create_timer(1.0).timeout
	
	pattern1()
	await get_tree().create_timer(5.0).timeout


func pattern1():
	var bomb1 = create_normal_bomb(Vector2(-100, 100), 2, 3)
	var bomb2 = create_normal_bomb(Vector2(100, 100), 2, 3)
	create_bomb_link(bomb1, bomb2)
