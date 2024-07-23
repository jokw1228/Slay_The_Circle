extends Sprite2D
class_name Themecolor

func _on_menu_bomb_generator_circle():
	var sprite = $"."
	if visible == false:
		visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($".", "modulate", Color(0.498039, 1, 0.831373, 0.4), 1)
	tween1.tween_property($".", "modulate", Color(0.498039, 1, 0.831373, 0), 2)
	sprite.modulate = Color(0.498039, 1, 0.831373, 1) #AQUA
	PlayingFieldInterface.color = Color(0.498039, 1, 0.831373, 1)

func _on_menu_bomb_generator_circler():
	var sprite = $"."
	if visible == false:
		visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($".", "modulate", Color(0.678431, 1, 0.184314, 0.4), 1)
	tween1.tween_property($".", "modulate", Color(0.678431, 1, 0.184314, 0), 2)
	sprite.modulate = Color(0.678431, 1, 0.184314, 1) #GREEN YELLOW
	PlayingFieldInterface.color = Color(0.678431, 1, 0.184314, 1)

func _on_menu_bomb_generator_circlest():
	var sprite = $"."
	if visible == false:
		visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($".", "modulate", Color(0.803922, 0.360784, 0.360784, 0.4), 1)
	tween1.tween_property($".", "modulate", Color(0.803922, 0.360784, 0.360784, 0), 2)
	sprite.modulate = Color(0.803922, 0.360784, 0.360784, 1) #INDIAN RED
	PlayingFieldInterface.color = Color(0.803922, 0.360784, 0.360784, 1)

func _on_menu_bomb_generator_hyper():
	var sprite = $"."
	if visible == false:
		visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($".", "modulate", Color(0.972549, 0.972549, 1, 0.4), 1)
	tween1.tween_property($".", "modulate", Color(0.972549, 0.972549, 1, 0), 2)
	sprite.modulate = Color(0.972549, 0.972549, 1, 1) #GHOST WHITE
	PlayingFieldInterface.color = Color(0.972549, 0.972549, 1, 1)
