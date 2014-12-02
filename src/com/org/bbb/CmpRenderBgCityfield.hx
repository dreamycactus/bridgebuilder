package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
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
    parallaxK : Float
}
typedef Building = 
{
    pos : Vec2,
    w : Float,
    h : Float,
    type : BuildingType,
    layer : BuildingLayer
}
class CmpRenderBgCityfield extends CmpRender
{
    var buildingLayers : List<BuildingLayer> = new List();
    public var width : Float;
    public var height : Float;
    public var depth : Float;
    public var numLayers : Float;
    public var pos : Vec2;
    
    var camDelta : Vec2;
    
    public function new(pos : Vec2, w : Float, h : Float, depth : Float, numLayers : Int, numFirstLayerBuildings: Int, parallaxK : Float) 
    {
        super(true);
        this.pos = pos;
        width = w;
        height = h;
        subscriptions = [Msgs.CAMERAMOVE];
        var prevX = 0.0;
        for (i in 0...numLayers) {
            var layer : BuildingLayer = { buildings : new List<Building>(), parallaxK : parallaxK + 0.1 * i };
            buildingLayers.push(layer);
            for (j in 0...numFirstLayerBuildings) {
                var randX = Util.randomf(10, 25);
                var randHeight = Util.randomf(20, 70);
                prevX += randX;
                layer.buildings.push( { pos : Vec2.get(pos.x + prevX, pos.y + 300 * i - randHeight), w : Util.randomf(10, 20), h : randHeight, type : BuildingType.RECT, layer :layer } );
            }
            
        }
        sprite.filters = [new GlowFilter(0xFFFFFF, 0.8, 6, 6, 2, 1)];
    }
    
    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
        g.clear();
        for (layer in buildingLayers) {
            for (building in layer.buildings) {
                g.beginFill(0xFFFFFF);
                g.moveTo(building.pos.x, building.pos.y);
                g.drawRect(building.pos.x, building.pos.y, building.w, building.h);
                g.endFill();
                trace(building.pos);
            }
        }
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        camDelta = options.delta;
        //sprite.x -= delta.x * 0.8;
        //sprite.y -= delta.y * 0.8;
    }
    
}