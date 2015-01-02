attribute vec4 aVertexPosition;
attribute vec4 aColor;
varying vec4 ex_Color;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main(void)
{
	gl_Position = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
	ex_Color = aColor;
}