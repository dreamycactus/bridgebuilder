package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpSpawn extends CmpPhys
{
    public var pos : Vec2;
    public var dir : Int;
    public var spawnType : Int;
    public var body : Body;
    public var totalCount : Int;
    public var curCount : Int = 0;
    public var period : Float;
    public var spawnCD : Float;
    public var active : Bool = false;
    
    public function new(pos : Vec2, dir : Int, type : Int, body : Body, totalCount : Int, period : Float)
    {
        super();
        this.pos = pos;
        this.dir = dir;
        this.spawnType = type;
        this.body = body;
        this.totalCount = totalCount;
        this.period = period;
        
        this.spawnCD = period;
    }
    
    override public function update() : Void
    {
        if (!active) { return; }
        var dt = entity.state.top.dt;
        
        spawnCD -= dt;
        pos = body.position;
        if (body.rotation < 1) {
            dir = 1;
        } else {
            dir = -1;
        }
        if (spawnCD < 0 && curCount++ < totalCount) {
            entity.state.insertEnt(EntFactory.inst.createCar(pos, dir));
            spawnCD = period;
        }
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
    
    
}