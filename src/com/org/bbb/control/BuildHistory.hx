package com.org.bbb.control ;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpBeam;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.mes.Entity;
import com.org.mes.MESState;
import haxe.ds.GenericStack;
import haxe.ds.ObjectMap;
import nape.geom.Vec2;
import nape.phys.Body;
using Lambda;
using com.org.bbb.Util;
using com.org.utils.ArrayHelper;
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
        // special case for cables since they need reference to sharedJoint
        // AND they must have both sharedJoints set before they are added to a CmpSharedJoint...
        var cables : Array<CmpCable> = new Array(); 
        
        for (e in builtEnts) {
            var newEnt : Entity = null;
            if (e.hasCmp(CmpBeam)) {
                var cmpBeam = e.getCmp(CmpBeam);
                var newBody = cmpBeam.body.copy();
                newEnt = EntFactory.inst.createBeamEnt(cmpBeam.p1, cmpBeam.p2, cmpBeam.material);
                newBody.userData.entity = newEnt;
            } else if (e.hasCmp(CmpCable)) {
                var cmpCable = e.getCmp(CmpCable);
                newEnt = EntFactory.inst.createCable(cmpCable.p1, cmpCable.p2, cmpCable.material);
            } else if (e.hasCmp(CmpAnchor)) {
                var cmpAnchor = e.getCmp(CmpAnchor);
                var bounds = cmpAnchor.body.bounds;
                newEnt = EntFactory.inst.createAnchor(cmpAnchor.body.position, Vec2.get(bounds.width, bounds.height), cmpAnchor.fluid, cmpAnchor.startEnd, cmpAnchor.tapered);
            }
            if (newEnt != null) {
                oldToNew.set(e, newEnt);
                snapshot.push(newEnt);
            } 
            
        }
        
        for (e in builtEnts.ffilter(function(s) { return s.hasCmp(CmpSharedJoint); } )) {
            var sharedJoint = e.getCmp(CmpSharedJoint);
            var newEnt = EntFactory.inst.createSharedJoint(sharedJoint.body.position);
            var newSharedJoint = newEnt.getCmp(CmpSharedJoint);
            
            for (b in sharedJoint.bodies) {
                var ent : Entity = b.userData.entity;
                if (ent == null) {
                    trace('problem $ent.id');
                }
                var newB = oldToNew.get(ent);
                
                if (newB == null && ent.hasCmp(CmpAnchor)) { // for cmpAnchor?
                    newB = ent;
                }
                var body : Body = null;
                if (newB.hasCmp(CmpBeam)) {
                    var beam = newB.getCmp(CmpBeam);
                    body = beam.body;
                } else if (newB.hasCmp(CmpAnchor)) {
                    var anc = newB.getCmp(CmpAnchor);
                    body = anc.body;
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
                    cables.push(cmpCable);
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
                // This special case is pretty ugly as cables must know both their sharedJoints befor
                // they are actually added to a sharedJoint (which uses the current position of the cable link)
                if (!newB.hasCmp(CmpCable)) {
                    newSharedJoint.addBody(body);
                }
                oldToNew.set(e, newEnt);

            }
            newSharedJoint.isRolling = sharedJoint.isRolling;
            snapshot.push(newEnt);
        }
        for (cab in cables) {
            if (cab.sj1 != null) {
                cab.sj1.addBody(cab.first);
            }
            if (cab.sj1 != null) {
                cab.sj2.addBody(cab.last);
            }
        }
        
        stack.push( { ents: snapshot, lines : linechecker.copy() } );
        if (stack.length >= maxStackDepth) {
            stack.popLast();
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