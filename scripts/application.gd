class_name Application
extends Node

signal simulation_started

@export var is_paused: bool = false
@export var seed_str: String = "mehiko"
var dimensions: int = 3

var simulation: Simulation = Simulation3D.new()


func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	start_simulation()


func _physics_process(delta: float) -> void:
	if not is_paused:
		simulation.do_step(delta)


func start_simulation() -> void:
	seed(seed_str.hash())

	if dimensions == 2:
		simulation = Simulation2D.new()
		($Camera2D as Camera2D).make_current()
	elif dimensions == 3:
		simulation = Simulation3D.new()

	simulation_started.emit()


func _on_menu_pressed_restart(seed_string: String, particles_count: int, types_count: int) -> void:
	seed_str = seed_string
	Params.randomize_particle_params(particles_count, types_count)
	start_simulation()


func _on_menu_run_on_gpu_changed(value: bool) -> void:
	simulation.run_on_gpu = value


func _on_menu_pause_changed(value: bool) -> void:
	is_paused = value


func _on_menu_pressed_step() -> void:
	if is_paused:
		simulation.do_step(1.0 / Engine.physics_ticks_per_second)


func _on_menu_physics_fps_changed() -> void:
	GPU.set_uniform(GPU.Uniform.DELTA, 1.0 / Engine.physics_ticks_per_second)
