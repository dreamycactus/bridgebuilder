package com.org.bbb;
import com.org.bbb.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.ShapeList;
import nape.space.Space;

/**
 * ...
 * @author 
 */

using com.org.bbb.Util;
 
class CmpCable extends CmpBeamBase
{
    public var compound : Compound;
    public var tightness : Float = 1.0;
    public var firstBuild = true;
    
    public var first : Body;
    public var last : Body;
    public var prevFilter : InteractionFilter;
    
    var prevLen : Float = Math.POSITIVE_INFINITY;
    var lastTension : Float =-1;
    
    public function new(pos1 : Vec2, pos2 : Vec2, cableMat : BuildMat) 
    {
        super(pos1, pos2);
        this.material = cableMat;
        tightness = 1.0;
        
        compound = new Compound();
        first = new Body(null, pos1);
        first.shapes.add(new Polygon(Polygon.box(30, material.height, true), material.material
                                        , new InteractionFilter(GameConfig.cgCable, GameConfig.cmCable)));
        first.compound = compound;
        last = new Body(null, pos2);
        last.shapes.add(new Polygon(Polygon.box(30, material.height, true), material.material
                                        , new InteractionFilter(GameConfig.cgCable, GameConfig.cmCable)));
        last.compound = compound;
        prevFilter = new InteractionFilter(GameConfig.cgCable, GameConfig.cmCable);
        
    }
    
    override public function update() : Void
    {
        if (broken) return;
        if (compound.bodies.length < 1) { return; }
        var mid = Std.int(compound.bodies.length / 2);
        var midbody = compound.bodies.at(mid);
        var stress : Vec3 = midbody.calculateBeamStress();
        var stressWorldSpace = midbody.localVectorToWorld(stress.xy(true));
        if (stress.x > material.tensionBreak) {
            var rand = Std.random(compound.constraints.length);
            compound.constraints.at(rand).compound = null;
            broken = true;
        }
        var multiplier = (p2.sub(p1).length  / GameConfig.gridCellWidth) / material.maxLength  + 1;
        if (stress.x > 5 && stress.x < 20*multiplier && tightness > 0.4) {
            //tightness -= 0.1;
            rebuild();
        }
        // Last tension is the Y component of tension in world space for... keeping the road level
        lastTension = stressWorldSpace.y;
        sendMsg(Msgs.CABLEUPDATE, this, null);
    }
    
    public function rebuild()
    {
        if (sj1 == null || sj2 == null) { return; }
        if (sj1.body.position.sub(p1, true).lsq() > sj2.body.position.sub(p1, true).lsq()) {
            var tmp = sj1;
            sj1 = sj2;
            sj2 = tmp;
        }
        var p1 = sj1.body.position;
        var p2 = sj2.body.position;
        
        var dir = p2.sub(p1);
        if (firstBuild) {
            prevLen = dir.length;
        }
        var len = dir.length;
        if (lastTension < 160) {
            len = Math.min(dir.length, prevLen*0.99);
        }
        dir = dir.normalise();
        var prev : Body = null;
        
        var segWidth = GameConfig.cableSegWidth;
        if (len < 200) {
            segWidth /= 2.0;
        }
        var segCount = Math.round(len / segWidth);
        if (!firstBuild) {
            segCount = compound.bodies.length;
            segWidth = len / segCount;
        }

        var offset = segWidth * 0.5;
        var startPos = p1.add(dir.mul(segWidth * 0.5) );
        
        var l = p1.sub(p2).length;
        
        for (i in 0...segCount) {
            var body : Body = null;
            if (firstBuild) {
                body = new Body();
            } else {
                body = compound.bodies.at(i);
            }
            if (i == 0) {
                body = first;
            } else if (i == segCount - 1) {
                body = last;
            }
            body.shapes.clear();
            var shape : Shape = new Polygon(Polygon.box(segWidth*tightness, material.height, true) );
            shape.filter = prevFilter;
            body.shapes.add(shape);
            if (firstBuild) {
                body.position = startPos.add(dir.mul(i * segWidth)); 
                body.rotation = dir.angle;
                body.compound = compound;
                body.userData.entity = entity;
                if (prev != null) {
                    var pj = GameConfig.pivotJoint(JointType.CABLELINK);
                    pj.maxForce = 1e9;
                    pj.body1 = prev;
                    pj.body2 = body;
                    pj.anchor1 = Vec2.weak(offset, 0);
                    pj.anchor2 = Vec2.weak(-offset, 0);
                    pj.compound = compound;
                }
                prev = body;
            }
        }
        if (!firstBuild) {
            compound.visitConstraints(function (c) {
                var pj = cast(c, PivotJoint);
                pj.anchor1.x = offset * Util.sign(pj.anchor1.x);
                pj.anchor2.x = offset * Util.sign(pj.anchor2.x);
            });
        }
        prevLen = len;
        if (firstBuild) {
            sendMsg(Msgs.CABLECREATE, this, null);
        }
        firstBuild = false;
    }
    
    public function getBody(i : Int) : Body
    {
        if (i > compound.bodies.length - 1 || i < 0) {
            return null;
        }
        var j = 0;
        for (k in compound.bodies) {
            if (j++ == i) {
                return k;
            }
        }
        return null;
    }
    
    override public function changeFilter(f : InteractionFilter) : Void
    {
        prevFilter = f;
        compound.visitBodies(function (b) { b.setShapeFilters(f); } );
    }
    
    override function set_space(space : Space) : Space
    {
        this.space = space;
        if (compound != null) {
            compound.space = space;
        }
        return space;
    }
    
    override function get_space() : Space
    {
        return this.space;
    }
    
    override function set_entity(e : Entity) : Entity
    {
        this.entity = e;
        if (compound != null) {
            for (b in compound.bodies) {
                b.userData.entity = e;
            }
        }
        return e;
    }
    
    override function set_sj1(sj : CmpSharedJoint) : CmpSharedJoint
    {
        if (sj2 != sj) {
            sj1 = sj;
            rebuild();
        }
        return sj;
    }
    
    override function set_sj2(sj : CmpSharedJoint) : CmpSharedJoint
    {
        if (sj1 != sj) {
            sj2 = sj;
            rebuild();
        }
        return sj;
    }
    override function get_isRoad() : Bool
    {
        return compound.bodies.at(0).shapes.at(0).filter.collisionMask & GameConfig.cgLoad != 0;
    }
}