package com.org.bbb;
import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.Top;
import nape.geom.Vec3;
import nape.phys.MassMode;
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

class CmpBeam extends CmpBeamBase
{
    public var body : Body;
    public var width : Float;
    public var jointOffsets : Array<Vec2>;
    public var stressCHp : Float = GameConfig.beamStressHp;
    public var stressTHp : Float = GameConfig.beamStressHp;
    public var stressSHp : Float = GameConfig.beamStressHp;
    
    public function new(p1 : Vec2, p2 : Vec2, body : Body, width : Float, material : BuildMat) 
    {
        super(p1, p2);
        this.body = body;
        this.width = width;
        this.jointOffsets = new Array();
        this.material = material;
        
        stressCHp *= Util.randomf(2, 5);
        stressTHp *= Util.randomf(2, 5);
        stressSHp *= Util.randomf(2, 5);
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
        var dt = Top.dt;
        
        var w = width;
        var h = material.height;
        
        if (body == null) {
            return;
        }
        
        var stress = body.calculateBeamStress().xy();
        var splitType = SplitType.TENSION;
        var isBreaking = false;

        if (stress.x > material.tensionBreak) { // Tension
            stressTHp -= dt * (stress.x / material.tensionBreak);
            if (stressTHp < 0) {
                isBreaking = true;
                splitType = SplitType.TENSION;
                trace('tension');
            }
        } else if (stressTHp < material.tensionBreak) {
            //stressTHp += dt;
        }
        
        if (stress.x < -material.compressionBreak) {
            stressCHp -= dt * -(stress.x/material.compressionBreak);
            if (stressCHp < 0) {
                isBreaking = true;
                splitType = SplitType.COMPRESSION;
                trace('compr');
            }
        } else if (stressTHp < material.compressionBreak) {
            //stressCHp += dt;
        }
        
        var moment = Math.abs(stress.y) * this.length * 0.5;
        // Shear only happens on vertical beams
        if (moment > material.momentBreak) {
            stressSHp -= dt * Math.max(moment/material.compressionBreak, 3);
            if (stressSHp < 0) {
                isBreaking = true;
                splitType = SplitType.SHEAR;
                trace('shear $moment');
                
            }
        } else if (stressSHp < GameConfig.beamStressHp) {
            //stressSHp += dt;
        }
        
        stress.dispose();

        if (isBreaking) {
            var cmpMulti = EntFactory.inst.createMultiBeamEnt(Vec2.get(), entity, splitType);
            if (cmpMulti != null) {
                entity.state.insertEnt(cmpMulti);
            }
            sendMsg(Msgs.BEAMBREAK, this, { } );
            this.broken = true;
            entity.delete();
        }
    }
    
    override public function changeFilter(f : InteractionFilter) : Void
    {
        body.setShapeFilters(f);
    }
    
    override public function getFilter() :InteractionFilter
    {
        return body.shapes.at(0).filter;
    }
    
    override function set_space(space : Space) : Space
    {
        this.space = space;
        body.space = space;
        return space;
    }
    
    override function get_body() : Body
    {
        return body;
    }
    
    override function get_space() : Space
    {
        return space;
    }
    
    override function get_isRoad() : Bool
    {
        return body.shapes.at(0).filter.collisionMask & GameConfig.cgLoad != 0;
    }
}