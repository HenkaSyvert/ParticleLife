class_name Application
extends Node

var simulation: Simulation


func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	start_simulation()


func start_simulation() -> void:
	if simulation != null:
		remove_child(simulation)
	if Params.dimensions == 2:
		var sim_2d: PackedScene = preload("res://scenes/simulation/simulation2d/simulation_2d.tscn")
		var n: Simulation2D = sim_2d.instantiate()
		add_child(n, true)
		simulation = n
	elif Params.dimensions == 3:
		var sim_3d: PackedScene = preload("res://scenes/simulation/simulation3d/simulation_3d.tscn")
		var n: Simulation3D = sim_3d.instantiate()
		add_child(n, true)
		simulation = n


func _on_menu_pressed_restart(
	seed_string: String, particles_count: int, types_count: int, dims: int
) -> void:
	Params.randomize_particle_params(seed_string, particles_count, types_count, dims)
	start_simulation()
