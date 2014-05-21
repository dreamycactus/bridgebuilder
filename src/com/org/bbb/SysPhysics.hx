package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.System;
import com.org.mes.Top;
import flash.Lib;
import nape.geom.Vec2;
import nape.space.Broadphase;
import nape.space.Space;

/**
 * ...
 * @author 
 */
typedef PhysicsParams = {
    ?gravity : Vec2,
    ?shapeDebug : Bool,
    ?broadphase : Broadphase,
    ?noSpace : Bool,
    ?variableStep : Bool,
    ?noReset : Bool,
    ?velIterations : Int,
    ?posIterations : Int,
};

class SysPhysics extends System
{
    public var space : Space;
    
    public function new(top : Top, space : Space) 
    {
        super(top);
        this.space = space;
    }
    
    override public function update()
    {
        var deltaTime : Float = top.dt;
        if (deltaTime > (1000 / 60)) {
            deltaTime = (1000 / 60);
        }

        if (space != null) {
            space.step(deltaTime * 0.001, velIterations, posIterations);
        }
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        return false;
        //if (e.hasCmp(CmpBeam) || e.hasCmp( //todo implement with cmp bits
    }
    
    var velIterations : Int = 10;
    var posIterations : Int = 10;
}