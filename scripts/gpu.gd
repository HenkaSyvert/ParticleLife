class_name GPU
extends RefCounted

enum Uniform {
	NUM_PARTICLES,
	ATTRACTION_RADIUS,
	REPEL_RADIUS,
	FORCE_STRENGTH,
	DELTA,
	MAX_SPEED,
	UNIVERSE_RADIUS,
	WRAP_UNIVERSE,
	BUFFER_TOGGLE,
	NUM_TYPES,
	NUM_PARAMS,
	ATTRACTION_MATRIX,
	POSITIONS,
	TYPES,
	VELOCITIES,
}

const SIZEOF_DATATYPE: int = 4
const NUM_VEC_ELEMENTS: int = 4
const MEM_ALIGNMENT: int = 16
const WORKGROUP_SIZE: Vector3i = Vector3i(512, 1, 1)

static var _num_particles: int
static var _num_types: int

static var _rd: RenderingDevice = RenderingServer.create_local_rendering_device()
static var _shader: RID
static var _pipeline: RID
static var _uniform_set: RID

static var _positions_bufs: Array[RID]
static var _velocities_buf: RID
static var _params_buf: RID
static var _attraction_matrix_buf: RID
static var _types_buf: RID

static var _positions_buf_size: int
static var _velocities_buf_size: int
static var _params_buf_size: int
static var _attraction_matrix_buf_size: int
static var _types_buf_size: int

static var _buffer_toggle: int


static func _static_init() -> void:
	var _shader_file: RDShaderFile = load("res://particle_life.glsl")
	var _shader_spirv: RDShaderSPIRV = _shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(_shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)
	assert(_positions_bufs.resize(2) == OK)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_pipeline)
		GPU._free_uniforms()
		_rd.free_rid(_shader)
		_rd.free()


static func _free_uniforms() -> void:
	if _uniform_set.is_valid():
		_rd.free_rid(_uniform_set)
		_rd.free_rid(_positions_bufs[0])
		_rd.free_rid(_positions_bufs[1])
		_rd.free_rid(_velocities_buf)
		_rd.free_rid(_params_buf)
		_rd.free_rid(_attraction_matrix_buf)
		_rd.free_rid(_types_buf)


static func setup_shader_uniforms(num_particles: int, num_types: int) -> void:
	_num_particles = num_particles
	_num_types = num_types

	_free_uniforms()
	_buffer_toggle = 1

	_positions_buf_size = _num_particles * NUM_VEC_ELEMENTS * SIZEOF_DATATYPE
	_velocities_buf_size = _num_particles * NUM_VEC_ELEMENTS * SIZEOF_DATATYPE
	_params_buf_size = (
		ceili((Uniform.NUM_PARAMS as float) * SIZEOF_DATATYPE / MEM_ALIGNMENT) * MEM_ALIGNMENT
	)
	_attraction_matrix_buf_size = _num_types ** 2 * SIZEOF_DATATYPE
	_types_buf_size = _num_particles * SIZEOF_DATATYPE

	_positions_bufs[0] = _rd.storage_buffer_create(_positions_buf_size)
	_positions_bufs[1] = _rd.storage_buffer_create(_positions_buf_size)
	_velocities_buf = _rd.storage_buffer_create(_velocities_buf_size)
	_params_buf = _rd.storage_buffer_create(_params_buf_size)
	_attraction_matrix_buf = _rd.storage_buffer_create(_attraction_matrix_buf_size)
	_types_buf = _rd.storage_buffer_create(_types_buf_size)

	var positions0_u: RDUniform = RDUniform.new()
	var positions1_u: RDUniform = RDUniform.new()
	var velocities_u: RDUniform = RDUniform.new()
	var params_u: RDUniform = RDUniform.new()
	var attraction_matrix_u: RDUniform = RDUniform.new()
	var types_u: RDUniform = RDUniform.new()

	positions0_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	positions1_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	velocities_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	params_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	attraction_matrix_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	types_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER

	positions0_u.binding = 0
	positions1_u.binding = 1
	velocities_u.binding = 2
	params_u.binding = 3
	attraction_matrix_u.binding = 4
	types_u.binding = 5

	positions0_u.add_id(_positions_bufs[0])
	positions1_u.add_id(_positions_bufs[1])
	velocities_u.add_id(_velocities_buf)
	params_u.add_id(_params_buf)
	attraction_matrix_u.add_id(_attraction_matrix_buf)
	types_u.add_id(_types_buf)

	var uniforms: Array[RDUniform] = [
		positions0_u, positions1_u, velocities_u, params_u, attraction_matrix_u, types_u
	]
	_uniform_set = _rd.uniform_set_create(uniforms, _shader, 0)

	GPU.set_uniform(Uniform.NUM_PARTICLES, num_particles)
	GPU.set_uniform(Uniform.NUM_TYPES, num_types)
	GPU.set_uniform(Uniform.BUFFER_TOGGLE, _buffer_toggle)
	GPU.set_uniform(Uniform.DELTA, 0.0)


static func particle_life_gpu(delta: float) -> Array[Vector3]:
	_buffer_toggle = (_buffer_toggle + 1) % 2
	GPU.set_uniform(Uniform.BUFFER_TOGGLE, _buffer_toggle)
	GPU.set_uniform(Uniform.DELTA, delta)

	var compute_list: int = _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _uniform_set, 0)
	_rd.compute_list_dispatch(compute_list, WORKGROUP_SIZE.x, WORKGROUP_SIZE.y, WORKGROUP_SIZE.z)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()

	var data: PackedByteArray = _rd.buffer_get_data(
		_positions_bufs[_buffer_toggle], 0, _positions_buf_size
	)

	var positions: Array[Vector3] = []
	for i: int in range(_num_particles):
		var v: Vector3 = Vector3()
		for j: int in range(3):
			var offset: int = (i * NUM_VEC_ELEMENTS + j) * SIZEOF_DATATYPE
			v[j] = data.decode_float(offset)
		positions.append(v)

	return positions


static func set_uniform(uniform: Uniform, data: Variant) -> void:
	if not _uniform_set.is_valid():
		return

	var pba: PackedByteArray = PackedByteArray()

	var buffer_uniforms: Array[Uniform] = [
		Uniform.ATTRACTION_MATRIX, Uniform.POSITIONS, Uniform.TYPES, Uniform.VELOCITIES
	]

	if uniform in buffer_uniforms:
		var buffer: RID
		var size: int

		if uniform == Uniform.ATTRACTION_MATRIX:
			buffer = _attraction_matrix_buf
			size = _attraction_matrix_buf_size
			assert(pba.resize(size) == OK)
			for i: int in range(_num_types):
				for j: int in range(_num_types):
					var offset: int = (i * _num_types + j) * SIZEOF_DATATYPE
					pba.encode_float(offset, data[i][j])

		elif uniform == Uniform.POSITIONS:
			buffer = _positions_bufs[0]
			size = _positions_buf_size
			assert(pba.resize(size) == OK)
			for i: int in range(_num_particles):
				for j: int in range(3):
					var offset: int = (i * NUM_VEC_ELEMENTS + j) * SIZEOF_DATATYPE
					pba.encode_float(offset, data[i][j])

		elif uniform == Uniform.TYPES:
			buffer = _types_buf
			size = _types_buf_size
			assert(pba.resize(size) == OK)
			for i: int in range(_num_particles):
				pba.encode_s32(i * SIZEOF_DATATYPE, data[i])

		else:
			buffer = _velocities_buf
			size = _velocities_buf_size
			assert(pba.resize(size) == OK)
			for i: int in range(_num_particles):
				for j: int in range(3):
					var offset: int = (i * NUM_VEC_ELEMENTS + j) * SIZEOF_DATATYPE
					pba.encode_float(offset, data[i][j])

		assert(_rd.buffer_update(buffer, 0, size, pba) == OK)
		return

	var s32_uniforms: Array[Uniform] = [
		Uniform.NUM_PARTICLES, Uniform.WRAP_UNIVERSE, Uniform.BUFFER_TOGGLE, Uniform.NUM_TYPES
	]

	assert(pba.resize(SIZEOF_DATATYPE) == OK)
	if uniform in s32_uniforms:
		if uniform == Uniform.WRAP_UNIVERSE:
			data = int(data)
		pba.encode_s32(0, data)
	else:
		pba.encode_float(0, data)

	assert(_rd.buffer_update(_params_buf, uniform * SIZEOF_DATATYPE, SIZEOF_DATATYPE, pba) == OK)
