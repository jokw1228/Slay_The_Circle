extends Node2D
class_name BombExplodedEffect

@export var sprite: Sprite2D

var red_circle_radius: float = 0.0

func _ready():
	circle_effect()
	sprite_effect()

func sprite_effect():
	const delay = 0.08
	
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	# color inversion
	#sprite.modulate = Color(1-theme_color.r, 1-theme_color.g, 1-theme_color.b, 1)
	# Seonghyeon's Algorithm
	sprite.modulate = Color((theme_color.r+theme_color.g+theme_color.b)/3, 0, 0, 1)
	await get_tree().create_timer(delay).timeout
	sprite.modulate = theme_color
	await get_tree().create_timer(delay).timeout
	sprite_effect()

func circle_effect():
	var tween_red_circle_radius_up: Tween = get_tree().create_tween()
	tween_red_circle_radius_up.set_ease(Tween.EASE_OUT)
	tween_red_circle_radius_up.set_trans(Tween.TRANS_CUBIC)
	tween_red_circle_radius_up.tween_property(self, "red_circle_radius", 64, 0.5)
	
	await tween_red_circle_radius_up.finished
	
	var tween_red_circle_radius_down: Tween = get_tree().create_tween()
	tween_red_circle_radius_down.set_ease(Tween.EASE_IN)
	tween_red_circle_radius_down.set_trans(Tween.TRANS_CUBIC)
	tween_red_circle_radius_down.tween_property(self, "red_circle_radius", 0, 0.5)
	
	await tween_red_circle_radius_down.finished
	
	queue_free()

func _draw():
	draw_arc(Vector2.ZERO, red_circle_radius, 0, 2*PI, 256, Color(1,0,0,0.6), 8.0, true)

func _process(_delta):
	queue_redraw()
