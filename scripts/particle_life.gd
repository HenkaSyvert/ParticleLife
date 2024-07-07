class_name ParticleLife
extends MultiMeshInstance3D

@export var num_types: int = 3
@export var num_particles: int = 150
@export var wrap_universe: bool = false
@export var run_on_gpu: bool = false

@export var universe_radius: float = 70
@export var attraction_radius: float = 10
@export var repel_radius: float = 1
@export var force_strength: float = 0.001
@export var max_speed: float = 2

var positions = []
var velocities = []
var types = []
var attraction_matrix = []
var colors = []


func _ready():
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	%UniverseSphere.scale = Vector3.ONE * universe_radius * 2

	start_simulation("det luktar fisk")


func _process(delta):

	if run_on_gpu:
		positions = GPU.particle_life_gpu(delta)
	else:
		particle_life_cpu(delta)

	for i in range(num_particles):
		var t = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, t)


func start_simulation(seed_str):
	
	generate_params(seed_str)
	set_multimesh_params()
	
	if run_on_gpu:
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


func generate_params(seed_str):
	
	seed(seed_str.hash())
	
	attraction_matrix = []
	for i in range(num_types):
		attraction_matrix.append([])
		for j in range(num_types):
			var val = randf_range(-1, 1)
			attraction_matrix[i].append(val)

	positions = []
	velocities = []
	types = []
	colors = []
	for i in range(num_particles):
		var p = Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1))
		p = p.normalized()
		p *= randf_range(0, universe_radius)
		positions.append(p)
		velocities.append(Vector3.ZERO)
		types.append(randi_range(0, num_types - 1))
	
	colors = [Color.RED, Color.BLUE, Color.YELLOW]


func set_multimesh_params():
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = num_particles
	for i in range(num_particles):
		multimesh.set_instance_color(i, colors[types[i]])


func particle_life_cpu(delta):
	var new_positions = []
	for i in range(num_particles):
		
		var force = Vector3.ZERO
		for j in range(num_particles):
			
			if i == j:
				continue
		
			var dist_squared = positions[i].distance_squared_to(positions[j])
			
			if wrap_universe:
				dist_squared = min(dist_squared, positions[i].distance_squared_to(-positions[j].normalized() * universe_radius))
		
			if dist_squared > attraction_radius**2:
				continue
			
			var dir = (positions[j] - positions[i])
			dir.limit_length(1.0 / dir.length()**2)
			if dist_squared < repel_radius**2:
				force -= dir
			else:
				force += dir * attraction_matrix[types[i]][types[j]]
		
		force *= force_strength
		velocities[i] += force / delta
		velocities[i] = velocities[i].limit_length(max_speed)
		var pos = positions[i] + velocities[i]
		
		var overlap_squared = positions[i].length_squared() - universe_radius**2
		if overlap_squared > 0:
			if wrap_universe:
				var length = universe_radius - sqrt(overlap_squared)
				pos = -pos.limit_length(length)
			else:
				pos = pos.limit_length(universe_radius)
				velocities[i] = velocities[i] - pos.normalized() * velocities[i].dot(pos.normalized())
		
		new_positions.append(pos)

	positions = new_positions


func _on_menu_attraction_radius_changed(value):
	attraction_radius = value
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)


func _on_menu_force_strength_changed(value):
	force_strength = value
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)


func _on_menu_max_speed_changed(value):
	max_speed = value
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)


func _on_menu_pressed_restart(seed_str, particles_count, types_count):
	num_particles = particles_count
	num_types = types_count
	start_simulation(seed_str)


func _on_menu_repel_radius_changed(value):
	repel_radius = value
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)


func _on_menu_run_on_gpu_changed(value):
	run_on_gpu = value


func _on_menu_universe_radius_changed(value):
	universe_radius = value
	%UniverseSphere.scale = Vector3.ONE * value * 2
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)


func _on_menu_wrap_universe_changed(value):
	wrap_universe = value
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, value)
