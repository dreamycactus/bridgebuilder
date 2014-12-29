package com.org.bbb;
import nape.geom.Vec2;
import openfl.display.Sprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;
import spritesheet.AnimatedSprite;

/**
 * ...
 * @author ...
 */
using com.org.bbb.Util;
class CmpRenderTruckRigid extends CmpRender
{
    var cmpcar : CmpMoverTruckRigid;
    var fw : Sprite;
    var bw : Sprite;
    var rotDelta : Float = 0;
    var spritesheet : Spritesheet;
    var chassis : AnimatedSprite;
    
    public function new(cmpcar : CmpMoverTruckRigid, bitmapData) 
    {
        super(true);
        this.cmpcar = cmpcar;
        displayLayer = GameConfig.zCar;
        this.spritesheet = BitmapImporter.create(bitmapData, 5, 5, 128, 128);
        this.spritesheet.addBehavior(new BehaviorData("running",[0,1,2,3], true, 2));

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

        chassis = new AnimatedSprite(this.spritesheet, true);
        chassis.showBehavior("running");

        sprite.addChild(chassis);
        sprite.addChild(fw);
        sprite.addChild(bw);
    }
    
    override public function render(dt : Float) : Void
    {
        var chassispos = cmpcar.compound.bodies.at(2).position;
        var fwpos = cmpcar.compound.bodies.at(1).position;
        var bwpos = cmpcar.compound.bodies.at(0).position;
        
        var rot = cmpcar.compound.bodies.at(2).rotation;
        this.chassis.rotateSprite(Vec2.get(chassis.x, chassis.y), rot);

        var offs = Vec2.weak(-40, -90);
        this.chassis.x = chassispos.x + Math.cos(rot) * offs.x - Math.sin(rot) * offs.y; // FIXME make me standard and automatic, or specify-able by artist
        this.chassis.y = chassispos.y + Math.sin(rot) * offs.x + Math.cos(rot) * offs.y; // FIXME ibid
        
        fw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        fw.x = fwpos.x;
        fw.y = fwpos.y;
        bw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        bw.x = bwpos.x;
        bw.y = bwpos.y;

        this.chassis.update(Math.round(dt));
    }
    
}
