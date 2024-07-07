extends MultiMeshInstance3D

@export var particle_life: ParticleLife


func _process(_delta: float) -> void:
	for i: int in range(particle_life.num_particles):
		var t: Transform3D = Transform3D(Basis(), particle_life.positions[i])
		multimesh.set_instance_transform(i, t)


func _on_particle_life_simulation_started() -> void:
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = particle_life.num_particles
	for i: int in range(particle_life.num_particles):
		multimesh.set_instance_color(i, particle_life.colors[particle_life.types[i]])
