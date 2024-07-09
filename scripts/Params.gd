class_name Params

static var num_particles: int = 100
static var num_types: int = 3
static var universe_radius: float = 40
static var attraction_radius: float = 10
static var repel_radius: float = 1
static var force_strength: float = 0.5
static var max_speed: float = 2
static var wrap_universe: bool = false

static var types: PackedInt32Array = PackedInt32Array()
static var attraction_matrix: PackedFloat32Array = PackedFloat32Array()
static var colors: Array[Color]


static func randomize_particle_params() -> void:
	assert(attraction_matrix.resize(num_types ** 2) == OK)
	for i: int in range(num_types ** 2):
		attraction_matrix[i] = randf_range(-1, 1)

	assert(types.resize(num_particles) == OK)
	for i: int in range(num_particles):
		types[i] = randi_range(0, num_types - 1)

	colors = []
	for i: int in range(num_types):
		var c: Color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
		colors.append(c)
