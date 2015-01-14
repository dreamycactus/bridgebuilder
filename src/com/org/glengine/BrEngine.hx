package com.org.glengine;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.OpenGLView;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.Lib;
import openfl.ui.Keyboard;
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
    public var view:OpenGLView;
    public var framebuffer : BrPostProcess;
    var p : GLSLProgram;
    var fb : BrPostProcess;
    var fragStrings = ["scanline.frag", "hq2x.frag", "grain.frag", "blur.frag", "color/deuteranopia.frag", "color/grayscale.frag",
                 "color/protanopia.frag", "color/tritanopia.frag", "basic.frag"];
    var fragPrograms : Array<GLSLProgram> = new Array();
    var fragIndex = 0;
    
    public function new() 
    {
        if (OpenGLView.isSupported) {
            view = new OpenGLView();

            // Init shaders
            p = new GLSLProgram();
            p.compileShaderFromFile("shaders/vert.vert");
            p.compileShaderFromFile("shaders/basic.frag");
            p.link();
            p.validate();
            
            var projectionMatrix = Matrix3D.createOrtho (0, 1024, 576, 0, 1000, -1000);
            var modelViewMatrix = Matrix3D.create2D (0, 0, 1.0, 0);
            
        } else {
            trace("GL not supported");
        }
        
        view.render = renderView;
        Lib.current.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        
    }
    
    function renderView(rect:Rectangle):Void {
        GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
        
        GL.clearColor (1.0, 1.0, 0.5, 1.0);
        GL.clear (GL.COLOR_BUFFER_BIT);
        
    }
    
    public function keyDown(ev:KeyboardEvent)
    {
        if (ev.keyCode == Keyboard.SPACE) {
            if (++fragIndex == fragPrograms.length) {
                fragIndex = 0;
            }
            fb.shader = fragPrograms[fragIndex];
        }
    }
}