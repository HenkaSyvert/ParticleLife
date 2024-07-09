extends MultiMeshInstance3D

@export var particle_life: Application


func _ready() -> void:
	(%UniverseSphere as MeshInstance3D).scale = Vector3.ONE * Params.universe_radius * 2


func _process(_delta: float) -> void:
	for i: int in range(Params.num_particles):
		var t: Transform3D = Transform3D(Basis(), particle_life.positions[i])
		multimesh.set_instance_transform(i, t)


func _on_particle_life_simulation_started() -> void:
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = Params.num_particles
	for i: int in range(Params.num_particles):
		multimesh.set_instance_color(i, Params.colors[Params.types[i]])


func _on_menu_universe_radius_changed(value: float) -> void:
	(%UniverseSphere as MeshInstance3D).scale = Vector3.ONE * value * 2
