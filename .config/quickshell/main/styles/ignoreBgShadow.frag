#version 440

layout(location = 0) in vec2 qt_TexCoord0;

layout(location = 0) out vec4 fragColor; 

layout(std140, binding = 0) uniform buf 
{ 
    mat4 qt_Matrix; 
    float qt_Opacity; 
    vec4 color; 
    vec3 iResolution; 
    vec2 rectSize; 
    float radius; 
    float blur; 
    float opacity;
}; 

float roundedBox(vec2 p, vec2 b, float r)
{
    vec2 q = abs(p) - b + r;
    return length(max(q, 0.0)) - r;
}

void main()
{
    vec2 p = qt_TexCoord0 * iResolution.xy - iResolution.xy * 0.5;

    float d = roundedBox(p, rectSize, radius);

    if (d < 0.0)
        discard;

    float alpha = 1.0 - smoothstep(0.0, blur, d);

    fragColor = vec4(color.rgb * alpha, opacity * alpha);
}
