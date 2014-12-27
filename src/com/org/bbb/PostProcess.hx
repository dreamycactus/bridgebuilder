package com.org.bbb;
import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.utils.Float32Array;

/**
 * ...
 * @author ...
 */
class PostProcess
{

    public function new(fragmentShader:String) 
    {
            if (OpenGLView.isSupported) {
            var buffer = GL.createFramebuffer();
            var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
            switch (status)
            {
                case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
                    trace("FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
                case GL.FRAMEBUFFER_UNSUPPORTED:
                    trace("GL_FRAMEBUFFER_UNSUPPORTED");
                case GL.FRAMEBUFFER_COMPLETE:
                default:
                    trace("Check frame buffer: " + status);
            }
            buffer = GL.createBuffer();
            GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
            GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertices), GL.STATIC_DRAW);
            GL.bindBuffer(GL.ARRAY_BUFFER, null);
            
            shader = new Shader([
                { src: vertexShader, fragment: false },
                { src: Assets.getText(fragmentShader), fragment: true }
            ]);

            // default shader variables
            imageUniform = shader.uniform("uImage0");
            timeUniform = shader.uniform("uTime");
            resolutionUniform = shader.uniform("uResolution");

            vertexSlot = shader.attribute("aVertex");
            texCoordSlot = shader.attribute("aTexCoord");
    }
    
    private static var vertices(get, never):Array<Float>;
    private static inline function get_vertices():Array<Float>
    {
        return [
            -1.0, -1.0, 0, 0,
             1.0, -1.0, 1, 0,
            -1.0,  1.0, 0, 1,
             1.0, -1.0, 1, 0,
             1.0,  1.0, 1, 1,
            -1.0,  1.0, 0, 1
        ];
    }
}