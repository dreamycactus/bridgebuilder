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
class CmpRenderTruckTrailer extends CmpRender
{
    var cmpcar : CmpMoverTruckTrailer;
    var rotDelta : Float = 0;
    var chassisSpritesheet : Spritesheet;
    var wheelSpritesheet : Spritesheet;
    var chassis : AnimatedSprite;
    var bw : AnimatedSprite;
    static var sds : StringMap<SpriteData> = null;
    static var spriteSpecPath: String = "img/truck_trailer.xml";

    public function new(cmpcar: CmpMoverTruckTrailer)
    {
        super(true);

        if ( sds == null ) {
            sds = AssetProcessor.processSpriteSpec(spriteSpecPath);
        }

        this.cmpcar = cmpcar;
        displayLayer = GameConfig.zCar;
        var specChassis = sds.get("chassis");
        this.chassisSpritesheet = BitmapImporter.create(specChassis.bmpDat,
                                                        specChassis.slice.rows,
                                                        specChassis.slice.cols,
                                                        specChassis.slice.frameW,
                                                        specChassis.slice.frameH);

        for (anim in specChassis.anims) {
            this.chassisSpritesheet.addBehavior(new BehaviorData(anim.name, anim.frames, anim.loop, anim.fps, anim.centerX, anim.centerY));
        }

        var wheelChassis = sds.get("wheel");
        if (wheelChassis != null) {
            this.wheelSpritesheet = BitmapImporter.create(wheelChassis.bmpDat,
                                                          wheelChassis.slice.rows,
                                                          wheelChassis.slice.cols,
                                                          wheelChassis.slice.frameW,
                                                          wheelChassis.slice.frameH);
            for (anim in wheelChassis.anims) {
                this.wheelSpritesheet.addBehavior(new BehaviorData(anim.name, anim.frames, anim.loop, anim.fps, anim.centerX, anim.centerY));
            }
        }

        chassis = new AnimatedSprite(this.chassisSpritesheet, true);
        chassis.showBehavior("idle");
        sprite.addChild(chassis);

        if (this.wheelSpritesheet != null) {
            bw = new AnimatedSprite(this.wheelSpritesheet, true);
            bw.showBehavior("idle");

            sprite.addChild(bw);
        }
    }

    override public function render(dt : Float) : Void
    {
        var chassispos = cmpcar.compound.bodies.at(1).position;
        var bwpos = cmpcar.compound.bodies.at(0).position;

        var rot = cmpcar.compound.bodies.at(1).rotation;
        this.chassis.rotateSprite(Vec2.get(chassis.x, chassis.y), rot);

        this.chassis.x = chassispos.x;
        this.chassis.y = chassispos.y;

        var delta = Math.round(dt);
        this.chassis.update(delta);

        if (this.wheelSpritesheet != null) {
            bw.rotateSprite(Vec2.get(bw.x, bw.y), cmpcar.compound.bodies.at(0).rotation);
            bw.x = bwpos.x;
            bw.y = bwpos.y;
            this.bw.update(delta);
        }
    }
}
