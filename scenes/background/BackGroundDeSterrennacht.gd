extends Node2D
class_name BackGroundDeSterrennacht

@export var BackGroundArcDrawer_scene: PackedScene

var center_list: Array[Node2D]
var angular_velocity_list: Array[float]

func _ready():
	const number_of_centers = 6
	const radius_offset = 320
	const radius_difference = 64
	
	for i in range(number_of_centers):
		var center: Node2D = Node2D.new()
		
		var number_of_arc: int = i + 4
		var radian_of_arc: float = (2*PI) / number_of_arc
		var radian_of_arc_offset: float = (PI/12) * radian_of_arc
		for j in range(number_of_arc):
			var arc: BackGroundArcDrawer = BackGroundArcDrawer_scene.instantiate()
			
			arc.radius = radius_offset + i * radius_difference
			arc.radian = radian_of_arc - radian_of_arc_offset
			arc.rotate(j * radian_of_arc)
			center.add_child(arc)
		
		var sign_of_angular_velocity = 1 if (i % 2) else (-1)
		angular_velocity_list.append(sign_of_angular_velocity)
		center_list.append(center)
		
		add_child(center)
		


func _process(delta):
	for index: int in range(center_list.size()):
		center_list[index].rotate(delta * angular_velocity_list[index])
