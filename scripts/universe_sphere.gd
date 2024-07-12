extends MeshInstance3D


func _ready() -> void:
	scale = Vector3.ONE * Params.universe_radius * 2


func _process(_delta: float) -> void:
	scale = Vector3.ONE * Params.universe_radius * 2
