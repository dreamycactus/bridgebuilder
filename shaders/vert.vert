attribute vec2 aVertexPosition;
attribute vec2 aTexCoord;
attribute vec2 aColor;

varying vec2 vTexCoord;
varying vec4 vColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main(void) 
{
    vTexCoord = aTexCoord;
    vec3 color = mod(vec3(aColor.y/65536.0, aColor.y/256.0, aColor.y), 256.0) / 256.0;
	vColor = vec4(color * aColor.x, aColor.x);
    gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 0.0, 1.0);
}