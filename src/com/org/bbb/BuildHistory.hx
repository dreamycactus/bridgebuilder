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
class BuildHistory
{
    var stack : GenericStack<Array<Entity>> = new GenericStack<Array<Entity>>();
    var state : MESState;
    
    public function new(state : MESState) 
    {
        this.state = state;
    }
    
    public function snapAndPush(builtEnts : Array<Entity>)
    {
        var snapshot : Array<Entity> = new Array();
        var oldToNew : ObjectMap<Entity, Entity> = new ObjectMap();
        
        for (e in builtEnts) {
            if (e.hasCmp(CmpBeam)) {
                var cmpBeam = e.getCmp(CmpBeam);
                
                var newEnt = state.createEnt();
                var newBody = cmpBeam.body.copy();
                newBody.userData.entity = newEnt;
                var newCmpBeam = new CmpBeam(newBody, cmpBeam.material);
                newEnt.attachCmp(newCmpBeam);
                
                oldToNew.set(e, newEnt);
                snapshot.push(newEnt);
            } else if (true) {
                
            }
        }
        
        for (e in builtEnts.filter(function(s) { return s.hasCmp(CmpSharedJoint); } )) {
            var newEnt = state.createEnt();
            var sharedJoint = e.getCmp(CmpSharedJoint);
            var newSharedJoint = new CmpSharedJoint(sharedJoint.body.position);
            newEnt.attachCmp(newSharedJoint);
            for (b in sharedJoint.bodies) {
                var ent = b.userData.entity;
                var newB = oldToNew.get(ent);
                if (newB == null) {
                    newB = ent;
                }
                var body : Body = null;
                if (newB.hasCmp(CmpBeam)) {
                    body = newB.getCmp(CmpBeam).body;
                } else if (newB.hasCmp(CmpAnchor)) {
                    body = newB.getCmp(CmpAnchor).body;
                }
                newSharedJoint.addBody(body);
            }
            snapshot.push(newEnt);
        }
        
        stack.add(snapshot);
    }
    
    public function pop() : Array<Entity>
    {
        return stack.pop();
    }
}