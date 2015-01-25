package com.org.bbb.systems ;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.physics.CmpBeamBase;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpMoverCar;
import com.org.bbb.physics.CmpPhys;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;
import com.org.mes.Top;
import nape.callbacks.Callback;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.Listener;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.phys.Body;
import openfl.Lib;
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
    public var level(default, set) : CmpLevel;
    public var space : Space;
    public var paused : Bool;
    
    public function new(state : MESState, level : CmpLevel) 
    {
        super(state);
        this.level = level;
                
        this.paused = true;
    }
    
    override public function update()
    {
        if (paused) {
            return;
        }
        var deltaTime : Float = Top.dt;
        if (deltaTime > (1000 / 60)) {
            deltaTime = (1000 / 60);
        }

        if (level.space != null) {
            level.space.step(deltaTime * 0.001, velIterations, posIterations);
        }
    }
    override public function inserted(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpPhys);
        for (c in res) {
            c.space = level.space;
        }
        var c = e.getCmp(CmpCable);
        if (c != null) {
            c.sendMsg(Msgs.CABLECREATE, c, null);
        }
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpPhys);
        for (c in res) {
            c.space = null;
        }
        var beamz = e.getCmpsHavingAncestor(CmpBeamBase);
        if (beamz.length != 0) {
            for (b in beamz) {
                for (sj in b.sharedJoints) {
                    sj.deleteNull();
                }
            }
        }
        
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if (e.getCmpsHavingAncestor(CmpPhys) != null) {
            return true;
        }
        return false;
    }
    
    function oneWayHandler(cb : PreCallback) : PreFlag
    {
        var colArb = cb.arbiter.collisionArbiter;
        
        if ((colArb.normal.y > 0) != cb.swapped) {
            return PreFlag.IGNORE;
        } else {
            return PreFlag.ACCEPT;
        }
    }
    
    function set_level(l : CmpLevel) : CmpLevel
    {
        level = l;
        if (level != null) {
            this.space = level.space;
            space.listeners.add(new PreListener(
                InteractionType.COLLISION,
                GameConfig.cbOneWay,
                CbType.ANY_BODY,
                oneWayHandler));
            space.listeners.add(new InteractionListener(
                CbEvent.BEGIN, 
                InteractionType.COLLISION, 
                GameConfig.cbCar, 
                GameConfig.cbGround,
                carOnGroundHandler.bind(true)));
            space.listeners.add(new InteractionListener(
                CbEvent.END, 
                InteractionType.COLLISION, 
                GameConfig.cbCar, 
                GameConfig.cbGround,
                carOnGroundHandler.bind(false)));
        }
        return l;
    }
    
    function carOnGroundHandler(touching : Bool, cb : InteractionCallback)
    {
        var cmpcar = cb.int1.castBody.userData.entity.getCmp(CmpMoverCar);
        cmpcar.onGround = touching;
    }
    
    var velIterations : Int = 10;
    var posIterations : Int = 10;
}