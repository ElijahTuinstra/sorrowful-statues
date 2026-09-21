shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
}

void light() {
	if (LIGHT_ENERGY > 0.0) {
		LIGHT = vec4(1.0);
	}
}
