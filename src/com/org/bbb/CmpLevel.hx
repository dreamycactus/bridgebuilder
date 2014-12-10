package com.org.bbb;
import com.org.bbb.CmpAnchor.AnchorStartEnd;
import com.org.bbb.CmpSpawn.SpawnType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.Assets;

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
    public function new(id : Int = -1) 
    {
        super();
        spawns = new Array();
        this.id = id;
    }
    
    public static function genLevelFromString(state : MESState, content : String) : CmpLevel
    {
        var level = new CmpLevel();
        level.space = new Space(Vec2.weak(0, 600) );
        
        var xml = Xml.parse(content);
        var root = xml.elementsNamed("root").next();
        var dim = level.worldDim( Std.parseFloat(root.get("w")),  Std.parseFloat(root.get("h"))  );
        level.width = dim.w;
        level.height = dim.h;
        var gridOffset = Vec2.get(0, -(GameConfig.gridCellWidth-GameConfig.matSteel.height)*0.5);
        for (e in root) {
            if (e.nodeType == Xml.PCData) {
                continue;
            }
            switch(e.nodeName.toLowerCase()) {
            case "anchor":
                var tdim = level.worldDim(Std.parseFloat(e.get("w")),  Std.parseFloat(e.get("h"))  );
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")), tdim);
                var startend = e.get("type");
                var ase = AnchorStartEnd.NONE;
                if (startend != null) {
                   if (startend == "start") ase = AnchorStartEnd.START;
                   else if (startend == "end") ase = AnchorStartEnd.END;
                }
                var fluid = false;
                if (e.get('fluid') != null) {
                    fluid = true;
                }
                var ent = EntFactory.inst.createAnchor(pos, tdim, fluid, ase, e.get('taperEnd')!=null);
                level.ents.push(ent);
            case "budget":
                var ent = state.createEnt();
                
                //ent.attachCmp(new CmpObjectiveBudget(level, Std.parseInt(e.get('
                level.ents.push(ent);
            case "material":
                var matName = e.get("name");
                level.materialsAllowed.push(matName);
            case "spawn":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")), {w : 1, h : 1});
                var dir = Std.parseInt(e.get("dir"));
                var period = Std.parseFloat(e.get("period"));
                var count = Std.parseInt(e.get("count"));
                var spawnTypeName  = e.get("type");

                var spawnType : SpawnType = Type.createEnum(SpawnType, spawnTypeName);
                var spawn = EntFactory.inst.createSpawn(spawnType, pos.addeq(gridOffset), dir, period, count);
                level.spawns.push(spawn.getCmp(CmpSpawn));
                level.ents.push(spawn);
                
            case "end":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")), {w : 200, h : 100});
                var end = state.createEnt();
                end.attachCmp(new CmpEnd(pos.add(gridOffset)));
                level.ents.push(end);
            case "city":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")), { w : 0, h : 0 } );
                var tdim = level.worldDim(Std.parseFloat(e.get("w")),  Std.parseFloat(e.get("h")));
                var buildingW = level.worldDim(Std.parseFloat(e.get("buildingW")), 0).w;
                var layers = Std.parseInt(e.get('layers'));
                var parallaxK = Std.parseFloat(e.get('parallaxK'));
                
                var citybg1 = state.createEnt();
                citybg1.attachCmp(new CmpRenderBgCityfield(pos, tdim.w, tdim.h, buildingW, layers, parallaxK));
                level.ents.push(citybg1);

            default:
                 
            }
        }
        return level;
    }
    

    
    public static function loadLevelXml(state : MESState, xmlAssetPath : String) : CmpLevel
    {
        var content = Assets.getText(xmlAssetPath);
        var level = genLevelFromString(state, content);
        var r = ~/([0-9]+)/;
        
        if (r.match(xmlAssetPath)) {
            var levelcount = Std.parseInt(r.matched(1));
            level.id = levelcount;
            trace(levelcount);  
        }
        return level;
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