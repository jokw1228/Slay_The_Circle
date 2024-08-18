extends Node2D
class_name BombLink

const BombLink_scene = "res://scenes/bombs/BombLink.tscn"

@export var ray_1to2: RayCast2D
@export var ray_2to1: RayCast2D
@export var Indicator_1to2: Indicator
@export var Indicator_2to1: Indicator

signal both_bombs_removed
signal single_bomb_removed

var bomb1: Bomb
var bomb2: Bomb
var num_child_bombs: int = 0
var bomb1_indicator: Sprite2D
var bomb2_indicator: Sprite2D
var bomb1_last_position: Vector2
var bomb2_last_position: Vector2

var last_bright: float
var last_color: Color

static func create(bomb1_to_set: Bomb, bomb2_to_set: Bomb) -> BombLink:
	var inst: BombLink = load(BombLink_scene).instantiate() as BombLink
	inst.set_child_bombs(bomb1_to_set, bomb2_to_set)
	return inst

func set_child_bombs(b1: Bomb, b2: Bomb):
	bomb1 = b1
	bomb2 = b2
	num_child_bombs = 2
	bomb1.player_body_entered.connect(on_bomb_slayed)
	bomb2.player_body_entered.connect(on_bomb_slayed)
	bomb1.add_child( LinkedMark.create() )
	bomb2.add_child( LinkedMark.create() )
	
	update_drawings()


func set_ray_cast():
	if bomb1 != null && bomb2 != null:
		ray_1to2.enabled = true
		ray_2to1.enabled = true
		
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
		both_bombs_removed.emit()

# signal by Player to PlayingField to BombLink
func on_player_grounded():
	if num_child_bombs == 1:
		# only one of linked bombs is slayed, game over
		single_bomb_removed.emit()

func game_over():
	var return_position: Vector2 = Vector2.ZERO
	if bomb1 != null:
		return_position = bomb1.global_position
		bomb1.exploded()
	elif bomb2 != null:
		return_position = bomb2.global_position
		bomb2.exploded()
	PlayingFieldInterface.game_over(return_position)

func _draw():
	if num_child_bombs < 2: # queue_redraw() 말고도 redraw하는 경우가 있나
		return

	# Size: half of arrow size, BombSize: for pos offset
	const Size: float = 8
	const BombSize: float = 48
	
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
		
		var color_value: float = 1 - PlayingFieldInterface.get_theme_bright()
		draw_colored_polygon(points_1to2, Color(color_value, color_value, color_value, 0.5))
		draw_colored_polygon(points_2to1, Color(color_value, color_value, color_value, 0.5))
		
		d += Size * 2
		pos_1to2 += front * 2
		pos_2to1 -= front * 2
	
	# display intersection point of link line and circle field
	var ray_intersect: Vector2 = ray_1to2.get_collision_point()
	if ray_intersect != Vector2.ZERO:
		Indicator_1to2.visible = true
		Indicator_1to2.global_position = ray_intersect
		Indicator_1to2.look_at(bomb1.global_position)
		Indicator_1to2.modulate = PlayingFieldInterface.get_theme_color()
	
	ray_intersect = ray_2to1.get_collision_point()
	if ray_intersect != Vector2.ZERO:
		Indicator_2to1.visible = true
		Indicator_2to1.global_position = ray_intersect
		Indicator_2to1.look_at(bomb2.global_position)
		Indicator_2to1.modulate = PlayingFieldInterface.get_theme_color()

func _process(_delta):
	update_drawings()
	
func update_drawings():
	if num_child_bombs < 2:
		Indicator_1to2.visible = false
		Indicator_2to1.visible = false
		return
	if bomb1_last_position != null and bomb2_last_position != null\
		and bomb1_last_position == bomb1.global_position\
		and bomb2_last_position == bomb2.global_position\
		and last_bright == PlayingFieldInterface.get_theme_bright()\
		and last_color == PlayingFieldInterface.get_theme_color():
			# print("%d bomblink redraw skipped" % Engine.get_frames_drawn())
			return
	
	bomb1_last_position = bomb1.global_position
	bomb2_last_position = bomb2.global_position
	last_bright = PlayingFieldInterface.get_theme_bright()
	last_color = PlayingFieldInterface.get_theme_color()
	
	set_ray_cast()
	queue_redraw()
