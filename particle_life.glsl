#[compute]
#version 450

layout(local_size_x = 512, local_size_y = 1, local_size_z = 1) in;


layout(set = 0, binding = 0) buffer Positions {
	vec3 data[];
}
positions;

layout(set = 0, binding = 1, std430) restrict buffer Velocities {
	vec3 data[];
}
velocities;

layout(set = 0, binding = 2) readonly uniform Params {
	int num_particles;
	float attraction_radius;
	float repel_radius;
	// todo: add attraction matrix
	float force_strength;
	float delta; // todo: other way to do this?..
	float max_speed;
	float universe_radius;
	bool wrap_universe;
	int index_toggle;
	int num_types;
} params;

layout(set = 0, binding = 3, std430) readonly buffer AttractionMatrix {
	float data[];
}
attraction_matrix;

layout(set = 0, binding = 4, std430) readonly buffer Types {
	int data[];
}
types;

void main() {

	uint i = gl_LocalInvocationID.x;
	int pos_in_index = params.num_particles * params.index_toggle;
	int pos_out_index = params.num_particles - params.num_particles * params.index_toggle;
	vec3 p = positions.data[pos_in_index + i];
	vec3 force_sum = vec3(0);

	//positions.data[pos_out_index + i] = 1.01f * positions.data[pos_in_index + i];
	//return;

	for(int j = 0; j < params.num_particles; j++){

		if(i == j) continue;

		vec3 q = positions.data[pos_in_index + j];
		float dist = distance(p, q);
		if(dist > params.attraction_radius) continue;

		vec3 dir = q - p;
		if(dist < params.repel_radius)
			force_sum += -dir;
		else
			force_sum += dir * attraction_matrix.data[types.data[i] * params.num_types + types.data[j]];

	}

	vec3 v = velocities.data[i];
	force_sum *= params.force_strength;
	vec3 acceleration = force_sum;
	v += acceleration / params.delta;
	
	if(v.length() > params.max_speed && v != vec3(0)) // WHY is this check needed??
		v = normalize(v) * params.max_speed;
	p += v;

	float overlap = p.length() - params.universe_radius;
	if(overlap > 0){
		if (params.wrap_universe){
			float l = -params.universe_radius + overlap;
			if (p.length() > l) p = normalize(p) * l;
		}
		else{
			if(p.length() > params.universe_radius)
				p = normalize(p) * params.universe_radius;
			v = vec3(0.0);
		}
	}

	velocities.data[i] = v;
	positions.data[pos_out_index + i] = p;

}

