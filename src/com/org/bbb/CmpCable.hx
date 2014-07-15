package com.org.bbb;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.JointType;
import com.org.mes.Cmp;
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
class CmpCable extends CmpPhys
{
    public var compound : Compound;
    var cableMat : BuildMat;
    
    public function new(body1 : Body, body2 : Body, pos1 : Vec2, pos2 : Vec2, cableMat : BuildMat) 
    {
        super();
        this.cableMat = cableMat;
        
        var dir = pos2.sub(pos1);
        var len = dir.length;
        dir = dir.normalise();
        var segCount = Math.round(len / Config.cableSegWidth);
        var prev : Body = null;
        var segWidth = Config.cableSegWidth;
        var offset = segWidth * 0.5;
        var startPos = pos1.add(dir.mul(segWidth * 0.5) );
        
        var l = pos1.sub(pos2).length;
        compound = new Compound();
        for (i in 0...segCount) {
            var body = new Body();
            var shape : Shape = new Polygon(Polygon.box(segWidth, cableMat.height, true) );
            shape.filter.collisionGroup = Config.cgCable;
            shape.filter.collisionMask = Config.cmCable;
            body.shapes.add(shape);
            body.position = startPos.add(dir.mul(i * segWidth)); 
            body.rotation = dir.angle;
            body.compound = compound;
            
            if (prev != null) {
                var pj = Config.pivotJoint(JointType.MULTISTIFF);
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
        
        var pj = Config.pivotJoint(JointType.MULTISTIFF);
        pj.body1 = compound.bodies.at(compound.bodies.length-1);
        pj.body2 = body1;
        pj.anchor1 = Vec2.weak(-offset, 0);
        pj.anchor2 = body1.worldPointToLocal(pos1);
        pj.compound = compound;
        
        pj = Config.pivotJoint(JointType.MULTISTIFF);
        pj.body1 = prev;
        pj.body2 = body2;
        pj.anchor1 = Vec2.weak(offset, 0);

        pj.anchor2 = body2.worldPointToLocal(pos2);
        pj.compound = compound;
        
    }
    
    override public function update() : Void
    {
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
}