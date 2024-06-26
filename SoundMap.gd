extends AudioStreamPlayer

var fib_points
var playback
var pulse_hz = 0.0
var tones
var a2_freq = 110.0
var twelfth_root_of_2 = 2**(1.0 / 12.0)

var thread


func _ready():
	
	play()
	playback = get_stream_playback()
	thread = Thread.new()
	#thread.start(fill_buffer)

	fib_points = fibonacci_sphere(100)
	#for i in range(100):
#		var t = Transform3D(Basis(), fib_points[i] * universe_radius)
#		multimesh.set_instance_transform(i, t)

	for i in range(100):
		var t = a2_freq * twelfth_root_of_2**i


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		pulse_hz = 880.0
	elif Input.is_action_pressed("ui_right"):
		pulse_hz = 220.0
	else:
		pulse_hz = 440.0
	fill_buffer(delta)

func fill_buffer(delta):	
	for i in range(playback.get_frames_available()):
		playback.push_frame(Vector2.ONE * sin(delta * TAU))



func fibonacci_sphere(n):
	var points = []
	var phi = PI * (sqrt(5) - 1)
	for i in range(n):
		var y = 1  - (i / float(n - 1)) * 2
		var r = sqrt(1 - y**2)
		var theta = phi * i
		var x = r * cos(theta)
		var z = r * sin(theta)
		points.append(Vector3(x, y, z))
	return points









