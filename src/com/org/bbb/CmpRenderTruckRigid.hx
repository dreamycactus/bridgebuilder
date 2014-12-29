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
    var rotDelta : Float = 0;
    var chassisSpritesheet : Spritesheet;
    var wheelSpritesheet : Spritesheet;
    var chassis : AnimatedSprite;
    var fw : AnimatedSprite;
    var bw : AnimatedSprite;
    
    public function new(cmpcar : CmpMoverTruckRigid, chassisBitmapData, wheelBitmapData)
    {
        super(true);
        this.cmpcar = cmpcar;
        displayLayer = GameConfig.zCar;
        this.chassisSpritesheet = BitmapImporter.create(chassisBitmapData, 5, 5, 128, 128);
        this.chassisSpritesheet.addBehavior(new BehaviorData("running",[0,1,2,3], true, 2, 64, 64));

        this.wheelSpritesheet = BitmapImporter.create(wheelBitmapData, 4, 4, 32, 32);
        this.wheelSpritesheet.addBehavior(new BehaviorData("running",[0], false, 1, 16, 16));

        chassis = new AnimatedSprite(this.chassisSpritesheet, true);
        chassis.showBehavior("running");

        fw = new AnimatedSprite(this.wheelSpritesheet, true);
        fw.showBehavior("running");

        bw = new AnimatedSprite(this.wheelSpritesheet, true);
        bw.showBehavior("running");

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

        var offs = Vec2.weak(20, -20);
        this.chassis.x = chassispos.x + Math.cos(rot) * offs.x - Math.sin(rot) * offs.y; // FIXME make me standard and automatic, or specify-able by artist
        this.chassis.y = chassispos.y + Math.sin(rot) * offs.x + Math.cos(rot) * offs.y; // FIXME ibid
        
        fw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        fw.x = fwpos.x;
        fw.y = fwpos.y;
        bw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
        bw.x = bwpos.x;
        bw.y = bwpos.y;

        this.chassis.update(Math.round(dt));
        this.fw.update(Math.round(dt));
        this.bw.update(Math.round(dt));
    }
    
}
