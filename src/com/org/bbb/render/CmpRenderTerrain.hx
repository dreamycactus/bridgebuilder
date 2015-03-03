package com.org.bbb.render;
import com.org.bbb.physics.CmpTerrain;
import com.org.mes.Cmp;
import nape.shape.Polygon;

/**
 * ...
 * @author ...
 */
@editor
class CmpRenderTerrain extends CmpRender
{
    var terrain : CmpTerrain;
    public function new(terrain : CmpTerrain) 
    {
        super(true);
        subscriptions = [Msgs.ENTMOVE];
        this.terrain = terrain;
        refresh();
        
    }
    
    function refreshterrain() : Void
    {
        if (terrain == null || terrain.cells == null) return;
        var g = sprite.graphics;
        g.clear();
        for (c in terrain.cells) {
            if (c == null) continue;
            for (s in c.shapes) {
                var p : Polygon = s.castPolygon;
                var edges = p.edges;
                var v1 = edges.at(0).worldVertex1;
                g.beginFill(0x454545);
                g.moveTo(v1.x, v1.y);
                for (i in 0...edges.length) {
                    var v2 = edges.at(i).worldVertex2;
                    g.lineTo(v2.x, v2.y);
                }
                g.endFill();
            }
        }
    }
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        switch(msgType) {
        case Msgs.ENTMOVE:
            refreshterrain();
        }
    }
    
}