package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

import com.org.bbb.EntFactory.TruckType;

enum SpawnType
{
    Car;
    Train;
    Truck;
}

/**
 * ...
 * @author 
 */
class CmpSpawn extends CmpPhys
{
    public var pos : Vec2;
    public var dir : Int;
    public var spawnType : SpawnType;
    public var body : Body;
    public var totalCount : Int;
    public var curCount : Int = 0;
    public var period : Float;
    public var spawnCD : Float;
    public var active(default, set_active) : Bool = false;
    
    public function new(spawnType : SpawnType, pos : Vec2, dir : Int, body : Body, totalCount : Int, period : Float)
    {
        super();
        this.pos = pos;
        this.dir = dir;
        this.spawnType = spawnType;
        this.body = body;
        this.totalCount = totalCount;
        this.period = period;
        
        this.spawnCD = period;
    }
    
    override public function update() : Void
    {
        if (!active) { return; }
        var dt = entity.state.top.dt;
        
        spawnCD -= 30;
        pos = body.position;
        if (body.rotation < 1) {
            dir = 1;
        } else {
            dir = -1;
        }
        if (spawnCD < 0 && curCount < totalCount) {
            switch(spawnType) {
            case Car:
                entity.state.insertEnt(EntFactory.inst.createCar(pos, dir));
                curCount++;
            case Train:
                var arr = EntFactory.inst.createTrain(pos, dir, totalCount);
                for (e in arr) {
                    entity.state.insertEnt(e);
                }
                curCount = totalCount;
            case Truck:
                var i = Math.floor(Math.random() * Type.allEnums(TruckType).length);
                var type = Type.createEnumIndex(TruckType, i);
                var arr = EntFactory.inst.createTruck(pos, dir, type);
                for (e in arr) {
                    entity.state.insertEnt(e);
                }
                curCount++;
            }
            spawnCD = period;

        }
    }
    
    public function reset() : Void
    {
        curCount = 0;
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
    function set_active(a : Bool) : Bool
    {
        active = a;
        if (a) {
            reset();
        }
        return a;
    }
    
    
}
