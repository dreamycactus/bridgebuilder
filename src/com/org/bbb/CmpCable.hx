package com.org.bbb;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpCable extends CmpBeamBase
{
    public var compound : Compound;
    var cableMat : BuildMat;
    
    public function new(pos1 : Vec2, pos2 : Vec2, cableMat : BuildMat) 
    {
        super(pos1, pos2);
        this.cableMat = cableMat;
        
        var dir = pos2.sub(pos1);
        var len = dir.length;
        dir = dir.normalise();
        var segCount = Math.round(len / GameConfig.cableSegWidth);
        var prev : Body = null;
        var segWidth = GameConfig.cableSegWidth;
        var offset = segWidth * 0.5;
        var startPos = pos1.add(dir.mul(segWidth * 0.5) );
        
        var l = pos1.sub(pos2).length;
        compound = new Compound();
        for (i in 0...segCount) {
            var body = new Body();
            var shape : Shape = new Polygon(Polygon.box(segWidth, cableMat.height, true) );
            shape.filter.collisionGroup = GameConfig.cgCable;
            shape.filter.collisionMask = GameConfig.cmCable;
            body.shapes.add(shape);
            body.position = startPos.add(dir.mul(i * segWidth)); 
            body.rotation = dir.angle;
            body.compound = compound;
            
            if (prev != null) {
                var pj = GameConfig.pivotJoint(JointType.MULTISTIFF);
                pj.maxForce = cableMat.tensionBreak;
                pj.breakUnderForce = true;
                pj.body1 = prev;
                pj.body2 = body;
                pj.anchor1 = Vec2.weak(offset, 0);
                pj.anchor2 = Vec2.weak( -offset, 0);
                pj.compound = compound;
            }
            prev = body;
        }
        
    }
    
    override public function update() : Void
    {
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
    override function set_space(space : Space) : Space
    {
        compound.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return compound.space;
    }
    
    override function set_entity(e : Entity) : Entity
    {
        for (b in compound.bodies) {
            b.userData.entity = e;
        }
        return e;
    }
}