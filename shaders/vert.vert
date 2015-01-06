attribute vec3 aVertexPosition;
attribute vec2 aTexCoord;

varying vec2 vTexCoord;

uniform mat4 u_projTrans;

void main(void) 
{
    vTexCoord = aTexCoord;
    gl_Position = u_projTrans * vec4 (aVertexPosition, 1.0);
}