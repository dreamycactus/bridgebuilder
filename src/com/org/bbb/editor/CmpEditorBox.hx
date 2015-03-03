package com.org.bbb.editor;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.CmpRender;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.geom.AABB;

/**
 * ...
 * @author ...
 */
class CmpEditorBox extends CmpRender
{
    public var w(default, set) : Float;
    public var h(default, set) : Float;
    public var x(get, never) : Float;
    public var y(get, never) : Float;
    public var bbox(get, never) : AABB;

    public var trans : CmpTransform;
    
    public function new(w : Float, h : Float) 
    {
        super(true);
        subscriptions = [Msgs.XTRANSCHANGE, Msgs.YTRANSCHANGE, Msgs.DIMCHANGE];
        this.w = w;
        this.h = h;
    }
    public function clear() : Void
    {
        sprite.graphics.clear();
    }
    override function set_entity(e:Entity):Entity 
    {
        trans = e.getCmp(CmpTransform);
        refreshbox();
        return super.set_entity(e);
    }
    function refreshbox() : Void
    {
        if (trans == null) return;
        var g = sprite.graphics;
        g.clear();
        g.beginFill(0xFF00FF);
            g.drawRect(trans.x, trans.y, w, h);
        g.endFill();
    }
    
    function set_h(value:Float):Float 
    {
        refreshbox();
        return h = value;
    }
    function set_w(value:Float):Float 
    {
        refreshbox();
        return w = value;
    }    
    function get_x():Float 
    {
        return trans == null ? Math.NaN : trans.x;
    }
    function get_y():Float 
    {
        return trans == null ? Math.NaN : trans.y;
    }    
    function get_bbox():AABB 
    {
        return trans == null ? null : new AABB(x, y, w, h);
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        switch(msgType)
        {
        case Msgs.XTRANSCHANGE:
            refresh();
        case Msgs.YTRANSCHANGE:
            refresh();
        case Msgs.DIMCHANGE:
            h = options.h;
            w = options.w;
        }
    }

}