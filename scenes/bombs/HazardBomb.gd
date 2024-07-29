extends Bomb
class_name HazardBomb

@export var HazardBombEndedEffect_scene: PackedScene

func ended_effect():
	var inst = HazardBombEndedEffect_scene.instantiate()
	inst.position = position
	get_tree().current_scene.add_child(inst)
