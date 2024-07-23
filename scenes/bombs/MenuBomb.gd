extends Bomb
class_name MenuBomb

@export var sprite: Sprite2D
@export var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = texture
	
