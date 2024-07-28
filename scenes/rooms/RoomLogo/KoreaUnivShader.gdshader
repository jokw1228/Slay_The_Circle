shader_type canvas_item;

void fragment()
{
    if (FRAGCOORD.x > 576.0)
	{
        discard;
    }
}