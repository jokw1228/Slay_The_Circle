extends BombGenerator

func _ready():
	await get_tree().create_timer(1.0).timeout
	
	pattern1()
	await get_tree().create_timer(5.0).timeout


func pattern1():
	create_normal_bomb(Vector2(-100, 100), 2, 3)
	# add pattern
