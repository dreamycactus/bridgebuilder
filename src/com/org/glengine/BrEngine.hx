package com.org.glengine;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.OpenGLView;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.Lib;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;
import openfl.utils.Int32Array;
import openfl.utils.UInt8Array;

using com.org.glengine.GLUtils;
/**
 * ...
 * @author ...
 */
class BrEngine
{
    private var bitmapData:BitmapData;
    private var imageUniform:GLUniformLocation;
    private var MVPUniform:GLUniformLocation;
    private var projectionMatrixUniform:GLUniformLocation;
    private var modelViewMatrixUniform:GLUniformLocation;
    private var shaderProgram:GLProgram;
    private var texCoordAttribute:Int;
    private var colorAttribute:Int;
    private var texCoordBuffer:GLBuffer;
    private var texture:Texture2D;
    public var view:OpenGLView;
    private var vertexAttribute:Int;
    private var vertexBuffer:GLBuffer;
    
    var p : GLSLProgram;
    var fb : BrScene;
    
    var Vertices = [
       0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  ,
	// Top
	  -0.2, 0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  ,
	  0.2, 0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  ,
	  0.0, 0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  ,
	  0.0, 1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,
	// Bottom
	  -0.2, -0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  ,
	  0.2, -0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  ,
	  0.0, -0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  ,
	  0.0, -1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,
	// Left
	  -0.8, -0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  ,
	  -0.8, 0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  ,
	  -0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  ,
	  -1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,
	// Right
	  0.8, -0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  ,
	  0.8, 0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  ,
	  0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  ,
	  1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  
    ];
    
    var Indices = [
    0, 1, 3,
    0, 3, 2,
    3, 1, 4,
    3, 4, 2,

    // Bottom
    0, 5, 7,
    0, 7, 6,
    7, 5, 8,
    7, 8, 6,

    // Left
    0, 9, 11,
    0, 11, 10,
    11, 9, 12,
    11, 12, 10,

    // Right
    0, 13, 15,
    0, 15, 14,
    15, 13, 16,
    15, 16, 14
    ];
    var IndexBufferId : GLBuffer;
    var BufferId : GLBuffer;
    var BufferSize : Int;

    public function new() 
    {
        bitmapData = Assets.getBitmapData("img/openfl.png");
        if (OpenGLView.isSupported) {
            view = new OpenGLView();

            // Init shaders
            p = new GLSLProgram();
            p.compileShaderFromFile("shaders/TVert.vert");
            p.compileShaderFromFile("shaders/TFrag.frag");
            p.validate();
            p.link();
            
            p.use();
            
            vertexAttribute = p.getAttribLocation("aVertexPosition");
            //texCoordAttribute = p.getAttribLocation ("aTexCoord");
            projectionMatrixUniform = p.getUniformLocation("uProjectionMatrix");
            modelViewMatrixUniform = p.getUniformLocation("uModelViewMatrix");
            //colorAttribute = p.getAttribLocation ("aColor");
            //MVPUniform = p.getUniformLocation ("uMVP");
            imageUniform = p.getUniformLocation ("uImage0");
            
            // Init buffers
            var vertices = [
                bitmapData.width, bitmapData.height,
                0, bitmapData.height,
                bitmapData.width, 0,
                0, 0
            ];
            
            vertexBuffer = GL.createBuffer ();
            GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
            GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STATIC_DRAW);
            GL.bindBuffer (GL.ARRAY_BUFFER, null);
            
            var texCoords = [
                1, 1, 
                0, 1, 
                1, 0, 
                0, 0, 
            ];
            
            texCoordBuffer = GL.createBuffer ();
            GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
            GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast texCoords), GL.STATIC_DRAW);
            GL.bindBuffer (GL.ARRAY_BUFFER, null);
            
            
            // Create texture
            texture = new Texture2D();
            texture.upload(0, 0, bitmapData.width, bitmapData.height, GL.UNSIGNED_BYTE, new Int32Array(cast GLUtils.getImgABGR(bitmapData)));
            texture.setFilter(GL.LINEAR, GL.LINEAR);
            texture.setWrap(GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE);

            GL.bindTexture (GL.TEXTURE_2D, null);
            
        } else {
            trace("GL not supported");
        }
        
        view.render = renderView;
        
        BufferId = GL.createBuffer();
        GL.bindBuffer(GL.ARRAY_BUFFER, BufferId);
        GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(Vertices), GL.STATIC_DRAW);
       
        var indd = new Int16Array(Indices);
        IndexBufferId = GL.createBuffer();
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, IndexBufferId);
        GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indd, GL.STATIC_DRAW);

        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
        GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
    
    function renderView(rect:Rectangle):Void {
        
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 0.5, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        
        var positionX = (1024 - bitmapData.width) / 2;
        var positionY = (576 - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 10000, -10000);
        var modelViewMatrix = Matrix3D.create2D (0, 0, 1, 0);
        
        projectionMatrix.identity();
        modelViewMatrix.identity();
        
        p.use();

        GL.enableVertexAttribArray(vertexAttribute);
        GL.enableVertexAttribArray(colorAttribute);

        var g = new Float32Array([]);
        GL.bindBuffer(GL.ARRAY_BUFFER, BufferId);
        GL.vertexAttribPointer (vertexAttribute, 4, GL.FLOAT, false, 8 * 4, 0);
        GL.vertexAttribPointer (colorAttribute, 4, GL.FLOAT, false, 8 * 4, 4 * g.BYTES_PER_ELEMENT);
        
        GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, IndexBufferId);
        
        GL.drawElements(GL.TRIANGLES, 48, GL.UNSIGNED_SHORT, 0);

        GL.bindBuffer(GL.ARRAY_BUFFER, null);
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
        
        GL.disableVertexAttribArray(vertexAttribute);
        GL.disableVertexAttribArray(colorAttribute);
        
        GL.useProgram(null);
        
        return;
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 1.0, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        
        var stage = Lib.current.stage;
        var positionX = (stage.stageWidth - bitmapData.width) / 2;
        var positionY = (stage.stageHeight - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 10000, -10000);
        var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
        
        p.use();
        
        GL.enableVertexAttribArray (vertexAttribute);
        GL.enableVertexAttribArray (texCoordAttribute);
        
        GL.activeTexture (GL.TEXTURE0);
        texture.bind();
        
        GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
        GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 0, 0);
        GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
        GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
        
        //modelViewMatrix.identity();
        GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        GL.uniform1i (imageUniform, 0);
        
        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        
        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture (GL.TEXTURE_2D, null);
        
        GL.disableVertexAttribArray (vertexAttribute);
        GL.disableVertexAttribArray (texCoordAttribute);
        
        GL.useProgram (null);
    }
    
}