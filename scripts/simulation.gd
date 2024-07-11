class_name Simulation

static var run_on_gpu: bool:
	set(value):
		sync_gpu_cpu()
		run_on_gpu = value


static func sync_gpu_cpu() -> void:
	pass


func do_step(_delta: float) -> void:
	pass
