package com.org.glengine;
import lime.utils.UInt16Array;
//import openfl.Assets;
//import openfl.display.BitmapData;
import lime.math.Rectangle;
//import openfl.geom.Matrix3D;
import lime.graphics.opengl.GL;

//import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.utils.Int32Array;
import lime.utils.UInt8Array;

using com.org.glengine.GLUtils;
/**
 * ...
 * @author ...
 */
class BrEngine
{
    private var bitmapData:BitmapData;
    private var imageUniform:GLUniformLocation;
    private var modelViewMatrixUniform:GLUniformLocation;
    private var projectionMatrixUniform:GLUniformLocation;
    private var shaderProgram:GLProgram;
    private var texCoordAttribute:Int;
    private var texCoordBuffer:GLBuffer;
    private var texture:Texture2D;
    private var vertexAttribute:Int;
    private var colorAttribute:Int;
    private var vertexBuffer:GLBuffer;
    
    
    var p : GLSLProgram;
    //var fb : BrScene;
    //var sb : BrSpriteBatch = new BrSpriteBatch();
    
    var Vertices = [
      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      -0.2, 0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 1
      0.0, 0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //3

      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      0.0, 0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //3
      0.2, 0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 2
    
      0.0, 0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //3
      -0.2, 0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 1
      0.0, 1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,  // 4

      0.0, 0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //3
      0.0, 1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,  // 4
      0.2, 0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 2

    // Bottom
      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      0.0, -0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //7
      -0.2, -0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 5

      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      0.0, -0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //7
      0.2, -0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 6

      0.0, -0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //7
      -0.2, -0.8, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 5
      0.0, -1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  , // 8

      0.0, -0.8, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //7
      0.2, -0.8, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 6
      0.0, -1.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  , // 8

    // Let
      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      -0.8, -0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 9
      -0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //11

      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      -0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //11
      -0.8, 0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 10
    
      -0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //11
      -0.8, 0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 10
      -1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  , // 12

      -0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //11
      -1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  , // 12
      -0.8, -0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 9

    // Right
      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      0.8, 0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 14
      0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //15

      0.0, 0.0, 0.0, 1.0 ,  1.0, 1.0, 1.0, 1.0  , // 0
      0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //15
      0.8, -0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 13

      0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //15
      0.8, -0.2, 0.0, 1.0 ,  0.0, 1.0, 0.0, 1.0  , // 13
      1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0  ,  // 16
    
      0.8, 0.2, 0.0, 1.0 ,  0.0, 0.0, 1.0, 1.0  , // 14
      0.8, 0.0, 0.0, 1.0 ,  0.0, 1.0, 1.0, 1.0  , //15
      1.0, 0.0, 0.0, 1.0 ,  1.0, 0.0, 0.0, 1.0    // 16
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
        if (true) {

            // Init shaders
            p = new GLSLProgram();
            p.compileShaderFromFile("shaders/TVert.vert");
            p.compileShaderFromFile("shaders/TFrag.frag");
            p.validate();
            p.link();
            
            vertexAttribute = p.getAttribLocation("aVertexPosition");
            colorAttribute = p.getAttribLocation("aColor");
            //texCoordAttribute = p.getAttribLocation ("aTexCoord");
            projectionMatrixUniform = p.getUniformLocation ("uProjectionMatrix");
            modelViewMatrixUniform = p.getUniformLocation ("uModelViewMatrix");
            //imageUniform = p.getUniformLocation ("uImage0");
            
            // Init buffers
            //var vertices : Array<Float> = [
                //bitmapData.width, bitmapData.height, 0,
                //0, bitmapData.height,0,
                //bitmapData.width, 0,0,
                //0, 0,0
            //];
            //
            //vertexBuffer = GL.createBuffer ();
            //GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
            //GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (vertices), GL.STATIC_DRAW);
            //GL.bindBuffer (GL.ARRAY_BUFFER, null);
            //
            //var texCoords = [
                //1, 1, 
                //0, 1, 
                //1, 0, 
                //0, 0, 
            //];
            //
            //texCoordBuffer = GL.createBuffer ();
            //GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
            //GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (texCoords), GL.STATIC_DRAW);
            //GL.bindBuffer (GL.ARRAY_BUFFER, null);
            //
            //// Create texture
            //var pixelData = new UInt8Array (bitmapData.getPixels (bitmapData.rect));
            //
            //texture = new Texture2D();
            //texture.upload(0, 0, bitmapData.width, bitmapData.height, GL.UNSIGNED_BYTE, new Int32Array(GLUtils.getImgABGR(bitmapData)));
            //texture.setFilter(GL.LINEAR, GL.LINEAR);
            //texture.setWrap(GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE);
//
            //GL.bindTexture (GL.TEXTURE_2D, null);
            
        } else {
            trace("GL not supported");
        }
        
        BufferSize = Vertices.length;
        
        BufferId = GL.createBuffer();
        GL.bindBuffer(GL.ARRAY_BUFFER, BufferId);
        GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(Vertices), GL.STATIC_DRAW);
       
        GL.enableVertexAttribArray(vertexAttribute);
        GL.enableVertexAttribArray(colorAttribute);

        GL.vertexAttribPointer (vertexAttribute, 4, GL.FLOAT, false, 8, 0);
        GL.vertexAttribPointer (colorAttribute, 4, GL.FLOAT, false, 8, 4);
        IndexBufferId = GL.createBuffer();
        
        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, IndexBufferId);
        GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, new UInt16Array(Indices), GL.STATIC_DRAW);

        GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, IndexBufferId);
        
        //fb = new BrScene(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
        //fb.init();
        
        //sb.shader = p;
        //view.render = renderView;
    }
    public function renderView(rect:Rectangle):Void {
        //GL.bindFramebuffer(GL.FRAMEBUFFER, fb.handle);
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 1.0, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        p.use();
        
        var positionX = (1024 - bitmapData.width) / 2;
        var positionY = (576 - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
        var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
        //
        GL.drawElements(GL.TRIANGLES, 48, GL.UNSIGNED_SHORT, 0);
        //sb.projectionMatrix = projectionMatrix;
        //sb.transformMatrix = modelViewMatrix;
        //
        //sb.begin();
            //sb.draw(texture, 200, 0);
        //sb.end();
        
        //p.use();
        //GL.enableVertexAttribArray (vertexAttribute);
        //GL.enableVertexAttribArray (texCoordAttribute);
        //
        //GL.activeTexture (GL.TEXTURE0);
        //texture.bind();
        //GL.enable(GL.TEXTURE_2D);
        //
        //GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
        //GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 0, 0);
        //GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
        //GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
        //
        GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        //GL.uniform1i (imageUniform, 0);
        //
        //GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        //modelViewMatrix.appendTranslation(200, 0, 0);
        //GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        //GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        //
        //GL.bindBuffer (GL.ARRAY_BUFFER, null);
        //GL.bindTexture (GL.TEXTURE_2D, null);
        //
        //GL.disableVertexAttribArray (vertexAttribute);
        //GL.disableVertexAttribArray (texCoordAttribute);
        //GL.useProgram (null);

        // Draw fb to screen
        //GL.bindFramebuffer(GL.FRAMEBUFFER, null);
        //GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
        //
        //GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        //
        //p.use();
        //
        //GL.activeTexture (GL.TEXTURE0);
        //fb.texture.bind();
        //GL.uniform1i (imageUniform, 0);
        //
        //GL.enableVertexAttribArray (vertexAttribute);
        //GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer2);
        //GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 0, 0);
        //
        //GL.enableVertexAttribArray (texCoordAttribute);
        //GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
        //GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
        //
        //GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        //GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        //
        //GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        //
        //GL.bindBuffer(GL.ARRAY_BUFFER, null);
        //
        //GL.useProgram(null);
        //GL.disableVertexAttribArray (vertexAttribute);
        //GL.disableVertexAttribArray (texCoordAttribute);
        
        //if (GL.getError() == GL.INVALID_FRAMEBUFFER_OPERATION)
		//{
			//trace("INVALID_FRAMEBUFFER_OPERATION!!");
		//}
    }
    
}