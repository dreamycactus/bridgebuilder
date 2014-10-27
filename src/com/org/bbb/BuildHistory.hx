package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.MESState;
import haxe.ds.GenericStack;
import haxe.ds.ObjectMap;
import nape.phys.Body;
using Lambda;
/**
 * ...
 * @author 
 */
typedef BuildState = 
{
    ents : Array<Entity>,
    lines : LineChecker
};

class BuildHistory
{
    var stack : List<BuildState> = new List<BuildState>();
    var state : MESState;
    var maxStackDepth = 10;
    public var length(get_length, null) : Int;
    
    public function new(state : MESState) 
    {
        this.state = state;
    }
    
    public function snapAndPush(builtEnts : Array<Entity>, linechecker : LineChecker)
    {
        var snapshot : Array<Entity> = new Array();
        var oldToNew : ObjectMap<Entity, Entity> = new ObjectMap();
        var cables : Array<CmpCable> = new Array(); // special case for cables since they need reference to sharedJoint
        
        for (e in builtEnts) {
            var newEnt : Entity = null;
            if (e.hasCmp(CmpBeam)) {
                var cmpBeam = e.getCmp(CmpBeam);
                var newBody = cmpBeam.body.copy();
                newEnt = EntFactory.inst.createBeamEnt(cmpBeam.p1, cmpBeam.p2, cmpBeam.body.position, newBody, cmpBeam.width, cmpBeam.material);
                newBody.userData.entity = newEnt;
            } else if (e.hasCmp(CmpCable)) {
                var cmpCable = e.getCmp(CmpCable);
                newEnt = state.createEnt();
                var newCable = new CmpCable(cmpCable.p1, cmpCable.p2, cmpCable.material);
                newEnt.attachCmp(newCable);
            }
            if (newEnt != null) {
                oldToNew.set(e, newEnt);
                snapshot.push(newEnt);
            }
            
        }
        
        for (e in builtEnts.filter(function(s) { return s.hasCmp(CmpSharedJoint); } )) {
            var sharedJoint = e.getCmp(CmpSharedJoint);
            var newEnt = EntFactory.inst.createSharedJoint(sharedJoint.body.position);
            var newSharedJoint = newEnt.getCmp(CmpSharedJoint);
            
            for (b in sharedJoint.bodies) {
                var ent : Entity = b.userData.entity;
                if (ent == null) {
                    trace(ent.id);
                }
                var newB = oldToNew.get(ent);
                if (newB == null) { // for cmpAnchor?
                    newB = ent;
                }
                var body : Body = null;
                if (newB.hasCmp(CmpBeam)) {
                    body = newB.getCmp(CmpBeam).body;
                } else if (newB.hasCmp(CmpAnchor)) {
                    body = newB.getCmp(CmpAnchor).body;
                } else if (newB.hasCmp(CmpCable)) {
                    var cmpCable = newB.getCmp(CmpCable);
                    var b1 = cmpCable.first;
                    var b2 = cmpCable.last;
                    var dp = sharedJoint.body.position.sub(b1.position);
                    var dp2 = sharedJoint.body.position.sub(b2.position);
                    
                    if (dp.lsq() < dp2.lsq()) {
                        body = b1;
                        cmpCable.sj1 = newSharedJoint;
                    } else {
                        body = b2;
                        cmpCable.sj2 = newSharedJoint;
                    }
                }
                //var beambase = newB.getCmpsHavingAncestor(CmpBeamBase);
                //for (bb in beambase) {
                    //if (bb.sj1 == null) {
                        //bb.sj1 = newSharedJoint;
                    //} else if (bb.sj2 == null) {
                        //bb.sj2 = newSharedJoint;
                    //} else {
                        //trace('whoa 3 sj on beambase');
                    //}
                //}
                newSharedJoint.addBody(body);
                oldToNew.set(e, newEnt);
            }
            newSharedJoint.isRolling = sharedJoint.isRolling;
            snapshot.push(newEnt);
        }
        
        stack.push( { ents: snapshot, lines : linechecker.copy() } );
        if (stack.length >= maxStackDepth) {
            Util.popLast(stack);
        }
    }
    
    public function pop() : BuildState
    {
        return stack.pop();
    }
    
    public function peek() : BuildState
    {
        return stack.first();
    }
    
    public function get_length() : Int
    {
        return stack.length;
    }
}