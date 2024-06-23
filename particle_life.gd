extends MultiMeshInstance3D

@onready var num_types: int = $Menu/Simulation/NumTypesSpinBox.value
@onready var num_particles: int = $Menu/Simulation/NumParticlesSpinBox.value
@onready var wrap_universe: bool = $Menu/Simulation/WrapUniverseCheckBox.button_pressed
@onready var run_on_gpu: bool = $Menu/Simulation/RunOnGpuCheckBox.button_pressed

@onready var universe_radius: float = $Menu/Particles/UniverseRadiusSpinBox.value
@onready var attraction_radius: float = $Menu/Particles/AttractionRadiusSpinBox.value
@onready var repel_radius: float = $Menu/Particles/RepelRadiusSpinBox.value
@onready var force_strength: float = $Menu/Particles/ForceStrengthSpinBox.value
@onready var max_speed: float = $Menu/Particles/MaxSpeedSpinBox.value


var positions = []
var velocities = []
var forces = []
var types = []
var attraction_matrix = []
var colors = []


var rd = RenderingServer.create_local_rendering_device()
var pos_in = PackedByteArray()
var pos_out = PackedByteArray()
var vels = PackedByteArray()
var params = PackedByteArray()
var pos_in_buf
var pos_out_buf
var vels_buf
var params_buf


func _ready():
	$UniverseSphere.scale = Vector3.ONE * $Menu/Particles/UniverseRadiusSpinBox.value * 2
	
	var seed_str = str(randi())
	$Menu/Simulation/SeedLineEdit.set_text(seed_str)

	generate_params(seed_str)
	set_multimesh_params()
	init_shader()
	


func _process(delta):
	
	if run_on_gpu:
		particle_life_gpu()
	else:
		particle_life_cpu(delta)

	for i in range(num_particles):
		var t = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, t)


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
	forces = []
	types = []
	colors = []
	for i in range(num_particles):
		var p = Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1))
		p = p.normalized()
		p *= randf_range(0, universe_radius)
		positions.append(p)
		velocities.append(Vector3.ZERO)
		forces.append(Vector3.ZERO)
		types.append(randi_range(0, num_types - 1))
	
	colors = [Color.RED, Color.BLUE, Color.YELLOW]


func set_multimesh_params():
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = num_particles
	for i in range(num_particles):
		multimesh.set_instance_color(i, colors[types[i]])


func init_shader():
	
	var shader_file = load("res://particle_life.glsl")
	var shader_spirv = shader_file.get_spirv()
	if shader_spirv.compile_error_compute != "":
		print(shader_spirv.compile_error_compute)
		get_tree().quit()
	var shader = rd.shader_create_from_spirv(shader_spirv)
	var pipeline = rd.compute_pipeline_create(shader)
	
	var uniform_set = setup_shader_uniforms(shader)
	
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, 2, 1, 1)
	rd.compute_list_end()
	

func setup_shader_uniforms(shader):
	
	var float_size = 4 #vec3 uses 32-bit
	var buf_size = num_particles * 3 * float_size
	pos_in.resize(buf_size)
	pos_out.resize(buf_size)
	vels.resize(buf_size)
	params.resize(4 * 8)
	
	var stride = float_size * 3
	for i in range(positions.size()):
		pos_in.encode_float(i * stride, positions[i].x)
		pos_in.encode_float(i * stride + 1 * float_size , positions[i].y)
		pos_in.encode_float(i * stride + 2 * float_size, positions[i].z)

	params.encode_s32(0, num_particles)
	params.encode_float(1 * 4, attraction_radius)
	params.encode_float(2 * 4, repel_radius)
	params.encode_float(3 * 4, force_strength)
	params.encode_float(4 * 4, 0.1) # TODO: fix delta somehow
	params.encode_float(5 * 4, max_speed)
	params.encode_float(6 * 4, universe_radius)
	params.encode_s32(7 * 4, int(wrap_universe))

	pos_in_buf = rd.storage_buffer_create(buf_size, pos_in)
	pos_out_buf = rd.storage_buffer_create(buf_size, pos_out)
	vels_buf = rd.storage_buffer_create(buf_size, vels)
	params_buf = rd.uniform_buffer_create(4 * 8, params)

	var pos_in_u = RDUniform.new()
	var pos_out_u = RDUniform.new()
	var vels_u = RDUniform.new()
	var params_u = RDUniform.new()
	
	pos_in_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	pos_out_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	vels_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	params_u.uniform_type = RenderingDevice.UNIFORM_TYPE_UNIFORM_BUFFER
	
	pos_in_u.binding = 0
	pos_out_u.binding = 1
	vels_u.binding = 2
	params_u.binding = 3
	
	pos_in_u.add_id(pos_in_buf)
	pos_out_u.add_id(pos_out_buf)
	vels_u.add_id(vels_buf)
	params_u.add_id(params_buf)
	
	var uniform_set = rd.uniform_set_create([pos_in_u, pos_out_u, vels_u, params_u], shader, 0)
	return uniform_set


func particle_life_cpu(delta):
	var new_positions = []
	for i in range(num_particles):
		
		var force_sum = Vector3.ZERO
		for j in range(num_particles):
			
			if i == j:
				continue
		
			var dist_squared = positions[i].distance_squared_to(positions[j])
			if dist_squared > attraction_radius**2:
				continue
			
			var dir = (positions[j] - positions[i])
			if dist_squared < repel_radius**2:
				force_sum += -dir
			else:
				force_sum += dir * attraction_matrix[types[i]][types[j]]
		
		force_sum *= force_strength
		var acceleration = force_sum
		velocities[i] += acceleration / delta
		velocities[i] = velocities[i].limit_length(max_speed)
		var pos = positions[i] + velocities[i]
		
		var overlap_squared = positions[i].length_squared() - universe_radius**2
		if overlap_squared > 0:
			if wrap_universe:
				var length = -universe_radius + sqrt(overlap_squared)
				pos = pos.limit_length(length)
			else:
				pos = pos.limit_length(universe_radius)
				velocities[i] = Vector3.ZERO
		
		new_positions.append(pos)

	positions = new_positions


func particle_life_gpu():
	rd.submit()
	rd.sync()
	
	
	
#	var byte_data = rd.buffer_get_data(positions_out)
#	for i in range(16):
#		print(byte_data.decode_float(i*4))


func _on_universe_radius_spin_box_value_changed(value):
	universe_radius = value
	$UniverseSphere.scale = Vector3.ONE * value * 2


func _on_attraction_radius_spin_box_value_changed(value):
	attraction_radius = value


func _on_repel_radius_spin_box_value_changed(value):
	repel_radius = value


func _on_force_strength_spin_box_value_changed(value):
	force_strength = value


func _on_max_speed_spin_box_value_changed(value):
	max_speed = value


func _on_wrap_universe_check_box_toggled(toggled_on):
	wrap_universe = toggled_on


func _on_update_button_pressed():
	num_particles = $Menu/Simulation/NumParticlesSpinBox.value
	num_types = $Menu/Simulation/NumTypesSpinBox.value
	run_on_gpu = $Menu/Simulation/RunOnGpuCheckBox.button_pressed
	generate_params($Menu/Simulation/SeedLineEdit.text)
	set_multimesh_params()

