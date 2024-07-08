class_name Sound
extends MultiMeshInstance3D

@export var particle_life: ParticleLife
@export var enable_sound: bool = false
var note_strings: Array[Vector3]
var note_timers: Array[float] = []
var num_octaves: int = 3
var num_notes: int = 15
@export var note_cooldown: float = 3
var starting_octaves: Array[int] = [3, 5, 3]
@export var string_width: float = 0.05
@export var show_note_strings: bool = false

var penta_scale: Array[String] = ["C", "D", "E", "G", "A"]
var jap_penta_scale: Array[String] = ["A", "B", "C", "E", "F"]
var hicaz_scale: Array[String] = ["A", "A#", "C#", "D", "E", "F", "G"]
var major_scale: Array[String] = ["A", "B", "C", "D", "E", "F", "G"]
var melodic_minor_scale: Array[String] = ["A", "B", "C", "D", "E", "F#", "G#"]
var whole_tone_scale: Array[String] = ["C", "D", "E", "F#", "G#", "A#"]
var diminished_scale: Array[String] = ["C", "C#", "D#", "E", "F#", "G", "A", "A#"]
var blues_scale: Array[String] = ["A", "C", "D", "D#", "E", "G"]
var doric_hicaz_scale: Array[String] = ["D", "E", "F", "G#", "A", "B", "C"]

var music_scales: Array[Array] = [
	penta_scale,
	jap_penta_scale,
	hicaz_scale,
	major_scale,
	melodic_minor_scale,
	whole_tone_scale,
	diminished_scale,
	blues_scale,
	doric_hicaz_scale
]
@export var selected_scale: int = 0
@export var samplers: Array[SamplerInstrument]
@export var selected_sampler: int = 0


func _ready() -> void:
	multimesh.use_colors = true
	multimesh.instance_count = num_notes
	(multimesh.mesh as CapsuleMesh).height = particle_life.universe_radius
	(multimesh.mesh as CapsuleMesh).radius = string_width / 2

	visible = show_note_strings

	note_strings = fibonacci_sphere(num_notes)
	for i: int in range(num_notes):
		note_timers.append(note_cooldown / 2 + randf_range(-1, 1))

		var t: Transform3D = Transform3D(
			Basis(), note_strings[i] * particle_life.universe_radius / 2
		)

		if not t.origin.normalized().cross(Vector3.UP).is_zero_approx():
			t = t.looking_at(Vector3.ZERO)
			t = t.rotated_local(Vector3.RIGHT, PI / 2)

		multimesh.set_instance_transform(i, t)


func _process(delta: float) -> void:
	map_sound(delta)

	for i: int in range(multimesh.instance_count):
		var t: Transform3D = multimesh.get_instance_transform(i)
		t.origin = Vector3.ZERO
		t = t.translated(note_strings[i] * particle_life.universe_radius / 2)
		(multimesh.mesh as CapsuleMesh).height = particle_life.universe_radius
		multimesh.set_instance_transform(i, t)


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

		for j: int in range(particle_life.num_particles):
			if particle_life.velocities[j].length() < 0.1:
				continue

			var d: float = note_strings[i].normalized().dot(particle_life.positions[j].normalized())
			if d > 0.9:
				var notes: Array[String] = music_scales[selected_scale]
				if note_timers[i] < 0:
					note_timers[i] = note_cooldown
					if enable_sound:
						@warning_ignore("integer_division")
						samplers[selected_sampler].play_note(
							notes[i % notes.size()],
							starting_octaves[selected_sampler] + i / notes.size()
						)

		if note_timers[i] > 0:
			multimesh.set_instance_color(i, Color.GREEN)
		else:
			multimesh.set_instance_color(i, Color.RED)


func _on_menu_enable_sound_changed(value: float) -> void:
	enable_sound = value
	samplers[selected_sampler].release()


func _on_menu_music_scale_changed(value: int) -> void:
	selected_scale = value


func _on_menu_note_cooldown_changed(value: float) -> void:
	note_cooldown = value


func _on_menu_note_string_width_changed(value: float) -> void:
	string_width = value
	(multimesh.mesh as CapsuleMesh).radius = value / 2


func _on_menu_show_note_strings_changed(value: float) -> void:
	visible = value
	show_note_strings = value


func _on_menu_instrument_changed(value: int) -> void:
	selected_sampler = value
