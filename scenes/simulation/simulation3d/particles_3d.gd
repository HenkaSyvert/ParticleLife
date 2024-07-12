extends MultiMeshInstance3D


func _ready() -> void:
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = Params.num_particles
	for i: int in range(Params.num_particles):
		multimesh.set_instance_color(i, Params.colors[Params.types[i]])


func _process(_delta: float) -> void:
	for i: int in range(Params.num_particles):
		var t: Transform3D = Transform3D(Basis(), Simulation3D.positions[i])
		multimesh.set_instance_transform(i, t)
