extends CharacterBody2D

@export var PlayerRayCast2D: RayCast2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_position: Vector2 = get_global_mouse_position()
		
		PlayerRayCast2D.look_at(target_position)
		
		### Player moves to the edge
		
		# C: (x - circle_center.x)^2 + (y - circle_centor.y)^2 = r^2
		var circle_centor: Vector2 = Vector2(0.0, 0.0)
		var r: float = 256.0
		
		if target_position.x == position.x:
			pass
		else:
			# l: y = mx + b
			var m: float = (target_position.y - position.y) / (target_position.x - position.x)
			var b: float = position.y - m * position.x
			
			# intersection point (x1, y1)
			var x1: float
			var y1: float
			
			var h: float = circle_centor.x
			var k: float = circle_centor.y
			
			var x1_candidate1: float = (h-m*k + sqrt((h-m*k)*(h-m*k) - (1+m*m)*(h*h+(b-k)*(b-k)-r*r))) / (1+m*m)
			var x1_candidate2: float = (h-m*k - sqrt((h-m*k)*(h-m*k) - (1+m*m)*(h*h+(b-k)*(b-k)-r*r))) / (1+m*m)
			
			if abs(target_position.x - x1_candidate1) < abs(target_position.x - x1_candidate2):
				x1 = x1_candidate1
			else:
				x1 = x1_candidate2
			y1 = m*x1 + b
			
			position = Vector2(x1, y1).normalized() * r

func _draw():
	draw_arc(position, 32, 0, 2 * PI, 9, Color.WHITE, 4.0, false)
