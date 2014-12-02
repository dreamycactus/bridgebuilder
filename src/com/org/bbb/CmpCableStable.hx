package com.org.bbb;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;

/**
 * ... TO DO :DELETE FILE
 * @author 
 */
class CmpCableStable extends CmpPhys
{
    public var dj : DistanceJoint;
    var cableMat : BuildMat;
    
    public function new(body1 : Body, body2 : Body, pos1 : Vec2, pos2 : Vec2, cableMat : BuildMat) 
    {
        super();
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
        dj = new DistanceJoint(body1, body2, body1.worldPointToLocal(pos1), body2.worldPointToLocal(pos2), 0, len + 5);
        //for (i in 0...segCount) {
            //var body = new Body();
            //var shape : Shape = new Polygon(Polygon.box(segWidth, cableMat.height, true) );
            //shape.filter.collisionGroup = GameConfig.cgCable;
            //shape.filter.collisionMask = GameConfig.cmCable;
            //body.shapes.add(shape);
            //body.position = startPos.add(dir.mul(i * segWidth)); 
            //body.rotation = dir.angle;
            //body.compound = compound;
            //
            //if (prev != null) {
                //var pj = GameConfig.pivotJoint(JointType.MULTISTIFF);
                //pj.maxForce = cableMat.tensionBreak;
                //pj.breakUnderForce = true;
                //pj.body1 = prev;
                //pj.body2 = body;
                //pj.anchor1 = Vec2.weak(offset, 0);
                //pj.anchor2 = Vec2.weak( -offset, 0);
                //pj.compound = compound;
            //}
            //prev = body;
        //}
        //
        //var pj = GameConfig.pivotJoint(JointType.MULTISTIFF);
        //pj.body1 = compound.bodies.at(compound.bodies.length-1);
        //pj.body2 = body1;
        //pj.anchor1 = Vec2.weak(-offset, 0);
        //pj.anchor2 = body1.worldPointToLocal(pos1);
        //pj.compound = compound;
        //
        //pj = GameConfig.pivotJoint(JointType.MULTISTIFF);
        //pj.body1 = prev;
        //pj.body2 = body2;
        //pj.anchor1 = Vec2.weak(offset, 0);
//
        //pj.anchor2 = body2.worldPointToLocal(pos2);
        //pj.compound = compound;
        
    }
    
    override public function update() : Void
    {
        trace(dj.isSlack());
    }
    override function set_space(space : Space) : Space
    {
        dj.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return dj.space;
    }
}