package com.org.glengine;
import openfl.utils.Int16Array;
import openfl.geom.Matrix3D;
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
    
    public var transformMatrix : Matrix3D = new Matrix3D();
    public var projectionMatrix : Matrix3D = new Matrix3D();
    
    var indexBuffer : GLBuffer;
    var indices : Int16Array;
    var idx : Int = 0;
    var numItemsPerPack = 6;

    var vertexBuffer : GLBuffer;
    var vertices : Float32Array;
    var stride : Int;
    
    // Shader Uniforms
    var vertexAttribute : GLUniformLocation;
    var texCoordAttribute : GLUniformLocation;
    var colorAttribute : GLUniformLocation;
    var projectionMatrixUniform : GLUniformLocation;
    var modelViewMatrixUniform : GLUniformLocation;
    var imageUniform : GLUniformLocation;
    
    public function new() 
    {
        //var stride = 
        var numVerts = size * 4 * numItemsPerPack;
        var numIndicies = size * numItemsPerPack;

        vertices = new Float32Array(numVerts);
        indices = new Int16Array (numIndicies);
        
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
            j += 4;
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
            switchTexture(texture);
        }
        
        var drawVertices = this.vertices;
        
        if (idx == vertices.length) {
            flush();
        }

        var fx = 0.0;
        var fy = 0.0;
        var fx2 = x + texture.width;
        var fy2 = y + texture.height;
        var u = 0.0;
        var v = 1.0;
        var u2 = 1.0;
        var v2 = 0.0;
        
        var p1x = texture.height;
        
        var x1 = x;
        var y1 = y;
        
        var x2 = fx2;
        var y2 = fy2;
        
        var color = 0xffffff;
        
        vertices[idx++] = x1;
        vertices[idx++] = y1;
        vertices[idx++] = u;
        vertices[idx++] = v;
        vertices[idx++] = color;
        vertices[idx++] = 0xFFFFFFFF;

        
        vertices[idx++] = x2;
        vertices[idx++] = fy2;
        vertices[idx++] = u;
        vertices[idx++] = v2;
        vertices[idx++] = color;
        vertices[idx++] = 0xFFFFFFFF;

        
        vertices[idx++] = fx2;
        vertices[idx++] = fy2;
        vertices[idx++] = u2;
        vertices[idx++] = v2;
        vertices[idx++] = color;
        vertices[idx++] = 0xFFFFFFFF;

        
        vertices[idx++] = fx2;
        vertices[idx++] = y;
        vertices[idx++] = u2;
        vertices[idx++] = v;
        vertices[idx++] = color;
        vertices[idx++] = 0xFFFFFFFF;

        
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
        if (idx == 0) return;
        
        shader.use();
        
        if (dirty) {
            dirty = false;
            GL.activeTexture(GL.TEXTURE0);
            
            GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
            GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
            
            GL.uniformMatrix4fv(projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
            GL.uniformMatrix4fv(modelViewMatrixUniform, false, new Float32Array(transformMatrix.rawData));
            
            var stride = numItemsPerPack * 4;

            GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, stride, 0);
            GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, stride, 2 * 4);
            GL.vertexAttribPointer (colorAttribute, 2, GL.FLOAT, false, stride, 4 * 4);
            GL.uniform1i (imageUniform, 0);
            
            var positionX = (1024 - bitmapData.width) / 2;
        var positionY = (576 - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, 0, rect.height, 10, -10);
        //var modelViewMatrix = Matrix3D.create2D (1, 1, 1, 0);
        
        p.use();

        GL.enableVertexAttribArray(vertexAttribute);
        GL.enableVertexAttribArray(colorAttribute);

        var g = new Float32Array([]);
        GL.bindBuffer(GL.ARRAY_BUFFER, BufferId);
        GL.vertexAttribPointer (vertexAttribute, 4, GL.FLOAT, false, 8 * 4, 0);
        GL.vertexAttribPointer (colorAttribute, 4, GL.FLOAT, false, 8 * 4, 4 * g.BYTES_PER_ELEMENT);
        
        //trace(projectionMatrix.rawData);
        GL.uniformMatrix4fv (MVPUniform, false, new Float32Array (projectionMatrix.rawData));
        
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, IndexBufferId);
        
        GL.drawElements(GL.TRIANGLES, 48, GL.UNSIGNED_SHORT, 0);

        GL.bindBuffer(GL.ARRAY_BUFFER, null);
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
        
        GL.disableVertexAttribArray(vertexAttribute);
        GL.disableVertexAttribArray(colorAttribute);
        
        GL.useProgram(null);
            
        }
        
        //if (currentBatchSize > (size * 0.5)||true) {
            GL.bufferSubData(GL.ARRAY_BUFFER, 0, vertices);
        //}
        //else {
            //var view = vertices.subarray (0, currentBatchSize * 4 * numItemsPerPack);
            //GL.bufferSubData(GL.ARRAY_BUFFER, 0, view);
        //}
        
        var batchSize = 0;
        var start = 0;
        
        currentTexture.bind();
        GL.drawElements(GL.TRIANGLES, size * numItemsPerPack, GL.UNSIGNED_SHORT, 0);
        
        currentBatchSize = 0;
        idx = 0;
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
            colorAttribute = s.getAttribLocation ("aColor");
            projectionMatrixUniform = s.getUniformLocation ("uProjectionMatrix");
            modelViewMatrixUniform = s.getUniformLocation ("uModelViewMatrix");
            imageUniform = s.getUniformLocation ("uImage0");
        }
        return s;
    }
    
    function switchTexture(texture : Texture2D) : Void
    {
        flush();
        currentTexture = texture;
    }
}