extends Sprite2D
class_name BackgroundColor

# Called when the node enters the scene tree for the first time.
func _ready():
	if visible == false:
		visible = true
	var color = Color(PlayingFieldInterface.color.r,PlayingFieldInterface.color.g,PlayingFieldInterface.color.b,0.5)
	var tween1 = get_tree().create_tween()
	tween1.tween_property($".", "modulate", color, 1)
	
