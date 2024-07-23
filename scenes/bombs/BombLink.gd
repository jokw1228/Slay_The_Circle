extends Node2D
class_name BombLink

@export var ray_1to2: RayCast2D
@export var ray_2to1: RayCast2D

var bomb1: Bomb
var bomb2: Bomb
var num_child_bombs: int = 0

func set_child_bombs(b1: Bomb, b2: Bomb):
	bomb1 = b1
	bomb2 = b2
	num_child_bombs = 2
	bomb1.player_body_entered.connect(on_bomb_slayed)
	bomb2.player_body_entered.connect(on_bomb_slayed)
	set_ray_cast()

func set_ray_cast():
	ray_1to2.global_position = bomb1.global_position
	ray_1to2.look_at(bomb2.global_position)
	
	ray_2to1.global_position = bomb2.global_position
	ray_2to1.look_at(bomb1.global_position)
	
	# wait ray cast update
	await ray_1to2.ray_cast_end
	ray_1to2.enabled = false
	
	await ray_2to1.ray_cast_end
	ray_2to1.enabled = false
	
	queue_redraw()

# connected to player_body_entered signal
func on_bomb_slayed():
	num_child_bombs -= 1
	if num_child_bombs == 0:
		# all linked bombs are safely slayed
		queue_free()

# signal by Player to PlayingField to BombLink
func on_player_grounded():
	if num_child_bombs == 1:
		# only one of linked bombs is slayed, game over
		PlayingFieldInterface.game_over(self.position)
		queue_free()

func _draw():
	if num_child_bombs == 0:
		return
	
	# Size: half of arrow size, BombSize: for pos offset
	const Size: float = 10.0
	const BombSize: float = Size * 6.5
	
	var bomb1_pos: Vector2 = bomb1.global_position
	var bomb2_pos: Vector2 = bomb2.global_position
	
	var dir: Vector2 = (bomb2_pos - bomb1_pos).normalized()
	var dist: float = (bomb2_pos - bomb1_pos).length()
	
	var front: Vector2 = dir * Size
	var left: Vector2 = dir.rotated(PI / -2.0) * Size
	var right: Vector2 = dir.rotated(PI / 2.0) * Size
	
	# bomb position + offset
	var pos_1to2: Vector2 = bomb1_pos + dir * BombSize + left * 1.5
	var pos_2to1: Vector2 = bomb2_pos - dir * BombSize - left * 1.5
	# points to draw polygon
	var points_1to2: PackedVector2Array
	var points_2to1: PackedVector2Array
	
	var d: float = BombSize + Size * 2
	while d < dist - BombSize:
		points_1to2 = [pos_1to2 + front, pos_1to2 + right, pos_1to2 + front + right,
						pos_1to2 + front + front, pos_1to2 + front + left, pos_1to2 + left]
		points_2to1 = [pos_2to1 - front, pos_2to1 - right, pos_2to1 - front - right,
						pos_2to1 - front - front, pos_2to1 - front - left, pos_2to1 - left]
		draw_colored_polygon(points_1to2, Color.DEEP_SKY_BLUE)
		draw_colored_polygon(points_2to1, Color.DEEP_SKY_BLUE)
		
		d += Size * 2
		pos_1to2 += front * 2
		pos_2to1 -= front * 2
	
	# display intersection point of link line and circle field
	var ray_intersect: Vector2 = ray_1to2.get_collision_point()
	if ray_intersect != Vector2.ZERO:
		draw_circle(ray_intersect, 20, Color.RED)
		
	ray_intersect = ray_2to1.get_collision_point()
	if ray_intersect != Vector2.ZERO:
		draw_circle(ray_intersect, 20, Color.RED)
