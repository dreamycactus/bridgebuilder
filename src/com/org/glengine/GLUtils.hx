package com.org.glengine;
import com.org.glengine.GLSLProgram.GLSLShaderType;
import haxe.ds.StringMap;
import openfl.Assets;
import openfl.gl.GL;

/**
 * ...
 * @author ...
 */
class GLUtils
{
    public static var shaderFileExt : StringMap<GLSLShaderType> = [
        "vs" => GLSLShaderType.VERTEX,
        "vert" => GLSLShaderType.VERTEX,
        "fs" => GLSLShaderType.FRAGMENT,
        "frag" => GLSLShaderType.FRAGMENT
    ];
    
    public static var shaderGLType : Map<GLSLShaderType, Int> = [
        GLSLShaderType.VERTEX => GL.VERTEX_SHADER,
        GLSLShaderType.FRAGMENT => GL.FRAGMENT_SHADER
    ];
    
    public static function compileShaderFromFile(program : GLSLProgram, filename : String) : Void
    {
        var extz = filename.split(".");
        if (extz.length <= 1) {
            throw "Filename: $filename invalid shader extension";
        }
        var ext = extz[extz.length - 1];
        var matchFound = false;
        var shaderType : GLSLShaderType = GLSLShaderType.VERTEX;
        for (k in shaderFileExt.keys()) {
            if (k == ext) {
                matchFound = true;
                shaderType = shaderFileExt.get(k);
            }
        }
        if (!matchFound) {
            throw "Unrecognized shader extension";
        }
        
        var source = Assets.getText(filename);
        if (source == null || source == "") {
            throw "Bad shader file contents";
        }
        var glShaderType = shaderGLType.get(shaderType);
        program.compileFromString(source, glShaderType);
    }
    
}