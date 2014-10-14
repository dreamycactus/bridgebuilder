package com.org.bbb;
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
        var gridOffset = Vec2.get(0, GameConfig.gridCellWidth+GameConfig.matDeck.height*0.5);
        for (e in root) {
            if (e.nodeType == Xml.PCData) {
                continue;
            }
            switch(e.nodeName.toLowerCase()) {
            case "anchor":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")));
                var dim = level.worldDim( Std.parseFloat(e.get("w")),  Std.parseFloat(e.get("h"))  );
                var gridMultiple = Std.int(pos.y/GameConfig.gridCellWidth);
                pos.y =   (gridMultiple-0.5) * GameConfig.gridCellWidth
                        + dim.h * 0.5
                        - GameConfig.matDeck.height * 0.5;

                var anc = new Body(BodyType.STATIC);
                anc.shapes.add( new Polygon(Polygon.box(dim.w, dim.h), null, new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor) ) );
                anc.shapes.at(0).filter.collisionGroup = GameConfig.cgAnchor;
                anc.shapes.at(0).filter.collisionMask = GameConfig.cmAnchor;
                anc.position = pos;
                var ent = state.createEnt();
                ent.attachCmp(new CmpAnchor(anc));
                anc.userData.entity = ent;
                level.ents.push(ent);
                
            case "spawn":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")));
                var dir = Std.parseInt(e.get("dir"));
                var period = Std.parseFloat(e.get("period"));
                var count = Std.parseInt(e.get("count"));
                trace(Std.parseFloat(e.get("x")));
                var spawnIcon = new Body(BodyType.KINEMATIC );
                spawnIcon.shapes.add(new Polygon(Polygon.regular(20, 20, 3, 0.0), null, new InteractionFilter(GameConfig.cgSpawn, GameConfig.cmEditable)));
                spawnIcon.position = pos.add(gridOffset);
                if (dir == -1) {
                    spawnIcon.rotation = Math.PI;
                }
                var spawn = state.createEnt();
                var cmpSpawn = new CmpSpawn(pos, dir, 0, spawnIcon, count, period);
                spawn.attachCmp(cmpSpawn);
                spawnIcon.userData.entity = spawn;
                level.spawns.push(cmpSpawn);
                level.ents.push(spawn);
                
            case "end":
                var pos = level.worldCoords(Std.parseFloat(e.get("x")), Std.parseFloat(e.get("y")));
                var end = state.createEnt();
                end.attachCmp(new CmpEnd(pos.add(gridOffset)));
                level.ents.push(end);
                
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
                    var gridPos = gridCoords(b.position.x, b.position.y);
                    var gridDim = gridDim(bounds.width, bounds.height);
                    anchor.set("x", cast(gridPos.x));
                    anchor.set("y", cast(gridPos.y));
                    anchor.set("w", cast(gridDim.w));
                    anchor.set("h", cast(gridDim.h));
                    xml.addChild(anchor);
                case GameConfig.cgSpawn:
                    var spawn = Xml.createElement('spawn');
                    var gridPos = gridCoords(b.position.x, b.position.y);
                    spawn.set("x", cast(gridPos.x));
                    spawn.set("y", cast(gridPos.y));
                    if (b.rotation < 1) {
                        spawn.set("dir", "1");
                    } else {
                        spawn.set("dir", "-1");
                    }
                    spawn.set("period", "2000");
                    xml.addChild(spawn);
                case GameConfig.cgEnd:
                    var end = Xml.createElement('end');
                    var gridPos = gridCoords(b.position.x, b.position.y);
                    end.set("x", cast(gridPos.x));
                    end.set("y", cast(gridPos.y));
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
    
    function worldCoords(x : Float, y : Float) : Vec2
    {
        var v = new Vec2(x * GameConfig.gridCellWidth, height - y * GameConfig.gridCellWidth);
        return v;
    }
    
    function worldDim(x : Float, y : Float) : { w : Float, h : Float }
    {
        return { w : x * GameConfig.gridCellWidth, h : y * GameConfig.gridCellWidth };
    }
    
    function gridCoords(xx : Float, yy : Float) : { x : Float, y : Float }
    {
        return { x: xx / GameConfig.gridCellWidth, y: (height - yy) / GameConfig.gridCellWidth };
    }
    
    function gridDim(x : Float, y : Float) : { w : Float, h : Float }
    {
        return { w : x / GameConfig.gridCellWidth, h : y / GameConfig.gridCellWidth}
    }
    
}