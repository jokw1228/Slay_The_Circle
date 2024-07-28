shader_type canvas_item;

void fragment()
{
    if (FRAGCOORD.x < 576.0)
	{
        discard;
    }
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
