package com.org.bbb;
import nape.geom.Vec2;
import openfl.display.Sprite;

/**
 * ...
 * @author ...
 */
using com.org.bbb.Util;
class CmpRenderCar extends CmpRender
{
    var cmpcar : CmpMoverCar;
    var fw : Sprite;
    var bw : Sprite;
    var chassis : Sprite;
    var rotDelta : Float = 0;
    
    public function new(cmpcar : CmpMoverCar) 
    {
        super(true);
        this.cmpcar = cmpcar;
        displayLayer = GameConfig.zCar;
        
        chassis = new Sprite();
        chassis.graphics.beginFill(0xba74d4 );
        var chassispos = cmpcar.compound.bodies.at(0).position;
        chassis.graphics.drawRect(-20, -10, 40, 20);
        chassis.graphics.endFill();
        
        fw = new Sprite();
        fw.graphics.beginFill(0xbf9dcc);
        var fwpos = cmpcar.compound.bodies.at(1).position;
        fw.graphics.drawCircle(0, 0, GameConfig.carWheelRadius);
        fw.graphics.endFill();
        fw.graphics.beginFill(0xba74d4);
        fw.graphics.drawCircle(GameConfig.carWheelRadius*0.5, 0, 2);
        fw.graphics.endFill();
        
        bw = new Sprite();
        bw.graphics.beginFill(0xbf9dcc);
        var bwpos = cmpcar.compound.bodies.at(2).position;
        bw.graphics.drawCircle(0, 0, GameConfig.carWheelRadius);
        bw.graphics.endFill();
        bw.graphics.beginFill(0xba74d4);
        bw.graphics.drawCircle(GameConfig.carWheelRadius*0.5, 0, 2);
        bw.graphics.endFill();
        
        sprite.addChild(chassis);
        sprite.addChild(fw);
        sprite.addChild(bw);
    }
    
    override public function render(dt : Float) : Void
    {
        var chassispos = cmpcar.compound.bodies.at(2).position;
        var fwpos = cmpcar.compound.bodies.at(1).position;
        var bwpos = cmpcar.compound.bodies.at(0).position;
        
        //rotDelta -= cmpcar.compound.bodies.at(2).rotation;
        chassis.rotateSprite(Vec2.get(chassis.x, chassis.y), cmpcar.compound.bodies.at(2).rotation);
        chassis.x = chassispos.x;
        chassis.y = chassispos.y;
        
        fw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        fw.x = fwpos.x;
        fw.y = fwpos.y;
        bw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        bw.x = bwpos.x;
        bw.y = bwpos.y;
    }
    
}