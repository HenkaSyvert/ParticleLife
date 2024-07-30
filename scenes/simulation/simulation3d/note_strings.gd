class_name NoteStrings
extends MultiMeshInstance3D

static var note_cooldown: float = 3
static var string_width: float = 0.05
static var show_note_strings: bool = false

var note_strings: PackedVector3Array = PackedVector3Array()
var note_timers: PackedFloat32Array = PackedFloat32Array()


func _ready() -> void:
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = Sound.NUM_NOTES
	(multimesh.mesh as CapsuleMesh).height = Params.universe_radius
	(multimesh.mesh as CapsuleMesh).radius = string_width / 2

	visible = show_note_strings

	note_strings = fibonacci_sphere(Sound.NUM_NOTES)
	assert(note_timers.resize(Sound.NUM_NOTES) == OK)
	for i: int in range(Sound.NUM_NOTES):
		note_timers[i] = note_cooldown / 2 + randf_range(-1, 1)

		var t: Transform3D = Transform3D(Basis(), note_strings[i] * Params.universe_radius / 2)

		if not t.origin.normalized().cross(Vector3.UP).is_zero_approx():
			t = t.looking_at(Vector3.ZERO)
			t = t.rotated_local(Vector3.RIGHT, PI / 2)

		multimesh.set_instance_transform(i, t)


func _process(delta: float) -> void:
	map_sound(delta)

	for i: int in range(multimesh.instance_count):
		var t: Transform3D = multimesh.get_instance_transform(i)
		t.origin = Vector3.ZERO
		t = t.translated(note_strings[i] * Params.universe_radius / 2)
		(multimesh.mesh as CapsuleMesh).height = Params.universe_radius
		multimesh.set_instance_transform(i, t)


func fibonacci_sphere(n: int) -> PackedVector3Array:
	var points: PackedVector3Array = PackedVector3Array()
	assert(points.resize(n) == OK)
	var phi: float = PI * (sqrt(5) - 1)
	for i: int in range(n):
		var y: float = 1 - (i / float(n - 1)) * 2
		var r: float = sqrt(1 - y ** 2)
		var theta: float = phi * i
		var x: float = r * cos(theta)
		var z: float = r * sin(theta)
		points[i] = Vector3(x, y, z)
	return points


func map_sound(delta: float) -> void:
	for i: int in range(note_strings.size()):
		note_timers[i] -= delta

		for j: int in range(Params.num_particles):
			if Simulation3D.velocities[j].length() < 0.1:
				continue

			var d: float = note_strings[i].normalized().dot(Simulation3D.positions[j].normalized())
			if d > 0.9:
				if note_timers[i] < 0:
					note_timers[i] = note_cooldown
					Sound.play_note(i)

		if note_timers[i] > 0:
			multimesh.set_instance_color(i, Color.GREEN)
		else:
			multimesh.set_instance_color(i, Color.RED)


func _on_menu_note_cooldown_changed(value: float) -> void:
	note_cooldown = value


func _on_menu_note_string_width_changed(value: float) -> void:
	string_width = value
	(multimesh.mesh as CapsuleMesh).radius = value / 2


func _on_menu_show_note_strings_changed(value: float) -> void:
	visible = value
	show_note_strings = value
