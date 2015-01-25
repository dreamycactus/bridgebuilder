package com.org.bbb.level ;
import com.org.bbb.physics.CmpAnchor.AnchorStartEnd;
import com.org.bbb.level.CmpSpawn.SpawnType;
import com.org.bbb.render.CmpParallaxLayer;
import com.org.bbb.systems.SysPhysics;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import haxe.xml.Fast;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Broadphase;
import nape.space.Space;
import openfl.Assets;
import openfl.display.BitmapData;

typedef SublevelData = 
{
    var src : String;
    var x : Float;
    var y : Float;
}

typedef TerrainData =
{
    var src : String;
    var x : Float;
    var y : Float;
}

class CmpLevel extends Cmp
{
    public var space : Space;
    public var spawns : Array<CmpSpawn>;
    public var width : Float;
    public var height : Float;
    public var spawnCD : Float = GameConfig.spawnCDCar;
    public var id : Int;
    public var ents : List<Entity> = new List();
    public var materialsAllowed : Array<String> = new Array();
    public var parallaxLayers : Array<CmpParallaxLayer> = new Array();
    public var sublevels : Array<SublevelData> = new Array();
    public var terrainz : Array<TerrainData> = new Array();
    
    public function new(id : Int = -1) 
    {
        super();
        spawns = new Array();
        this.id = id;
    }
    
    
    public function generateLevelXML(w : Float, h : Float) : Xml
    {
        var xml = Xml.createElement('root');
        var leveldim = gridDim(w, h);
        xml.set("w", cast(leveldim.w));
        xml.set("h", cast(leveldim.h));
        space.bodies.foreach(function(b) {
            if (b.shapes.length == 1) {
                switch(b.shapes.at(0).filter.collisionGroup) {
                case GameConfig.cgAnchor:
                    var bounds = b.bounds;
                    var anchor = Xml.createElement('anchor');
                    var gd = gridDim(bounds.width, bounds.height);
                    var gridPos = gridCoords(b.position.x, b.position.y, gd);
                    anchor.set("x", cast(Util.fdec(gridPos.x, 2)));
                    anchor.set("y", cast(Util.fdec(gridPos.y, 2)));
                    anchor.set("w", cast(Util.fdec(gd.w, 2)));
                    anchor.set("h", cast(Util.fdec(gd.h, 2)));
                    xml.addChild(anchor);
                case GameConfig.cgSpawn:
                    var spawn = Xml.createElement('spawn');
                    var gridPos = gridCoords(b.position.x, b.position.y, {w : 0, h : 0});
                    spawn.set("x", cast(Util.fdec(gridPos.x, 2)));
                    spawn.set("y", cast(Util.fdec(gridPos.y, 2)));
                    if (b.rotation < 1) {
                        spawn.set("dir", "1");
                    } else {
                        spawn.set("dir", "-1");
                    }
                    spawn.set("period", "2000");
                    spawn.set("count", "30");
                    xml.addChild(spawn);
                case GameConfig.cgEnd:
                    var end = Xml.createElement('end');
                    var gridPos = gridCoords(b.position.x, b.position.y, {w : 0, h : 0});
                    end.set("x", cast(Util.fdec(gridPos.x, 2)));
                    end.set("y", cast(Util.fdec(gridPos.y, 2)));
                    xml.addChild(end);
                }
            }

        });
        return xml;
    }
    
    override public function update() 
    {
        if (!entity.state.getSystem(SysPhysics).paused) {
        }
    }
    
    function worldCoords(x : Float, y : Float, dim : {w : Float, h : Float}) : Vec2
    {
        var v = new Vec2(x * GameConfig.gridCellWidth + dim.w * 0.5, height - (y * GameConfig.gridCellWidth - dim.h * 0.5));
        return v;
    }
    
    function worldDim(x : Float, y : Float) : { w : Float, h : Float }
    {
        return { w : x * GameConfig.gridCellWidth, h : y * GameConfig.gridCellWidth };
    }
    
    function gridCoords(xx : Float, yy : Float, dim : {w : Float, h : Float}) : { x : Float, y : Float }
    {
        return { x: (xx) / GameConfig.gridCellWidth - dim.w * 0.5 , y: (height - yy) / GameConfig.gridCellWidth + dim.h * 0.5   };
    }
    
    function gridDim(w : Float, h : Float) : { w : Float, h : Float }
    {
        return { w : w / GameConfig.gridCellWidth, h : h / GameConfig.gridCellWidth}
    }
    
}
