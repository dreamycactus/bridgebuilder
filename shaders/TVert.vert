attribute vec4 aVertexPosition;
attribute vec4 aColor;

varying vec4 vColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main(void)
{
    vColor = aColor;
    gl_Position = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
}