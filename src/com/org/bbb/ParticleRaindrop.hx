package com.org.bbb;
import openfl.display.Sprite;
import openfl.geom.Point;

/*

Altered version to be used for Dripping example.


Flash CS4 ActionScript 3 Tutorial by Dan Gries.

www.flashandmath.com.

Last modified August 22, 2009.
Ported to Haxe
*/
class ParticleRaindrop extends Sprite
{
    public var lifespan:Int;
    public var breakawayTime:Float;
            
    public var thickness:Float;
    
    public var pos:Point;
    public var vel:Point;
    public var accel:Point;
    
    public var color:Int;
    
    //drawing points
    public var p0:Point;
    public var p1:Point;
    
    public var lastPos:Point;
    public var lastLastPos:Point;
    
    public var radiusWhenStill:Float;
    
    //The following attributes are for the purposes of creating a
    //linked list of LineRaindrop instances.
    public var next:ParticleRaindrop;
    public var prev:ParticleRaindrop;
    
    public var splashing:Bool;
    public var atTerminalVelocity:Bool;
    
    public function new(x0 : Float, y0 : Float) 
    {
        super();
        lastPos = new Point(x0,y0);
        lastLastPos = new Point(x0,y0);
        pos = new Point(x0,y0);
        p0 = new Point(x0,y0);
        p1 = new Point(x0,y0);
        accel = new Point();
        vel = new Point();
        thickness = 1;
        color = 0xDDDDDD;
        splashing = true;
        atTerminalVelocity = false;
        radiusWhenStill = 1.5;
    }
    
    public function resetPosition(x0 : Float= 0, y0 : Float = 0) 
    {
        lastPos = new Point(x0,y0);
        lastLastPos = new Point(x0,y0);
        pos = new Point(x0,y0);
        p0 = new Point(x0,y0);
        p1 = new Point(x0,y0);
    }
    
    public function redraw():Void {
        this.graphics.clear();
        if (lifespan < breakawayTime) {
            this.graphics.beginFill(color);
            this.graphics.drawEllipse(p1.x - radiusWhenStill, p1.y - radiusWhenStill, 2 * radiusWhenStill, 2 * radiusWhenStill);
            this.graphics.endFill();
        }
        else {
            this.graphics.lineStyle(thickness,color,1,false, openfl.display.LineScaleMode.NORMAL, openfl.display.CapsStyle.NONE);
            this.graphics.moveTo(p0.x,p0.y);
            this.graphics.lineTo(p1.x,p1.y);
        }
    }
    
}