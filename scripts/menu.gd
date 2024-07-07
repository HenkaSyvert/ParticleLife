extends Window

signal pressed_restart(seed_str: String, particles_count: int, types_count: int)
signal wrap_universe_changed(value: bool)
signal run_on_gpu_changed(value: bool)

signal universe_radius_changed(value: float)
signal attraction_radius_changed(value: float)
signal repel_radius_changed(value: float)
signal force_strength_changed(value: float)
signal max_speed_changed(value: float)

signal enable_sound_changed(value: bool)
signal note_cooldown_changed(value: float)
signal show_note_strings_changed(value: bool)
signal music_scale_changed(value: int)
signal note_string_width_changed(value: float)

@export var particle_life: ParticleLife
@export var sound: Sound


func _ready():
	%WrapUniverseCheckBox.button_pressed = particle_life.wrap_universe
	%NumParticlesSpinBox.value = particle_life.num_particles
	%NumTypesSpinBox.value = particle_life.num_types
	%RunOnGpuCheckBox.button_pressed = particle_life.run_on_gpu
	
	%UniverseRadiusSpinBox.value = particle_life.universe_radius
	%AttractionRadiusSpinBox.value = particle_life.attraction_radius
	%RepelRadiusSpinBox.value = particle_life.repel_radius
	%ForceStrengthSpinBox.value = particle_life.force_strength
	%MaxSpeedSpinBox.value = particle_life.max_speed
	
	%EnableSoundCheckBox.button_pressed = sound.enable_sound
	%NoteCooldownSpinBox.value = sound.note_cooldown
	%ShowNoteStringsCheckBox.button_pressed = sound.show_note_strings
	%MusicScaleOptionButton.selected = sound.selected_scale
	%NoteStringWidthSpinBox.value = sound.string_width


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	%FpsLabel.set_text("FPS: %d" % Engine.get_frames_per_second())


func _on_restart_button_pressed():
	pressed_restart.emit(
		%SeedLineEdit.text,
		%NumParticlesSpinBox.value,
		%NumTypesSpinBox.value
	)


func _on_wrap_universe_check_box_toggled(toggled_on):
	wrap_universe_changed.emit(toggled_on)


func _on_run_on_gpu_check_box_toggled(toggled_on):
	run_on_gpu_changed.emit(toggled_on)


func _on_universe_radius_spin_box_value_changed(value):
	universe_radius_changed.emit(value)


func _on_attraction_radius_spin_box_value_changed(value):
	attraction_radius_changed.emit(value)


func _on_repel_radius_spin_box_value_changed(value):
	repel_radius_changed.emit(value)


func _on_force_strength_spin_box_value_changed(value):
	force_strength_changed.emit(value)


func _on_max_speed_spin_box_value_changed(value):
	max_speed_changed.emit(value)


func _on_enable_sound_check_box_toggled(toggled_on):
	enable_sound_changed.emit(toggled_on)


func _on_note_cooldown_spin_box_value_changed(value):
	note_cooldown_changed.emit(value)


func _on_show_note_strings_check_box_toggled(toggled_on):
	show_note_strings_changed.emit(toggled_on)


func _on_music_scale_option_button_item_selected(index):
	music_scale_changed.emit(index)


func _on_note_string_width_spin_box_value_changed(value):
	note_string_width_changed.emit(value)



