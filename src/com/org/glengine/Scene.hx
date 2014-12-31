package com.org.glengine;
import com.org.bbb.BuildHistory.BuildState;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;

/**
 * ...
 * @author ...
 */
class Scene
{
    public var handle : GLFramebuffer;
    public var texture : Texture2D;
    public var width : Int;
    public var height : Int;
    
    public function new(width : Int, height : Int) 
    {
        this.width = width;
        this.height = height;
    }
    public var db : GLRenderbuffer;
    public function init() : Void
    {
        handle = GL.createFramebuffer();
        GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
        
        texture = new Texture2D();
        texture.bind();
        texture.upload(0, 0, width, height, GL.UNSIGNED_BYTE, new UInt8Array(new ByteArray()));
        
        db = GL.createRenderbuffer();
        GL.bindRenderbuffer(GL.RENDERBUFFER, db);
        GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
        
        GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.RENDERBUFFER, db);
        
        var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
        if (status != GL.FRAMEBUFFER_COMPLETE) {
            throw "Framebuffer could not be initialized";
        }
    }
    
    public function dispose() : Void
    {
        GL.deleteFramebuffer(handle);
        texture.dispose();
    }
    
    public function render() : Void
    {
        // Draw to texture
        //GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
        
    }
    
}