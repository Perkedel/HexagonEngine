RSRC                    VisualShader            ��������                                            :      resource_local_to_scene    resource_name    script    output_port_for_preview    default_input_values    expanded_output_ports    source 	   cube_map    texture_type    texture    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    
   Texture2D     res://Sprites/MavrickleIcon.png ���J6�'   
   local://1 �      
   local://2 �      
   local://3 /         local://VisualShader_dpapy s         Cubemap             VisualShaderNodeCubemap                                   VisualShaderNodeTexture    	                               VisualShader 	   
      �  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_frg_3 : source_color;
uniform samplerCube cube_frg_2 : source_color;



void fragment() {
// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, UV);


	vec4 n_out2p0;
// Cubemap:2
	n_out2p0 = texture(cube_frg_2, vec3(n_out3p0.xyz));


// Output:0
	ALBEDO = vec3(n_out2p0.xyz);


}
    
     "� ���$   
     9D  �A%            &   
     4C  �B'            (   
     ��  �B)                                             RSRC