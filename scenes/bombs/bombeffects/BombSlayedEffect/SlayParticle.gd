extends GPUParticles2D
class_name SlayParticle

static func create(position_to_set: Vector2) -> SlayParticle:
	return SlayParticle_creator.create(position_to_set)
