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
    var tr : TextureRegion;
    var batch : BrSpriteBatch;

    public function new() 
    {
        bitmapData = Assets.getBitmapData("img/smurf.png");
        if (OpenGLView.isSupported) {
            view = new OpenGLView();

            // Init shaders
            p = new GLSLProgram();
            p.compileShaderFromFile("shaders/vert.vert");
            p.compileShaderFromFile("shaders/basic.frag");
            p.validate();
            p.link();
            
            p.begin();
            
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

        tr = new TextureRegion();
        tr.initUV(texture, 0, 0, 0.25, 0.25);
        batch = new BrSpriteBatch();
        batch.shader = p;
    }
    var boo = true;
    function renderView(rect:Rectangle):Void {
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 0.5, 1.0);
        
        GL.clear (GL.COLOR_BUFFER_BIT);
        
        var projectionMatrix = Matrix3D.createOrtho (0, 1.78, 1, 0, 1000, -1000);
        var modelViewMatrix = Matrix3D.create2D (0, 0, 1/1024, 0);
        batch.projectionMatrix = projectionMatrix;
        batch.modelViewMatrix = modelViewMatrix;
        
        batch.begin();
            batch.draw(texture, 0, 0, 100, 100);
            batch.draw(texture, 320 ,0, 100, 100);
            batch.draw(texture, 924, 500, 100, 100);
            batch.draw(texture, 2, 300, 100, 100);
            batch.drawTextureRegion(tr, 100, 300, 200, 200, Math.PI * 0.5);
        batch.end();
        
        return;
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 1.0, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        
        var stage = Lib.current.stage;
        var positionX = (stage.stageWidth - bitmapData.width) / 2;
        var positionY = (stage.stageHeight - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
        var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
        
        p.begin();
        
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