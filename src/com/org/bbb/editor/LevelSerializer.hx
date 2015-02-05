package com.org.bbb.editor ;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.level.CmpObjectiveBudget;
import com.org.bbb.level.CmpSpawn;
import com.org.bbb.physics.CmpAnchor.AnchorStartEnd;
import com.org.bbb.level.CmpSpawn.SpawnType;
import com.org.bbb.physics.CmpEnd;
import com.org.bbb.physics.CmpTerrain;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.CmpRenderBg;
import com.org.mes.MESState;
import haxe.xml.Fast;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.space.Broadphase;
import nape.space.Space;
import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author ...
 */
@:access(com.org.bbb.level.CmpLevel)
class LevelSerializer
{
    public var state : MESState;
    public function new(state : MESState) 
    {
        this.state = state;
    }
    
    public function loadLevelXml(xmlAssetPath : String) : CmpLevel
    {
        var content = Assets.getText(xmlAssetPath);
        var level = parseLevelFromString(content);
        var r = ~/([0-9]+)/;
        
        if (r.match(xmlAssetPath)) {
            var levelcount = Std.parseInt(r.matched(1));
            level.id = levelcount;
        }
        return level;
    }
    
    public function parseLevelFromString(xmlData : String) : CmpLevel
    {
        var level = new CmpLevel();
        level.space = new Space(Vec2.weak(0, 600),Broadphase.DYNAMIC_AABB_TREE);
        
        var xml = Xml.parse(xmlData);
        var root = xml.elementsNamed("root").next();
        var dim = level.worldDim(Std.parseFloat(root.get("w")),  Std.parseFloat( root.get("h") ));
        level.width = dim.w;
        level.height = dim.h;
        var gridOffset = Vec2.get(0, -(GameConfig.gridCellWidth-GameConfig.matSteel.height)*0.5);
        for (e in root.elements()) {
            var fast = new Fast(e);
            switch(e.nodeName.toLowerCase()) {
            case "anchor":
                parseAnchor(level, fast);
            case "spawn":
                parseSpawn(level, fast);
            case "bg":
                parseBg(level, e);
            case "sublevel":
                parseSublevel(level, fast);
            case "terrain":
                parseTerrain(level, fast);
            default:
                 
            }
        }
        return level;
    }
    
    
    function parseSublevel(level : CmpLevel, fast : Fast) : Void
    {
        var src = 'levels/${fast.att.src}';
        var xmlData = Assets.getText(src);
        var xml = Xml.parse(xmlData);
        var sublevel = new Fast(xml.firstChild());
        var offset = Vec2.get(Std.parseFloat(fast.att.x), Std.parseFloat(fast.att.y));
        for (sfast in sublevel.elements) {
            switch(sfast.name.toLowerCase()) {
            case "anchor":
                parseAnchor(level, sfast, offset);
            case "budget":
                parseObjective(level, sfast);
            case "material":
                var matName = sfast.att.name;
                level.materialsAllowed.push(matName);
            case "spawn":
                parseSpawn(level, sfast, offset);
            case "end":
                parseEnd(level, sfast, offset);
            case "terrain":
                parseTerrain(level, fast, offset);
            case "bg":
                parseBg(level, fast.x);
            default:
            }
        }
        offset.dispose();
    }
    
    function parseAnchor(level : CmpLevel, fast : Fast, offset:Vec2=null) : Void
    {
        var tdim = level.worldDim(Std.parseFloat(fast.att.w),  Std.parseFloat(fast.att.h));
        var pos = level.worldCoords(Std.parseFloat(fast.att.x), Std.parseFloat(fast.att.y), tdim);
        var startend = fast.att.type;
        var ase = AnchorStartEnd.NONE;
        if (startend != null) {
           if (startend == "start") ase = AnchorStartEnd.START;
           else if (startend == "end") ase = AnchorStartEnd.END;
        }
        var fluid = false;
        if (fast.has.fluid) {
            fluid = true;
        }
        var taperEnd = false;
        if (fast.has.taperEnd) {
            taperEnd = true;
        }
        if (offset == null) {
            offset = Vec2.weak();
        }
        var ent = EntFactory.inst.createAnchor(pos.add(offset), tdim, fluid, ase, taperEnd);
        level.ents.push(ent);
    }
    
    function parseMaterial(level : CmpLevel, fast : Fast) : Void
    {
        
    }
    
    function parseObjective(level : CmpLevel, fast : Fast) : Void
    {
        switch(fast.name) {
        case "budget":
            var ent = state.createEnt();
            ent.attachCmp(new CmpObjectiveBudget(level
                , Std.parseInt(fast.att.maxBudget)
                , Std.parseInt(fast.att.expectedBudget)
                , Std.parseInt(fast.att.minBudget)));
            level.ents.push(ent);
        }
    }
    
    function parseSpawn(level : CmpLevel, fast : Fast, offset:Vec2=null) : Void
    {
        var pos = level.worldCoords(Std.parseFloat(fast.att.x), Std.parseFloat(fast.att.y), {w : 1, h : 1});
        var dir = Std.parseInt(fast.att.dir);
        var period = Std.parseFloat(fast.att.period);
        var count = Std.parseInt(fast.att.count);
        var spawnTypeName  = fast.att.type;

        var spawnType : SpawnType = Type.createEnum(SpawnType, spawnTypeName);
        if (offset == null) {
            offset = Vec2.weak();
        }
        var spawn = EntFactory.inst.createSpawn(spawnType, pos.add(offset), dir, period, count);
        level.spawns.push(spawn.getCmp(CmpSpawn));
        level.ents.push(spawn);
    }
    
    function parseEnd(level : CmpLevel, fast : Fast, offset:Vec2=null) : Void
    {
        var pos = level.worldCoords(Std.parseFloat(fast.att.x), Std.parseFloat(fast.att.y), {w : 200, h : 100});
        var end = state.createEnt();
        var trans = new CmpTransform();
        if (offset == null) {
            offset = Vec2.weak();
        }
        end.attachCmp(new CmpEnd(trans, pos.add(offset)));
        level.ents.push(end);
    }
    //todo replace with layer and static sprite
    function parseBg(level : CmpLevel, xml : Xml, offset:Vec2=null) : Void
    {
        for (l in xml.elements()) {
            if (l.nodeType == Xml.PCData) {
                continue;
            }
            var layer = new Fast(l);
            var element = new Fast(l);
            var pos = Vec2.weak(Std.parseFloat(element.att.x), Std.parseFloat(element.att.y));
            var parallaxK = Std.parseFloat(element.att.parallaxK);
            var bmpDat = Assets.getBitmapData("img/" + layer.att.src);
            var w = bmpDat.width;
            var h = bmpDat.height;

            var bg = state.createEnt();
            if (offset == null) {
                offset = Vec2.weak();
            }
            bg.attachCmp(new CmpRenderBg(bmpDat, pos.add(offset), w, h, parallaxK));
            level.ents.push(bg);
        }
        // backwards depth ordering is so weird...
        if (xml.get('color') != null) {
            var sanitizedColor = StringTools.replace(xml.get('color'), "#", "0x");
            var bgbmp = new BitmapData(Math.round(level.width), Math.round(level.height), false, Std.parseInt(sanitizedColor));
            var bg = state.createEnt();
            bg.attachCmp(new CmpRenderBg(bgbmp, Vec2.weak(0, 0), Math.round(level.width), Math.round(level.height), 1));
            level.ents.push(bg);
        }
    }
    
    function parseLayer(level : CmpLevel, xml : Fast, offset:Vec2=null) : Void
    {
        if (offset == null) {
            offset = Vec2.weak();
        }
    }
    
    function parseSprite(level : CmpLevel, xml : Fast, offset:Vec2=null) : Void
    {
        if (offset == null) {
            offset = Vec2.weak();
        }
    }
    
    function parseTerrain(level : CmpLevel, fast : Fast, offset:Vec2 = null) : Void
    {
        var terrain = state.createEnt("terrain");
        var bd = Assets.getBitmapData('img/${fast.att.src}');
        var ct = new CmpTerrain(bd, 100, 40);
        var offset = new Vec2(Std.parseFloat(fast.att.x), Std.parseFloat(fast.att.y));
        ct.invalidate(new AABB(0, 0, bd.width, bd.height), level.space, offset);
        offset.dispose();
        terrain.attachCmp(ct);
        level.ents.push(terrain);
    }
    
}