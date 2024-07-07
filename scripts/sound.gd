class_name Sound
extends MultiMeshInstance3D


@export var particle_life: ParticleLife
@export var enable_sound = false
var note_strings
var note_timers = []
var num_octaves = 3
var num_notes = 15
@export var note_cooldown: float = 3
var starting_octave: int = 3
@export var string_width = 0.05
@export var show_note_strings: bool = false

var penta_scale = ["C", "D", "E", "G", "A"]
var jap_penta_scale = ["A", "B", "C", "E", "F"]
var hicaz_scale = ["A", "A#", "C#", "D", "E", "F", "G"]
var major_scale = ["A", "B", "C", "D", "E", "F", "G"]
var melodic_minor_scale = ["A", "B", "C", "D", "E", "F#", "G#"]
var whole_tone_scale = ["C", "D", "E", "F#", "G#", "A#"]
var diminished_scale = ["C", "C#", "D#", "E", "F#", "G", "A", "#A"]
var blues_scale = ["A", "C", "D", "D#", "E", "G"]
var doric_hicaz_scale = ["D", "E", "F", "G#", "A", "B", "C"]

var music_scales = [penta_scale, jap_penta_scale, hicaz_scale, major_scale, melodic_minor_scale,
	whole_tone_scale, diminished_scale, blues_scale, doric_hicaz_scale]
@export var selected_scale = 0


func _ready():
	multimesh.use_colors = true
	multimesh.instance_count = num_notes
	multimesh.mesh.height = particle_life.universe_radius
	multimesh.mesh.radius = string_width / 2
	
	visible = show_note_strings
	
	note_strings = fibonacci_sphere(num_notes)
	for i in range(num_notes):
		note_timers.append(note_cooldown / 2 + randf_range(-1, 1))
		
		var t = Transform3D(Basis(), note_strings[i] * particle_life.universe_radius / 2)
	
		if not t.origin.normalized().cross(Vector3.UP).is_zero_approx():
			t = t.looking_at(Vector3.ZERO)
			t = t.rotated_local(Vector3.RIGHT, PI / 2)
		
		multimesh.set_instance_transform(i, t)


func _process(delta):

	map_sound(delta)

	for i in range(multimesh.instance_count):
		var t = multimesh.get_instance_transform(i)
		t.origin = Vector3.ZERO
		t = t.translated(note_strings[i] * particle_life.universe_radius / 2)
		multimesh.mesh.height = particle_life.universe_radius
		multimesh.set_instance_transform(i, t)


func fibonacci_sphere(n):
	var points = []
	var phi = PI * (sqrt(5) - 1)
	for i in range(n):
		var y = 1  - (i / float(n - 1)) * 2
		var r = sqrt(1 - y**2)
		var theta = phi * i
		var x = r * cos(theta)
		var z = r * sin(theta)
		points.append(Vector3(x, y, z))
	return points


func map_sound(delta):

	for i in range(note_strings.size()):
		
		note_timers[i] -= delta
		
		for j in range(particle_life.num_particles):
			
			if particle_life.velocities[j].length() < 0.1:
				continue
			
			var d = note_strings[i].normalized().dot(particle_life.positions[j].normalized())
			if d > 0.9:
				var notes = music_scales[selected_scale]
				if note_timers[i] < 0:
					note_timers[i] = note_cooldown
					if enable_sound:
						%HarpSampler.play_note(notes[i % notes.size()], starting_octave + i / notes.size())

		if note_timers[i] > 0:
			multimesh.set_instance_color(i, Color.GREEN)
		else:
			multimesh.set_instance_color(i, Color.RED)


func _on_menu_enable_sound_changed(value):
	enable_sound = value
	%HarpSampler.release()


func _on_menu_music_scale_changed(value):
	selected_scale = value


func _on_menu_note_cooldown_changed(value):
	note_cooldown = value


func _on_menu_note_string_width_changed(value):
	string_width = value
	multimesh.mesh.radius = value / 2


func _on_menu_show_note_strings_changed(value):
	visible = value
	show_note_strings = value
