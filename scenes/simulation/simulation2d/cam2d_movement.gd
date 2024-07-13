extends Camera2D

var zoom_speed: float = 50


func _process(delta: float) -> void:
	var z: float = Input.get_axis("forward", "backward")
	zoom += Vector2.ONE * zoom_speed * z * delta
