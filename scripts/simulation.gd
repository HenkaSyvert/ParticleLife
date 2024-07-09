class_name Simulation

var run_on_gpu: bool:
	set(value):
		sync_gpu_cpu()
		run_on_gpu = value


func sync_gpu_cpu() -> void:
	pass


func get_pos_2d(_index: int) -> Vector2:
	return Vector2()


func get_pos_3d(_index: int) -> Vector3:
	return Vector3()


func get_vel_2d(_index: int) -> Vector2:
	return Vector2()


func get_vel_3d(_index: int) -> Vector3:
	return Vector3()


func do_step(_delta: float) -> void:
	pass
