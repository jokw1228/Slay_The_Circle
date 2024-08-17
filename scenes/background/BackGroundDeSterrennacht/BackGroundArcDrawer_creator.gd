extends Node
class_name BackGroundArcDrawer_creator

const BackGroundArcDrawer_scene = "res://scenes/background/BackGroundDeSterrennacht/BackGroundArcDrawer.tscn"

static func create(radius_to_set: float, radian_to_set: float, to_rotate: float) -> BackGroundArcDrawer:
	var inst: BackGroundArcDrawer = preload(BackGroundArcDrawer_scene).instantiate() as BackGroundArcDrawer
	inst.radius = radius_to_set
	inst.radian = radian_to_set
	inst.rotate(to_rotate)
	return inst
