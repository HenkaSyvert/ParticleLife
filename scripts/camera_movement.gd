extends Camera3D

@export var mouse_sensitivity: float = 0.003
@export var move_speed: float = 100


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("pan_camera"):
		rotate_x(-(event as InputEventMouseMotion).relative.y * mouse_sensitivity)
		rotate_y(-(event as InputEventMouseMotion).relative.x * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI / 2, PI / 2)


func _process(delta: float) -> void:
	var x: float = Input.get_axis("left", "right")
	var y: float = Input.get_axis("down", "up")
	var z: float = Input.get_axis("forward", "backward")

	var dir: Vector3 = (transform.basis * Vector3(x, y, z)).normalized()
	position += dir * move_speed * delta
