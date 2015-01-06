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
    public var maxSize : Int = 100;

    public var isDrawing(default, null) : Bool = false;
    public var currentBatchSize(default, null) : Int = 0;
    public var currentTexture(default, null) : Texture2D = null;
    
    public var color : Int = 0xFFFFFF;
    public var shader(default, set) : GLSLProgram;
    
    public var blendingEnabled(default, set) : Bool = true;
    public var blendingSrcFunction = GL.SRC_ALPHA;
    public var blendingDstFunction = GL.ONE_MINUS_SRC_ALPHA;

    public var modelViewMatrix(default, set) : Matrix3D = new Matrix3D();
    public var projectionMatrix(default, set) : Matrix3D = new Matrix3D();
    
    var combinedMatrix : Matrix3D = new Matrix3D();
    var dirty : Bool = false;

    var idx : Int = 0;
    var numItemsPerPack = 5;
    var stride : Int;
    
    var indexBuffer : GLBuffer;
    var indices : Int16Array;

    var vertexBuffer : GLBuffer;
    var vertices : Float32Array;
    
    // Shader Uniforms
    var vertexAttribute : GLUniformLocation;
    var texCoordAttribute : GLUniformLocation;
    var colorAttribute : GLUniformLocation;
    var projectionTransformMatrixUniform : GLUniformLocation;
    var imageUniform : GLUniformLocation;
    
    public function new() 
    {
        //var stride = 
        var numVerts = maxSize * 4 * numItemsPerPack;
        var numIndicies = maxSize * numItemsPerPack;
        
        stride = numItemsPerPack * Float32Array.SBYTES_PER_ELEMENT;

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
    }
    
    public function begin() : Void
    {
        GL.depthMask(false);
        shader.begin();
        setupMatrices();
        
        isDrawing = true;
    }
    
    public function end() : Void
    {
        if (idx > 0) {
            flush();
        }
        if (blendingEnabled) { GL.disable(GL.BLEND); }
        
        shader.end();
        isDrawing = false;
    }
    
    public function draw(texture : Texture2D, x : Float, y : Float, w : Float, h : Float, options : Dynamic=null) : Void
    {
        if (!isDrawing) {
            throw "Sprite batch is not drawing";
        }
        if (texture != currentTexture) {
            switchTexture(texture);
        }
        
        var drawVertices = this.vertices;
        
        if (idx == vertices.length) {
            flush();
        }
        
        var u = 0.0;
        var v = 0.0;
        var u2 = 1.0;
        var v2 = 1.0;
        
        var p1x = texture.height;
        
        var x1 = x;
        var y1 = y;
        
        var x2 = x + w;
        var y2 = y + h;
        
        var color = 0xffffff;
        
        vertices[idx++] = x1;
        vertices[idx++] = y1;
        vertices[idx++] = u;
        vertices[idx++] = v;
        vertices[idx++] = color;
        
        vertices[idx++] = x1;
        vertices[idx++] = y2;
        vertices[idx++] = u;
        vertices[idx++] = v2;
        vertices[idx++] = color;

        vertices[idx++] = x2;
        vertices[idx++] = y2;
        vertices[idx++] = u2;
        vertices[idx++] = v2;
        vertices[idx++] = color;
        
        vertices[idx++] = x2;
        vertices[idx++] = y1;
        vertices[idx++] = u2;
        vertices[idx++] = v;
        vertices[idx++] = color;
        
        currentBatchSize++;
        
        dirty = true;

    }
    
    public function drawTextureRegion(textureRegion : TextureRegion, x : Float, y : Float, w : Float, h : Float, rotation : Float, options : Dynamic=null)
    {
        if (!isDrawing) {
            throw "Sprite batch is not drawing";
        }
        var texture : Texture2D = textureRegion.texture;
        if (texture != currentTexture) {
            switchTexture(texture);
        } else if (idx == vertices.length) {
            flush();
        }
        if (options == null) {
            options = {};
        }
        
        var originX = (options.originX == null) ? textureRegion.regionWidth * 0.5 :  options.originX;
        var originY = (options.originY == null) ? textureRegion.regionHeight * 0.5 :  options.originY;
        var worldOriginX  = x + originX;
        var worldOriginY  = y + originY;
        var fx = -originX;
        var fy = -originY;
        var fx2 = w - originX;
        var fy2 = h - originY;
        
        var scaleX = (options.originX == null) ? 1 :  options.scaleX;
        var scaleY = (options.originY == null) ? 1 :  options.scaleY;
        fx *= scaleX;
        fy *= scaleY;
        fx2 *= scaleX;
        fy2 *= scaleY;
        
        // ccw
        var p1x = fx;
        var p1y = fy;
        var p2x = fx;
        var p2y = fy2;
        var p3x = fx2;
        var p3y = fy2;
        var p4x = fx2;
        var p4y = fy;
        
        var x1 = p1x;
        var y1 = p1y;
        var x2 = p2x;
        var y2 = p2y;
        var x3 = p3x;
        var y3 = p3y;
        var x4 = p4x;
        var y4 = p4y;
        
        if (rotation != 0) {
            var cos = Math.cos(rotation);
            var sin = Math.sin(rotation);
            
            x1 = cos * p1x - sin * p1y;
            y1 = sin * p1x + cos * p1y;

            x2 = cos * p2x - sin * p2y;
            y2 = sin * p2x + cos * p2y;

            x3 = cos * p3x - sin * p3y;
            y3 = sin * p3x + cos * p3y;

            x4 = x1 + (x3 - x2);
            y4 = y3 - (y2 - y1);
        }
        
        x1 += worldOriginX;
        y1 += worldOriginY;
        x2 += worldOriginX;
        y2 += worldOriginY;
        x3 += worldOriginX;
        y3 += worldOriginY;
        x4 += worldOriginX;
        y4 += worldOriginY;
        
        var u = textureRegion.u;
        var v = textureRegion.v;
        var u2 = textureRegion.u2;
        var v2 = textureRegion.v2;
        
        var color = options.color == null ? this.color : options.color;
        var idx = this.idx;
        vertices[idx++] = x1;
        vertices[idx++] = y1;
        vertices[idx++] = u;
        vertices[idx++] = v;
        vertices[idx++] = color;
        
        vertices[idx++] = x2;
        vertices[idx++] = y2;
        vertices[idx++] = u;
        vertices[idx++] = v2;
        vertices[idx++] = color;
        
        vertices[idx++] = x3;
        vertices[idx++] = y3;
        vertices[idx++] = u2;
        vertices[idx++] = v2;
        vertices[idx++] = color;
        
        vertices[idx++] = x4;
        vertices[idx++] = y4;
        vertices[idx++] = u2;
        vertices[idx++] = v;
        vertices[idx++] = color;
        
        this.idx = idx;
        currentBatchSize++;
        
        dirty = true;

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
        
        if (dirty) {
            dirty = false;
            if (blendingEnabled) {
                GL.enable(GL.BLEND);
                //GL.blendFuncSeparate(blendingSrcFunction, blendingDstFunction, GL.ONE, GL.ZERO);
                GL.blendFunc(blendingSrcFunction, blendingDstFunction);
            } else {
                GL.disable(GL.BLEND);
            }
            
            shader.begin();

            GL.enableVertexAttribArray(vertexAttribute);
            GL.enableVertexAttribArray(texCoordAttribute);
            GL.enableVertexAttribArray(colorAttribute);
            
            GL.activeTexture(GL.TEXTURE0);
            currentTexture.bind();
            GL.uniform1i (imageUniform, 0);

            GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
            // Upload Data.. creating new buffer if the current buffer exceeds a size
            GL.bufferSubData(GL.ARRAY_BUFFER, 0, vertices);
            //else {
                //var view = vertices.subarray(0, currentBatchSize * 4 * numItemsPerPack);
                //GL.bufferSubData(GL.ARRAY_BUFFER, 0, view);
            //}
            
            GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, stride, 0);
            GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, stride, 2 * Float32Array.SBYTES_PER_ELEMENT);
            GL.vertexAttribPointer (colorAttribute, 1, GL.FLOAT, false, stride, 4 * Float32Array.SBYTES_PER_ELEMENT);
            
            GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
            GL.drawElements(GL.TRIANGLES, 6*currentBatchSize, GL.UNSIGNED_SHORT, 0);

            GL.bindBuffer(GL.ARRAY_BUFFER, null);
            GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
            
            GL.disableVertexAttribArray(vertexAttribute);
            GL.disableVertexAttribArray(texCoordAttribute);
            GL.disableVertexAttribArray(colorAttribute);
            
            GL.useProgram(null);
            
        }
        
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
    
    function setupMatrices() : Void
    {
        combinedMatrix.copyFrom(projectionMatrix);
        combinedMatrix.append(modelViewMatrix);
        shader.setUniformMatrix(projectionTransformMatrixUniform, combinedMatrix);
        
    }
    
    function set_shader(s : GLSLProgram) : GLSLProgram
    {
        if (isDrawing) {
            flush();
            GL.useProgram(null);
        }
        shader = s;
        if (s != null) {
            vertexAttribute = s.getAttribLocation("aVertexPosition");
            texCoordAttribute = s.getAttribLocation ("aTexCoord");
            colorAttribute = s.getAttribLocation ("aColor");
            projectionTransformMatrixUniform = s.getUniformLocation ("u_projTrans");
            imageUniform = s.getUniformLocation ("uImage0");
        }
        setupMatrices();
        return s;
    }
    
    function switchTexture(texture : Texture2D) : Void
    {
        flush();
        currentTexture = texture;
    }
    
    function set_blendingEnabled(b : Bool) : Bool
    {
        if (blendingEnabled == b) { return b; }
        
        blendingEnabled = b;
        flush();
        return b;
    }
    
    function set_projectionMatrix(m : Matrix3D) : Matrix3D
    {
        if (isDrawing) { flush(); }
        projectionMatrix = m;
        if (isDrawing) { setupMatrices(); }

        return m;
    }    
    
    function set_modelViewMatrix(m : Matrix3D) : Matrix3D
    {
        if (isDrawing) { flush(); }
        modelViewMatrix = m;
        if (isDrawing) { setupMatrices(); }

        return m;
    }
    
    //var vert = [
        //"attribute vec2 aVertexPosition;",
        //"attribute vec2 aTexCoord;",
        //"attribute vec4 aColor;"
//
        //"varying vec2 vTexCoord;"
        //"varying vec4 vColor;"
//
        //uniform mat4 u_projTrans;
//
        //void main(void) 
        //{
            //vTexCoord = aTexCoord;
            //vColor = aColor;
            //gl_Position = u_projTrans * vec4 (aVertexPosition, 0.0, 1.0);
        //}
    //]
}