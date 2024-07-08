class_name ParticleLife
extends Node

signal simulation_started

@export var num_types: int = 3
@export var num_particles: int = 512
@export var wrap_universe: bool = false
@export var run_on_gpu: bool = true

@export var universe_radius: float = 70
@export var attraction_radius: float = 10
@export var repel_radius: float = 1
@export var force_strength: float = 0.5
@export var max_speed: float = 2
@export var seed_str: String = "mehiko"

@onready var universe_sphere: MeshInstance3D = %UniverseSphere

var positions: PackedVector3Array = PackedVector3Array()
var velocities: PackedVector3Array = PackedVector3Array()
var types: PackedInt32Array = PackedInt32Array()
var attraction_matrix: PackedFloat32Array = PackedFloat32Array()
var colors: Array[Color] = []


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	universe_sphere.scale = Vector3.ONE * universe_radius * 2

	start_simulation()


func _process(delta: float) -> void:
	if run_on_gpu:
		GPU.particle_life_gpu(delta, positions, velocities)
	else:
		particle_life_cpu(delta)


func start_simulation() -> void:
	generate_params()

	GPU.setup_shader_uniforms(num_particles, num_types)

	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, attraction_radius)
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, repel_radius)
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, force_strength)
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, max_speed)
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, universe_radius)
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, wrap_universe)

	GPU.set_uniform(GPU.Uniform.POSITIONS, positions)
	GPU.set_uniform(GPU.Uniform.TYPES, types)
	GPU.set_uniform(GPU.Uniform.ATTRACTION_MATRIX, attraction_matrix)

	simulation_started.emit()


func generate_params() -> void:
	seed(seed_str.hash())

	attraction_matrix = []
	assert(attraction_matrix.resize(num_types ** 2) == OK)
	for i: int in range(num_types ** 2):
		attraction_matrix[i] = randf_range(-1, 1)

	assert(positions.resize(num_particles) == OK)
	assert(velocities.resize(num_particles) == OK)
	assert(types.resize(num_particles) == OK)
	colors = []

	for i: int in range(num_particles):
		var p: Vector3 = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
		p = p.normalized()
		p *= randf_range(0, universe_radius)
		positions[i] = p
		velocities[i] = Vector3()
		types[i] = randi_range(0, num_types - 1)

	colors = [Color.RED, Color.BLUE, Color.YELLOW]


func particle_life_cpu(delta: float) -> void:
	var new_positions: Array[Vector3] = []
	for i: int in range(num_particles):
		var force: Vector3 = Vector3.ZERO
		for j: int in range(num_particles):
			if i == j:
				continue

			var dist_squared: float = positions[i].distance_squared_to(positions[j])

			if wrap_universe:
				dist_squared = min(
					dist_squared,
					positions[i].distance_squared_to(-positions[j].normalized() * universe_radius)
				)

			if dist_squared > attraction_radius ** 2:
				continue

			var dir: Vector3 = positions[j] - positions[i]
			dir = dir.limit_length(1.0 / dir.length() ** 2)
			if dist_squared < repel_radius ** 2:
				force -= dir
			else:
				force += dir * attraction_matrix[types[i] * num_types + types[j]]

		force *= force_strength
		velocities[i] += force / delta
		velocities[i] = velocities[i].limit_length(max_speed)
		var pos: Vector3 = positions[i] + velocities[i]

		var overlap_squared: float = positions[i].length_squared() - universe_radius ** 2
		if overlap_squared > 0:
			if wrap_universe:
				var length: float = universe_radius - sqrt(overlap_squared)
				pos = -pos.limit_length(length)
			else:
				pos = pos.limit_length(universe_radius)
				velocities[i] = (
					velocities[i] - pos.normalized() * velocities[i].dot(pos.normalized())
				)

		new_positions.append(pos)

	positions = new_positions


func _on_menu_attraction_radius_changed(value: float) -> void:
	attraction_radius = value
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)


func _on_menu_force_strength_changed(value: float) -> void:
	force_strength = value
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)


func _on_menu_max_speed_changed(value: float) -> void:
	max_speed = value
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)


func _on_menu_pressed_restart(seed_string: String, particles_count: int, types_count: int) -> void:
	num_particles = particles_count
	num_types = types_count
	seed_str = seed_string
	start_simulation()


func _on_menu_repel_radius_changed(value: float) -> void:
	repel_radius = value
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)


func _on_menu_run_on_gpu_changed(value: bool) -> void:
	if not run_on_gpu:
		GPU._buffer_toggle = 1
		GPU.set_uniform(GPU.Uniform.BUFFER_TOGGLE, 0)
		GPU.set_uniform(GPU.Uniform.POSITIONS, positions)
		GPU.set_uniform(GPU.Uniform.VELOCITIES, velocities)
	run_on_gpu = value


func _on_menu_universe_radius_changed(value: float) -> void:
	universe_radius = value
	universe_sphere.scale = Vector3.ONE * value * 2
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)


func _on_menu_wrap_universe_changed(value: float) -> void:
	wrap_universe = value
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, value)
