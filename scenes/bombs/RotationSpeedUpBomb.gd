extends Bomb
class_name RotationSpeedUpBomb

func slayed():
	var camera: PlayingfieldCamera = get_tree().current_scene.get_node("PlayingfieldCamera")
	camera.rotation_speed_up(PI / 16)
	queue_free()

func exploded():
	queue_free()
