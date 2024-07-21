extends RayCast2D

signal ray_cast_end

func _physics_process(_delta):
	ray_cast_end.emit()
