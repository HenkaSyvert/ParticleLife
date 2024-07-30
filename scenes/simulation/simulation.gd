class_name Simulation
extends Node

static var _instance: Simulation = null

static var run_on_gpu: bool:
	set(value):
		_sync_gpu_cpu()
		run_on_gpu = value

static var is_paused: bool = false


static func _sync_gpu_cpu() -> void:
	pass


func _ready() -> void:
	_instance = self


func _physics_process(delta: float) -> void:
	if not is_paused:
		Simulation.do_step(delta)


static func do_step(delta: float) -> void:

	if _instance == null:
		return
	
	if run_on_gpu:
		_instance._do_gpu_step()
	else:
		_instance._do_cpu_step(delta)


func _do_gpu_step() -> void:
	pass


func _do_cpu_step(_delta: float) -> void:
	pass
