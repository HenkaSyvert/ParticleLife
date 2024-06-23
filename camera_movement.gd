extends Camera3D

@export var mouse_sensitivity = 0.005
@export var move_speed = 100


func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("pan_camera"):
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)

		
func _process(delta):
	
	var x = Input.get_axis("left", "right")
	var y = Input.get_axis("down", "up")
	var z = Input.get_axis("forward", "backward")
	
	var dir = (transform.basis * Vector3(x, y, z)).normalized()
	position += dir * move_speed * delta

