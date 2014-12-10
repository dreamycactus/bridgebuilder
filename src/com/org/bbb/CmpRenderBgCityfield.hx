package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.display.Sprite;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author 
 */
enum BuildingType {
    RECT;
}
typedef BuildingLayer = 
{
    buildings : List<Building>,
    parallaxK : Float,
	color : Int,
	sprite : Sprite

}
typedef Building = 
{
    pos : Vec2,
    w : Float,
    h : Float,
    type : BuildingType,
    layer : BuildingLayer,
}
class CmpRenderBgCityfield extends CmpRender
{
    var buildingLayers : List<BuildingLayer> = new List();
    public var width : Float;
    public var height : Float;
    public var depth : Float;
    public var numLayers : Float;
    public var pos : Vec2;
    
    var camPos : Vec2;
	
    public function new(pos : Vec2, w : Float, h : Float, buildingWidth : Float, numLayers : Int, parallaxK : Float) 
    {
        super(true);
        this.pos = pos;
        width = w;
        height = h;
        subscriptions = [Msgs.CAMERAMOVE];
		this.z = GameConfig.zCity;
		
        for (t in 0...numLayers) {
			var i = numLayers - t;
			var prevX = 0.0;
            var layer : BuildingLayer = { buildings : new List<Building>(), parallaxK : parallaxK + 0.1 * i, color : Std.random(0xFFFFFF), sprite : new Sprite()};
            buildingLayers.push(layer);
            var numBuildings = Std.int(w / buildingWidth);
            var j = 0;
            while (true) {
                var randX = Util.randomf(buildingWidth*0.2, buildingWidth*1.0);
                var randHeight = Util.randomf(buildingWidth*1.2, buildingWidth*5);
                prevX += randX;
                if (prevX - pos.x > width) {
                    break;
                }
                layer.buildings.push( { pos : Vec2.get(pos.x + prevX, pos.y + 10 * i - randHeight), w : Util.randomf(buildingWidth*0.5, buildingWidth*1.5), h : randHeight, type : BuildingType.RECT, layer :layer } );
                j++;
            }
        }
		camPos = Vec2.get();

		for (layer in buildingLayers) {
			var sp = layer.sprite;
			var g = sp.graphics;
            for (building in layer.buildings) {
                g.beginFill(layer.color);
                //g.moveTo(building.pos.x-camDelta.x, building.pos.y-camDelta.y);
                g.drawRect(building.pos.x-camPos.x*layer.parallaxK, building.pos.y-camPos.y*layer.parallaxK, building.w, building.h);
                g.endFill();
                trace(building.pos);
            }
			sprite.addChild(sp);
        }
        //sprite.filters = [new GlowFilter(0xFFFFFF, 0.8, 6, 6, 2, 1)];
    }
    
    override public function render(dt : Float) : Void
    {
        //var g = sprite.graphics;
        //g.clear();
        
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        camPos = options.camPos;
		for (layer in buildingLayers) {
			layer.sprite.x = - camPos.x * layer.parallaxK;
			layer.sprite.y = - camPos.y* layer.parallaxK;
		}
        //sprite.x -= delta.x * 0.8;
        //sprite.y -= delta.y * 0.8;
    }
    
}