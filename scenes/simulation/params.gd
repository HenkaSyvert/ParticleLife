class_name Params

static var seed_str: String = "mehiko"
static var num_particles: int = 100
static var num_types: int = 3
static var dimensions: int = 3

static var types: PackedInt32Array = PackedInt32Array()
static var attraction_matrix: PackedFloat32Array = PackedFloat32Array()
static var colors: Array[Color]

static var universe_radius: float = 40:
	set(value):
		universe_radius = value
		GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)

static var attraction_radius: float = 10:
	set(value):
		attraction_radius = value
		GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)

static var repel_radius: float = 1:
	set(value):
		repel_radius = value
		GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)

static var force_strength: float = 0.5:
	set(value):
		force_strength = value
		GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)

static var max_speed: float = 2:
	set(value):
		max_speed = value
		GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)

static var wrap_universe: bool = false:
	set(value):
		wrap_universe = value
		GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, value)


static func _static_init() -> void:
	randomize_particle_params(seed_str, num_particles, num_types, dimensions)
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, universe_radius)
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, attraction_radius)
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, repel_radius)
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, force_strength)
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, max_speed)
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, wrap_universe)


static func randomize_particle_params(
	seed_string: String, particles_count: int, types_count: int, dims: int
) -> void:
	seed_str = seed_string
	num_particles = particles_count
	num_types = types_count
	dimensions = dims

	seed(seed_str.hash())

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

	GPU.compile_shader(dimensions)
	GPU.setup_shader_uniforms()
	GPU.set_uniform(GPU.Uniform.TYPES, types)
	GPU.set_uniform(GPU.Uniform.ATTRACTION_MATRIX, attraction_matrix)
