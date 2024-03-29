package com.org.glengine;

import openfl.geom.Matrix3D;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.Vector;


enum GLSLShaderType
{
    VERTEX;
    GEOMETRY;
    TESS_CONTROL;
    TESS_EVALUATION;
    FRAGMENT;
    COMPUTE;
}
/**
 * ...
 * @author ...
 */
class GLSLProgram
{
    public var handle : GLProgram;
    public var isLinked = false;
    
    public function new() 
    {
    }

    public function dispose()
    {
        if (handle == null) { return; }
        var shaders = GL.getAttachedShaders(handle);
        for (s in shaders) {
            GL.deleteShader(s);
        }
        GL.deleteProgram(handle);
    }
    
    public function compileFromString(source : String, type : Int) : Void
    {
        if (handle == null) {
            handle = GL.createProgram();
            if (handle == null) throw "Unable to create shader program";
        }

        var shaderHandle = GL.createShader(type);
        GL.shaderSource(shaderHandle, source);
        GL.compileShader(shaderHandle);

        if (GL.getShaderParameter(shaderHandle, GL.COMPILE_STATUS) == 0) {
            throw 'Error compiling shader:${GL.getShaderInfoLog(shaderHandle)}';
            
        }

        GL.attachShader(handle, shaderHandle);
        GL.deleteShader(shaderHandle);
    }
    
    public function link() : Void
    {
        if (isLinked) return;
        if (handle == null) throw "Shader has not been compiled";

        GL.linkProgram(handle);
        if (GL.getProgramParameter (handle, GL.LINK_STATUS) == 0) {
            throw "Unable to initialize the shader program";
        }
        isLinked = true;
    }
    
    public function begin() : Void
    {
        if (handle == null || !isLinked) {
            throw "Shader has not been linked";
        }
        GL.useProgram(handle);
    }
    
    public function end() : Void
    {
        if (handle == null || !isLinked) {
            throw "Shader has not been linked";
        }
        GL.useProgram(null);
    }
    
    public function validate() : Void
    {
        if (!isLinked) {
            throw "Program is not linked";
        }
        GL.validateProgram(handle);
        var status = GL.getProgramParameter(handle, GL.VALIDATE_STATUS);
        if (status == 0) {
            throw ('Program failed to validate: ${GL.getProgramParameter(handle, GL.VALIDATE_STATUS)}\nERROR: ${GL.getError ()}\nProgram Info:${GL.getProgramInfoLog(handle)}')   ;
        }
    }

    public function bindAttribLocation(location : Int, name : String) : Void
    {
        GL.bindAttribLocation(handle, location, name);
    }
    
    //public function bindFragDataLocation(location : Int, name : String) : Void
    //{
    //}
//
    //public function setUniform3f(name : String, x : Float, y : Float, z : Float) : Void
    //{
//
    //}

    public function getAttribLocation(name : String) : GLUniformLocation
    {
        return GL.getAttribLocation(handle, name);
    }

    public function getUniformLocation(name : String) : GLUniformLocation
    {
        return GL.getUniformLocation(handle, name);
    }
    
    public function setUniformMatrix(uniform : GLUniformLocation, matrix : Matrix3D)
    {
        GL.uniformMatrix4fv (uniform, false, new Float32Array(matrix.rawData));
    }
    
    function getShaderLog(shaderHandle : GLShader) : String
    {
        return GL.getShaderInfoLog(shaderHandle);
    }
}