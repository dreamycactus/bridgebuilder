varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void)
{
    vec4 color = texture2D(uImage0, vTexCoord);
    gl_FragColor = color;
}