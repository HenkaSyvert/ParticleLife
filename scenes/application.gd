class_name Application
extends Node

var dimensions: int = 3

var simulation: Simulation


func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	start_simulation()


func start_simulation() -> void:
	if dimensions == 2:
		simulation = Simulation2D.new()
		($Camera2D as Camera2D).make_current()
	elif dimensions == 3:
		simulation = Simulation3D.new()


func _on_menu_pressed_restart(seed_string: String, particles_count: int, types_count: int) -> void:
	Params.randomize_particle_params(seed_string, particles_count, types_count)
	start_simulation()
