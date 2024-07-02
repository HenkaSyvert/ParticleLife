extends MultiMeshInstance3D

@onready var num_types: int = %NumTypesSpinBox.value
@onready var num_particles: int = %NumParticlesSpinBox.value
@onready var wrap_universe: bool = %WrapUniverseCheckBox.button_pressed
@onready var run_on_gpu: bool = %RunOnGpuCheckBox.button_pressed

@onready var universe_radius: float = %UniverseRadiusSpinBox.value
@onready var attraction_radius: float = %AttractionRadiusSpinBox.value
@onready var repel_radius: float = %RepelRadiusSpinBox.value
@onready var force_strength: float = %ForceStrengthSpinBox.value
@onready var max_speed: float = %MaxSpeedSpinBox.value

var positions = []
var velocities = []
var types = []
var attraction_matrix = []
var colors = []


func _ready():
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	$UniverseSphere.scale = Vector3.ONE * %UniverseRadiusSpinBox.value * 2
	
	var seed_str = "det luktar fisk" #str(randi())
	%SeedLineEdit.set_text(seed_str)

	start_simulation()


func _process(delta):
	%FpsLabel.set_text("FPS: %d" % Engine.get_frames_per_second())	
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if run_on_gpu:
		positions = GPU.particle_life_gpu(delta)
	else:
		particle_life_cpu(delta)

	for i in range(num_particles):
		var t = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, t)


func start_simulation():
	
	generate_params(%SeedLineEdit.text)
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


func _on_universe_radius_spin_box_value_changed(value):
	universe_radius = value
	$UniverseSphere.scale = Vector3.ONE * value * 2
	$NoteStrings.multimesh.mesh.height = value
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)


func _on_attraction_radius_spin_box_value_changed(value):
	attraction_radius = value
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)


func _on_repel_radius_spin_box_value_changed(value):
	repel_radius = value
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)


func _on_force_strength_spin_box_value_changed(value):
	force_strength = value
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)


func _on_max_speed_spin_box_value_changed(value):
	max_speed = value
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)


func _on_wrap_universe_check_box_toggled(toggled_on):
	wrap_universe = toggled_on
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, toggled_on)


func _on_update_button_pressed():
	num_particles = %NumParticlesSpinBox.value
	num_types = %NumTypesSpinBox.value
	run_on_gpu = %RunOnGpuCheckBox.button_pressed
	start_simulation()

