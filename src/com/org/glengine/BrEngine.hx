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
    var pp : GLSLProgram;
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
            
            //pp = new GLSLProgram();
            //pp.compileShaderFromFile("shaders/hxp/defaultVert.vert");
            //pp.compileShaderFromFile("shaders/hxp/grain.frag");
            //pp.validate();
            //pp.link();
            
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
        //fb = new BrScene(1024, 576);
        //fb.shader = pp;
        //fb.init();
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
        var modelViewMatrix = Matrix3D.create2D (0, 0, 1.0 / 1024, 0);
        projectionMatrix.identity();
        modelViewMatrix.identity();
        batch.projectionMatrix = projectionMatrix;
        batch.modelViewMatrix = modelViewMatrix;
        
        //fb.capture();
        batch.begin();
            batch.draw(texture, 0, 0, 100, 100);
            batch.draw(texture, 320 ,0, 100, 100);
            batch.draw(texture, 924, 500, 100, 100);
            batch.draw(texture, 2, 300, 100, 100);
            batch.drawTextureRegion(tr, 100, 300, 200, 200, Math.PI * 0.5);
        batch.end();
        
        //fb.render();
        
    }
    
}