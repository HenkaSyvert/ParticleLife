extends MultiMeshInstance2D

@export var particle_life: Application


func _process(_delta: float) -> void:
	for i: int in range(Params.num_particles):
		var t: Transform2D = Transform2D(0, particle_life.simulation.get_pos_2d(i))
		multimesh.set_instance_transform(i, t)


func _on_particle_life_simulation_started() -> void:
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = Params.num_particles
	for i: int in range(Params.num_particles):
		multimesh.set_instance_color(i, Params.colors[Params.types[i]])
