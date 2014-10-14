package com.org.bbb;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.bbb.GameConfig.MatType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.callbacks.InteractionCallback;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.GeomPoly;
import nape.geom.Mat23;
import nape.geom.Ray;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author 
 */
enum SplitType
{
    MOMENT;
    SHEAR;
    TENSION;
    COMPRESSION;
}
 
class CmpMultiBeam extends CmpBeamBase
{
    public var compound : Compound;
    
    public static function createFromBeam(cmpBeam : CmpBeam, splitType : SplitType, brokenCons : PivotJoint) : CmpMultiBeam
    {
        var beamBody = cmpBeam.body;
        if (beamBody.shapes.length > 1) {
            trace("not sure how to split beam with 1+ shapes");
        }
        var c = new Compound();
        var space = beamBody.space;
        var bodySeg : Body;
        var rectheight = cmpBeam.material.height*1.1;
        var comtop = beamBody.localPointToWorld(Vec2.weak(0, -rectheight) );
        var combot = beamBody.localPointToWorld(Vec2.weak(0, rectheight) );
        if (combot.y < comtop.y) {
            var tmp = combot;
            combot = comtop;
            comtop = tmp;
        }
        var width = cmpBeam.width;
        switch (splitType) {
        case TENSION:
            var off = beamBody.worldVectorToLocal(Vec2.weak(Util.randomf( -width * 0.1, width * 0.1), 0));
            comtop.addeq(off);
            combot.addeq(off);

        case COMPRESSION:
            var off1 = beamBody.worldVectorToLocal(Vec2.weak(Util.randomf( -width * 0.4, width * 0.4), 0));
            var off2 = beamBody.worldVectorToLocal(Vec2.weak(Util.randomf( -width * 0.4, width * 0.4), 0));
            comtop.addeq(off1);
            combot.addeq(off2);

        //case SHEAR:
            ////var breakingPoint = brokenCons.body1.localPointToWorld(brokenCons.anchor1);
            //comtop = beamBody.localPointToWorld( Vec2.weak(0, -rectheight * 0.7) );
            //combot = beamBody.localPointToWorld( Vec2.weak(0, rectheight * 0.7) );
        default:
        }
            var s = new Sprite();
            s.graphics.beginFill(0xFF00FF);
            s.graphics.drawCircle(comtop.x, comtop.y, 5);
            s.graphics.drawCircle(combot.x, combot.y, 5);
            s.graphics.endFill();
            Lib.current.stage.addChild(s);
        var ray : Ray = Ray.fromSegment(comtop, combot);
        var rayresult = space.rayMultiCast(ray, false, new InteractionFilter(GameConfig.cgSensor) );
        if (rayresult.length != 0) {
            var polyToCut : Polygon = null;
            for (r in rayresult) {
               if (r.shape == beamBody.shapes.at(0)) {
                   polyToCut = r.shape.castPolygon;
               }
            }
            if (polyToCut == null) {
                throw "Errorzz couldn't break beam";
            }
            var geomPoly = new GeomPoly(polyToCut.worldVerts);
            var segmentPolys = geomPoly.cut(comtop, combot, false, false);
            var prev : Body = null;
            for (s in segmentPolys) {
                var centroid : Vec2 = Vec2.get();
                for (point in s.forwardIterator()) {
                    centroid.addeq(point);
                }
                centroid.muleq(1 / s.size());
                s.transform(Mat23.translation(-centroid.x, -centroid.y));
                s.transform(Mat23.rotation( -beamBody.rotation));
                var width = s.right().x - s.left().x;
                var body : Body = new Body();
                body.shapes.push(new Polygon(s, Material.steel()));
                body.shapes.at(0).filter.collisionGroup = beamBody.shapes.at(0).filter.collisionGroup;
                body.shapes.at(0).filter.collisionMask = beamBody.shapes.at(0).filter.collisionMask;
                body.position = centroid;
                body.rotation = beamBody.rotation;
                body.compound = c;
                
                body.userData.width = width;
                body.userData.height = beamBody.userData.height;
                body.userData.matType = beamBody.userData.matType;
                
                if (prev != null) {
                    var body1 = prev;
                    var body2 = body;
                    
                    switch(splitType) {
                    case TENSION:
                        var joint : PivotJoint = GameConfig.pivotJoint(JointType.MULTISTIFF);
                        joint.body1 = body1;
                        joint.body2 = body2;
                        joint.anchor1 = body1.worldPointToLocal(comtop);
                        joint.anchor2 = body2.worldPointToLocal(comtop);
                        joint.compound = c;
                        
                        var joint2 : PivotJoint = GameConfig.pivotJoint(JointType.MULTIELASTIC);
                        joint2.body1 = body1;
                        joint2.body2 = body2;
                        joint2.anchor1 = body1.worldPointToLocal(combot);
                        joint2.anchor2 = body2.worldPointToLocal(combot);
                        joint2.compound = c;
                    case COMPRESSION:
                        var center = combot.add(comtop).mul(0.5);
                        var joint2 : PivotJoint = GameConfig.pivotJoint(JointType.MULTIELASTIC);
                        joint2.body1 = body1;
                        joint2.body2 = body2;
                        joint2.anchor1 = body1.worldPointToLocal(center);
                        joint2.anchor2 = body2.worldPointToLocal(center);
                        joint2.compound = c;
                    default:
                    }
                    
                    
                    
                }
                prev = body;
            }
        } else {
            trace(comtop + "," + combot);
            throw "No ray intersection detected when trying to break beam " + beamBody.id + ", " + beamBody.rotation + ", " + beamBody.localPointToWorld(Vec2.get(100, 0));
        }  
        /* If there are any existing joints attached to a beam, move them to new multi-beam */
        if (beamBody.space != null) {
            var iter = 0;
            var space = beamBody.space;
            c.space = space; // Temporarily add compound to space- a hack to do collision detection
            
            while (beamBody.constraints.length != 0) {
                var cons = beamBody.constraints.at(0);
                var pj = cast(cons, PivotJoint);
                var firstAnchor = false;
                var otheranchor : Vec2 = pj.anchor2;
                
                if (pj.body1 == beamBody) {
                    firstAnchor = true;
                    otheranchor = pj.anchor1;
                } else if (pj.body2 != beamBody) {
                    throw("WHAO");
                }
                var anchorWorld = beamBody.localPointToWorld(otheranchor);
                var newAnchorBody : Body = null;
                
                var minDT = Math.POSITIVE_INFINITY;
                var index = -1;
                for (i in 0...c.bodies.length) {
                    var dt = c.bodies.at(i).position.sub(anchorWorld, true).lsq();
                    if (dt < minDT) {
                        minDT = dt;
                        index = i;
                    }
                }
                
                var cmpSharedJoint : CmpSharedJoint = null;
                if (pj.body1.userData.sharedJoint != null) {
                    cmpSharedJoint = pj.body1.userData.sharedJoint;
                    firstAnchor = false;
                } else if (pj.body2.userData.sharedJoint != null) {
                    cmpSharedJoint = pj.body2.userData.sharedJoint;
                    firstAnchor = true;
                }

                if (firstAnchor) {
                    cmpSharedJoint.removeBody(pj.body1);
                } else {
                    cmpSharedJoint.removeBody(pj.body2);
                }
                if (index != -1) {
                    newAnchorBody = c.bodies.at(index);
                    cmpSharedJoint.addBody(newAnchorBody);
                }
                
                if (newAnchorBody == null) {
                    trace("Error finding constraint for multibeam" + anchorWorld);
                    
                    for (b in c.space.bodies) {
                        trace(b.id);
                    }
                    EntFactory.inst.state.getSystem(SysPhysics).paused = true;
                    break;
                }
            }
            
            var ent : Entity = cmpBeam.entity;
            var beams : Array<CmpBeamBase> = ent.getCmpsHavingAncestor(CmpBeamBase);
            
            if (beams[0] != null) {
                for (sj in beams[0].sharedJoints) {
                    sj.removeBody(beamBody);
                }
            }
            
            c.space = null;
            return new CmpMultiBeam(cmpBeam.p1, cmpBeam.p2, c);
        }
        return null;
    }
    
    public function new(p1 : Vec2, p2 : Vec2, compound : Compound, material : BuildMat=null) 
    {
        super(p1, p2);
        this.compound = compound;
        this.material = material;
        this.constraints = new List();
        
        compound.constraints.foreach(function(c) {
           constraints.add(c); 
        });
    }
    
    override public function update()
    {   
        if (compound == null) {
            return;
        }
        var dt = entity.state.top.dt;

        for (c in constraints) {
            var f = c.frequency - GameConfig.multiBeamFrequencyDecay * dt;
            f = Util.clampf(f, 0.4, 1000);
            c.frequency = f;
            
            if (c.maxForce > GameConfig.multiBeamJointDecay * dt) {
                c.maxForce -= GameConfig.multiBeamJointDecay * dt;
            } else {
                c.maxForce = 40;
            }

        }
    }
    var constraints : List<Constraint>;
    
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