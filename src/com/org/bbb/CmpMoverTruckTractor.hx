package com.org.bbb;

import com.org.bbb.CmpMover;
import nape.constraint.DistanceJoint;
import nape.constraint.LineJoint;
import nape.constraint.MotorJoint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.geom.Mat23;
import nape.phys.Body;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

class CmpMoverTruckTractor extends CmpMover
{
    public var compound : Compound;
    var material : Material;
    var speed : Float;

    var wheelFrontPos : Vec2;
    var wheelBackPos : Vec2;

    public var motorFront : MotorJoint;
    public var motorBack : MotorJoint;
    public var trailers : Array<CmpMoverTruckTrailer> = new Array();

    public function new(pos : Vec2) 
    {
        super(null);
        this.compound = new Compound();

        var w = GameConfig.truckTractorFrameDim.w;
        var h = GameConfig.truckTractorFrameDim.h;

        body = new Body();

        var cabShape = new Polygon(Polygon.box(GameConfig.truckTractorCabDim.w, GameConfig.truckTractorCabDim.h), GameConfig.materialTruck, new InteractionFilter(GameConfig.cgLoad));
        cabShape.transform(GameConfig.truckTractorCabOffset);
        var frameShape = new Polygon(Polygon.box(w, h), GameConfig.materialTruck, new InteractionFilter(GameConfig.cgLoad));

        body.shapes.add(cabShape);
        body.shapes.add(frameShape);
        body.cbTypes.add(GameConfig.cbTruck);
        body.compound = compound;
        body.position = pos;

        var fw = new Body(); // Front wheel
        fw.shapes.add(new Circle(12, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offFw = Vec2.get(w * 0.5 - 15, h * 0.5 + 4);
        fw.position = pos.add(offFw);
        fw.compound = compound;

        var bw = new Body(); // Rear wheel
        bw.shapes.add(new Circle(12, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offBw = Vec2.get(-w * 0.5 + 5, h * 0.5 + 4);
        bw.position = pos.add(offBw);
        bw.compound = compound;

        var fwj = new PivotJoint(body, fw, offFw, Vec2.weak());
        fwj.ignore = true;
        fwj.compound = compound;

        var bwj = new PivotJoint(body, bw, offBw, Vec2.weak());
        bwj.ignore = true;
        bwj.compound = compound;
        offFw.dispose();
        offBw.dispose();

        motorFront = new MotorJoint(null, fw, 0);
        motorFront.rate = 10;
        motorFront.compound = compound;

        motorBack = new MotorJoint(null, bw, 0);
        motorBack.rate = 10;
        motorBack.compound = compound;
    }

    override function set_space(space : Space) : Space
    {
        if (space != null) {
            motorFront.body1 = space.world;
            motorBack.body1 = space.world;
        }
        compound.space = space;
        return space;
    }

    override function get_space() : Space
    {
        return compound.space;
    }

    public function addTrailer(trailer : CmpMoverTruckTrailer) : Void
    {
        var lj = new LineJoint(body, trailer.body, Vec2.weak(-GameConfig.truckTractorCabDim.w*0.5-5, GameConfig.truckTractorCabOffset.ty), Vec2.weak(GameConfig.truckSemiTrailerDim.w*0.5, -14), Vec2.weak(1, 0), 0, GameConfig.truckTrailerMaxMargin);
        lj.ignore = true;
        lj.compound = compound;
    }
}
