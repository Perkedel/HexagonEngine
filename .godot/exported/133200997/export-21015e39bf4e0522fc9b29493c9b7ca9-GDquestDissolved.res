RSRC                    VisualShader            ��������                                            R      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script 	   function 	   operator    source    texture    texture_type    op_type 	   constant    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    
   Texture2D 6   res://Shader/NoiseTexture/GDquestDissolved_noise.tres ��������   
   local://1 "
      
   local://2 e
      
   local://3 �
      
   local://4 �
      
   local://6 T      
   local://7 �      
   local://8 �      
   local://9          local://10 ~         local://11 �         local://12 0         local://13 q         local://VisualShader_xy2ma �         VisualShaderNodeInput                       time          VisualShaderNodeInput                       uv          VisualShaderNodeFloatFunc                                 VisualShaderNodeFloatOp                                                 @                  VisualShaderNodeTexture    
                      VisualShaderNodeFloatOp                                VisualShaderNodeFloatFunc                                VisualShaderNodeFloatOp                                           )   {�G�zt?                  VisualShaderNodeFloatOp                                   �?      )   {�G�zt?                  VisualShaderNodeFloatFunc                                VisualShaderNodeVectorOp                                VisualShaderNodeColorConstant                      �?��/?      �?         VisualShader          �  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_frg_7;



void fragment() {
// Input:3
	vec2 n_out3p0 = UV;


// Texture2D:7
	vec4 n_out7p0 = texture(tex_frg_7, n_out3p0);


// Input:2
	float n_out2p0 = TIME;


// FloatFunc:4
	float n_out4p0 = sin(n_out2p0);


// FloatOp:5
	float n_in5p1 = 2.00000;
	float n_out5p0 = n_out4p0 / n_in5p1;


// FloatOp:8
	float n_out8p0 = n_out7p0.x - n_out5p0;


// FloatFunc:9
	float n_out9p0 = round(n_out8p0);


// FloatOp:10
	float n_in10p1 = 0.00500;
	float n_out10p0 = n_out8p0 - n_in10p1;


// FloatOp:11
	float n_in11p0 = 1.00000;
	float n_out11p0 = n_in11p0 - n_out10p0;


// FloatFunc:12
	float n_out12p0 = round(n_out11p0);


// ColorConstant:14
	vec4 n_out14p0 = vec4(1.000000, 0.686275, 0.000000, 1.000000);


// VectorOp:13
	vec3 n_out13p0 = vec3(n_out12p0) * vec3(n_out14p0.xyz);


// Output:0
	ALPHA = n_out9p0;
	EMISSION = n_out13p0;


}
    
   v2��  �                  (   
     HD    )             *   
     C�  �B+            ,   
     �  ��-            .   
     �  �B/            0   
     ��  �B1            2   
     ��  �3            4   
     4�    5            6   
     �C    7            8   
         HC9            :   
     4C  HC;         	   <   
     �C  HC=         
   >   
     D   C?            @   
     �C  �CA       4                                                                        	                     	              
       
                                                                          RSRC