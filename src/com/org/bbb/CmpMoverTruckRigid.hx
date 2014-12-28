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

class CmpMoverTruckRigid extends CmpMover
{
    public var compound : Compound;
    var material : Material;
    var speed : Float;

    var wheelFrontPos : Vec2;
    var wheelBackPos : Vec2;

    public var motorFront : MotorJoint;
    public var motorBack : MotorJoint;

    public function new(pos : Vec2) 
    {
        super(null);
        this.compound = new Compound();

        var w = GameConfig.truckRigidDim.w;
        var h = GameConfig.truckRigidDim.h;

        body = new Body();
        var shape = new Polygon(Polygon.box(w, h), GameConfig.materialTruck, new InteractionFilter(GameConfig.cgLoad));

        body.shapes.add(shape);
        body.cbTypes.add(GameConfig.cbTruck);
        body.compound = compound;
        body.position = pos;

        var fw = new Body(); // Front wheel
        fw.shapes.add(new Circle(12, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offFw = Vec2.get(w * 0.5 - 5, h * 0.5 - 3);
        fw.position = pos.add(offFw);
        fw.compound = compound;

        var bw = new Body(); // Rear wheel
        bw.shapes.add(new Circle(12, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offBw = Vec2.get(-w * 0.5 + 5, h * 0.5 - 3);
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
        motorFront.rate = 14;
        motorFront.compound = compound;

        motorBack = new MotorJoint(null, bw, 0);
        motorBack.rate = 14;
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
}
