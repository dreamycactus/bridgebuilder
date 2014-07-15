package com.org.bbb;
import com.org.mes.Cmp;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class CmpLevel extends Cmp
{
    public var space : Space;
    
    public function new() 
    {
        super();
    }
    
    public static function genFromXml(xmlAssetPath : String) : CmpLevel
    {
        var level = null;
        
        var content = Assets.getText(xmlAssetPath);
        var xml = Xml.parse(content);
        
        level = new CmpLevel();
        level.space = new Space(Vec2.weak(0, 600) );
        
        var root = xml.elementsNamed("root").next();
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
                anc.shapes.add( new Polygon(Polygon.box(w, h), null, new InteractionFilter(Config.cgAnchor, Config.cmAnchor) ) );
                anc.shapes.at(0).filter.collisionGroup = Config.cgAnchor;
                anc.shapes.at(0).filter.collisionMask = Config.cmAnchor;
                anc.position.setxy(x, y);
                anc.space = level.space;
            }
        }
        return level;
    }
    
}