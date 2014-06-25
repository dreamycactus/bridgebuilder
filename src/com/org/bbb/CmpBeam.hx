package com.org.bbb;
import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.Config.BeamMat;
import com.org.bbb.Config.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.geom.Vec3;
import nape.space.Space;
import openfl.display.Shape;
import nape.callbacks.BodyListener;
import nape.constraint.ConstraintIterator;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.Compound;
import nape.shape.Polygon;

using com.org.bbb.Util;

class CmpBeam extends CmpPhys
{
    public var body : Body;
    public var material : BeamMat;
    public var jointOffsets : Array<Vec2>;
    public var stressCHp : Float = 300;
    public var stressTHp : Float = 300;
    
    public function new(body : Body, material : BeamMat=null) 
    {
        super();
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
    
    override public function update()
    {
        var dt = entity.top.dt;
        var t : CmpTransform = entity.getCmp(CmpTransform);
        t.pos = body.position;
        
        if (body == null) {
            return;
        }
        
        var stress = body.worldVectorToLocal(body.calculateBeamStress().xy(true));

        if (Math.abs(stress.x) > 3000 ) {
            stressTHp -= dt;
        }
        
        var splitType = SplitType.TENSION;
        var isBreaking = false;
        
        if (stressTHp > 0 && stressTHp < 300) {
            stressTHp += dt * 3;
            splitType = SplitType.TENSION;
            isBreaking = true;
        } else if (stressCHp > 0 && stressCHp < 300) {
            stressCHp += dt * 3;
            splitType = SplitType.SHEAR;
            isBreaking = true;
        }
        
        if (isBreaking) {
            entity.top.insertEnt(EntFactory.inst.createMultiBeamEnt(Vec2.get(), CmpMultiBeam.createFromBeam(body, splitType, null) ) );
            entity.top.deleteEnt(entity);
        }
        
    }
    
    override function set_space(space : Space) : Space
    {
        body.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return body.space;
    }
}