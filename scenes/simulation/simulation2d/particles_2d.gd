extends MultiMeshInstance2D


func _ready() -> void:
	multimesh.instance_count = 0
	multimesh.transform_format = MultiMesh.TRANSFORM_2D
	multimesh.use_colors = true
	multimesh.instance_count = Params.num_particles
	for i: int in range(Params.num_particles):
		multimesh.set_instance_color(i, Params.colors[Params.types[i]])


func _process(_delta: float) -> void:
	for i: int in range(Params.num_particles):
		var t: Transform2D = Transform2D(0, Simulation2D.positions[i])
		multimesh.set_instance_transform_2d(i, t)
