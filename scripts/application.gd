class_name Application
extends Node

signal simulation_started

@export var run_on_gpu: bool = true
@export var is_paused: bool = false
@export var seed_str: String = "mehiko"

var positions: PackedVector3Array = PackedVector3Array()
var velocities: PackedVector3Array = PackedVector3Array()


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	start_simulation()


func _physics_process(delta: float) -> void:
	if not is_paused:
		step_simulation(delta)


func step_simulation(delta: float) -> void:
	if run_on_gpu:
		GPU.particle_life_gpu(positions, velocities)
	else:
		particle_life_cpu(delta)


func start_simulation() -> void:
	generate_params()

	GPU.setup_shader_uniforms(Params.num_particles, Params.num_types)

	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, Params.attraction_radius)
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, Params.repel_radius)
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, Params.force_strength)
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, Params.max_speed)
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, Params.universe_radius)
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, Params.wrap_universe)

	GPU.set_uniform(GPU.Uniform.TYPES, Params.types)
	GPU.set_uniform(GPU.Uniform.ATTRACTION_MATRIX, Params.attraction_matrix)
	GPU.set_particles_state(positions, velocities)

	simulation_started.emit()


func generate_params() -> void:
	seed(seed_str.hash())

	assert(positions.resize(Params.num_particles) == OK)
	assert(velocities.resize(Params.num_particles) == OK)

	for i: int in range(Params.num_particles):
		var p: Vector3 = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
		p = p.normalized()
		p *= randf_range(0, Params.universe_radius)
		positions[i] = p
		velocities[i] = Vector3()

	Params.randomize_particle_params()


func particle_life_cpu(delta: float) -> void:
	var new_positions: Array[Vector3] = []
	for i: int in range(Params.num_particles):
		var force: Vector3 = Vector3.ZERO
		for j: int in range(Params.num_particles):
			if i == j:
				continue

			var dist_squared: float = positions[i].distance_squared_to(positions[j])

			if Params.wrap_universe:
				dist_squared = min(
					dist_squared,
					positions[i].distance_squared_to(
						-positions[j].normalized() * Params.universe_radius
					)
				)

			if dist_squared > Params.attraction_radius ** 2:
				continue

			var dir: Vector3 = positions[j] - positions[i]

			dir = dir.limit_length(1.0 / (dir.length() ** 2))

			if dist_squared < Params.repel_radius ** 2:
				force -= dir
			else:
				force += (
					dir
					* Params.attraction_matrix[Params.types[i] * Params.num_types + Params.types[j]]
				)

		force *= Params.force_strength
		velocities[i] += force / delta

		velocities[i] = velocities[i].limit_length(Params.max_speed)

		var pos: Vector3 = positions[i] + velocities[i]

		var overlap_squared: float = positions[i].length_squared() - Params.universe_radius ** 2
		if overlap_squared > 0:
			if Params.wrap_universe:
				var length: float = Params.universe_radius - sqrt(overlap_squared)
				pos = -pos.limit_length(length)
			else:
				pos = pos.limit_length(Params.universe_radius)
				velocities[i] = (
					velocities[i] - pos.normalized() * velocities[i].dot(pos.normalized())
				)

		new_positions.append(pos)

	positions = new_positions


func _on_menu_attraction_radius_changed(value: float) -> void:
	Params.attraction_radius = value
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)


func _on_menu_force_strength_changed(value: float) -> void:
	Params.force_strength = value
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)


func _on_menu_max_speed_changed(value: float) -> void:
	Params.max_speed = value
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)


func _on_menu_pressed_restart(seed_string: String, particles_count: int, types_count: int) -> void:
	Params.num_particles = particles_count
	Params.num_types = types_count
	seed_str = seed_string
	start_simulation()


func _on_menu_repel_radius_changed(value: float) -> void:
	Params.repel_radius = value
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)


func _on_menu_run_on_gpu_changed(value: bool) -> void:
	if not run_on_gpu:
		GPU.set_particles_state(positions, velocities)
	run_on_gpu = value


func _on_menu_universe_radius_changed(value: float) -> void:
	Params.universe_radius = value
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)


func _on_menu_wrap_universe_changed(value: float) -> void:
	Params.wrap_universe = value
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, value)


func _on_menu_pause_changed(value: bool) -> void:
	is_paused = value


func _on_menu_pressed_step() -> void:
	if is_paused:
		step_simulation(1.0 / Engine.physics_ticks_per_second)


func _on_menu_physics_fps_changed() -> void:
	GPU.set_uniform(GPU.Uniform.DELTA, 1.0 / Engine.physics_ticks_per_second)
