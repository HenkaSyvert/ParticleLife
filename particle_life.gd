extends MultiMeshInstance3D

@onready var universe_radius = $Menu/Particles/UniverseRadiusSpinBox.value
@onready var num_types  = $Menu/Simulation/NumTypesSpinBox.value
@onready var num_particles = $Menu/Simulation/NumParticlesSpinBox.value
@onready var attraction_radius = $Menu/Particles/AttractionRadiusSpinBox.value
@onready var repel_radius = $Menu/Particles/RepelRadiusSpinBox.value
@onready var force_strength = $Menu/Particles/ForceStrengthSpinBox.value
@onready var max_speed = $Menu/Particles/MaxSpeedSpinBox.value
@onready var wrap_universe = $Menu/Simulation/WrapUniverseCheckBox.button_pressed

var positions = []
var velocities = []
var forces = []
var types = []
var attraction_matrix = []
var colors = []


func _ready():
	$UniverseSphere.scale = Vector3.ONE * $Menu/Particles/UniverseRadiusSpinBox.value * 2
	
	var seed = randi()
	$Menu/Simulation/SeedLineEdit.set_text(str(seed))

	generate_params(str(seed))
	set_multimesh_params()

func _process(delta):
	
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

	for i in range(num_particles):
		var t = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, t)


func generate_params(seed):
	
	seed(seed.hash())
	
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
	var seed = $Menu/Simulation/SeedLineEdit.text
	generate_params(seed)
	set_multimesh_params()

