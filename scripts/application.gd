class_name Application
extends Node

signal simulation_started

@export var is_paused: bool = false
@export var seed_str: String = "mehiko"
var dimensions: int = 3

var simulation: Simulation


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	start_simulation()


func _physics_process(delta: float) -> void:
	if not is_paused:
		simulation.do_step(delta)


func start_simulation() -> void:
	seed(seed_str.hash())
	Params.randomize_particle_params()

	if dimensions == 2:
		simulation = Simulation2D.new()
		($Camera2D as Camera2D).make_current()
	elif dimensions == 3:
		simulation = Simulation3D.new()

	simulation_started.emit()


func _on_menu_attraction_radius_changed(value: float) -> void:
	Params.attraction_radius = value
	GPU.set_uniform(GPU.Uniform.ATTRACTION_RADIUS, value)


func _on_menu_force_strength_changed(value: float) -> void:
	Params.force_strength = value
	GPU.set_uniform(GPU.Uniform.FORCE_STRENGTH, value)


func _on_menu_max_speed_changed(value: float) -> void:
	Params.max_speed = value
	GPU.set_uniform(GPU.Uniform.MAX_SPEED, value)


func _on_menu_pressed_restart(seed_string: String, particles_count: int, types_count: int) -> void:
	Params.num_particles = particles_count
	Params.num_types = types_count
	seed_str = seed_string
	start_simulation()


func _on_menu_repel_radius_changed(value: float) -> void:
	Params.repel_radius = value
	GPU.set_uniform(GPU.Uniform.REPEL_RADIUS, value)


func _on_menu_run_on_gpu_changed(value: bool) -> void:
	simulation.run_on_gpu = value


func _on_menu_universe_radius_changed(value: float) -> void:
	Params.universe_radius = value
	GPU.set_uniform(GPU.Uniform.UNIVERSE_RADIUS, value)


func _on_menu_wrap_universe_changed(value: float) -> void:
	Params.wrap_universe = value
	GPU.set_uniform(GPU.Uniform.WRAP_UNIVERSE, value)


func _on_menu_pause_changed(value: bool) -> void:
	is_paused = value


func _on_menu_pressed_step() -> void:
	if is_paused:
		simulation.do_step(1.0 / Engine.physics_ticks_per_second)


func _on_menu_physics_fps_changed() -> void:
	GPU.set_uniform(GPU.Uniform.DELTA, 1.0 / Engine.physics_ticks_per_second)
