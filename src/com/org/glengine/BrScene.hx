package com.org.glengine;
import com.org.bbb.BuildHistory.BuildState;
import com.org.glengine.BrCompositeScene.CompositeScene;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLTexture;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;

/**
 * ...
 * @author ...
 */
class BrScene
{
    public var handle : GLFramebuffer;
    public var texture : Texture2D;
    public var renderBuffer : GLRenderbuffer;
    
    public var width : Int;
    public var height : Int;
    
    public var compositeScene : CompositeScene;
    
    public function new(width : Int, height : Int) 
    {
        this.width = width;
        this.height = height;
    }
    
    public function init() : Void
    {
        handle = GL.createFramebuffer();
        
        rebuild();
    }
    
    public function rebuild() : Void
    {
        if (handle == null) return;
        
        GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
        
        if (texture != null) texture.dispose();
        if (renderBuffer != null) GL.deleteRenderbuffer(renderBuffer);
        
        // Create texture
        texture = new Texture2D();
        texture.upload(0, 0, width, height, GL.UNSIGNED_BYTE, null);
        texture.setWrap(GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE);
        texture.setFilter(GL.LINEAR, GL.LINEAR); 
        
        GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.handle, 0);
       
        // Create render buffer
        renderBuffer = GL.createRenderbuffer();
        GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
        GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
        
        GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderBuffer);
        
        var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
        if (status != GL.FRAMEBUFFER_COMPLETE) {
            throw "Framebuffer could not be initialized";
        }
    }
    
    public function dispose() : Void
    {
        if (handle != null) GL.deleteFramebuffer(handle);
        if (renderBuffer != null) GL.deleteRenderbuffer(renderBuffer);
        if (texture != null) texture.dispose();
    }
    
    public function render() : Void
    {
        // Draw to texture
        //GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
        
    }
    
}