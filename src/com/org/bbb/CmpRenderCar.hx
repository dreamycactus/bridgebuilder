package com.org.bbb;
import com.org.bbb.AssetProcessor;
import haxe.ds.StringMap;
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
class CmpRenderCar extends CmpRender
{
    var cmpcar : CmpMoverCar;
    var fw : AnimatedSprite;
    var bw : AnimatedSprite;
    var chassis : AnimatedSprite;
    var rotDelta : Float = 0;
    static var sds : StringMap<SpriteData> = null;
    static var spriteSpecPath: String = "img/car.xml";

    public function new(cmpcar : CmpMoverCar) 
    {
        super(true);

        if ( sds == null ) {
            sds = AssetProcessor.processSpriteSpec(spriteSpecPath);
        }

        this.cmpcar = cmpcar;
        displayLayer = GameConfig.zCar;

        var specChassis = sds.get("chassis");
        var chassisSpritesheet = BitmapImporter.create(specChassis.bmpDat,
                                                        specChassis.slice.rows,
                                                        specChassis.slice.cols,
                                                        specChassis.slice.frameW,
                                                        specChassis.slice.frameH);

        for (anim in specChassis.anims) {
            chassisSpritesheet.addBehavior(new BehaviorData(anim.name, anim.frames, anim.loop, anim.fps, anim.centerX, anim.centerY));
        }

        chassis = new AnimatedSprite(chassisSpritesheet, true);
        chassis.showBehavior("idle");
        sprite.addChild(chassis);

        var specWheel = sds.get("wheel");
        if (specWheel != null) {
            var wheelSpritesheet = BitmapImporter.create(specWheel.bmpDat,
                                                         specWheel.slice.rows,
                                                         specWheel.slice.cols,
                                                         specWheel.slice.frameW,
                                                         specWheel.slice.frameH);
            for (anim in specWheel.anims) {
                wheelSpritesheet.addBehavior(new BehaviorData(anim.name, anim.frames, anim.loop, anim.fps, anim.centerX, anim.centerY));
            }

            fw = new AnimatedSprite(wheelSpritesheet, true);
            fw.showBehavior("idle");

            bw = new AnimatedSprite(wheelSpritesheet, true);
            bw.showBehavior("idle");

            sprite.addChild(fw);
            sprite.addChild(bw);
        }
    }

    override public function render(dt : Float) : Void
    {
        var chassispos = cmpcar.compound.bodies.at(2).position;

        var rot = cmpcar.compound.bodies.at(2).rotation;
        this.chassis.rotateSprite(Vec2.get(chassis.x, chassis.y), rot);

        this.chassis.x = chassispos.x;
        this.chassis.y = chassispos.y;

        var delta = Math.round(dt);
        this.chassis.update(delta);

        var fwpos = cmpcar.compound.bodies.at(1).position;
        var bwpos = cmpcar.compound.bodies.at(0).position;
        if (this.fw != null) {
            fw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
            fw.x = fwpos.x;
            fw.y = fwpos.y;
            this.fw.update(delta);
        }

        if (this.bw != null) {
            bw.rotateSprite(Vec2.get(fw.x, fw.y), cmpcar.compound.bodies.at(1).rotation);
            bw.x = bwpos.x;
            bw.y = bwpos.y;
            this.bw.update(delta);
        }
    }
}
