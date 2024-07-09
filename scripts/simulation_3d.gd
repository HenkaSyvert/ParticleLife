class_name Simulation3D
extends Simulation

var positions: PackedVector3Array = PackedVector3Array()
var velocities: PackedVector3Array = PackedVector3Array()


func _init() -> void:
	assert(positions.resize(Params.num_particles) == OK)
	assert(velocities.resize(Params.num_particles) == OK)

	for i: int in range(Params.num_particles):
		var p: Vector3 = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
		p = p.limit_length(Params.universe_radius)
		positions[i] = p
		velocities[i] = Vector3()

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


func sync_gpu_cpu() -> void:
	if not run_on_gpu:
		GPU.set_particles_state(positions, velocities)



func get_pos_3d(index: int) -> Vector3:
	return positions[index]


func get_vel_3d(index: int) -> Vector3:
	return velocities[index]


func do_step(delta: float) -> void:
	if run_on_gpu:
		GPU.particle_life_gpu(positions, velocities)
	else:
		_do_cpu_step(delta)


func _do_cpu_step(delta: float) -> void:
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
