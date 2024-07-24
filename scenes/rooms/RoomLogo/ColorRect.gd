extends ColorRect
var is_color=1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.color = Color(0,0,0)

func _on_room_logo_room_color_change():
	if(is_color>0):
		self.color=Color(0.525,0.149,0.2)
		is_color*=-1
	else:
		self.color=Color(0,0,0)
