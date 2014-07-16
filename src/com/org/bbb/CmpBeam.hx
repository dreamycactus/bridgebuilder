package com.org.bbb;
import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.Config.BuildMat;
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
    public var material : BuildMat;
    public var jointOffsets : Array<Vec2>;
    public var stressCHp : Float = Config.stressHp;
    public var stressTHp : Float = Config.stressHp;
    public var stressSHp : Float = Config.stressHp;
    
    public function new(body : Body, material : BuildMat=null) 
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
        var splitType = SplitType.TENSION;
        var isBreaking = false;

        if (stress.x > 1000) { // Tension
            stressTHp -= dt;
            if (stressTHp < 0) {
                isBreaking = true;
                splitType = SplitType.TENSION;
            }
        } else if (stressTHp < Config.stressHp) {
            stressTHp += dt;
        }
        
        if (stress.x < -1000) {
            stressCHp -= dt;
            if (stressCHp < 0) {
                isBreaking = true;
                splitType = SplitType.COMPRESSION;
            }
        } else if (stressTHp < Config.stressHp) {
            stressCHp += dt;
        }
        
        if (Math.abs(stress.y) > 1000) {
            stressSHp -= dt;
            if (stressCHp < 0) {
                isBreaking = true;
                splitType = SplitType.SHEAR;
            }
        } else if (stressSHp < Config.stressHp) {
            stressSHp += dt;
        }
        
        if (isBreaking) {
            entity.top.insertEnt(EntFactory.inst.createMultiBeamEnt(Vec2.get(), CmpMultiBeam.createFromBeam(body, splitType, null) ) );
            entity.top.deleteEnt(entity);
            trace(splitType);
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