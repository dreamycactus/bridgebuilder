package com.org.glengine;
import openfl.display.OpenGLView;
import openfl.gl.GL;

/**
 * ...
 * @author ...
 */
class GLEngine
{
    var view : OpenGLView;
    public function new() 
    {
        if (OpenGLView.isSupported) {
            view = new OpenGLView();

            // Init shaders
            var vertexShaderSource = "";
            var vertexShader = GL.createShader(GL.VERTEX_SHADER);
            GL.shaderSource(vertexShader, vertexShaderSource);
            GL.compileShader(vertexShader);
            
        } else {
            trace("GL not supported");
        }
    }
    
}