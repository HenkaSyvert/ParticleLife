#[compute]
#version 450


layout(local_size_x = 512, local_size_y = 1, local_size_z = 1) in;


layout(binding = 0) buffer Positions0 {
	vec3 data[];
}
positions0;


layout(binding = 1) buffer Positions1 {
	vec3 data[];
}
positions1;


layout(binding = 2) restrict buffer Velocities {
	vec3 data[];
}
velocities;


layout(binding = 3) readonly buffer Params {
	int num_particles;
	float attraction_radius;
	float repel_radius;
	float force_strength;
	float delta;
	float max_speed;
	float universe_radius;
	bool wrap_universe;
	bool buffer_toggle;
	int num_types;
} 
params;


layout(binding = 4) readonly buffer AttractionMatrix {
	float data[];
}
attraction_matrix;


layout(binding = 5) readonly buffer Types {
	int data[];
}
types;


void main() {

	uint i = gl_LocalInvocationID.x;

	vec3 pos_i = params.buffer_toggle ? positions1.data[i] : positions0.data[i];
	vec3 force = vec3(0);

	for(int j = 0; j < params.num_particles; j++){

		if(i == j) continue;

		vec3 pos_j = params.buffer_toggle ? positions1.data[j] : positions0.data[j];
		float dist = distance(pos_i, pos_j);

		if (params.wrap_universe)
			dist = min(dist, distance(pos_i, -normalize(pos_j) * params.universe_radius));

		if(dist > params.attraction_radius) continue;

		vec3 dir = pos_j - pos_i;
		dir = normalize(dir) * 1.0 / dot(dir, dir);
		if(dist < params.repel_radius)
			force -= dir;
		else
			force += dir * attraction_matrix.data[types.data[i] * params.num_types + types.data[j]];

	}

	vec3 vel = velocities.data[i];
	force *= params.force_strength;
	vel += force / params.delta;

	if(length(vel) > params.max_speed)
		vel = normalize(vel) * params.max_speed;
	pos_i += vel;

	float overlap = length(pos_i) - params.universe_radius;
	if(overlap > 0){
		if (params.wrap_universe)
			pos_i = -normalize(pos_i) * (params.universe_radius - overlap);
		else{	
			pos_i = normalize(pos_i) * params.universe_radius;
			vel = vel - normalize(pos_i) * dot(normalize(pos_i), vel);
		}
	}

	velocities.data[i] = vel;
	if(params.buffer_toggle)
		positions0.data[i] = pos_i;
	else
		positions1.data[i] = pos_i;

}

