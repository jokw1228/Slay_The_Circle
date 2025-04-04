extends ColorRect
class_name Darksight

static func create() -> Darksight:
	return Darksight_creator.create()

func _ready():
	fade_in()

var tween_fade_in: Tween
func fade_in():
	const fade_time = 1.3
	tween_fade_in = get_tree().create_tween()
	tween_fade_in.tween_property(self, "color", Color.BLACK, fade_time)

func fade_out():
	if tween_fade_in != null:
		tween_fade_in.kill()
	
	const fade_time = 0.5
	var tween_fade_out: Tween = get_tree().create_tween()
	tween_fade_out.tween_property(self, "color", Color(0,0,0,0), fade_time)
	await tween_fade_out.finished
	queue_free()
