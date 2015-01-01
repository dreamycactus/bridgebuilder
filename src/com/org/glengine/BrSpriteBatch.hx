package com.org.glengine;
import lime.utils.UInt16Array;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;

/**
 * ...
 * @author ...
 */
class BrSpriteBatch
{
    public var isDrawing : Bool = false;
    public var currentBatchSize : Int = 0;
    public var currentTexture : Texture2D = null;
    public var blendingEnabled : Bool = true;
    public var dirty : Bool = true;
    public var shader(default, set) : GLSLProgram;
    public var size : Int = 100;
    
    var indexBuffer : GLBuffer;
    var indices : UInt16Array;
    var lastIndexCount : Int = 0;
    var numItemsPerPack = 6;

    
    var vertexBuffer : GLBuffer;
    var vertices : Float32Array;
    var stride : Int;
    
    // Shader Uniforms
    var projectionMatrixUniform : GLUniformLocation;
    var vertexAttribute : GLUniformLocation;= p.getAttribLocation("aVertexPosition");
    var texCoordAttribute : GLUniformLocation;= p.getAttribLocation ("aTexCoord");
    var projectionMatrixUniform : GLUniformLocation;= p.getUniformLocation ("uProjectionMatrix");
    var modelViewMatrixUniform : GLUniformLocation;= p.getUniformLocation ("uModelViewMatrix");
    var imageUniform : GLUniformLocation;= p.getUniformLocation ("uImage0");
    
    public function new() 
    {
        //var stride = 
        var numVerts = size * 4 * numItemsPerPack;
        var numIndicies = size * numItemsPerPack;

        vertices = new Float32Array(numVerts);
        indices = new UInt16Array(numIndicies);
        
        var i = 0;
        var j = 0;
        
        while (i < numIndicies) {
            indices[i + 0] = j + 0;
            indices[i + 1] = j + 1;
            indices[i + 2] = j + 2;
            indices[i + 3] = j + 0;
            indices[i + 4] = j + 2;
            indices[i + 5] = j + 3;
            i += 6;
            j += j;
        }
        
        buildBuffers();
        
        shader = null;
    }
    
    public function begin() : Void
    {
        isDrawing = true;
    }
    
    public function end() : Void
    {
        if (idx > 0) {
            flush();
        }
        isDrawing = false;
    }
    
    public function draw(texture : Texture2D, x : Float, y : Float, options : Dynamic=null) : Void
    {
        if (texture != currentTexture) {
            
        }
        
        var drawVertices = this.vertices;
        
        if (idx == vertices.length) {
            flush();
        }
        
        vertices.push(x1);
        vertices.push(y1);
        vertices.push(color);
        vertices.push(u);
        vertices.push(v);
        
        idx += 20; // 5 * 4
        
    }
    
    function buildBuffers() : Void
    {
        vertexBuffer = GL.createBuffer();
        indexBuffer = GL.createBuffer();
        
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
        
        GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
        GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.DYNAMIC_DRAW);
    }
    
    public function flush() : Void
    {
        if (currentBatchSize == 0) return;
        
        shader.use();
        
        if (dirty) {
            dirty = false;
            GL.activeTexture(GL.TEXTURE0);
            
            GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
            GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
            
            GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
            
            var stride = numItemsPerPack * 4;
        }
        
    }
    
    public function dispose() : Void
    {
        vertices = null;
        indices = null;
        
        GL.deleteBuffer(vertexBuffer);
        GL.deleteBuffer(indexBuffer);
        
        currentTexture = null;
    }
    
    function set_shader(s : GLSLProgram) : GLSLProgram
    {
        shader = s;
        if (s != null) {
            projectionMatrixUniform = s.getAttribLocation('uProjectionMatrix');
            vertexAttribute = s.getAttribLocation("aVertexPosition");
            texCoordAttribute = s.getAttribLocation ("aTexCoord");
            projectionMatrixUniform = s.getUniformLocation ("uProjectionMatrix");
            modelViewMatrixUniform = s.getUniformLocation ("uModelViewMatrix");
            imageUniform = s.getUniformLocation ("uImage0");
        }
        return s;
    }
}