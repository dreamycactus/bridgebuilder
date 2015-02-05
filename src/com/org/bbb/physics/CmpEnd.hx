package com.org.bbb.physics ;
import com.org.bbb.physics.CmpPhys;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpEnd extends CmpPhys
{
    public var body : Body;
    public var pos(get_pos, null) : Vec2;
    public function new(trans : CmpTransform, pos : Vec2) 
    {
        super(trans);
        this.body = new Body(BodyType.STATIC, pos);
        var shape = new Polygon(Polygon.box(200, 100), null, new InteractionFilter(GameConfig.cgEnd, GameConfig.cmEditable));
        shape.sensorEnabled = true;
        this.body.shapes.add(shape);
        this.body.cbTypes.add(GameConfig.cbEnd);
        this.pos = pos;
    }
    
    override public function update() : Void
    {
    }
    
    override function set_space(space : Space) : Space
    {
        body.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return body.space;
    }
    
    function get_pos() : Vec2
    {
        return body.position;
    }
}