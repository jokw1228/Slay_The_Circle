extends GPUParticles2D
class_name SlayParticle

const SlayParticle_scene = "res://scenes/bombs/bombeffects/SlayParticle.tscn"

static func create(position_to_set: Vector2) -> SlayParticle:
	var inst: SlayParticle = preload(SlayParticle_scene).instantiate() as SlayParticle
	inst.position = position_to_set
	inst.emitting = true
	return inst
