package com.org.bbb;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.MatType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.callbacks.InteractionCallback;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.GeomPoly;
import nape.geom.Ray;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

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
 
class CmpMultiBeam extends CmpPhys
{
    public var compound : Compound;
    public var material : BuildMat;
    public var consDecayRate : Float = 3e4;
    
    public static function createFromBeam(beamBody : Body, splitType : SplitType, brokenCons : PivotJoint) : Compound
    {
        if (beamBody.shapes.length > 1) {
            trace("not sure how to split beam with 1+ shapes");
        }
        var c = new Compound();
        var space = beamBody.space;
        var bodySeg : Body;
        var rectheight = beamBody.copy().shapes.at(0).rotate( -beamBody.rotation).bounds.height;
        var comtop = beamBody.localPointToWorld(Vec2.weak(0, -rectheight*0.7) );
        var combot = beamBody.localPointToWorld(Vec2.weak(0, rectheight * 0.7) );
        
        switch (splitType) {
        case TENSION:
            var off = Util.randomf( -30, 30);
            combot = beamBody.localPointToWorld(Vec2.weak(off, -rectheight*0.7) );
            comtop = beamBody.localPointToWorld(Vec2.weak(off, rectheight * 0.7) );
        case COMPRESSION:
            var off = Util.randomf( -30, 30);
            comtop = beamBody.localPointToWorld(Vec2.weak(off, -rectheight*0.7) );
            combot = beamBody.localPointToWorld(Vec2.weak(off, rectheight * 0.7) );
        case SHEAR:
            var breakingPoint = Vec2.get();
            //var breakingPoint = brokenCons.body1.localPointToWorld(brokenCons.anchor1);
            comtop = breakingPoint.add(  beamBody.localVectorToWorld( Vec2.weak(0, -rectheight * 0.7) )  );
            combot = breakingPoint.add(  beamBody.localVectorToWorld( Vec2.weak(0, rectheight * 0.7) )  );
          default:
        }
        var ray : Ray = Ray.fromSegment(comtop, combot);
        var rayresult = space.rayMultiCast(ray, false, new InteractionFilter(Config.cgSensor) );
        if (rayresult.length != 0) {
            var polyToCut : Polygon = null;
            for (r in rayresult) {
               if (r.shape == beamBody.shapes.at(0)) {
                   polyToCut = r.shape.castPolygon;
               }
            }
            var geomPoly = new GeomPoly(polyToCut.worldVerts);
            var segmentPolys = geomPoly.cut(comtop, combot, true, true);
            var prev : Body = null;
            segmentPolys.foreach(function (s){
                var body : Body = new Body();
                body.shapes.push(new Polygon(s, Material.steel()));
                body.shapes.at(0).filter.collisionGroup = beamBody.shapes.at(0).filter.collisionGroup;
                body.shapes.at(0).filter.collisionMask = beamBody.shapes.at(0).filter.collisionMask;
                body.compound = c;
                
                if (prev != null) {
                    var ejoint = EntFactory.inst.createDoubleJoint(comtop, combot, prev, body, c);
                    EntFactory.inst.top.insertEnt(ejoint);
                }
                prev = body;
            });
            
        } else {
            trace(comtop + "," + combot);
            throw "No ray intersection detected when trying to break beam";
        }  
        /* If there are any existing joints attached to a beam, move them to new multi-beam */
        if (beamBody.space != null) {
            var iter = 0;
            var maxiter = beamBody.constraints.length+1;
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
                }
                
                var anchorWorld = beamBody.localPointToWorld(otheranchor);
                var newAnchorBody : Body = null;
                var colbodies = Util.closestBodyToPoint(space, anchorWorld, new InteractionFilter(Config.cgSensor), false, 10, 40);
                
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
                if (newAnchorBody == null) {
                    trace("Error finding constraint for multibeam" + anchorWorld);
                    colbodies.foreach(function(b) { trace("id: " + b.id); } );
                    //#if debug
                        //throw "Error finding constraint for multibeam" + anchorWorld ;
                    //#end
                    beamBody.constraints.foreach(function(cons) {
                        if (cons.compound == null) {
                            cons.active = false;
                        }
                    });
                    break;
                }
            }
            c.space = null;
            return c;
        }
        return null;
    }
    
    public function new(compound : Compound, material : BuildMat=null) 
    {
        super();
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
        var dt = entity.top.dt;

        for (c in constraints) {
            var f = c.frequency - 0.0045 * dt;
            f = Util.clampf(f, 0.4, 1000);
            c.frequency = f;
            
            if (c.maxForce > consDecayRate * dt) {
                c.maxForce -= consDecayRate * dt;
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