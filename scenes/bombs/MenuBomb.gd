extends Bomb
class_name MenuBomb

@export var sprite: Sprite2D
@export var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = texture
	sprite.scale = Vector2(1, 1) * 64 / max(texture.get_height(), texture.get_width())
	
