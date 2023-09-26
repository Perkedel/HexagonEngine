RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_1nl0n �          Shader          s  // https://godotengine.org/qa/41400/simple-texture-rotation-shader

shader_type canvas_item;
//render_mode unshaded, blend_disabled;

uniform float speed = 1.0;
uniform bool ignore_rotation = true;
uniform bool rotating = false;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) 
{
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

vec2 rotateUVmatrinx(vec2 uv, vec2 pivot, float rotation)
{
    mat2 rotation_matrix=mat2(  vec2(sin(rotation),-cos(rotation)),
                                vec2(cos(rotation),sin(rotation))
                                );
    uv -= pivot;
    uv= uv*rotation_matrix;
    uv += pivot;
    return uv;
}

void vertex() {
	if(rotating){
		VERTEX = rotateUV(VERTEX, 3.14/TEXTURE_PIXEL_SIZE, TIME * speed);
	}
}       RSRC