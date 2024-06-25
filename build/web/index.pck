GDPC                `                                                                         X   res://.godot/exported/133200997/export-3ea44b0f453fae14c9c5ee8adf72272d-ParticleLife.scn`      #'      ���[$���\��8    ,   res://.godot/global_script_class_cache.cfg  {             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      �      �̛�*$q�*�́     P   res://.godot/imported/particle_life.glsl-8cb4e201ce2aa7a4535a5c045f455728.res    _      �      3]�t<�
(���}�M       res://.godot/uid_cache.bin  �~      e       ����#Db��ձ       res://FpsLabel.gd   P      ^       ����]X�f�.�        res://ParticleLife.tscn.remap   �z      i       1&,B`Y�Z�cz�9�       res://camera_movement.gd        K      `�]��SI���Wz�s�       res://icon.svg  0{      �      C��=U���^Qu��U3       res://icon.svg.import   �      �       ��-�I��m<U���$       res://particle_life.gd  �7      f'      =�A�|O���מ��(�        res://particle_life.glsl.import  z      �       �%��Ech��ӑ�x       res://project.binary`      L      �ښ�b;h�,�_�>    extends Camera3D

@export var mouse_sensitivity = 0.003
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

     extends Label


func _process(_delta):
	set_text("FPS: %d" % Engine.get_frames_per_second())

  GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cgikn3jdsrmxp"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                            �      ..    resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    transform_format    use_colors    use_custom_data    instance_count    visible_instance_count    mesh    buffer    width    invert    in_3d_space    generate_mipmaps 	   seamless    seamless_blend_skirt    as_normal_map    bump_strength 
   normalize    color_ramp    noise    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction 	   _bundled       Script    res://particle_life.gd ��������   Script    res://camera_movement.gd ��������   Script    res://FpsLabel.gd ��������   !   local://StandardMaterial3D_es8bu |         local://SphereMesh_hga30 �         local://MultiMesh_rnxrb �         local://NoiseTexture2D_g0nml          local://NoiseTexture2D_jylc8 +         local://NoiseTexture2D_45w8o J         local://NoiseTexture2D_w4oc6 i         local://NoiseTexture2D_db0lp �         local://NoiseTexture2D_0akae �      !   local://StandardMaterial3D_eqshp �         local://SphereMesh_drbe8 �         local://Environment_m44sp          local://PackedScene_xrkbp           StandardMaterial3D             o         SphereMesh    q             o      
   MultiMesh    {         �            o         NoiseTexture2D    o         NoiseTexture2D    o         NoiseTexture2D    o         NoiseTexture2D    o         NoiseTexture2D    o         NoiseTexture2D    o         StandardMaterial3D                            ���>���>�� ?���=      �G?      )\?                  ���=            "         #      33�>$            &          .        �?/            ?            I        �?J            o         SphereMesh    q         	   o         Environment    o         PackedScene    �      	         names "   @      ParticleLife 
   multimesh    script    MultiMeshInstance3D    UniverseSphere 
   transform    mesh 	   skeleton    MeshInstance3D 	   Camera3D    DirectionalLight3D    WorldEnvironment    environment    Menu    anchors_preset    anchor_right    anchor_bottom    offset_right    offset_bottom    grow_horizontal    grow_vertical    TabContainer    Simulation    visible    layout_mode    VBoxContainer 
   SeedLabel    text    Label    SeedLineEdit 	   LineEdit    UpdateButton    Button 	   FpsLabel    ControlsLabel    WrapUniverseCheckBox    size_flags_horizontal    button_pressed 	   CheckBox    NumParticlesSpinBox 
   max_value    value 
   alignment    prefix    SpinBox    NumTypesSpinBox    RunOnGpuCheckBox 
   Particles    UniverseRadiusSpinBox    AttractionRadiusSpinBox    step    RepelRadiusSpinBox    ForceStrengthSpinBox    MaxSpeedSpinBox    _on_update_button_pressed    pressed $   _on_wrap_universe_check_box_toggled    toggled +   _on_universe_radius_spin_box_value_changed    value_changed -   _on_attraction_radius_spin_box_value_changed (   _on_repel_radius_spin_box_value_changed *   _on_force_strength_spin_box_value_changed %   _on_max_speed_spin_box_value_changed    	   variants    *                           HC              HC              HC                  
                      �?              �?              �?          �B                             �?    @_�     �B                   Seed:       Update       FPS:              .   Camera: 
WASD
up / down: Shift / Space
pan: C                   Wrap Universe     @F      D      Number of Particles:      �A     @@      Number of Particle Types:       Run on GPU      �B      Universe Radius: )   ����MbP?      A      Attraction Radius: )   ���Q��?)   �G�z�?      Repel Radius: )   {�G�z�?      Force Strength: )   �������?      @      Max Speed:       node_count             nodes     (  ��������       ����                                  ����                                 	   	   ����                           
   
   ����                      ����                           ����            	      	      
                                      ����                                ����                                ����                           ����                             !   ����                                   "   ����                          &   #   ����         $      %                       ,   '   ����         (      )      *      +                 ,   -   ����         (      )      *      +                 &   .   ����         %                          /   ����                          ,   0   ����         )      *      +                 ,   1   ����         2      )       *      +   !              ,   3   ����         2   "   )   #   *      +   $              ,   4   ����         (       2      )   %   *      +   &              ,   5   ����         2   '   )   (   *      +   )             conn_count             conns     1   	       7   6                     9   8                     ;   :                     ;   <                     ;   =                     ;   >                     ;   ?                    node_paths              editable_instances              version       o      RSRC             extends MultiMeshInstance3D

@onready var num_types: int = $Menu/Simulation/NumTypesSpinBox.value
@onready var num_particles: int = $Menu/Simulation/NumParticlesSpinBox.value
@onready var wrap_universe: bool = $Menu/Simulation/WrapUniverseCheckBox.button_pressed
@onready var run_on_gpu: bool = $Menu/Simulation/RunOnGpuCheckBox.button_pressed

@onready var universe_radius: float = $Menu/Particles/UniverseRadiusSpinBox.value
@onready var attraction_radius: float = $Menu/Particles/AttractionRadiusSpinBox.value
@onready var repel_radius: float = $Menu/Particles/RepelRadiusSpinBox.value
@onready var force_strength: float = $Menu/Particles/ForceStrengthSpinBox.value
@onready var max_speed: float = $Menu/Particles/MaxSpeedSpinBox.value


var positions = []
var velocities = []
var types = []
var attraction_matrix = []
var colors = []

var rd = RenderingServer.create_local_rendering_device()
var shader
var pipeline
var uniform_set

var positions_buf
var velocities_buf
var params_buf
var attraction_matrix_buf
var types_buf

var buffer_toggle = true


func _ready():
	$UniverseSphere.scale = Vector3.ONE * $Menu/Particles/UniverseRadiusSpinBox.value * 2
	
	var seed_str = "day" #str(randi())
	$Menu/Simulation/SeedLineEdit.set_text(seed_str)

	generate_params(seed_str)
	set_multimesh_params()
	init_shader()


func _process(delta):
	
	if run_on_gpu:
		particle_life_gpu(delta)
	else:
		particle_life_cpu(delta)

	for i in range(num_particles):
		var t = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, t)


func _exit_tree():
	rd.free_rid(pipeline)
	rd.free_rid(uniform_set)
	rd.free_rid(positions_buf)
	rd.free_rid(velocities_buf)
	rd.free_rid(params_buf)
	rd.free_rid(attraction_matrix_buf)
	rd.free_rid(types_buf)
	rd.free_rid(shader)
	rd.free()


func generate_params(seed_str):
	
	seed(seed_str.hash())
	
	attraction_matrix = []
	for i in range(num_types):
		attraction_matrix.append([])
		for j in range(num_types):
			var val = randf_range(-1, 1)
			attraction_matrix[i].append(val)

	positions = []
	velocities = []
	types = []
	colors = []
	for i in range(num_particles):
		var p = Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1))
		p = p.normalized()
		p *= randf_range(0, universe_radius)
		positions.append(p)
		velocities.append(Vector3.ZERO)
		types.append(randi_range(0, num_types - 1))
	
	colors = [Color.RED, Color.BLUE, Color.YELLOW]


func set_multimesh_params():
	multimesh.instance_count = 0
	multimesh.use_colors = true
	multimesh.instance_count = num_particles
	for i in range(num_particles):
		multimesh.set_instance_color(i, colors[types[i]])


func init_shader():
	var shader_file = load("res://particle_life.glsl")
	var shader_spirv = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)
	setup_shader_uniforms()
	set_uniform_values()


func setup_shader_uniforms():

	var float_size = 4
	var buf_size = num_particles * 4 * float_size
	var params_buf_size = 48
	var attraction_matrix_buf_size = num_types**2 * 4
	var types_buf_size = num_particles * 4

	positions_buf = rd.storage_buffer_create(buf_size * 2)
	velocities_buf = rd.storage_buffer_create(buf_size)
	params_buf = rd.storage_buffer_create(params_buf_size)
	attraction_matrix_buf = rd.storage_buffer_create(attraction_matrix_buf_size)
	types_buf = rd.storage_buffer_create(types_buf_size)

	var positions_u = RDUniform.new()
	var velocities_u = RDUniform.new()
	var params_u = RDUniform.new()
	var attraction_matrix_u = RDUniform.new()
	var types_u = RDUniform.new()
	
	positions_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	velocities_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	params_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	attraction_matrix_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	types_u.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	
	positions_u.binding = 0
	velocities_u.binding = 1
	params_u.binding = 2
	attraction_matrix_u.binding = 3
	types_u.binding = 4
	
	positions_u.add_id(positions_buf)
	velocities_u.add_id(velocities_buf)
	params_u.add_id(params_buf)
	attraction_matrix_u.add_id(attraction_matrix_buf)
	types_u.add_id(types_buf)
	
	var uniforms = [positions_u, velocities_u, params_u, attraction_matrix_u, types_u]
	uniform_set = rd.uniform_set_create(uniforms, shader, 0)


func set_uniform_values():
	var positions_pba = PackedByteArray()
	var velocities_pba = PackedByteArray()
	var params_pba = PackedByteArray()
	var attraction_matrix_pba = PackedByteArray()
	var types_pba = PackedByteArray()
	
	# vulkan pads vec3 as 16 bytes
	var float_size = 4
	var buf_size = num_particles * 4 * float_size
	positions_pba.resize(buf_size * 2)
	
	velocities_pba.resize(buf_size)

	var params_buf_size = 48
	params_pba.resize(params_buf_size)
	
	var attraction_matrix_buf_size = num_types**2 * 4
	attraction_matrix_pba.resize(attraction_matrix_buf_size)
	
	var types_buf_size = num_particles * 4
	types_pba.resize(types_buf_size)
	
	var stride = float_size * 4
	for i in range(num_particles):
		positions_pba.encode_float(i * stride, positions[i].x)
		positions_pba.encode_float(i * stride + 1 * float_size , positions[i].y)
		positions_pba.encode_float(i * stride + 2 * float_size, positions[i].z)

	params_pba.encode_s32(0, num_particles)
	params_pba.encode_float(1 * 4, attraction_radius)
	params_pba.encode_float(2 * 4, repel_radius)
	params_pba.encode_float(3 * 4, force_strength)
	#params_pba.encode_float(4 * 4, 0.0) # delta
	params_pba.encode_float(5 * 4, max_speed)
	params_pba.encode_float(6 * 4, universe_radius)
	params_pba.encode_s32(7 * 4, int(wrap_universe))
	params_pba.encode_s32(8 * 4, int(buffer_toggle))
	params_pba.encode_s32(9 * 4, num_types)

	for i in range(num_types):
		for j in range(num_types):
			attraction_matrix_pba.encode_float((i * num_types + j) * 4, attraction_matrix[i][j])

	for i in range(num_particles):
		types_pba.encode_s32(i * 4, types[i])

	rd.buffer_update(positions_buf, 0, buf_size * 2, positions_pba)
	rd.buffer_update(velocities_buf, 0, buf_size, velocities_pba)
	rd.buffer_update(params_buf, 0, params_buf_size, params_pba)
	rd.buffer_update(attraction_matrix_buf, 0, attraction_matrix_buf_size, attraction_matrix_pba)
	rd.buffer_update(types_buf, 0, types_buf_size, types_pba)


func particle_life_cpu(delta):
	var new_positions = []
	for i in range(num_particles):
		
		var force = Vector3.ZERO
		for j in range(num_particles):
			
			if i == j:
				continue
		
			var dist_squared = min(positions[i].distance_squared_to(positions[j]),
				positions[i].distance_squared_to(-positions[j].normalized() * universe_radius))
			if dist_squared > attraction_radius**2:
				continue
			
			var dir = (positions[j] - positions[i])
			dir.limit_length(1.0 / dir.length()**2)
			if dist_squared < repel_radius**2:
				force -= dir
			else:
				force += dir * attraction_matrix[types[i]][types[j]]
		
		force *= force_strength
		velocities[i] += force / delta
		velocities[i] = velocities[i].limit_length(max_speed)
		var pos = positions[i] + velocities[i]
		
		var overlap_squared = positions[i].length_squared() - universe_radius**2
		if overlap_squared > 0:
			if wrap_universe:
				var length = universe_radius - sqrt(overlap_squared)
				pos = -pos.limit_length(length)
			else:
				pos = pos.limit_length(universe_radius)
				velocities[i] = Vector3.ZERO
		
		new_positions.append(pos)

	positions = new_positions


func particle_life_gpu(delta):
	
	var pba = PackedByteArray()
	pba.resize(4)
	
	buffer_toggle = not buffer_toggle
	pba.encode_s32(0, int(buffer_toggle))
	rd.buffer_update(params_buf, 8 * 4, 4, pba)
	
	pba.encode_float(0, delta)
	rd.buffer_update(params_buf, 4 * 4, 4, pba)
	
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, 512, 1, 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()
	
	var float_size = 4
	var num_elements = 4
	var stride = float_size * num_elements
	
	var out_offset = num_particles - num_particles * int(buffer_toggle)
	var data = rd.buffer_get_data(positions_buf, out_offset * stride, num_particles * stride)

	for i in range(num_particles):
		positions[i].x = data.decode_float(i * num_elements * float_size)
		positions[i].y = data.decode_float((i * num_elements + 1) * float_size)
		positions[i].z = data.decode_float((i * num_elements + 2) * float_size)


func _on_universe_radius_spin_box_value_changed(value):
	universe_radius = value
	$UniverseSphere.scale = Vector3.ONE * value * 2
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_float(0, value)
	rd.buffer_update(params_buf, 6 * 4, 4, pba)


func _on_attraction_radius_spin_box_value_changed(value):
	attraction_radius = value
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_float(0, value)
	rd.buffer_update(params_buf, 1 * 4, 4, pba)


func _on_repel_radius_spin_box_value_changed(value):
	repel_radius = value
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_float(0, value)
	rd.buffer_update(params_buf, 2 * 4, 4, pba)


func _on_force_strength_spin_box_value_changed(value):
	force_strength = value
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_float(0, value)
	rd.buffer_update(params_buf, 3 * 4, 4, pba)


func _on_max_speed_spin_box_value_changed(value):
	max_speed = value
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_float(0, value)
	rd.buffer_update(params_buf, 5 * 4, 4, pba)


func _on_wrap_universe_check_box_toggled(toggled_on):
	wrap_universe = toggled_on
	var pba = PackedByteArray()
	pba.resize(4)
	pba.encode_s32(0, int(toggled_on))
	rd.buffer_update(params_buf, 7 * 4, 4, pba)


func _on_update_button_pressed():
	num_particles = $Menu/Simulation/NumParticlesSpinBox.value
	num_types = $Menu/Simulation/NumTypesSpinBox.value
	run_on_gpu = $Menu/Simulation/RunOnGpuCheckBox.button_pressed
	generate_params($Menu/Simulation/SeedLineEdit.text)
	buffer_toggle = true
	set_uniform_values()
	set_multimesh_params()

          RSRC                    RDShaderFile            ��������                                                  resource_local_to_scene    resource_name    bytecode_vertex    bytecode_fragment    bytecode_tesselation_control     bytecode_tesselation_evaluation    bytecode_compute    compile_error_vertex    compile_error_fragment "   compile_error_tesselation_control %   compile_error_tesselation_evaluation    compile_error_compute    script 
   _versions    base_error           local://RDShaderSPIRV_5glun ;         local://RDShaderFile_x8xj7 �         RDShaderSPIRV          P  #    �                 GLSL.std.450                     main          .   �   �   �                         �       main         i        gl_LocalInvocationID         in_offset        Params           num_particles           attraction_radius           repel_radius            force_strength          delta           max_speed           universe_radius         wrap_universe           buffer_toggle        	   num_types        params       out_offset    *   p     ,   Positions     ,       data      .   positions     6   force     9   j     K   q     R   dist      i   dir   �   AttractionMatrix      �       data      �   attraction_matrix     �   Types     �       data      �   types     �   v     �   Velocities    �       data      �   velocities    �   overlap G           H            H         #       H           H        #      H           H        #      H           H        #      H           H        #      H           H        #      H           H        #      H           H        #      H           H        #       H     	      H     	   #   $   G        G     "       G     !      G  +         H  ,       #       G  ,      G  .   "       G  .   !       G  �         H  �          H  �       #       G  �      G  �   "       G  �   !      G  �         H  �          H  �       #       G  �      G  �   "       G  �   !      G  �         H  �          H  �       #       G  �      G  �   "       G  �   !      G  �              !                                   	            
      	   ;  
         +                                                                                                        ;           +                        +             (            )      (     +   (     ,   +      -      ,   ;  -   .         3      (   +     7       ,  (   8   7   7   7     B      Q         +     Z         [         +     b      +     o     �?+     w        �        �   �      �      �   ;  �   �        �        �   �      �      �   ;  �   �      +     �   	     �   (     �   �      �      �   ;  �   �      +     �      +     �      +     �      +     �         �         +     �      +     �      ,  	   �   �   �   �   6               �     ;           ;           ;           ;  )   *      ;  )   6      ;     9      ;  )   K      ;  Q   R      ;  )   i      ;  )   �      ;  Q   �      A              =           >        A              =           A              =           �              >        A               =     !       A     "         =     #   "   A     $         =     %   $   �     &   #   %   �     '   !   &   >     '   =     /      |     0   /   =     1      �     2   0   1   A  3   4   .      2   =  (   5   4   >  *   5   >  6   8   >  9      �  :   �  :   �  <   =       �  >   �  >   =     ?   9   A     @         =     A   @   �  B   C   ?   A   �  C   ;   <   �  ;   =     D      =     E   9   |     F   E   �  B   G   D   F   �  I       �  G   H   I   �  H   �  =   �  I   =     L      =     M   9   �     N   L   M   A  3   O   .      N   =  (   P   O   >  K   P   =  (   S   *   =  (   T   K        U      C   S   T   =  (   V   *   =  (   W   K     (   X      E   W     (   Y   X   A  [   \      Z   =     ]   \   �  (   ^   Y   ]        _      C   V   ^        `      %   U   _   >  R   `   =     a   R   A  [   c      b   =     d   c   �  B   e   a   d   �  g       �  e   f   g   �  f   �  =   �  g   =  (   j   K   =  (   k   *   �  (   l   j   k   >  i   l   =  (   m   i     (   n      E   m   �  (   p   n   o   =  (   q   i   =  (   r   i   �     s   q   r   P  (   t   s   s   s   �  (   u   p   t   >  i   u   =     v   R   A  [   x      w   =     y   x   �  B   z   v   y   �  |       �  z   {   �   �  {   =  (   }   i   =  (   ~   6   �  (      ~   }   >  6      �  |   �  �   =  (   �   i   =     �      A     �   �      �   =     �   �   A     �      �   =     �   �   �     �   �   �   =     �   9   A     �   �      �   =     �   �   �     �   �   �   A  [   �   �      �   =     �   �   �  (   �   �   �   =  (   �   6   �  (   �   �   �   >  6   �   �  |   �  |   �  =   �  =   =     �   9   �     �   �   b   >  9   �   �  :   �  <   =     �      A  3   �   �      �   =  (   �   �   >  �   �   A  [   �      �   =     �   �   =  (   �   6   �  (   �   �   �   >  6   �   =  (   �   6   A  [   �      �   =     �   �   P  (   �   �   �   �   �  (   �   �   �   =  (   �   �   �  (   �   �   �   >  �   �   =  (   �   �        �      B   �   A  [   �      �   =     �   �   �  B   �   �   �   �  �       �  �   �   �   �  �   =  (   �   �     (   �      E   �   A  [   �      �   =     �   �   �  (   �   �   �   >  �   �   �  �   �  �   =  (   �   �   =  (   �   *   �  (   �   �   �   >  *   �   =  (   �   *        �      B   �   A  [   �      Z   =     �   �   �     �   �   �   >  �   �   =     �   �   �  B   �   �   7   �  �       �  �   �   �   �  �   A  �   �      �   =     �   �   �  B   �   �      �  �       �  �   �   �   �  �   =  (   �   *     (   �      E   �     (   �   �   A  [   �      Z   =     �   �   =     �   �   �     �   �   �   �  (   �   �   �   >  *   �   �  �   �  �   =  (   �   *     (   �      E   �   A  [   �      Z   =     �   �   �  (   �   �   �   >  *   �   >  �   8   �  �   �  �   �  �   �  �   =     �      =  (   �   �   A  3   �   �      �   >  �   �   =     �      |     �   �   =     �      �     �   �   �   =  (   �   *   A  3   �   .      �   >  �   �   �  8           RDShaderFile                                    RSRC         [remap]

importer="glsl"
type="RDShaderFile"
uid="uid://bjnnjnl882mbm"
path="res://.godot/imported/particle_life.glsl-8cb4e201ce2aa7a4535a5c045f455728.res"
    [remap]

path="res://.godot/exported/133200997/export-3ea44b0f453fae14c9c5ee8adf72272d-ParticleLife.scn"
       list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             lc`;�QH   res://icon.svg������"   res://ParticleLife.tscn&TG��D*   res://particle_life.glsl           ECFG      application/config/name         ParticleLife   application/run/main_scene          res://ParticleLife.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/forward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script         input/backward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      
   input/down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           echo          script         input/pan_camera�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   C   	   key_label             unicode    c      echo          script      *   rendering/renderer/rendering_method.mobile         forward_plus'   rendering/renderer/rendering_method.web         forward_plus2   rendering/environment/defaults/default_clear_color                    �?    