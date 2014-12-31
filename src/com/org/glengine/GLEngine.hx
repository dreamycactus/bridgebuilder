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
import openfl.utils.Int32Array;
import openfl.utils.UInt8Array;

using com.org.glengine.GLUtils;
/**
 * ...
 * @author ...
 */
class GLEngine
{
    private var bitmapData:BitmapData;
    private var imageUniform:GLUniformLocation;
    private var modelViewMatrixUniform:GLUniformLocation;
    private var projectionMatrixUniform:GLUniformLocation;
    private var shaderProgram:GLProgram;
    private var texCoordAttribute:Int;
    private var texCoordBuffer:GLBuffer;
    private var texture:Texture2D;
    public var view:OpenGLView;
    private var vertexAttribute:Int;
    private var vertexBuffer:GLBuffer;
    private var vertexBuffer2:GLBuffer;
    var p : GLSLProgram;
    public function new() 
    {
        bitmapData = Assets.getBitmapData("img/openfl.png");
        if (OpenGLView.isSupported) {
            view = new OpenGLView();

            // Init shaders
            p = new GLSLProgram();
            p.compileShaderFromFile("shaders/vert.vert");
            p.compileShaderFromFile("shaders/brga.frag");
            p.validate();
            p.link();
            
            vertexAttribute = p.getAttribLocation("aVertexPosition");
            texCoordAttribute = p.getAttribLocation ("aTexCoord");
            projectionMatrixUniform = p.getUniformLocation ("uProjectionMatrix");
            modelViewMatrixUniform = p.getUniformLocation ("uModelViewMatrix");
            imageUniform = p.getUniformLocation ("uImage0");
            
            // Init buffers
            var vertices = [
                bitmapData.width, bitmapData.height, 0,
                0, bitmapData.height, 0,
                bitmapData.width, 0, 0,
                0, 0, 0
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
            
            vertexBuffer2 = GL.createBuffer ();
            GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer2);
            GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STATIC_DRAW);
            GL.bindBuffer (GL.ARRAY_BUFFER, null);
            
            // Create texture
            var pixelData = new UInt8Array (bitmapData.getPixels (bitmapData.rect));
            //var pixelData = new Array<Int>();
            //for (j in 0...bitmapData.height)
            //for (i in 0...bitmapData.width)
            //{
                //var argb = bitmapData.getPixel32 (i, j);
                //var abgr = (argb & 0xFF00FF00) | ((argb >> 16) & 0xFF) | ((argb & 0xFF) << 16);
                //pixelData.push (abgr);
            //}
            
            texture = new Texture2D();
            texture.setWrap(GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE);
            texture.upload(0, 0, bitmapData.width, bitmapData.height, GL.UNSIGNED_BYTE, pixelData);
            texture.setFilter(GL.LINEAR, GL.LINEAR);
            GL.bindTexture (GL.TEXTURE_2D, null);
            
        } else {
            trace("GL not supported");
        }
        
        fb.init();
        view.render = renderView;
    }
    var fb = new Scene(300, 300);
    function renderView(rect:Rectangle):Void {
        GL.bindFramebuffer(GL.FRAMEBUFFER, fb.handle);
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 1.0, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        GL.enable(GL.TEXTURE_2D);
        
        var stage = Lib.current.stage;
        var positionX = (stage.stageWidth - bitmapData.width) / 2;
        var positionY = (stage.stageHeight - bitmapData.height) / 2;
        var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
        var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
        
        p.use();
        GL.enableVertexAttribArray (vertexAttribute);
        GL.enableVertexAttribArray (texCoordAttribute);
        
        GL.activeTexture (GL.TEXTURE0);
        texture.bind();
        
        GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 0, 0);
        GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
        GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
        
        GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        GL.uniform1i (imageUniform, 0);
        
        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        modelViewMatrix.appendTranslation(200, 0, 0);
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        
        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture (GL.TEXTURE_2D, null);
        
        GL.disableVertexAttribArray (vertexAttribute);
        GL.disableVertexAttribArray (texCoordAttribute);
        
        // Draw fb to screen
        GL.useProgram (null);
        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
        
        

        // Begin rendering fb
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        p.use();
        
        GL.activeTexture (GL.TEXTURE0);
        fb.texture.bind();
        GL.uniform1i (imageUniform, 0);
        
        GL.enableVertexAttribArray (vertexAttribute);
        GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer2);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 0, 0);
        
        GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.rawData));
        GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.rawData));
        //GL.uniform1i (imageUniform, 0);
        
        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
    }
    
}