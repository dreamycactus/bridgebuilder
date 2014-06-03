package com.org.bbb;
import com.org.bbb.Config.BeamMat;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import flash.display.Shape;
import nape.callbacks.BodyListener;
import nape.constraint.ConstraintIterator;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.Compound;
import nape.shape.Polygon;

class CmpBeam implements Cmp
{
    public var body : Body;
    public var material : BeamMat;
    public var entity : Entity;
    public var jointOffsets : Array<Vec2>;
    
    public function new(body : Body, material : BeamMat=null) 
    {
        this.body = body;
        this.jointOffsets = new Array();
        this.material = material;
    }
    
    public function getWorldOffset(index : Int) : Vec2
    {
        if (jointOffsets != null && body != null && index > -1 && index < jointOffsets.length) {
            return body.localPointToWorld(jointOffsets[index]);
        }
        return Vec2.get();
    }
    
    public function update()
    {
        var t : CmpTransform = entity.getCmp(CmpTransform);
        t.pos = body.position;
        
        if (body == null) {
            return;
        }
        var breaking = false;
        body.constraints.foreach(function(cons) {
            var imp = cons.bodyImpulse(body);
            
            if (Math.abs(imp.z) > 400000) {
                trace("constraint");
                breaking = true;
            }
        });
        
        if (breaking) {
            entity.top.insertEnt(EntFactory.inst.createMultiBeamEnt(Vec2.get(), splitBeam(body) ) );
            body.space = null;
        }
    }
    
    public static function splitBeam(beamBody : Body, splitDepth : Int=3) : Compound
    {
        if (beamBody.shapes.length > 1) {
            trace("not sure how to split beam with 1+ shapes");
        }
        var c = new Compound();
        var bodyRot = beamBody.rotation;
        var space = beamBody.space;
        var prevRot = beamBody.rotation;
        beamBody.space = null;
        beamBody.rotation = 0;
        var rect = beamBody.shapes.at(0).bounds.copy();
        var bodySeg : Body;
        var prev : Body = null;
        var prevWidth : Float = 0;
        var splitCount : Int = 2*splitDepth ;
        var curx : Float = 0;
        beamBody.rotation = prevRot;
        beamBody.space = space;

        
        /* Use binary algorithm to split one beam into many small beams, linking them all together with joints */
        for (i in 0...splitCount) {
            var num = Util.clampI(i, 1, splitCount - 2);
            var segWidth = rect.width / (Math.pow( 2, Math.abs(splitDepth - 0.5 - num) + 1.5 ));
            var bodySegShape = new Polygon(Polygon.box(segWidth, rect.height) );
            
            bodySeg = new Body();
            bodySegShape.filter.collisionGroup = beamBody.shapes.at(0).filter.collisionGroup | Config.cgBeamSplit;
            bodySegShape.filter.collisionMask = beamBody.shapes.at(0).filter.collisionMask;
            bodySeg.shapes.add(bodySegShape);
            
            bodySeg.position.setxy(curx + Std.int(segWidth / 2), 0);
            bodySeg.compound = c;
            
            curx += segWidth;
            
            if ( prev != null ) { 
                var j = new WeldJoint(bodySeg, prev, Vec2.weak(-segWidth * 0.5, 0), Vec2.weak(prevWidth * 0.5, 0) );
                
                j.breakUnderForce = true;
                j.maxForce = 5e8;
                j.compound = c;
                //var ejoint = entfactory.createJointEnt(Vec2.get(), [ j ] );
                //top.insertEnt(ejoint);
            }
            prevWidth = segWidth;
            prev = bodySeg;
        }
        c.rotate(Vec2.get(rect.width/2.0, 0), bodyRot);
        c.translate(beamBody.position.sub( Vec2.get(rect.width / 2.0, -rect.height / 2.0) ) );

        /* If there are any existing joints attached to a beam, move them to new multi-beam */
        if (beamBody.space != null) {
            var space = beamBody.space;
            c.space = space; // Temporarily add compound to space- a hack to do collision detection
            trace(beamBody.constraints.length + "boo");
            
            while (beamBody.constraints.length != 0) {
                var cons = beamBody.constraints.at(0);
                var pj = cast(cons, PivotJoint);
                var firstAnchor = true;
                var otheranchor : Vec2 = pj.anchor1;
                
                if (pj.body1 != beamBody) {
                    firstAnchor = false;
                    otheranchor = pj.anchor2;
                }
                
                var anchorWorld = beamBody.localPointToWorld(otheranchor);
                trace(otheranchor);
                var startSize = 5;
                var colbodies : BodyList = null;
                var i = startSize;
                var growth = 5;
                var maxiter = 20 + startSize;
                var newAnchorBody : Body = null;

                while (newAnchorBody == null) {
                    if (i++ >= maxiter) {
                        trace("Could not find achor body");
                        return null;
                    }
                    colbodies = space.bodiesInAABB( new AABB(anchorWorld.x - i*growth, anchorWorld.y - i*growth, 2*i*growth, 2*i*growth)
                                       , false, false);
                                       trace(colbodies.length);
                                       
                    for (i in 0...colbodies.length) {
                        var b = colbodies.at(i);
                        if (b.compound == c) {
                            newAnchorBody = b;
                             if (firstAnchor) {
                                pj.body1 = newAnchorBody;
                                pj.anchor1 = newAnchorBody.worldPointToLocal(anchorWorld);
                            } else {
                                pj.body2 = newAnchorBody;
                                pj.anchor2 = newAnchorBody.worldPointToLocal(anchorWorld);
                            }
                            break;
                        }
                    }
                }
            }
            //c.space = null;
            return c;
        }
        return null;
    }
}