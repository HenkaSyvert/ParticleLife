class_name NoteStrings
extends MultiMeshInstance3D

@export var particle_life: Application

static var show_note_strings: bool = false
static var string_width: float = 0.05
var note_strings: Array[Vector3]
static var note_cooldown: float = 3
var note_timers: Array[float] = []


func _ready() -> void:
	for i: int in range(Sound.num_notes):
		note_timers.append(note_cooldown / 2 + randf_range(-1, 1))
	multimesh.use_colors = true
	multimesh.instance_count = Sound.num_notes
	(multimesh.mesh as CapsuleMesh).height = Params.universe_radius
	(multimesh.mesh as CapsuleMesh).radius = string_width / 2

	visible = show_note_strings
	note_strings = fibonacci_sphere(Sound.num_notes)
	for i: int in range(Sound.num_notes):
		note_timers.append(note_cooldown / 2 + randf_range(-1, 1))

		var t: Transform3D = Transform3D(Basis(), note_strings[i] * Params.universe_radius / 2)

		if not t.origin.normalized().cross(Vector3.UP).is_zero_approx():
			t = t.looking_at(Vector3.ZERO)
			t = t.rotated_local(Vector3.RIGHT, PI / 2)


func _process(delta: float) -> void:
	map_sound(delta)
	for i: int in range(multimesh.instance_count):
		var t: Transform3D = multimesh.get_instance_transform(i)
		t.origin = Vector3.ZERO
		t = t.translated(note_strings[i] * Params.universe_radius / 2)
		(multimesh.mesh as CapsuleMesh).height = Params.universe_radius
		multimesh.set_instance_transform(i, t)
		multimesh.set_instance_transform(i, t)
		if note_timers[i] > 0:
			multimesh.set_instance_color(i, Color.GREEN)
		else:
			multimesh.set_instance_color(i, Color.RED)


func fibonacci_sphere(n: int) -> Array[Vector3]:
	var points: Array[Vector3] = []
	var phi: float = PI * (sqrt(5) - 1)
	for i: int in range(n):
		var y: float = 1 - (i / float(n - 1)) * 2
		var r: float = sqrt(1 - y ** 2)
		var theta: float = phi * i
		var x: float = r * cos(theta)
		var z: float = r * sin(theta)
		points.append(Vector3(x, y, z))
	return points


func map_sound(delta: float) -> void:
	for i: int in range(note_strings.size()):
		note_timers[i] -= delta

		for j: int in range(Params.num_particles):
			if particle_life.simulation.get_vel_3d(j).length() < 0.1:
				continue

			var d: float = note_strings[i].normalized().dot(
				particle_life.simulation.get_pos_3d(j).normalized()
			)
			if d > 0.9:
				if note_timers[i] < 0:
					note_timers[i] = note_cooldown
					Sound.play_note(i)
