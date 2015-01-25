package com.org.glengine;
import com.org.bbb.control.BuildHistory.BuildState;
import com.org.glengine.BrCompositeScene.CompositeScene;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;

/**
 * ...
 * @author ...
 */
class BrPostProcess
{
    public var handle(default, null) : GLFramebuffer;
    public var texture(default, default) : Texture2D;
    public var renderBuffer : GLRenderbuffer;
    
    public var renderTo : BrPostProcess = null;
    public var shader(default, set) : GLSLProgram;
    
    public var width : Int;
    public var height : Int;
    
    // Uniforms
    var vertexAttribute : GLUniformLocation;
    var texCoordAttribute : GLUniformLocation;
    var imageUniform : GLUniformLocation;
    var timeUniform : GLUniformLocation;
    var resolutionUniform : GLUniformLocation;
    
    
    var buffer : GLBuffer;
    
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
    
    function rebuild() : Void
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
       
        // Create render buffer - to be honest I'm not sure what this is for yet
        renderBuffer = GL.createRenderbuffer();
        GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
        GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
        
        GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderBuffer);
        
        var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
        if (status != GL.FRAMEBUFFER_COMPLETE) {
            throw "Framebuffer could not be initialized";
        }
        
        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
        
        buffer = GL.createBuffer();
        GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
        GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertices), GL.STATIC_DRAW);
        GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
    
    public function dispose() : Void
    {
        if (handle != null) GL.deleteFramebuffer(handle);
        if (renderBuffer != null) GL.deleteRenderbuffer(renderBuffer);
        if (texture != null) texture.dispose();
    }
    
    public function capture() : Void
    {
        GL.bindFramebuffer(GL.FRAMEBUFFER, handle);

        GL.viewport(0, 0, width, height);
        GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
    }
    
    public function render() : Void
    {
        var time = Math.random();
        // Draw to texture
        var fb = renderTo == null ? null : renderTo.handle;
        GL.bindFramebuffer(GL.FRAMEBUFFER, fb);
        
        GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
        shader.begin();
        
        GL.enableVertexAttribArray(vertexAttribute);
        GL.enableVertexAttribArray(texCoordAttribute);
        
        GL.activeTexture(GL.TEXTURE0);
        texture.bind();
        GL.enable(GL.TEXTURE_2D);
        
        GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
        GL.vertexAttribPointer(vertexAttribute, 2, GL.FLOAT, false, 16, 0);
        GL.vertexAttribPointer(texCoordAttribute, 2, GL.FLOAT, false, 16, 8);
        
        GL.uniform1i(imageUniform, 0);
        GL.uniform1f(timeUniform, time);
        GL.uniform2f(resolutionUniform, width, height);
        
        GL.drawArrays(GL.TRIANGLES, 0, 6);
        
        GL.bindBuffer(GL.ARRAY_BUFFER, null);
        GL.disable(GL.TEXTURE_2D);
        GL.bindTexture(GL.TEXTURE_2D, null);

        GL.disableVertexAttribArray(vertexAttribute);
        GL.disableVertexAttribArray(texCoordAttribute);
        
        shader.end();
        
        if (GL.getError() == GL.INVALID_FRAMEBUFFER_OPERATION)
        {
            trace("INVALID_FRAMEBUFFER_OPERATION!!");
        }
        
    }
    
    function set_shader(s : GLSLProgram) : GLSLProgram
    {
        if (s != null && shader != s) {
            vertexAttribute = s.getAttribLocation("aVertexPosition");
            texCoordAttribute = s.getAttribLocation ("aTexCoord");
            imageUniform = s.getUniformLocation ("uImage0");
            timeUniform = s.getUniformLocation ("uTime");
            resolutionUniform = s.getUniformLocation ("uResolution");
        }
        shader = s;

        return s;
    }
    
    static var vertices(get, never): Array<Float>;
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