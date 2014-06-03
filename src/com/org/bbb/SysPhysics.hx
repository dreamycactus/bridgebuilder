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
    public var paused : Bool;
    
    public function new(top : Top, space : Space) 
    {
        super(top);
        this.space = space;
        this.paused = true;
    }
    
    override public function update()
    {
        if (paused) {
            return;
        }
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
        if (e.hasCmp(CmpBeam) ) {
            return true;
        }
        return false;
    }
    
    var velIterations : Int = 10;
    var posIterations : Int = 10;
}