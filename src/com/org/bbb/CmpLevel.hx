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

/**
 * ...
 * @author 
 */

typedef Spawn =
{
   var pos : Vec2;
   var dir : Int;
   var type : Int;
   var body : Body;
};

class CmpLevel extends Cmp
{
    public var space : Space;
    public var spawns : Array<Spawn>;
    public var width : Float;
    public var height : Float;
    public var spawnCD : Float = GameConfig.spawnCDCar;
    public var id : Int;
    
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
        level.width = Std.parseFloat(root.get("w"));
        level.height = Std.parseFloat(root.get("h"));
        for (e in root) {
            if (e.nodeType == Xml.PCData) {
                continue;
            }
            switch(e.nodeName.toLowerCase()) {
            case "anchor":
                var x = Std.parseFloat(e.get("x"));
                var y = Std.parseFloat(e.get("y"));
                var w = Std.parseFloat(e.get("w"));
                var h = Std.parseFloat(e.get("h"));
                
                var anc = new Body(BodyType.STATIC);
                anc.shapes.add( new Polygon(Polygon.box(w, h), null, new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor) ) );
                anc.shapes.at(0).filter.collisionGroup = GameConfig.cgAnchor;
                anc.shapes.at(0).filter.collisionMask = GameConfig.cmAnchor;
                anc.position.setxy(x, y);
                anc.space = level.space;
                var ent = state.createEnt();
                ent.attachCmp(new CmpAnchor(anc));
                anc.userData.entity = ent;
                
            case "spawn":
                var x = Std.parseFloat(e.get("x"));
                var y = Std.parseFloat(e.get("y"));
                var poss = Vec2.get(x, y);
                var dir = Std.parseInt(e.get("dir"));
                
                var spawnIcon = new Body(BodyType.KINEMATIC );
                spawnIcon.shapes.add(new Polygon(Polygon.regular(20, 20, 3, 0.0), null, new InteractionFilter(GameConfig.cgSpawn, GameConfig.cmSpawn)));
                spawnIcon.position = Vec2.get(x, y);
                if (dir == -1) {
                    spawnIcon.rotation = Math.PI;
                }
                spawnIcon.space = level.space;
                var spawn = { pos : poss, dir : dir, type : 0, body : spawnIcon };
                spawnIcon.userData.spawn = spawn;
                level.spawns.push(spawn);
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
        xml.set("w", cast(w));
        xml.set("h", cast(h));
        space.bodies.foreach(function(b) {
            if (b.shapes.length == 1) {
                switch(b.shapes.at(0).filter.collisionGroup) {
                case GameConfig.cgAnchor:
                    var bounds = b.bounds;
                    var anchor = Xml.createElement('anchor');
                    anchor.set("x", cast(b.position.x));
                    anchor.set("y", cast(b.position.y));
                    anchor.set("w", cast(bounds.width));
                    anchor.set("h", cast(bounds.height));
                    xml.addChild(anchor);
                case GameConfig.cgSpawn:
                    var spawn = Xml.createElement('spawn');
                    spawn.set("x", cast(b.position.x));
                    spawn.set("y", cast(b.position.y));
                    if (b.rotation < 1) {
                        spawn.set("dir", "1");
                    } else {
                        spawn.set("dir", "-1");
                    }
                    xml.addChild(spawn);
                }
            }
        });
        return xml;
    }
    
    override public function update() 
    {
        if (!entity.state.getSystem(SysPhysics).paused) {
            for (s in spawns) {
                spawnCD -= entity.state.top.dt;
                s.pos = s.body.position;
                if (s.body.rotation < 1) {
                    s.dir = 1;
                } else {
                    s.dir = -1;
                }
                if (spawnCD < 0) {
                    entity.state.insertEnt(EntFactory.inst.createCar(s.pos, s.dir));
                    spawnCD = GameConfig.spawnCDCar;
                }
            }
        }
    }
    
}