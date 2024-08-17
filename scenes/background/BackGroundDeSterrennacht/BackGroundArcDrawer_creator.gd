extends Node
class_name BackGroundArcDrawer_creator

static func create(radius_to_set: float, radian_to_set: float, to_rotate: float) -> BackGroundArcDrawer:
	var inst: BackGroundArcDrawer = BackGroundArcDrawer.new()
	inst.radius = radius_to_set
	inst.radian = radian_to_set
	inst.rotate(to_rotate)
	return inst
