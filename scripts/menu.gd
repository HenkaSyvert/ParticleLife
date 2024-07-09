extends Window

signal pressed_restart(seed_string: String, particles_count: int, types_count: int)
signal wrap_universe_changed(value: bool)
signal run_on_gpu_changed(value: bool)
signal pause_changed(value: bool)
signal pressed_step
signal physics_fps_changed

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
signal instrument_changed(value: int)

@export var particle_life: Application
@export var sound: Sound

@onready var fps_label: Label = %FpsLabel


func _ready() -> void:
	(%SeedLineEdit as LineEdit).set_text(particle_life.seed_str)
	(%WrapUniverseCheckBox as CheckBox).button_pressed = Params.wrap_universe
	(%NumParticlesSpinBox as SpinBox).value = Params.num_particles
	(%NumTypesSpinBox as SpinBox).value = Params.num_types
	(%RunOnGpuCheckBox as CheckBox).button_pressed = false
	Engine.physics_ticks_per_second = 30
	(%PhysicsFPSSpinBox as SpinBox).value = Engine.physics_ticks_per_second
	(%PauseCheckBox as CheckBox).button_pressed = particle_life.is_paused

	(%UniverseRadiusSpinBox as SpinBox).value = Params.universe_radius
	(%AttractionRadiusSpinBox as SpinBox).value = Params.attraction_radius
	(%RepelRadiusSpinBox as SpinBox).value = Params.repel_radius
	(%ForceStrengthSpinBox as SpinBox).value = Params.force_strength
	(%MaxSpeedSpinBox as SpinBox).value = Params.max_speed

	(%EnableSoundCheckBox as CheckBox).button_pressed = sound.enable_sound
	(%NoteCooldownSpinBox as SpinBox).value = sound.note_cooldown
	(%ShowNoteStringsCheckBox as CheckBox).button_pressed = sound.show_note_strings
	(%MusicScaleOptionButton as OptionButton).selected = sound.selected_scale
	(%NoteStringWidthSpinBox as SpinBox).value = sound.string_width
	(%InstrumentOptionButton as OptionButton).selected = sound.selected_sampler


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	fps_label.set_text("FPS: %d" % Engine.get_frames_per_second())


func _on_restart_button_pressed() -> void:
	pressed_restart.emit(
		(%SeedLineEdit as LineEdit).text,
		(%NumParticlesSpinBox as SpinBox).value,
		(%NumTypesSpinBox as SpinBox).value
	)


func _on_wrap_universe_check_box_toggled(toggled_on: bool) -> void:
	wrap_universe_changed.emit(toggled_on)


func _on_run_on_gpu_check_box_toggled(toggled_on: bool) -> void:
	run_on_gpu_changed.emit(toggled_on)


func _on_universe_radius_spin_box_value_changed(value: float) -> void:
	universe_radius_changed.emit(value)


func _on_attraction_radius_spin_box_value_changed(value: float) -> void:
	attraction_radius_changed.emit(value)


func _on_repel_radius_spin_box_value_changed(value: float) -> void:
	repel_radius_changed.emit(value)


func _on_force_strength_spin_box_value_changed(value: float) -> void:
	force_strength_changed.emit(value)


func _on_max_speed_spin_box_value_changed(value: float) -> void:
	max_speed_changed.emit(value)


func _on_enable_sound_check_box_toggled(toggled_on: bool) -> void:
	enable_sound_changed.emit(toggled_on)


func _on_note_cooldown_spin_box_value_changed(value: float) -> void:
	note_cooldown_changed.emit(value)


func _on_show_note_strings_check_box_toggled(toggled_on: bool) -> void:
	show_note_strings_changed.emit(toggled_on)


func _on_music_scale_option_button_item_selected(index: int) -> void:
	music_scale_changed.emit(index)


func _on_note_string_width_spin_box_value_changed(value: float) -> void:
	note_string_width_changed.emit(value)


func _on_instrument_option_button_item_selected(index: int) -> void:
	instrument_changed.emit(index)


func _on_physics_fps_spin_box_value_changed(value: float) -> void:
	Engine.physics_ticks_per_second = int(value)
	physics_fps_changed.emit()


func _on_pause_check_box_toggled(toggled_on: bool) -> void:
	pause_changed.emit(toggled_on)


func _on_step_button_pressed() -> void:
	pressed_step.emit()
