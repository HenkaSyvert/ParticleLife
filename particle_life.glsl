#[compute]
#version 450


layout(local_size_x = 512, local_size_y = 1, local_size_z = 1) in;


layout(binding = 0) buffer Positions {
	vec3 data[];
}
positions;


layout(binding = 1) restrict buffer Velocities {
	vec3 data[];
}
velocities;


layout(binding = 2) readonly buffer Params {
	int num_particles;
	float attraction_radius;
	float repel_radius;
	float force_strength;
	float delta;
	float max_speed;
	float universe_radius;
	bool wrap_universe;
	int buffer_toggle;
	int num_types;
} 
params;


layout(binding = 3) readonly buffer AttractionMatrix {
	float data[];
}
attraction_matrix;


layout(binding = 4) readonly buffer Types {
	int data[];
}
types;


void main() {

	uint i = gl_LocalInvocationID.x;

	int in_offset = params.num_particles * params.buffer_toggle;
	int out_offset = params.num_particles - params.num_particles * params.buffer_toggle;
	
	vec3 p = positions.data[in_offset + i];
	vec3 force = vec3(0);

	for(int j = 0; j < params.num_particles; j++){

		if(i == j) continue;

		vec3 q = positions.data[in_offset + j];
		float dist = min(distance(p, q),
						 distance(p, -normalize(q) * params.universe_radius));
		if(dist > params.attraction_radius) continue;

		vec3 dir = q - p;
		if(dist < params.repel_radius)
			force -= dir;
		else
			force += dir * attraction_matrix.data[types.data[i] * params.num_types + types.data[j]];

	}

	vec3 v = velocities.data[i];
	force *= params.force_strength;
	v += force / params.delta;
	
	if(length(v) > params.max_speed)
		v = normalize(v) * params.max_speed;
	p += v;

	float overlap = length(p) - params.universe_radius;
	if(overlap > 0){
		if (params.wrap_universe)
			p = -normalize(p) * (params.universe_radius - overlap);
		else{	
			p = normalize(p) * params.universe_radius;
			v = vec3(0);
		}
	}

	velocities.data[i] = v;
	positions.data[out_offset + i] = p;

}

