package com.org.glengine;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ArrayBufferView;

/**
 * ...
 * @author ...
 */
class Texture2D
{
    public var width : Int;
    public var height : Int;
    public var handle : GLTexture;
    
    public function new() 
    {
        handle = GL.createTexture();
        if (!isValid()) {
            trace("Texture failed to create");
        }
    }
    
    public function upload(x : Int, y : Int, w : Int, h : Int, dataFormat : Int, data : ArrayBufferView) : Void
    {
        bind();
        GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, w, h, 0, GL.RGBA, dataFormat, data);
        width = w;
        height = h;
    }
    
    public function setFilter(minFilter : Int, magFilter : Int) : Void
    {
        bind();
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, minFilter);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, magFilter);
    }
    public function setWrap(wrapS : Int, wrapT : Int) : Void
    {
        bind();
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, wrapS);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, wrapT);
    }
    
    public function bind() : Void
    {
        GL.bindTexture(GL.TEXTURE_2D, handle);
    }
    
    public function dispose() : Void
    {
        if (isValid()) {
            GL.deleteTexture(handle);
        }
    }
    
    public function isValid() : Bool
    {
        return handle != null;
    }
    
}