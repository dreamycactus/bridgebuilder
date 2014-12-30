package com.org.bbb;

import openfl.Assets;
import openfl.display.BitmapData;
import haxe.ds.StringMap;
import haxe.xml.Fast;

typedef AnimData = {
    var name: String;
    var frames: Array<Int>;
    var loop: Bool;
    var fps: Int;
    var centerX: Int;
    var centerY: Int;
} //FIXME make me a class

typedef SpriteData = {
    var bmpDat: BitmapData;
    var slice: { frameW: Int, frameH: Int, rows: Int, cols: Int };
    var anims: Array<AnimData>;
} //FIXME make me a class

class AssetProcessor {
    public static function processSpriteSpec(specPath: String): StringMap<SpriteData> {
        var spec = new Fast(Xml.parse(Assets.getText(specPath)).firstElement());
        var sds = new StringMap<SpriteData>();

        for (spritesheet in spec.nodes.spritesheet) {
            var id = spritesheet.att.id;
            var src = spritesheet.att.src;
            var slice = spritesheet.node.slice;
            var frameW = slice.att.frameW;
            var frameH = slice.att.frameH;
            var rows = slice.att.rows;
            var columns = slice.att.columns;
            var anims = new Array<AnimData>();

            for (a in spritesheet.node.anims.nodes.anim) {
                var n = a.att.name;
                var frames = [for (i in Std.parseInt(a.att.start)...Std.parseInt(a.att.end)) i];
                var loop = Std.parseInt(a.att.loop) == 0 ? false : true;
                var fps = Std.parseInt(a.att.fps);
                var centerX = Std.parseInt(a.att.centerX);
                var centerY = Std.parseInt(a.att.centerY);
                anims.push( {
                    name: n,
                    frames: frames,
                    loop: loop,
                    fps: fps,
                    centerX: centerX,
                    centerY: centerY
                } );
            }

            sds.set(id, {
                bmpDat : Assets.getBitmapData("img/" + src),
                slice : {
                    frameW: Std.parseInt(frameW),
                    frameH: Std.parseInt(frameH),
                    rows: Std.parseInt(rows),
                    cols: Std.parseInt(columns)
                },
                anims: anims
            });
        }

        return sds;
    }
}
