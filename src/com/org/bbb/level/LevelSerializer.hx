package com.org.bbb.level;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpBeam;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpTerrain;
import com.org.bbb.render.CmpRenderSprite;
import com.org.bbb.states.StateBridgeLevel;
import com.org.mes.Entity;
import com.org.mes.EntityType;
import com.org.mes.MESState;
import haxe.format.JsonPrinter;
import haxe.Json;
import haxe.rtti.Meta;

/**
 * ...
 * @author ...
 */
class LevelSerializer
{
    public var state : StateBridgeLevel;
    
    
    var anchorType : EntityType;
    public function new(state : StateBridgeLevel) 
    {
        this.state = state;
        anchorType = state.entityTypeManager.getEntityType('anchor');
    }
    
    public function generateJson(state : StateBridgeLevel) : String
    {
        var leveldata : Dynamic = { w : state.level.width, h : state.level.height, objects : new Array<Dynamic>()}
        for (e in state.level.ents) {
            var entdata : Dynamic = { type : '', cmps : new Array<Dynamic>() };
            if (e.hasCmp(CmpAnchor)) {
                entdata.type = 'anchor';
            } else if (e.hasCmp(CmpTerrain)) {
                entdata.type = 'terrain';
            } else if (e.hasCmp(CmpRenderSprite)) {
                entdata.type = 'staticsprite';
            } else if (e.hasCmp(CmpBeam)) {
                entdata.type = 'beam';
            } else if (e.hasCmp(CmpCable)) {
                entdata.type = 'cable';
            }
            for (c in e.cmps) {
                c.genJson();
                if (c.jsondata != null) {
                    entdata.cmps.push(c.jsondata);
                }
            }
            leveldata.objects.push(entdata);
        }
        return Json.stringify(leveldata,null, ' ');
    }
    
    function genAnchor(e : Entity) : String
    {
        var c = e.getCmp(CmpAnchor);
        return c.genJson();
    }
    
}