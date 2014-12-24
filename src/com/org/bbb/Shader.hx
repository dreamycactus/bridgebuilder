package com.org.bbb;
import openfl.gl.GL;

typedef ShaderSource = {
    var src:String;
    var fragment:Bool;
}
class Shader
{

    public function new(sources:Array<ShaderSource>) 
    {
        program = GL.createProgram();

        for (source in sources)
        {
            var shader = compile(source.src, source.fragment ? GL.FRAGMENT_SHADER : GL.VERTEX_SHADER);
            if (shader == null) return;
            GL.attachShader(program, shader);
            GL.deleteShader(shader);
        }

        GL.linkProgram(program);
        
        if (GL.getProgramParameter(program, GL.LINK_STATUS) == 0)
        {
            trace(GL.getProgramInfoLog(program));
            trace("VALIDATE_STATUS: " + GL.getProgramParameter(program, GL.VALIDATE_STATUS));
            trace("ERROR: " + GL.getError());
            return;
        }
    }
    
}